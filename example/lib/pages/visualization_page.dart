import 'package:flutter/material.dart';

import 'package:duskmoon_ui/duskmoon_ui.dart';

import 'visualization/chart_gallery_page.dart';
import 'visualization/geo_gallery_page.dart';
import 'visualization/interactions_page.dart';
import 'visualization/lines_bars_page.dart';
import 'visualization/radial_page.dart';
import 'visualization/scatter_network_page.dart';

// ---------------------------------------------------------------------------
// VisualizationPage
// ---------------------------------------------------------------------------

class VisualizationPage extends StatelessWidget {
  const VisualizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Data Visualization Gallery',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          '35+ chart types from basic to advanced, migrated from the data_visualization showcase.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        const _VisualizationModuleCard(
          icon: Icons.show_chart_outlined,
          title: 'DmViz Charts',
          description:
              'DuskMoon-native curated chart wrappers (line, bar, scatter, heatmap, network).',
          tags: ['DmViz', 'Theme-aware', '5 types'],
          destination: ChartGalleryPage(),
        ),
        const SizedBox(height: 12),
        const _VisualizationModuleCard(
          icon: Icons.timeline_outlined,
          title: 'Lines & Bars',
          description:
              'Line, area, bar, stacked, horizontal, streamgraph charts.',
          tags: ['Line', 'Bar', 'Area', 'Stream'],
          destination: LinesBarsPage(),
        ),
        const SizedBox(height: 12),
        const _VisualizationModuleCard(
          icon: Icons.pie_chart_outline,
          title: 'Radial & Hierarchy',
          description: 'Pie, radar, radial bar, and box plot charts.',
          tags: ['Pie', 'Radar', 'Radial', 'BoxPlot'],
          destination: RadialPage(),
        ),
        const SizedBox(height: 12),
        const _VisualizationModuleCard(
          icon: Icons.scatter_plot_outlined,
          title: 'Scatter & Network',
          description:
              'Scatter, heatmap, force-directed networks, chord, sankey.',
          tags: ['Scatter', 'Network', 'Chord', 'Sankey'],
          destination: ScatterNetworkPage(),
        ),
        const SizedBox(height: 12),
        const _VisualizationModuleCard(
          icon: Icons.public_outlined,
          title: 'Geographic',
          description: 'World map projections, animated globe, regional focus.',
          tags: ['Mercator', 'Globe', 'Regions'],
          destination: GeoGalleryPage(),
        ),
        const SizedBox(height: 12),
        const _VisualizationModuleCard(
          icon: Icons.touch_app_outlined,
          title: 'Interactions & Utilities',
          description:
              'Hover, brush selection, zoom/pan, scale types, wordcloud.',
          tags: ['Interactive', 'Brush', 'Zoom'],
          destination: InteractionsPage(),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _VisualizationModuleCard  (unchanged API, updated implementation)
// ---------------------------------------------------------------------------

class _VisualizationModuleCard extends StatelessWidget {
  const _VisualizationModuleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.tags,
    required this.destination,
  });

  final IconData icon;
  final String title;
  final String description;
  final List<String> tags;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: colorScheme.onPrimaryContainer),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final tag in tags)
                  Chip(
                    label: Text(tag),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => destination),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Open module'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
