// Generated from: assets/seven-seas-open-ocean/french-southern-and-antarctic-lands.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for seven-seas-open-ocean/french-southern-and-antarctic-lands.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5VSTWvDMAy951cInzbITJfv9FYGPe0w6G6jDJNobSCVg+MOQsl/H0ma0DSG1T4I+Unv+Un44gAw3VTI1sC2KPRZ4ZssS8x0IYm5XflngGu2hi8HAODSxyWxb+8LlZIVKl30pLEdgJE4DQSFlB1hJ8/6iIpAUA4b0kJlusjgXVBeT2IArKjlt/A64ud2gfsdvpkXMkm6ICTd1Xb4iwQ1ihqeZIUEMkNBz+za3k6uDyhPqFUz9zwO+SHL5nDdyfSMVHlBQt8sZzi3+f0NIEp46ofuHfoSJDzywhm6d/8TSqLYqJT4lkKxt5RJuRdYO4oDg6GUx7GVULziXmLUebWUCSPjYKGtndAzzrWK7BaU8tAwV8LTwHLPj34hx5SPWeuMce+0zh/ndZ3JDwQAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for seven-seas-open-ocean/french-southern-and-antarctic-lands.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection
    get sevenSeasOpenOceanFrenchSouthernAndAntarcticLands110m {
  if (_cached != null) return _cached!;

  // Decode base64 and decompress
  final compressed = base64Decode(_kCompressedData);
  final decompressed = gzip.decode(compressed);
  final jsonString = utf8.decode(decompressed);

  // Parse GeoJSON
  final data = parseGeoJson(
    jsonDecode(jsonString) as Map<String, dynamic>,
  );

  if (data is! GeoJsonFeatureCollection) {
    throw StateError('Invalid GeoJSON format');
  }

  _cached = data;
  return _cached!;
}

/// Widget for rendering the seven-seas-open-ocean/french-southern-and-antarctic-lands.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// FrenchSouthernAndAntarcticLands110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class FrenchSouthernAndAntarcticLands110mWidget extends StatelessWidget {
  /// The projection to use for rendering.
  final Projection projection;

  /// The color to use for filling shapes.
  final Color? fillColor;

  /// The color to use for stroking shapes.
  final Color? strokeColor;

  /// The stroke width for shape outlines.
  final double strokeWidth;

  /// Optional callback when a feature is tapped.
  final void Function(GeoJsonFeature feature, Point position)? onFeatureTap;

  /// Whether to enable anti-aliasing.
  final bool antiAlias;

  /// Creates a FrenchSouthernAndAntarcticLands110mWidget.
  const FrenchSouthernAndAntarcticLands110mWidget({
    super.key,
    required this.projection,
    this.fillColor,
    this.strokeColor,
    this.strokeWidth = 1.0,
    this.onFeatureTap,
    this.antiAlias = true,
  });

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      geoJson: sevenSeasOpenOceanFrenchSouthernAndAntarcticLands110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
