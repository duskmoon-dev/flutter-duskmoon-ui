import 'package:flutter/material.dart';

import '../dm_chart_models.dart';
import '../dm_chart_palette.dart';
import '../vendor/dv_heatmap/dv_heatmap.dart';

class DmVizHeatmap extends StatelessWidget {
  final List<DmVizHeatmapCell> data;
  final int rows;
  final int columns;
  final List<String>? rowLabels;
  final List<String>? columnLabels;
  final bool showValues;
  final DmChartPalette? palette;

  const DmVizHeatmap({
    super.key,
    required this.data,
    required this.rows,
    required this.columns,
    this.rowLabels,
    this.columnLabels,
    this.showValues = true,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedPalette =
        palette ?? DmChartPalette.fromTheme(Theme.of(context));
    final minValue = data.isEmpty
        ? 0.0
        : data
            .map((point) => point.value)
            .reduce((left, right) => left < right ? left : right);
    final maxValue = data.isEmpty
        ? 1.0
        : data
            .map((point) => point.value)
            .reduce((left, right) => left > right ? left : right);

    return Heatmap(
      data: data.map((point) => point.toRaw()).toList(growable: false),
      rows: rows,
      columns: columns,
      rowLabels: rowLabels,
      columnLabels: columnLabels,
      colorScale: HeatmapColorScale.viridis(
        minValue: minValue,
        maxValue: maxValue == minValue ? minValue + 1 : maxValue,
      ),
      cellPadding: 3,
      cellRadius: 8,
      showValues: showValues,
      valueStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
      borderColor: resolvedPalette.heatmapBorder,
      borderWidth: 1,
    );
  }
}
