// Generated from: assets/south-america/falkland-islands.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for south-america/falkland-islands.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for south-america/falkland-islands.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get southAmericaFalklandIslands50m {
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

/// Widget for rendering the south-america/falkland-islands.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// FalklandIslands50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class FalklandIslands50mWidget extends StatelessWidget {
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

  /// Creates a FalklandIslands50mWidget.
  const FalklandIslands50mWidget({
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
      geoJson: southAmericaFalklandIslands50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
