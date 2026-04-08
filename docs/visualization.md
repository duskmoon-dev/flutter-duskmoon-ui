# Data Visualization

The `duskmoon_visualization` package provides five chart widgets that automatically integrate with the DuskMoon theme system. Colors are derived from `DmColorExtension` and the Material 3 color scheme — no manual theming required.

## Table of Contents

- [Installation](#installation)
- [Quick Start](#quick-start)
- [Line Chart](#line-chart)
- [Bar Chart](#bar-chart)
- [Scatter Chart](#scatter-chart)
- [Heatmap](#heatmap)
- [Network Graph](#network-graph)
- [Theming with DmChartPalette](#theming-with-dmchartpalette)
- [Compatibility Import](#compatibility-import)

## Installation

```yaml
dependencies:
  duskmoon_visualization: ^1.3.0
```

```dart
import 'package:duskmoon_visualization/duskmoon_visualization.dart';
```

Or use the umbrella package which re-exports everything:

```yaml
dependencies:
  duskmoon_ui: ^1.3.0
```

> **Requirements:** Dart >= 3.5.0, Flutter >= 3.24.0

## Quick Start

All charts work with zero configuration beyond supplying data:

```dart
DmVizLineChart(
  data: [
    DmVizPoint(x: 1, y: 10),
    DmVizPoint(x: 2, y: 35),
    DmVizPoint(x: 3, y: 22),
  ],
)
```

Charts automatically pick up colors from `Theme.of(context)` via `DmChartPalette.fromTheme()`.

## Line Chart

`DmVizLineChart` renders a line chart with optional comparison data.

```dart
DmVizLineChart(
  data: [
    DmVizPoint(x: 'Jan', y: 1200),
    DmVizPoint(x: 'Feb', y: 1800),
    DmVizPoint(x: 'Mar', y: 1500),
    DmVizPoint(x: 'Apr', y: 2100),
  ],
  comparisonData: [   // Optional second line (dashed, linear)
    DmVizPoint(x: 'Jan', y: 1000),
    DmVizPoint(x: 'Feb', y: 1400),
    DmVizPoint(x: 'Mar', y: 1600),
    DmVizPoint(x: 'Apr', y: 1900),
  ],
  xAxisLabel: 'Month',
  yAxisLabel: 'Revenue',
  smooth: true,       // Smooth curves for primary line (default: true)
  showMarkers: true,  // Show point dots (default: true)
)
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `data` | `List<DmVizPoint>` | required | Primary line data |
| `comparisonData` | `List<DmVizPoint>?` | `null` | Second line (dashed, secondary color) |
| `xAxisLabel` | `String?` | `null` | X-axis label |
| `yAxisLabel` | `String?` | `null` | Y-axis label |
| `smooth` | `bool` | `true` | Curved primary line |
| `showMarkers` | `bool` | `true` | Point markers |
| `palette` | `DmChartPalette?` | auto | Custom color palette |

## Bar Chart

`DmVizBarChart` renders a vertical bar chart.

```dart
DmVizBarChart(
  data: [
    DmVizPoint(x: 'Q1', y: 42500),
    DmVizPoint(x: 'Q2', y: 67800),
    DmVizPoint(x: 'Q3', y: 55200),
    DmVizPoint(x: 'Q4', y: 71000),
  ],
  xAxisLabel: 'Quarter',
  yAxisLabel: 'Sales',
  cornerRadius: 8,   // Rounded bar corners (default: 8)
)
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `data` | `List<DmVizPoint>` | required | Bar data (x: label, y: height) |
| `xAxisLabel` | `String?` | `null` | X-axis label |
| `yAxisLabel` | `String?` | `null` | Y-axis label |
| `cornerRadius` | `double` | `8` | Bar corner radius in pixels |
| `palette` | `DmChartPalette?` | auto | Custom color palette |

## Scatter Chart

`DmVizScatterChart` renders a scatter plot with configurable marker shapes and optional dynamic sizing.

```dart
DmVizScatterChart(
  data: [
    DmVizPoint(x: 1.2, y: 3.4),
    DmVizPoint(x: 2.8, y: 1.9),
    DmVizPoint(x: 3.5, y: 4.2),
    DmVizPoint(x: 0.8, y: 2.1),
  ],
  xAxisLabel: 'X Axis',
  yAxisLabel: 'Y Axis',
  shape: DmVizMarkerShape.circle,
  radiusAccessor: (point) => (point.y * 4).clamp(4.0, 20.0),
)
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `data` | `List<DmVizPoint>` | required | Point data |
| `xAxisLabel` | `String?` | `null` | X-axis label |
| `yAxisLabel` | `String?` | `null` | Y-axis label |
| `shape` | `DmVizMarkerShape` | `circle` | Marker shape |
| `radiusAccessor` | `double Function(DmVizPoint)?` | `null` | Dynamic radius per point |
| `palette` | `DmChartPalette?` | auto | Custom color palette |

### DmVizMarkerShape

```dart
enum DmVizMarkerShape { circle, square, triangle, diamond, cross, plus, star }
```

## Heatmap

`DmVizHeatmap` renders a grid-based heatmap using a Viridis color scale.

```dart
DmVizHeatmap(
  rows: 5,
  columns: 7,
  data: List.generate(5, (row) =>
    List.generate(7, (col) =>
      DmVizHeatmapCell(row: row, column: col, value: Random().nextDouble()),
    ),
  ).expand((x) => x).toList(),
  rowLabels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
  columnLabels: ['00h', '04h', '08h', '12h', '16h', '20h', '24h'],
  showValues: true,
)
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `data` | `List<DmVizHeatmapCell>` | required | Cell data |
| `rows` | `int` | required | Number of rows |
| `columns` | `int` | required | Number of columns |
| `rowLabels` | `List<String>?` | `null` | Row axis labels |
| `columnLabels` | `List<String>?` | `null` | Column axis labels |
| `showValues` | `bool` | `true` | Show value text in each cell |
| `palette` | `DmChartPalette?` | auto | Custom color palette |

### DmVizHeatmapCell

```dart
DmVizHeatmapCell(
  row: 2,
  column: 5,
  value: 0.75,                    // Intensity value (any range)
  metadata: {'label': 'High'},    // Optional custom data
)
```

## Network Graph

`DmVizNetworkGraph` renders an interactive network/graph visualization with optional physics simulation.

```dart
DmVizNetworkGraph(
  nodes: [
    DmVizNetworkNode(id: 'a', label: 'Server', group: 'backend', radius: 14),
    DmVizNetworkNode(id: 'b', label: 'API', group: 'backend'),
    DmVizNetworkNode(id: 'c', label: 'App', group: 'frontend'),
    DmVizNetworkNode(id: 'd', label: 'DB', group: 'backend', color: Colors.orange),
  ],
  links: [
    DmVizNetworkEdge(source: 'a', target: 'b', directed: true),
    DmVizNetworkEdge(source: 'b', target: 'c', weight: 2.0),
    DmVizNetworkEdge(source: 'b', target: 'd', label: 'queries'),
  ],
  enableSimulation: true,
  showNodeLabels: true,
  showLinkLabels: false,
  enableZoomPan: true,
  draggableNodes: true,
  nodeShape: DmVizNetworkNodeShape.circle,
  linkStyle: DmVizNetworkLinkStyle.curved,
  groupColors: {
    'backend': Colors.blue,
    'frontend': Colors.green,
  },
  onNodeTap: (node) => print('Tapped: ${node.label}'),
  onLinkTap: (edge) => print('Edge: ${edge.source} → ${edge.target}'),
)
```

### DmVizNetworkNode parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `id` | `String` | required | Unique identifier |
| `label` | `String?` | `null` | Display label |
| `group` | `String?` | `null` | Group for `groupColors` mapping |
| `x` | `double?` | auto | Pre-set X position |
| `y` | `double?` | auto | Pre-set Y position |
| `fixed` | `bool` | `false` | Lock position during simulation |
| `radius` | `double` | `10` | Node size |
| `color` | `Color?` | palette.primary | Override color (takes priority over group) |

### DmVizNetworkEdge parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `source` | `String` | required | Source node ID |
| `target` | `String` | required | Target node ID |
| `weight` | `double` | `1` | Layout weight |
| `label` | `String?` | `null` | Edge label (shown when `showLinkLabels: true`) |
| `color` | `Color?` | palette.grid | Edge color |
| `width` | `double` | `1` | Stroke width |
| `directed` | `bool` | `false` | Render arrow head |

### Enums

```dart
enum DmVizNetworkNodeShape { circle, square, diamond, triangle, hexagon }
enum DmVizNetworkLinkStyle { straight, curved, dashed }
```

## Theming with DmChartPalette

All charts automatically derive their colors from the current Flutter theme using `DmChartPalette.fromTheme(theme)`. This factory uses `DmColorExtension` (if available) for extended semantic colors.

To override colors for a specific chart, provide a custom `DmChartPalette`:

```dart
DmVizBarChart(
  data: myData,
  palette: DmChartPalette(
    background: Colors.grey[900]!,
    grid: Colors.grey[700]!,
    axis: Colors.grey[400]!,
    primary: Colors.tealAccent,
    secondary: Colors.purpleAccent,
    positive: Colors.teal,
    positiveOnColor: Colors.teal[700]!,
    warning: Colors.amber,
    warningOnColor: Colors.amber[700]!,
    heatmapBorder: Colors.grey[600]!,
  ),
)
```

## Data Models

### DmVizPoint

Shared by line, bar, and scatter charts:

```dart
DmVizPoint(
  x: 'Label',              // Object? — string labels or numbers
  y: 42.0,                 // double — the value
  metadata: {'key': 'val'}, // Optional custom data
)
```

## Compatibility Import

For advanced use cases requiring low-level vendor APIs (custom scales, axes, curves, geographic projections, etc.):

```dart
import 'package:duskmoon_visualization/duskmoon_visualization_compat.dart';
```

This exposes the full `dv_*` ecosystem: `LinearScale`, `LogScale`, `BandScale`, `LineSeries`, `BarSeries`, axis components, tooltip rendering, brush selections, zoom interactions, and more.
