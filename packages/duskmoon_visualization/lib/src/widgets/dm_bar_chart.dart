import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../dm_chart_models.dart';
import '../dm_chart_palette.dart';
import '../vendor/dv_scale/dv_scale.dart';
import '../vendor/dv_xychart/dv_xychart.dart';

class DmVizBarChart extends StatelessWidget {
  final List<DmVizPoint> data;
  final String? xAxisLabel;
  final String? yAxisLabel;
  final double cornerRadius;
  final DmChartPalette? palette;

  const DmVizBarChart({
    super.key,
    required this.data,
    this.xAxisLabel,
    this.yAxisLabel,
    this.cornerRadius = 8,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedPalette =
        palette ?? DmChartPalette.fromTheme(Theme.of(context));
    final xDomain = _barXDomain(data);
    final yDomain = _barYDomain(data);

    return XYChart(
      xScale: LinearScale(domain: xDomain, range: [0, 1]),
      yScale: LinearScale(domain: yDomain, range: [1, 0]),
      xAxisLabel: xAxisLabel,
      yAxisLabel: yAxisLabel,
      backgroundColor: resolvedPalette.background,
      gridColor: resolvedPalette.grid,
      axisColor: resolvedPalette.axis,
      children: [
        BarSeries(
          data: data.map((point) => point.toRaw()).toList(growable: false),
          color: resolvedPalette.positive,
          borderColor: resolvedPalette.positiveOnColor,
          borderWidth: 1,
          cornerRadius: cornerRadius,
        ),
      ],
    );
  }
}

List<double> _barXDomain(List<DmVizPoint> data) {
  final xValues = data
      .map((point) => point.x)
      .whereType<num>()
      .map((value) => value.toDouble())
      .toList();
  if (xValues.isEmpty) {
    return [0, 1];
  }

  final minValue = xValues.reduce(math.min);
  final maxValue = xValues.reduce(math.max);
  return [minValue - 0.5, maxValue + 0.5];
}

List<double> _barYDomain(List<DmVizPoint> data) {
  final yValues = data.map((point) => point.y).toList();
  if (yValues.isEmpty) {
    return [0, 1];
  }

  final maxValue = yValues.reduce(math.max);
  return [0, maxValue == 0 ? 1 : maxValue];
}
