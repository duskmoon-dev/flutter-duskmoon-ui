/// Package metadata and the first curated DuskMoon visualization surface.
abstract final class DmVisualization {
  /// Public package name.
  static const packageName = 'duskmoon_visualization';

  /// Whether the package only exposes a scaffold.
  static const isScaffold = false;

  /// High-level migration domains planned for this package.
  static const plannedDomains = <String>[
    'core',
    'scales',
    'geometry',
    'charts',
    'interaction',
    'theming',
  ];

  /// First curated DuskMoon wrapper widgets layered on top of vendored APIs.
  /// Explicit compatibility import for the full vendored workspace surface.
  static const compatImportPath =
      'package:duskmoon_visualization/duskmoon_visualization_compat.dart';

  static const curatedModels = <String>[
    'DmVizPoint',
    'DmVizHeatmapCell',
    'DmVizMarkerShape',
    'DmVizNetworkNode',
    'DmVizNetworkEdge',
    'DmVizNetworkNodeShape',
    'DmVizNetworkLinkStyle',
  ];

  static const curatedWrappers = <String>[
    'DmVizLineChart',
    'DmVizBarChart',
    'DmVizScatterChart',
    'DmVizHeatmap',
    'DmVizNetworkGraph',
  ];
}
