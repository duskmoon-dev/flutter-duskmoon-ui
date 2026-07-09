import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../config/layout_config.dart';
import '../ir/style.dart';
import '../ir/xy_chart.dart';
import '../layout/layout_types.dart';
import '../theme/theme.dart';
import 'mermaid_scene.dart';
import 'scene_edge.dart';
import 'scene_label.dart';
import 'scene_node.dart';

MermaidScene buildXyChartScene(
  XyChart chart,
  MermaidLayoutConfig config,
  MermaidTheme theme,
  MermaidTextMeasurer textMeasurer,
) {
  final textStyle = MermaidTextStyle(
    fontSize: config.fontSize,
    lineHeight: config.lineHeight,
  );
  final categories = _categoriesFor(chart);
  final range = _valueRangeFor(chart);
  final horizontal = chart.orientation == XyChartOrientation.horizontal;

  final chartWidth = math.max(
    440.0,
    (horizontal ? 520.0 : 280.0) +
        categories.length * (horizontal ? 28.0 : 56.0),
  );
  final chartHeight = math.max(
    320.0,
    (horizontal ? 180.0 : 260.0) +
        categories.length * (horizontal ? 34.0 : 8.0),
  );
  final titleHeight = chart.title == null ? 0.0 : config.fontSize * 2.2;
  final plot = Rect.fromLTWH(
    config.padding + 72,
    config.padding + titleHeight + 20,
    chartWidth - config.padding * 2 - 112,
    chartHeight - config.padding * 2 - titleHeight - 88,
  );

  final nodes = <SceneNode>[];
  final edges = <SceneEdge>[];
  final labels = <SceneLabel>[];
  final axisColor = theme.nodeStroke;
  final gridColor = theme.nodeStroke.withAlpha(56);
  final textColor = theme.textColor;

  if (chart.title != null) {
    labels.add(_label(
      chart.title!,
      Rect.fromLTWH(
        config.padding,
        config.padding,
        chartWidth - config.padding * 2,
        titleHeight,
      ),
      textColor,
    ));
  }

  if (horizontal) {
    _buildHorizontalChart(
      chart: chart,
      categories: categories,
      range: range,
      plot: plot,
      config: config,
      textStyle: textStyle,
      textMeasurer: textMeasurer,
      theme: theme,
      axisColor: axisColor,
      gridColor: gridColor,
      textColor: textColor,
      nodes: nodes,
      edges: edges,
      labels: labels,
    );
  } else {
    _buildVerticalChart(
      chart: chart,
      categories: categories,
      range: range,
      plot: plot,
      config: config,
      textStyle: textStyle,
      textMeasurer: textMeasurer,
      theme: theme,
      axisColor: axisColor,
      gridColor: gridColor,
      textColor: textColor,
      nodes: nodes,
      edges: edges,
      labels: labels,
    );
  }

  return MermaidScene(
    size: Size(chartWidth, chartHeight),
    nodes: nodes,
    edges: edges,
    labels: labels,
  );
}

void _buildVerticalChart({
  required XyChart chart,
  required List<String> categories,
  required _ValueRange range,
  required Rect plot,
  required MermaidLayoutConfig config,
  required MermaidTextStyle textStyle,
  required MermaidTextMeasurer textMeasurer,
  required MermaidTheme theme,
  required Color axisColor,
  required Color gridColor,
  required Color textColor,
  required List<SceneNode> nodes,
  required List<SceneEdge> edges,
  required List<SceneLabel> labels,
}) {
  double valueY(double value) {
    final fraction = (value - range.min) / (range.max - range.min);
    return plot.bottom - fraction.clamp(0.0, 1.0) * plot.height;
  }

  final ticks = _ticks(range);
  for (final tick in ticks) {
    final y = valueY(tick);
    edges.add(_line(
      Offset(plot.left, y),
      Offset(plot.right, y),
      gridColor,
    ));
    labels.add(_measuredLabel(
      _formatNumber(tick),
      Rect.fromCenter(
        center: Offset(plot.left - 34, y),
        width: 60,
        height: config.fontSize * config.lineHeight + 4,
      ),
      textColor,
      textStyle,
      textMeasurer,
    ));
  }

  edges
    ..add(_line(plot.bottomLeft, plot.bottomRight, axisColor))
    ..add(_line(plot.bottomLeft, plot.topLeft, axisColor));

  final categoryWidth = plot.width / categories.length;
  for (var i = 0; i < categories.length; i++) {
    final x = plot.left + categoryWidth * (i + 0.5);
    labels.add(_measuredLabel(
      categories[i],
      Rect.fromCenter(
        center: Offset(x, plot.bottom + 22),
        width: categoryWidth,
        height: config.fontSize * config.lineHeight + 4,
      ),
      textColor,
      textStyle,
      textMeasurer,
    ));
  }

  _addAxisTitles(
    chart: chart,
    plot: plot,
    labels: labels,
    textColor: textColor,
  );

  final baseline = valueY(0);
  final barSeries = chart.series
      .where((series) => series.type == XyChartSeriesType.bar)
      .toList();
  final barSlotWidth = categoryWidth * 0.72;
  final barWidth =
      barSeries.isEmpty ? 0.0 : math.max(6.0, barSlotWidth / barSeries.length);
  for (var s = 0; s < barSeries.length; s++) {
    final series = barSeries[s];
    final color = _seriesColor(theme, s);
    for (var i = 0;
        i < math.min(series.values.length, categories.length);
        i++) {
      final value = series.values[i].value;
      final x = plot.left +
          categoryWidth * i +
          (categoryWidth - barSlotWidth) / 2 +
          barWidth * s;
      final y = valueY(value);
      final top = math.min(y, baseline);
      final bottom = math.max(y, baseline);
      nodes.add(_rectNode(
        id: 'bar-$s-$i',
        rect: Rect.fromLTWH(x, top, barWidth * 0.86, bottom - top),
        color: color,
      ));
    }
  }

  final lineSeries = chart.series
      .where((series) => series.type == XyChartSeriesType.line)
      .toList();
  for (var s = 0; s < lineSeries.length; s++) {
    final series = lineSeries[s];
    final color = _seriesColor(theme, s + barSeries.length);
    final points = <Offset>[];
    for (var i = 0;
        i < math.min(series.values.length, categories.length);
        i++) {
      final point = Offset(
        plot.left + categoryWidth * (i + 0.5),
        valueY(series.values[i].value),
      );
      points.add(point);
      nodes.add(_pointNode(id: 'line-$s-$i', center: point, color: color));
      final label = series.values[i].label;
      if (label != null) {
        labels.add(_measuredLabel(
          label,
          Rect.fromCenter(
            center: point.translate(0, -18),
            width: categoryWidth,
            height: config.fontSize * config.lineHeight + 4,
          ),
          color,
          textStyle,
          textMeasurer,
        ));
      }
    }
    if (points.length >= 2) {
      edges.add(_polyline(points, color));
    }
  }
}

void _buildHorizontalChart({
  required XyChart chart,
  required List<String> categories,
  required _ValueRange range,
  required Rect plot,
  required MermaidLayoutConfig config,
  required MermaidTextStyle textStyle,
  required MermaidTextMeasurer textMeasurer,
  required MermaidTheme theme,
  required Color axisColor,
  required Color gridColor,
  required Color textColor,
  required List<SceneNode> nodes,
  required List<SceneEdge> edges,
  required List<SceneLabel> labels,
}) {
  double valueX(double value) {
    final fraction = (value - range.min) / (range.max - range.min);
    return plot.left + fraction.clamp(0.0, 1.0) * plot.width;
  }

  final ticks = _ticks(range);
  for (final tick in ticks) {
    final x = valueX(tick);
    edges.add(_line(
      Offset(x, plot.top),
      Offset(x, plot.bottom),
      gridColor,
    ));
    labels.add(_measuredLabel(
      _formatNumber(tick),
      Rect.fromCenter(
        center: Offset(x, plot.bottom + 22),
        width: 56,
        height: config.fontSize * config.lineHeight + 4,
      ),
      textColor,
      textStyle,
      textMeasurer,
    ));
  }

  edges
    ..add(_line(plot.bottomLeft, plot.topLeft, axisColor))
    ..add(_line(plot.bottomLeft, plot.bottomRight, axisColor));

  final categoryHeight = plot.height / categories.length;
  for (var i = 0; i < categories.length; i++) {
    final y = plot.top + categoryHeight * (i + 0.5);
    labels.add(_measuredLabel(
      categories[i],
      Rect.fromCenter(
        center: Offset(plot.left - 42, y),
        width: 76,
        height: categoryHeight,
      ),
      textColor,
      textStyle,
      textMeasurer,
    ));
  }

  _addAxisTitles(
    chart: chart,
    plot: plot,
    labels: labels,
    textColor: textColor,
  );

  final baseline = valueX(0);
  final barSeries = chart.series
      .where((series) => series.type == XyChartSeriesType.bar)
      .toList();
  final barSlotHeight = categoryHeight * 0.72;
  final barHeight =
      barSeries.isEmpty ? 0.0 : math.max(6.0, barSlotHeight / barSeries.length);
  for (var s = 0; s < barSeries.length; s++) {
    final series = barSeries[s];
    final color = _seriesColor(theme, s);
    for (var i = 0;
        i < math.min(series.values.length, categories.length);
        i++) {
      final value = series.values[i].value;
      final x = valueX(value);
      final left = math.min(x, baseline);
      final right = math.max(x, baseline);
      final y = plot.top +
          categoryHeight * i +
          (categoryHeight - barSlotHeight) / 2 +
          barHeight * s;
      nodes.add(_rectNode(
        id: 'bar-$s-$i',
        rect: Rect.fromLTWH(left, y, right - left, barHeight * 0.86),
        color: color,
      ));
    }
  }

  final lineSeries = chart.series
      .where((series) => series.type == XyChartSeriesType.line)
      .toList();
  for (var s = 0; s < lineSeries.length; s++) {
    final series = lineSeries[s];
    final color = _seriesColor(theme, s + barSeries.length);
    final points = <Offset>[];
    for (var i = 0;
        i < math.min(series.values.length, categories.length);
        i++) {
      final point = Offset(
        valueX(series.values[i].value),
        plot.top + categoryHeight * (i + 0.5),
      );
      points.add(point);
      nodes.add(_pointNode(id: 'line-$s-$i', center: point, color: color));
      final label = series.values[i].label;
      if (label != null) {
        labels.add(_measuredLabel(
          label,
          Rect.fromCenter(
            center: point.translate(28, 0),
            width: 72,
            height: config.fontSize * config.lineHeight + 4,
          ),
          color,
          textStyle,
          textMeasurer,
        ));
      }
    }
    if (points.length >= 2) {
      edges.add(_polyline(points, color));
    }
  }
}

void _addAxisTitles({
  required XyChart chart,
  required Rect plot,
  required List<SceneLabel> labels,
  required Color textColor,
}) {
  final xTitle = chart.xAxis.title;
  if (xTitle != null) {
    labels.add(_label(
      xTitle,
      Rect.fromCenter(
        center: Offset(plot.center.dx, plot.bottom + 52),
        width: plot.width,
        height: 22,
      ),
      textColor,
    ));
  }
  final yTitle = chart.yAxis.title;
  if (yTitle != null) {
    labels.add(_label(
      yTitle,
      Rect.fromLTWH(plot.left, plot.top - 28, plot.width, 22),
      textColor,
    ));
  }
}

List<String> _categoriesFor(XyChart chart) {
  final configured = chart.xAxis.categories;
  if (configured != null && configured.isNotEmpty) {
    return configured;
  }
  final length = chart.series.fold<int>(
    0,
    (maxLength, series) => math.max(maxLength, series.values.length),
  );
  final min = chart.xAxis.min;
  final max = chart.xAxis.max;
  if (min != null && max != null && length > 0) {
    if (length == 1) return [_formatNumber(min)];
    final step = (max - min) / (length - 1);
    return List<String>.generate(
      length,
      (index) => _formatNumber(min + step * index),
    );
  }
  return List<String>.generate(length, (index) => '${index + 1}');
}

_ValueRange _valueRangeFor(XyChart chart) {
  final values = [
    for (final series in chart.series)
      for (final point in series.values) point.value,
  ];
  var min = chart.yAxis.min ?? values.reduce(math.min);
  var max = chart.yAxis.max ?? values.reduce(math.max);
  if (chart.series.any((series) => series.type == XyChartSeriesType.bar)) {
    min = math.min(0, min);
    max = math.max(0, max);
  }
  if (min == max) {
    min -= 1;
    max += 1;
  }
  final padding = (max - min) * 0.08;
  if (chart.yAxis.min == null) min -= padding;
  if (chart.yAxis.max == null) max += padding;
  return _ValueRange(min, max);
}

List<double> _ticks(_ValueRange range) {
  const count = 5;
  final step = (range.max - range.min) / (count - 1);
  return List<double>.generate(count, (index) => range.min + step * index);
}

String _formatNumber(double value) {
  if (value.abs() >= 100 || value == value.roundToDouble()) {
    return value.round().toString();
  }
  return value.toStringAsFixed(1);
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

SceneEdge _polyline(List<Offset> points, Color color) {
  return SceneEdge(
    points: points,
    style: EdgeStyle.thick,
    color: color,
    arrowStart: false,
    arrowEnd: false,
  );
}

SceneNode _rectNode({
  required String id,
  required Rect rect,
  required Color color,
}) {
  return SceneNode(
    id: id,
    shape: NodeShape.rectangle,
    bounds: rect,
    fillColor: color.withAlpha(150),
    strokeColor: color,
    label: _emptyLabel(rect),
  );
}

SceneNode _pointNode({
  required String id,
  required Offset center,
  required Color color,
}) {
  return SceneNode(
    id: id,
    shape: NodeShape.circle,
    bounds: Rect.fromCircle(center: center, radius: 4),
    fillColor: color,
    strokeColor: color,
    label: _emptyLabel(Rect.fromCircle(center: center, radius: 4)),
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
  return SceneLabel(
    text: text,
    bounds: bounds,
    textColor: color,
  );
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
