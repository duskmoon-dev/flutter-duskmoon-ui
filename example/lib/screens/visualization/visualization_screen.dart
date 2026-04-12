import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../destination.dart';
import 'chart_gallery_page.dart';
import 'geo_gallery_page.dart';
import 'interactions_page.dart';
import 'lines_bars_page.dart';
import 'radial_page.dart';
import 'scatter_network_page.dart';

class VisualizationScreen extends StatelessWidget {
  static const name = 'Visualization';
  static const path = '/visualization';

  const VisualizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DmAdaptiveScaffold(
      selectedIndex: Destinations.indexOf(const Key(name)),
      onSelectedIndexChange: (idx) => Destinations.changeHandler(idx, context),
      destinations: Destinations.navs,
      useDrawer: true,
      transitionDuration: Duration.zero,
      appBar: DmAppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Visualization'),
        actions: const [PlatformSwitchAction()],
      ),
      appBarBreakpoint: Breakpoints.standard,
      body: (_) => const _VisualizationBody(),
    );
  }
}

class _VisualizationBody extends StatelessWidget {
  const _VisualizationBody();

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
          routeName: ChartGalleryPage.name,
        ),
        const SizedBox(height: 12),
        const _VisualizationModuleCard(
          icon: Icons.timeline_outlined,
          title: 'Lines & Bars',
          description:
              'Line, area, bar, stacked, horizontal, streamgraph charts.',
          tags: ['Line', 'Bar', 'Area', 'Stream'],
          routeName: LinesBarsPage.name,
        ),
        const SizedBox(height: 12),
        const _VisualizationModuleCard(
          icon: Icons.pie_chart_outline,
          title: 'Radial & Hierarchy',
          description: 'Pie, radar, radial bar, and box plot charts.',
          tags: ['Pie', 'Radar', 'Radial', 'BoxPlot'],
          routeName: RadialPage.name,
        ),
        const SizedBox(height: 12),
        const _VisualizationModuleCard(
          icon: Icons.scatter_plot_outlined,
          title: 'Scatter & Network',
          description:
              'Scatter, heatmap, force-directed networks, chord, sankey.',
          tags: ['Scatter', 'Network', 'Chord', 'Sankey'],
          routeName: ScatterNetworkPage.name,
        ),
        const SizedBox(height: 12),
        const _VisualizationModuleCard(
          icon: Icons.public_outlined,
          title: 'Geographic',
          description: 'World map projections, animated globe, regional focus.',
          tags: ['Mercator', 'Globe', 'Regions'],
          routeName: GeoGalleryPage.name,
        ),
        const SizedBox(height: 12),
        const _VisualizationModuleCard(
          icon: Icons.touch_app_outlined,
          title: 'Interactions & Utilities',
          description:
              'Hover, brush selection, zoom/pan, scale types, wordcloud.',
          tags: ['Interactive', 'Brush', 'Zoom'],
          routeName: InteractionsPage.name,
        ),
      ],
    );
  }
}

class _VisualizationModuleCard extends StatelessWidget {
  const _VisualizationModuleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.tags,
    required this.routeName,
  });

  final IconData icon;
  final String title;
  final String description;
  final List<String> tags;
  final String routeName;

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
                onPressed: () => context.goNamed(routeName),
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
