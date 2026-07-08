import 'package:flutter/material.dart';

import '../config/render_options.dart';
import '../scene/mermaid_scene.dart';
import 'edge_painter.dart';
import 'shape_painter.dart';
import 'text_painter.dart';

class MermaidPainter {
  const MermaidPainter({
    this.shapePainter = const ShapePainter(),
    this.edgePainter = const EdgePainter(),
  });

  final ShapePainter shapePainter;
  final EdgePainter edgePainter;

  void paint(
    Canvas canvas,
    MermaidScene scene,
    MermaidRenderOptions options,
    TextDirection textDirection,
    TextScaler textScaler,
  ) {
    final backgroundAlpha =
        (options.theme.background.a * 255.0).round().clamp(0, 255);
    if (backgroundAlpha != 0) {
      canvas.drawRect(
        Offset.zero & scene.size,
        Paint()
          ..color = options.theme.background
          ..style = PaintingStyle.fill,
      );
    }

    for (final edge in scene.edges) {
      edgePainter.paint(canvas, edge);
    }

    for (final node in scene.nodes) {
      shapePainter.paint(canvas, node);
    }

    final textPainter = MermaidTextPainter(
      config: options.layoutConfig,
      textDirection: textDirection,
      textScaler: textScaler,
    );
    for (final label in scene.labels) {
      textPainter.paint(canvas, label);
    }
  }
}
