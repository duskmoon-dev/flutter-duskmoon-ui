import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../dm_chart_models.dart';
import '../dm_chart_palette.dart';
import '../vendor/dv_scale/dv_scale.dart';
import '../vendor/dv_xychart/dv_xychart.dart';

class DmVizLineChart extends StatelessWidget {
  final List<DmVizPoint> data;
  final List<DmVizPoint>? comparisonData;
  final String? xAxisLabel;
  final String? yAxisLabel;
  final bool smooth;
  final bool showMarkers;
  final DmChartPalette? palette;

  const DmVizLineChart({
    super.key,
    required this.data,
    this.comparisonData,
    this.xAxisLabel,
    this.yAxisLabel,
    this.smooth = true,
    this.showMarkers = true,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedPalette =
        palette ?? DmChartPalette.fromTheme(Theme.of(context));
    final xDomain = _numericDomain([
      ...data.map((point) => point.x),
      ...?comparisonData?.map((point) => point.x),
    ]);
    final yDomain = _numericDomain([
      ...data.map((point) => point.y),
      ...?comparisonData?.map((point) => point.y),
    ], includeZero: true);

    return XYChart(
      xScale: LinearScale(domain: xDomain, range: [0, 1]),
      yScale: LinearScale(domain: yDomain, range: [1, 0]),
      xAxisLabel: xAxisLabel,
      yAxisLabel: yAxisLabel,
      backgroundColor: resolvedPalette.background,
      gridColor: resolvedPalette.grid,
      axisColor: resolvedPalette.axis,
      children: [
        LineSeries(
          data: data.map((point) => point.toRaw()).toList(growable: false),
          color: resolvedPalette.primary,
          showMarkers: showMarkers,
          smooth: smooth,
          markerColor: resolvedPalette.primary,
        ),
        if (comparisonData != null)
          LineSeries(
            data: comparisonData!
                .map((point) => point.toRaw())
                .toList(growable: false),
            color: resolvedPalette.secondary,
            showMarkers: showMarkers,
            smooth: false,
            dashPattern: const [10, 6],
            markerColor: resolvedPalette.secondary,
          ),
      ],
    );
  }
}

List<double> _numericDomain(Iterable<Object?> values,
    {bool includeZero = false}) {
  final numericValues =
      values.whereType<num>().map((value) => value.toDouble()).toList();
  if (numericValues.isEmpty) {
    return [0, 1];
  }

  var minValue = numericValues.reduce(math.min);
  var maxValue = numericValues.reduce(math.max);

  if (includeZero) {
    minValue = math.min(0, minValue);
    maxValue = math.max(0, maxValue);
  }

  if (minValue == maxValue) {
    final padding = minValue == 0 ? 1.0 : minValue.abs() * 0.1;
    return [minValue - padding, maxValue + padding];
  }

  return [minValue, maxValue];
}
