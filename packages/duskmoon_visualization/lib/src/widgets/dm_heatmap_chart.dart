import 'package:flutter/material.dart';

import '../dm_chart_models.dart';
import '../dm_chart_palette.dart';
import '../dm_viz_interaction.dart';
import '../dm_viz_series.dart';
import 'dm_viz_series_plot.dart';
import '../vendor/dv_heatmap/dv_heatmap.dart';

class DmVizHeatmap extends StatelessWidget {
  final List<DmVizHeatmapCell> data;
  final int rows;
  final int columns;
  final List<String>? rowLabels;
  final List<String>? columnLabels;
  final bool showValues;
  final DmChartPalette? palette;

  final List<DmVizCategory> _rowCategories;
  final List<DmVizCategory> _columnCategories;
  final List<DmVizHeatmapDatum>? _cells;
  final (double, double)? valueDomain;
  final DmVizOptions options;
  final DmVizInteraction interaction;
  final double height;

  const DmVizHeatmap({
    super.key,
    required this.data,
    required this.rows,
    required this.columns,
    this.rowLabels,
    this.columnLabels,
    this.showValues = true,
    this.palette,
  })  : _rowCategories = const [],
        _columnCategories = const [],
        _cells = null,
        valueDomain = null,
        options = const DmVizOptions(),
        interaction = const DmVizInteraction(),
        height = 300;

  /// Creates a heatmap with stable row, column and cell IDs.
  const DmVizHeatmap.cells({
    super.key,
    required List<DmVizCategory> rows,
    required List<DmVizCategory> columns,
    required List<DmVizHeatmapDatum> data,
    this.valueDomain,
    this.options = const DmVizOptions(),
    this.interaction = const DmVizInteraction(),
    this.height = 300,
    this.showValues = false,
    this.palette,
  })  : _rowCategories = rows,
        _columnCategories = columns,
        _cells = data,
        rows = 0,
        columns = 0,
        rowLabels = null,
        columnLabels = null,
        data = const [];

  @override
  Widget build(BuildContext context) {
    if (_cells case final cells?) {
      return DmVizHeatmapPlot(
        rows: _rowCategories,
        columns: _columnCategories,
        data: cells,
        valueDomain: valueDomain,
        showValues: showValues,
        options: options,
        interaction: interaction,
        palette: palette,
        height: height,
      );
    }

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
