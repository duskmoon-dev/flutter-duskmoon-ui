import 'package:duskmoon_visualization/duskmoon_visualization.dart';
import 'package:flutter/widgets.dart';

typedef _Json = Map<String, dynamic>;

List<_Json> _objects(Object? input) => (input as List).cast<_Json>();
List<DmVizCategory> _categories(Object? input) => [
      if (input != null)
        for (final item in _objects(input))
          DmVizCategory(
              id: item['id'] as String, label: item['label'] as String),
    ];
Color _color(String hex) =>
    Color(int.parse(hex.substring(1), radix: 16) | 0xff000000);

List<DmVizSeries> _series(Object? input) => [
      for (final source in _objects(input))
        DmVizSeries(
          id: source['id'] as String,
          name: source['name'] as String,
          data: [
            for (final point in _objects(source['data']))
              DmVizDatum(
                id: point['id'] as String,
                x: point['x'],
                y: (point['y'] as num?)?.toDouble(),
              ),
          ],
        ),
    ];

Widget contractFixtureChart(Map<String, dynamic> chart) =>
    switch (chart['kind']) {
      'line' => DmVizLineChart.series(
          series: _series(chart['series']),
          marker: const DmVizMarker(visible: true),
          options: const DmVizOptions(
            title: 'Ordered line',
            description:
                'Repeated x values and a missing point that breaks the line.',
          ),
        ),
      'bar' => DmVizBarChart.series(
          series: _series(chart['series']),
          categories: _categories(chart['categories']),
          options: const DmVizOptions(
            title: 'Grouped bars',
            description: 'Positive, negative and zero values for two series.',
          ),
        ),
      'scatter' => DmVizScatterChart.series(
          series: _series(chart['series']),
          options: const DmVizOptions(
            title: 'Missing coordinates',
            description:
                'Records with missing coordinates remain in the chart data.',
          ),
        ),
      'heatmap' => _heatmap(chart),
      'network' => DmVizNetworkGraph.fixed(
          nodes: [
            for (final node in _objects(chart['nodes']))
              DmVizNetworkNode(
                id: node['id'] as String,
                x: (node['x'] as num).toDouble(),
                y: (node['y'] as num).toDouble(),
              ),
          ],
          edges: [
            for (final edge in _objects(chart['edges']))
              DmVizNetworkEdge(
                id: edge['id'] as String,
                source: edge['source'] as String,
                target: edge['target'] as String,
              ),
          ],
          options: const DmVizOptions(
            title: 'Fixed network',
            description:
                'Drag a node to move it or drag the background to pan.',
          ),
        ),
      'map' => DmVizMapChart.mercator(
          geoJson: GeoJsonFeatureCollection.fromJson(chart['geoJson'] as _Json),
          padding: ((chart['options'] as _Json)['padding'] as num).toDouble(),
          options: const DmVizOptions(
            title: 'Mercator map',
            description: 'Offline polygons, a hole and a point marker.',
          ),
        ),
      _ => const Text('Unknown chart fixture'),
    };

Widget _heatmap(_Json chart) {
  final theme = (chart['options'] as _Json)['theme'] as _Json;
  return DmVizHeatmap.cells(
    rows: _categories(chart['rows']),
    columns: _categories(chart['columns']),
    data: [
      for (final cell in _objects(chart['cells']))
        DmVizHeatmapDatum(
          id: cell['id'] as String,
          rowId: cell['rowId'] as String,
          columnId: cell['columnId'] as String,
          value: (cell['value'] as num?)?.toDouble(),
        ),
    ],
    options: DmVizOptions(
      title: 'Ordered heatmap',
      description:
          'Ordered rows and columns with a continuous scale and a missing cell.',
      missingColor: _color(theme['missing'] as String),
      heatmapColors:
          (theme['heatmapColors'] as List).cast<String>().map(_color).toList(),
    ),
  );
}
