import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../config/layout_config.dart';
import '../ir/charts.dart';
import '../ir/style.dart';
import '../layout/layout_types.dart';
import '../theme/theme.dart';
import 'mermaid_scene.dart';
import 'scene_edge.dart';
import 'scene_label.dart';
import 'scene_node.dart';
import 'scene_path.dart';

MermaidScene buildQuadrantChartScene(
  QuadrantChart chart,
  MermaidLayoutConfig config,
  MermaidTheme theme,
  MermaidTextMeasurer textMeasurer,
) {
  final textStyle = MermaidTextStyle(
    fontSize: config.fontSize,
    lineHeight: config.lineHeight,
  );
  const width = 560.0;
  const height = 420.0;
  final titleHeight = chart.title == null ? 0.0 : config.fontSize * 2.4;
  final plot = Rect.fromLTWH(
    72,
    titleHeight + 44,
    width - 132,
    height - titleHeight - 104,
  );
  final labels = <SceneLabel>[];
  final edges = <SceneEdge>[];
  final nodes = <SceneNode>[];
  final paths = <ScenePath>[];
  final gridColor = theme.nodeStroke.withAlpha(96);

  if (chart.title != null) {
    labels.add(_label(
      chart.title!,
      Rect.fromLTWH(
          config.padding, config.padding, width - config.padding * 2, 28),
      theme.textColor,
    ));
  }

  final quadrantRects = <int, Rect>{
    1: Rect.fromLTRB(plot.center.dx, plot.top, plot.right, plot.center.dy),
    2: Rect.fromLTRB(plot.left, plot.top, plot.center.dx, plot.center.dy),
    3: Rect.fromLTRB(plot.left, plot.center.dy, plot.center.dx, plot.bottom),
    4: Rect.fromLTRB(plot.center.dx, plot.center.dy, plot.right, plot.bottom),
  };
  final fills = [
    theme.nodeFill.withAlpha(96),
    theme.edgeStroke.withAlpha(28),
    theme.nodeStroke.withAlpha(26),
    theme.errorStroke.withAlpha(22),
  ];
  for (final entry in quadrantRects.entries) {
    paths.add(ScenePath(
      path: _rectPath(entry.value),
      fillColor: fills[entry.key - 1],
    ));
    final text = chart.quadrants[entry.key];
    if (text != null) {
      labels.add(_measuredLabel(
        text,
        Rect.fromLTWH(
          entry.value.left + 10,
          entry.value.top + 8,
          entry.value.width - 20,
          26,
        ),
        theme.textColor.withAlpha(190),
        textStyle,
        textMeasurer,
      ));
    }
  }

  edges
    ..add(_line(plot.topLeft, plot.topRight, theme.nodeStroke))
    ..add(_line(plot.topRight, plot.bottomRight, theme.nodeStroke))
    ..add(_line(plot.bottomRight, plot.bottomLeft, theme.nodeStroke))
    ..add(_line(plot.bottomLeft, plot.topLeft, theme.nodeStroke))
    ..add(_line(Offset(plot.center.dx, plot.top),
        Offset(plot.center.dx, plot.bottom), gridColor))
    ..add(_line(Offset(plot.left, plot.center.dy),
        Offset(plot.right, plot.center.dy), gridColor));

  _addAxisLabels(
    chart: chart,
    plot: plot,
    labels: labels,
    textColor: theme.textColor,
    textStyle: textStyle,
    textMeasurer: textMeasurer,
  );

  for (var i = 0; i < chart.points.length; i++) {
    final point = chart.points[i];
    final center = Offset(
      plot.left + point.x * plot.width,
      plot.bottom - point.y * plot.height,
    );
    final color = _seriesColor(theme, i);
    nodes.add(SceneNode(
      id: 'point-$i',
      shape: NodeShape.circle,
      bounds: Rect.fromCircle(center: center, radius: 5),
      fillColor: color,
      strokeColor: color,
      label: _emptyLabel(Rect.fromCircle(center: center, radius: 5)),
    ));
    labels.add(_measuredLabel(
      point.label,
      Rect.fromCenter(
        center: center.translate(0, 18),
        width: 96,
        height: config.fontSize * config.lineHeight + 4,
      ),
      color,
      textStyle,
      textMeasurer,
    ));
  }

  return MermaidScene(
    size: const Size(560, 420),
    nodes: nodes,
    edges: edges,
    labels: labels,
    paths: paths,
  );
}

void _addAxisLabels({
  required QuadrantChart chart,
  required Rect plot,
  required List<SceneLabel> labels,
  required Color textColor,
  required MermaidTextStyle textStyle,
  required MermaidTextMeasurer textMeasurer,
}) {
  final xStart = chart.xAxis.start;
  if (xStart != null) {
    labels.add(_measuredLabel(
      xStart,
      Rect.fromLTWH(plot.left, plot.bottom + 16, plot.width / 2, 26),
      textColor,
      textStyle,
      textMeasurer,
    ));
  }
  final xEnd = chart.xAxis.end;
  if (xEnd != null) {
    labels.add(_measuredLabel(
      xEnd,
      Rect.fromLTWH(plot.center.dx, plot.bottom + 16, plot.width / 2, 26),
      textColor,
      textStyle,
      textMeasurer,
    ));
  }
  final yStart = chart.yAxis.start;
  if (yStart != null) {
    labels.add(_measuredLabel(
      yStart,
      Rect.fromLTWH(8, plot.center.dy, 58, 26),
      textColor,
      textStyle,
      textMeasurer,
    ));
  }
  final yEnd = chart.yAxis.end;
  if (yEnd != null) {
    labels.add(_measuredLabel(
      yEnd,
      Rect.fromLTWH(8, plot.top, 58, 26),
      textColor,
      textStyle,
      textMeasurer,
    ));
  }
}

Path _rectPath(Rect rect) {
  return Path()..addRect(rect);
}

SceneEdge _line(Offset from, Offset to, Color color) {
  return SceneEdge(
    points: [from, to],
    style: EdgeStyle.solid,
    color: color,
    arrowStart: false,
    arrowEnd: false,
  );
}

SceneLabel _emptyLabel(Rect rect) {
  return SceneLabel(
    text: '',
    bounds: rect,
    textColor: Colors.transparent,
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

Color _seriesColor(MermaidTheme theme, int index) {
  final palette = [
    theme.edgeStroke,
    const Color(0xFF22C55E),
    theme.errorStroke,
    const Color(0xFF8B5CF6),
    theme.nodeStroke,
  ];
  return palette[index % palette.length];
}
