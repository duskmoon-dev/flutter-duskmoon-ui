import 'package:flutter/material.dart';

import 'package:duskmoon_ui/duskmoon_ui.dart';

import '../../destination.dart';

class ChartGalleryPage extends StatelessWidget {
  const ChartGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DmAdaptiveScaffold(
      selectedIndex: Destinations.indexOf(const Key('Visualization')),
      onSelectedIndexChange: (idx) => Destinations.changeHandler(idx, context),
      destinations: Destinations.navs,
      useDrawer: true,
      transitionDuration: Duration.zero,
      appBar: DmAppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Curated Charts'),
        leading: const BackButton(),
      ),
      appBarBreakpoint: Breakpoints.standard,
      body: (_) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'DmViz wrappers',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'This module keeps the original example app spirit, but routes the primary chart demos through the new DuskMoon-facing API.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          const _ChartCard(
            title: 'Line chart',
            description:
                'Theme-aware trend lines with comparison data and automatic domains.',
            height: 240,
            child: DmVizLineChart(
              data: _revenueSeries,
              comparisonData: _retentionSeries,
              xAxisLabel: 'Week',
              yAxisLabel: 'Score',
            ),
          ),
          const SizedBox(height: 16),
          const _ChartCard(
            title: 'Bar chart',
            description:
                'Simplified categorical bars with DuskMoon positive-state defaults.',
            height: 220,
            child: DmVizBarChart(
              data: _ordersSeries,
              xAxisLabel: 'Quarter',
              yAxisLabel: 'Orders',
            ),
          ),
          const SizedBox(height: 16),
          _ChartCard(
            title: 'Scatter chart',
            description:
                'Scatter markers with automatic extents and custom marker sizing.',
            height: 240,
            child: DmVizScatterChart(
              data: _scatterSeries,
              xAxisLabel: 'Reach',
              yAxisLabel: 'Conversion',
              shape: DmVizMarkerShape.diamond,
              radiusAccessor: (point) =>
                  (point.metadata?['size'] as double?) ?? 6,
            ),
          ),
          const SizedBox(height: 16),
          const _ChartCard(
            title: 'Heatmap',
            description:
                'Compact matrix view using the curated heatmap wrapper.',
            height: 260,
            child: DmVizHeatmap(
              data: _heatmapSeries,
              rows: 4,
              columns: 5,
              rowLabels: ['North', 'South', 'East', 'West'],
              columnLabels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
            ),
          ),
          const SizedBox(height: 16),
          const _ChartCard(
            title: 'Network graph',
            description:
                'Relationship view on top of the migrated vendor network renderer.',
            height: 280,
            child: DmVizNetworkGraph(
              nodes: _networkNodes,
              links: _networkEdges,
              enableSimulation: false,
              nodeShape: DmVizNetworkNodeShape.hexagon,
              linkStyle: DmVizNetworkLinkStyle.curved,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.title,
    required this.description,
    required this.height,
    required this.child,
  });

  final String title;
  final String description;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(description, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            SizedBox(height: height, child: child),
          ],
        ),
      ),
    );
  }
}

const _revenueSeries = <DmVizPoint>[
  DmVizPoint(x: 0, y: 18),
  DmVizPoint(x: 1, y: 28),
  DmVizPoint(x: 2, y: 41),
  DmVizPoint(x: 3, y: 55),
  DmVizPoint(x: 4, y: 63),
  DmVizPoint(x: 5, y: 78),
  DmVizPoint(x: 6, y: 86),
];

const _retentionSeries = <DmVizPoint>[
  DmVizPoint(x: 0, y: 52),
  DmVizPoint(x: 1, y: 58),
  DmVizPoint(x: 2, y: 54),
  DmVizPoint(x: 3, y: 61),
  DmVizPoint(x: 4, y: 67),
  DmVizPoint(x: 5, y: 71),
  DmVizPoint(x: 6, y: 76),
];

const _ordersSeries = <DmVizPoint>[
  DmVizPoint(x: 0.5, y: 36),
  DmVizPoint(x: 1.5, y: 48),
  DmVizPoint(x: 2.5, y: 61),
  DmVizPoint(x: 3.5, y: 73),
];

const _scatterSeries = <DmVizPoint>[
  DmVizPoint(x: 18, y: 22, metadata: {'size': 5.0}),
  DmVizPoint(x: 29, y: 41, metadata: {'size': 8.0}),
  DmVizPoint(x: 42, y: 35, metadata: {'size': 6.0}),
  DmVizPoint(x: 58, y: 63, metadata: {'size': 10.0}),
  DmVizPoint(x: 70, y: 57, metadata: {'size': 7.0}),
  DmVizPoint(x: 84, y: 81, metadata: {'size': 11.0}),
];

const _heatmapSeries = <DmVizHeatmapCell>[
  DmVizHeatmapCell(row: 0, column: 0, value: 42),
  DmVizHeatmapCell(row: 0, column: 1, value: 58),
  DmVizHeatmapCell(row: 0, column: 2, value: 74),
  DmVizHeatmapCell(row: 0, column: 3, value: 61),
  DmVizHeatmapCell(row: 0, column: 4, value: 35),
  DmVizHeatmapCell(row: 1, column: 0, value: 22),
  DmVizHeatmapCell(row: 1, column: 1, value: 47),
  DmVizHeatmapCell(row: 1, column: 2, value: 53),
  DmVizHeatmapCell(row: 1, column: 3, value: 80),
  DmVizHeatmapCell(row: 1, column: 4, value: 65),
  DmVizHeatmapCell(row: 2, column: 0, value: 68),
  DmVizHeatmapCell(row: 2, column: 1, value: 71),
  DmVizHeatmapCell(row: 2, column: 2, value: 49),
  DmVizHeatmapCell(row: 2, column: 3, value: 33),
  DmVizHeatmapCell(row: 2, column: 4, value: 59),
  DmVizHeatmapCell(row: 3, column: 0, value: 15),
  DmVizHeatmapCell(row: 3, column: 1, value: 28),
  DmVizHeatmapCell(row: 3, column: 2, value: 44),
  DmVizHeatmapCell(row: 3, column: 3, value: 62),
  DmVizHeatmapCell(row: 3, column: 4, value: 91),
];

const _networkNodes = <DmVizNetworkNode>[
  DmVizNetworkNode(
    id: 'core',
    label: 'Core',
    group: 'platform',
    x: 90,
    y: 90,
    fixed: true,
    radius: 18,
  ),
  DmVizNetworkNode(
    id: 'theme',
    label: 'Theme',
    group: 'design',
    x: 220,
    y: 50,
    fixed: true,
    radius: 15,
  ),
  DmVizNetworkNode(
    id: 'widgets',
    label: 'Widgets',
    group: 'design',
    x: 250,
    y: 150,
    fixed: true,
    radius: 15,
  ),
  DmVizNetworkNode(
    id: 'viz',
    label: 'Viz',
    group: 'feature',
    x: 180,
    y: 230,
    fixed: true,
    radius: 16,
  ),
  DmVizNetworkNode(
    id: 'example',
    label: 'Example',
    group: 'app',
    x: 60,
    y: 230,
    fixed: true,
    radius: 14,
  ),
];

const _networkEdges = <DmVizNetworkEdge>[
  DmVizNetworkEdge(source: 'core', target: 'theme', weight: 1.2),
  DmVizNetworkEdge(source: 'core', target: 'widgets', weight: 1.5),
  DmVizNetworkEdge(source: 'core', target: 'viz', weight: 1.1),
  DmVizNetworkEdge(source: 'viz', target: 'example', weight: 0.8),
  DmVizNetworkEdge(source: 'widgets', target: 'example', weight: 0.7),
];
