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

MermaidScene buildRadarChartScene(
  RadarChart chart,
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
  final center = Offset(245, titleHeight + 194);
  const radius = 128.0;
  final labels = <SceneLabel>[];
  final edges = <SceneEdge>[];
  final nodes = <SceneNode>[];
  final paths = <ScenePath>[];
  final range = _rangeFor(chart);
  final gridColor = theme.nodeStroke.withAlpha(72);

  if (chart.title != null) {
    labels.add(_label(
      chart.title!,
      Rect.fromLTWH(
          config.padding, config.padding, width - config.padding * 2, 28),
      theme.textColor,
    ));
  }

  for (var tick = 1; tick <= chart.ticks; tick++) {
    final tickRadius = radius * tick / chart.ticks;
    paths.add(ScenePath(
      path: chart.graticule == RadarGraticule.polygon
          ? _polygonPath(center, tickRadius, chart.axes.length)
          : (Path()
            ..addOval(Rect.fromCircle(center: center, radius: tickRadius))),
      strokeColor: gridColor,
      strokeWidth: 1,
    ));
  }

  for (var i = 0; i < chart.axes.length; i++) {
    final angle = _axisAngle(i, chart.axes.length);
    final axisEnd = _polar(center, radius, angle);
    edges.add(_line(center, axisEnd, theme.nodeStroke.withAlpha(120)));
    labels.add(_measuredLabel(
      chart.axes[i].label,
      Rect.fromCenter(
        center: _polar(center, radius + 28, angle),
        width: 96,
        height: config.fontSize * config.lineHeight + 4,
      ),
      theme.textColor,
      textStyle,
      textMeasurer,
    ));
  }

  for (var curveIndex = 0; curveIndex < chart.curves.length; curveIndex++) {
    final curve = chart.curves[curveIndex];
    final color = _seriesColor(theme, curveIndex);
    final points = [
      for (var axisIndex = 0; axisIndex < chart.axes.length; axisIndex++)
        _curvePoint(
          curve,
          chart.axes[axisIndex],
          axisIndex,
          chart.axes.length,
          center,
          radius,
          range,
        ),
    ];
    paths.add(ScenePath(
      path: _closedPath(points),
      fillColor: color.withAlpha(48),
      strokeColor: color,
      strokeWidth: 2,
    ));

    for (var i = 0; i < points.length; i++) {
      nodes.add(SceneNode(
        id: '${curve.id}-$i',
        shape: NodeShape.circle,
        bounds: Rect.fromCircle(center: points[i], radius: 4),
        fillColor: color,
        strokeColor: color,
        label: _emptyLabel(Rect.fromCircle(center: points[i], radius: 4)),
      ));
    }

    if (chart.showLegend) {
      final legendY = titleHeight + 64 + curveIndex * 28;
      nodes.add(_swatchNode(
        id: 'legend-$curveIndex',
        rect: Rect.fromLTWH(430, legendY + 4, 14, 14),
        color: color,
      ));
      labels.add(_measuredLabel(
        curve.label,
        Rect.fromLTWH(454, legendY, 88, 24),
        theme.textColor,
        textStyle,
        textMeasurer,
      ));
    }
  }

  return MermaidScene(
    size: const Size(560, 460),
    nodes: nodes,
    edges: edges,
    labels: labels,
    paths: paths,
  );
}

_ValueRange _rangeFor(RadarChart chart) {
  final values = [
    for (final curve in chart.curves)
      for (final value in curve.values.values) value,
  ];
  var min = chart.min ?? 0;
  var max = chart.max ?? values.reduce(math.max);
  if (min == max) max = min + 1;
  return _ValueRange(min, max);
}

Offset _curvePoint(
  RadarCurve curve,
  RadarAxis axis,
  int axisIndex,
  int axisCount,
  Offset center,
  double radius,
  _ValueRange range,
) {
  final value = curve.values[axis.id] ?? range.min;
  final fraction =
      ((value - range.min) / (range.max - range.min)).clamp(0.0, 1.0);
  return _polar(center, radius * fraction, _axisAngle(axisIndex, axisCount));
}

double _axisAngle(int index, int count) {
  return -math.pi / 2 + math.pi * 2 * index / count;
}

Offset _polar(Offset center, double radius, double angle) {
  return Offset(
    center.dx + math.cos(angle) * radius,
    center.dy + math.sin(angle) * radius,
  );
}

Path _polygonPath(Offset center, double radius, int count) {
  return _closedPath([
    for (var i = 0; i < count; i++)
      _polar(center, radius, _axisAngle(i, count)),
  ]);
}

Path _closedPath(List<Offset> points) {
  final path = Path();
  if (points.isEmpty) return path;
  path.moveTo(points.first.dx, points.first.dy);
  for (final point in points.skip(1)) {
    path.lineTo(point.dx, point.dy);
  }
  path.close();
  return path;
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

SceneNode _swatchNode({
  required String id,
  required Rect rect,
  required Color color,
}) {
  return SceneNode(
    id: id,
    shape: NodeShape.rectangle,
    bounds: rect,
    fillColor: color.withAlpha(160),
    strokeColor: color,
    label: _emptyLabel(rect),
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
    bounds: Rect.fromCenter(
      center: preferredBounds.center,
      width: math.max(preferredBounds.width, measured.width + 8),
      height: math.max(preferredBounds.height, measured.height + 4),
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

class _ValueRange {
  const _ValueRange(this.min, this.max);

  final double min;
  final double max;
}
