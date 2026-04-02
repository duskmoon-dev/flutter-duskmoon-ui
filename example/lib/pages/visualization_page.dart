import 'package:flutter/material.dart';

import 'package:duskmoon_ui/duskmoon_ui.dart';

import 'visualization/chart_gallery_page.dart';
import 'visualization/geo_map_page.dart';
import 'visualization/interactive_chart_page.dart';

class VisualizationPage extends StatelessWidget {
  const VisualizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Visualization',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Migrated from the original data_visualization showcase and merged into the DuskMoon example app as a dedicated module.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        const _VisualizationModuleCard(
          title: 'Curated Charts',
          description:
              'DuskMoon-native DmViz wrappers for line, bar, scatter, heatmap, and network views.',
          icon: Icons.dashboard_customize_outlined,
          tags: ['DmViz*', 'Theme-aware', 'Showcase'],
          destination: ChartGalleryPage(),
        ),
        const SizedBox(height: 12),
        const _VisualizationModuleCard(
          title: 'Geo Projection Lab',
          description:
              'Projection switching and map interaction migrated from the source showcase app using the compat surface.',
          icon: Icons.public_outlined,
          tags: ['Compat', 'Geo', 'Projection'],
          destination: GeoMapPage(),
        ),
        const SizedBox(height: 12),
        const _VisualizationModuleCard(
          title: 'Interactive Hover Demo',
          description:
              'Pointer-driven detail inspection adapted from the original interactive chart example.',
          icon: Icons.ads_click_outlined,
          tags: ['Compat', 'Desktop', 'Touch'],
          destination: InteractiveChartPage(),
        ),
      ],
    );
  }
}

class _VisualizationModuleCard extends StatelessWidget {
  const _VisualizationModuleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.tags,
    required this.destination,
  });

  final String title;
  final String description;
  final IconData icon;
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
