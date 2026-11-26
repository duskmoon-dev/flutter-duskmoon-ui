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
- Wrappers: `DmVizLineChart`, `DmVizBarChart`, `DmVizScatterChart`, `DmVizHeatmap`, `DmVizNetworkGraph`, `DmVizMapChart`

## Shared chart contract

Use the `.series` constructors on Line, Bar and Scatter or `DmVizHeatmap.cells`
for stable IDs and missing values. These constructors follow the Web and
Flutter contract bundled under `specs/visualization/v1`.

```dart
const DmVizLineChart.series(
  xAxis: DmVizAxis.category(),
  yAxis: DmVizAxis.numeric(unit: 'ms'),
  series: [
    DmVizSeries(
      id: 'latency',
      name: 'Latency',
      data: [
        DmVizDatum(id: 'mon', x: 'Mon', y: 15),
        DmVizDatum(id: 'tue', x: 'Tue', y: null),
        DmVizDatum(id: 'wed', x: 'Wed', y: 17),
        DmVizDatum(id: 'thu', x: 'Thu', y: 19),
      ],
    ),
  ],
  options: DmVizOptions(title: 'Request latency'),
  marker: DmVizMarker(visible: true),
)
```

Line uses straight segments and leaves a gap at missing values. Use
`DmVizAxis.time` for timestamp inputs and `DmVizFormat` to configure an IANA
time zone for display. Bar groups series on its category axis and starts from a
shared zero baseline. Heatmap cells use row and column IDs, and their color scale
is continuous. The original constructors retain their existing data types and
defaults.

Use `DmVizNetworkGraph.fixed` with stable node and edge IDs and positions in
layout units. Use `DmVizMapChart.mercator` with offline GeoJSON containing
identified Polygon, MultiPolygon, and Point features within ±85° latitude and
without antimeridian crossings. Both support viewport pan and zoom.

Pass `DmVizInteraction(onEvent: ...)` to listen for typed events. Supply
`selection`, `hiddenSeriesIds`, or `viewport` and write the updated value back
to control that part of the state. Hover or tap a mark to inspect it. Focus the
plot and use the arrow keys to inspect marks and Enter or Space to select them.
Shift with Left/Right brushes a numeric or time line. Shift with arrows pans a
scene and Alt with arrows moves a network node. Assistive technology has plot
actions and a separate **Show chart data** control.

The design preview's **Shared chart fixtures** gallery uses the imported
contract data. See the repository's [migration guide](https://github.com/duskmoon-dev/duskmoon-flutter/blob/main/docs/visualization-migration.md)
for constructor mappings.

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

## Source and licenses

Imported `dv_*` program code retains the GSMLG Limited MIT notice alongside
DuskMoon's own MIT terms. Embedded Natural Earth data provenance and known
generation steps are documented separately from source-code licensing.

See [SOURCE.md](SOURCE.md),
[LICENSE](LICENSE) and [THIRD_PARTY_LICENSES](THIRD_PARTY_LICENSES) for the
retained notices, import history and known provenance limits.
