# duskmoon_visualization

Data visualization package for the DuskMoon Design System.

`duskmoon_visualization` now exposes a curated DuskMoon-facing API for common chart
and relationship views, while preserving the full migrated `data_visualization`
workspace behind a separate compatibility import.

## What To Import

- `package:duskmoon_visualization/duskmoon_visualization.dart`
  Use this for the curated DuskMoon API: `Dm*` data models, theme-aware wrappers,
  and stable public defaults.
- `package:duskmoon_visualization/duskmoon_visualization_compat.dart`
  Use this only when you need the full migrated `dv_*` surface directly.

## Curated Surface

The default import currently includes:

- Chart data models: `DmVizPoint`, `DmVizHeatmapCell`, `DmVizMarkerShape`
- Network data models: `DmVizNetworkNode`, `DmVizNetworkEdge`, `DmVizNetworkNodeShape`, `DmVizNetworkLinkStyle`
- Theme helpers: `DmChartPalette`
- Wrappers: `DmVizLineChart`, `DmVizBarChart`, `DmVizScatterChart`, `DmVizHeatmap`, `DmVizNetworkGraph`

## Line Chart Example

```dart
import 'package:duskmoon_visualization/duskmoon_visualization.dart';
import 'package:flutter/material.dart';

class SalesChart extends StatelessWidget {
  const SalesChart({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 240,
      child: DmVizLineChart(
        data: [
          DmVizPoint(x: 0, y: 18),
          DmVizPoint(x: 1, y: 28),
          DmVizPoint(x: 2, y: 41),
          DmVizPoint(x: 3, y: 55),
        ],
        comparisonData: [
          DmVizPoint(x: 0, y: 22),
          DmVizPoint(x: 1, y: 26),
          DmVizPoint(x: 2, y: 31),
          DmVizPoint(x: 3, y: 38),
        ],
        xAxisLabel: 'Week',
        yAxisLabel: 'Revenue',
      ),
    );
  }
}
```

## Network Graph Example

```dart
import 'package:duskmoon_visualization/duskmoon_visualization.dart';
import 'package:flutter/material.dart';

class DependencyGraph extends StatelessWidget {
  const DependencyGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 280,
      child: DmVizNetworkGraph(
        nodes: [
          DmVizNetworkNode(id: 'core', label: 'Core', x: 80, y: 90, fixed: true),
          DmVizNetworkNode(id: 'theme', label: 'Theme', x: 210, y: 55, fixed: true),
          DmVizNetworkNode(id: 'widgets', label: 'Widgets', x: 240, y: 150, fixed: true),
        ],
        links: [
          DmVizNetworkEdge(source: 'core', target: 'theme'),
          DmVizNetworkEdge(source: 'core', target: 'widgets', directed: true),
        ],
        enableSimulation: false,
        nodeShape: DmVizNetworkNodeShape.hexagon,
        linkStyle: DmVizNetworkLinkStyle.curved,
      ),
    );
  }
}
```

## When To Use Compat

Reach for `duskmoon_visualization_compat.dart` if you need one of these:

- Raw migrated widgets such as `XYChart`, `Heatmap`, or `Network`
- Lower-level geometry, scale, map, geo, or interaction primitives
- Existing code that still depends on `dv_*` type names

If you are starting a new DuskMoon-facing screen or package, prefer the curated
`duskmoon_visualization.dart` import.

## Status

- Exported through `duskmoon_ui`
- Curated wrappers are covered by widget smoke tests
- Full migrated `dv_*` compatibility surface is preserved behind the compat import
- Migration checklist is tracked in `docs/visualization-migration.md`
