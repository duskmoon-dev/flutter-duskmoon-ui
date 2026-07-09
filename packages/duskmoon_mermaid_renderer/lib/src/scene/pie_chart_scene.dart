import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../config/layout_config.dart';
import '../ir/charts.dart';
import '../ir/style.dart';
import '../layout/layout_types.dart';
import '../theme/theme.dart';
import 'mermaid_scene.dart';
import 'scene_label.dart';
import 'scene_node.dart';
import 'scene_path.dart';

MermaidScene buildPieChartScene(
  PieChart chart,
  MermaidLayoutConfig config,
  MermaidTheme theme,
  MermaidTextMeasurer textMeasurer,
) {
  final textStyle = MermaidTextStyle(
    fontSize: config.fontSize,
    lineHeight: config.lineHeight,
  );
  const width = 560.0;
  final titleHeight = chart.title == null ? 0.0 : config.fontSize * 2.4;
  final center = Offset(180, titleHeight + 150);
  const radius = 108.0;
  final total = chart.slices.fold<double>(
    0,
    (sum, slice) => sum + slice.value,
  );
  final labels = <SceneLabel>[];
  final nodes = <SceneNode>[];
  final paths = <ScenePath>[];
  var startAngle = -math.pi / 2;

  if (chart.title != null) {
    labels.add(_label(
      chart.title!,
      Rect.fromLTWH(
          config.padding, config.padding, width - config.padding * 2, 28),
      theme.textColor,
    ));
  }

  for (var i = 0; i < chart.slices.length; i++) {
    final slice = chart.slices[i];
    final sweep = slice.value / total * math.pi * 2;
    final color = _seriesColor(theme, i);
    final path = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        false,
      )
      ..close();
    paths.add(ScenePath(
      path: path,
      fillColor: color.withAlpha(176),
      strokeColor: theme.background.withAlpha(220),
      strokeWidth: 2,
    ));

    final middle = startAngle + sweep / 2;
    final labelCenter = Offset(
      center.dx + math.cos(middle) * radius * 0.62,
      center.dy + math.sin(middle) * radius * 0.62,
    );
    final percent = slice.value / total * 100;
    labels.add(_measuredLabel(
      '${percent.toStringAsFixed(percent >= 10 ? 0 : 1)}%',
      Rect.fromCenter(center: labelCenter, width: 52, height: 22),
      theme.textColor,
      textStyle,
      textMeasurer,
    ));

    final legendY = titleHeight + 72 + i * 30;
    nodes.add(_swatchNode(
      id: 'legend-$i',
      rect: Rect.fromLTWH(330, legendY + 3, 14, 14),
      color: color,
    ));
    final valueText = chart.showData ? ' (${_formatNumber(slice.value)})' : '';
    labels.add(_measuredLabel(
      '${slice.label}$valueText',
      Rect.fromLTWH(354, legendY - 1, 180, 24),
      theme.textColor,
      textStyle,
      textMeasurer,
    ));

    startAngle += sweep;
  }

  return MermaidScene(
    size: const Size(560, 360),
    nodes: nodes,
    edges: const [],
    labels: labels,
    paths: paths,
  );
}

SceneNode _swatchNode({
  required String id,
  required Rect rect,
  required Color color,
}) {
  return SceneNode(
    id: id,
    shape: NodeShape.rectangle,
    bounds: rect,
    fillColor: color.withAlpha(176),
    strokeColor: color,
    label: SceneLabel(
      text: '',
      bounds: rect,
      textColor: Colors.transparent,
    ),
  );
}

SceneLabel _label(String text, Rect bounds, Color color) {
  return SceneLabel(text: text, bounds: bounds, textColor: color);
}

SceneLabel _measuredLabel(
  String text,
  Rect preferredBounds,
  Color color,
  MermaidTextStyle textStyle,
  MermaidTextMeasurer textMeasurer,
) {
  final measured = textMeasurer.measure(text, textStyle);
  return SceneLabel(
    text: text,
    bounds: Rect.fromLTWH(
      preferredBounds.left,
      preferredBounds.top,
      math.max(preferredBounds.width, measured.width + 8),
      math.max(preferredBounds.height, measured.height + 4),
    ),
    textColor: color,
  );
}

String _formatNumber(double value) {
  if (value == value.roundToDouble()) return value.round().toString();
  return value.toStringAsFixed(2);
}

Color _seriesColor(MermaidTheme theme, int index) {
  final palette = [
    theme.edgeStroke,
    const Color(0xFF22C55E),
    theme.errorStroke,
    const Color(0xFF8B5CF6),
    theme.nodeStroke,
    const Color(0xFFF59E0B),
  ];
  return palette[index % palette.length];
}
