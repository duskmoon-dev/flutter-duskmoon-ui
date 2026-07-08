import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../config/render_options.dart';
import '../error/mermaid_error.dart';
import '../ir/edge.dart';
import '../ir/graph.dart';
import '../ir/node.dart';
import '../ir/style.dart';
import '../layout/flowchart_layout.dart';
import '../layout/layout_types.dart';
import '../parser/parser.dart';
import '../scene/mermaid_scene.dart';
import '../scene/scene_edge.dart';
import '../scene/scene_label.dart';
import '../scene/scene_node.dart';
import 'mermaid_painter.dart';

class RenderDmMermaid extends RenderBox {
  RenderDmMermaid({
    required String source,
    required MermaidRenderOptions options,
    required TextDirection textDirection,
    required TextScaler textScaler,
    ValueChanged<MermaidError>? onError,
  })  : _source = source,
        _options = options,
        _textDirection = textDirection,
        _textScaler = textScaler,
        _onError = onError;

  final MermaidPainter _painter = const MermaidPainter();
  MermaidScene? _scene;
  String? _cacheKey;
  String? _lastNotifiedError;

  String get source => _source;
  String _source;
  set source(String value) {
    if (value == _source) return;
    _source = value;
    _invalidateScene();
    markNeedsLayout();
  }

  MermaidRenderOptions get options => _options;
  MermaidRenderOptions _options;
  set options(MermaidRenderOptions value) {
    if (value == _options) return;
    final oldLayoutConfig = _options.layoutConfig;
    _options = value;
    _invalidateScene();
    if (oldLayoutConfig == value.layoutConfig) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (value == _textDirection) return;
    _textDirection = value;
    _invalidateScene();
    markNeedsLayout();
  }

  TextScaler get textScaler => _textScaler;
  TextScaler _textScaler;
  set textScaler(TextScaler value) {
    if (value == _textScaler) return;
    _textScaler = value;
    _invalidateScene();
    markNeedsLayout();
  }

  ValueChanged<MermaidError>? get onError => _onError;
  ValueChanged<MermaidError>? _onError;
  set onError(ValueChanged<MermaidError>? value) {
    if (value == _onError) return;
    _onError = value;
  }

  @override
  void performLayout() {
    final scene = _ensureScene();
    final naturalSize = scene.size;
    final maxWidth = constraints.hasBoundedWidth
        ? math.max(0, constraints.maxWidth)
        : naturalSize.width;
    final scale = naturalSize.width > 0
        ? math.min(1.0, maxWidth / naturalSize.width)
        : 1.0;
    final targetSize = Size(
      naturalSize.width * scale,
      naturalSize.height * scale,
    );
    size = constraints.constrain(targetSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final scene = _ensureScene();
    if (scene.size.isEmpty) return;

    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    final scaleX = size.width / scene.size.width;
    final scaleY = size.height / scene.size.height;
    final scale = math.min(scaleX, scaleY);
    canvas.scale(scale);
    _painter.paint(canvas, scene, options, textDirection, textScaler);
    canvas.restore();
  }

  @override
  bool hitTestSelf(Offset position) => true;

  MermaidScene _ensureScene() {
    final key =
        Object.hash(source, options, textDirection, textScaler).toString();
    if (_scene != null && _cacheKey == key) {
      return _scene!;
    }

    try {
      final output = parseMermaid(source);
      final layout = computeMermaidLayout(
        output.graph,
        options.layoutConfig,
        FlutterTextMeasurer(
          textDirection: textDirection,
          textScaler: textScaler,
        ),
      );
      _scene = buildMermaidScene(layout, options.theme);
      _cacheKey = key;
      _lastNotifiedError = null;
      return _scene!;
    } on MermaidError catch (error) {
      _notifyError(error);
      _scene = _buildErrorScene(error);
      _cacheKey = key;
      return _scene!;
    } catch (error) {
      final renderError = MermaidRenderError(error.toString());
      _notifyError(renderError);
      _scene = _buildErrorScene(renderError);
      _cacheKey = key;
      return _scene!;
    }
  }

  void _invalidateScene() {
    _scene = null;
    _cacheKey = null;
  }

  void _notifyError(MermaidError error) {
    final message = error.toString();
    if (_lastNotifiedError == message) return;
    _lastNotifiedError = message;
    _onError?.call(error);
  }

  MermaidScene _buildErrorScene(MermaidError error) {
    const width = 280.0;
    const height = 96.0;
    final graph = Graph()
      ..addNode(const Node(
        id: 'error',
        label: 'Mermaid error',
        shape: NodeShape.diamond,
      ))
      ..addNode(Node(
        id: 'message',
        label: _compactError(error),
        shape: NodeShape.roundRect,
      ))
      ..addEdge(const Edge(from: 'error', to: 'message'));
    final layout = computeMermaidLayout(
      graph,
      options.layoutConfig,
      const HeuristicTextMeasurer(),
    );
    final scene = buildMermaidScene(layout, options.theme);
    return MermaidScene(
      size: Size(math.max(width, scene.size.width),
          math.max(height, scene.size.height)),
      nodes: scene.nodes.map((node) {
        if (node.id != 'error') return node;
        return SceneNode(
          id: node.id,
          shape: node.shape,
          bounds: node.bounds,
          fillColor: options.theme.errorFill,
          strokeColor: options.theme.errorStroke,
          label: node.label,
        );
      }).toList(),
      edges: scene.edges
          .map((edge) => SceneEdge(
                points: edge.points,
                style: edge.style,
                color: options.theme.errorStroke,
                arrowStart: edge.arrowStart,
                arrowEnd: edge.arrowEnd,
                label: edge.label,
              ))
          .toList(),
      labels: scene.labels
          .map((label) => SceneLabel(
                text: label.text,
                bounds: label.bounds,
                textColor: label.textColor,
                backgroundColor: label.backgroundColor,
              ))
          .toList(),
    );
  }

  String _compactError(MermaidError error) {
    final message = error is MermaidParseError
        ? '${error.message}${error.line == null ? '' : ' (${error.line}:${error.column ?? 1})'}'
        : error.message;
    return message.length <= 48 ? message : '${message.substring(0, 45)}...';
  }
}
