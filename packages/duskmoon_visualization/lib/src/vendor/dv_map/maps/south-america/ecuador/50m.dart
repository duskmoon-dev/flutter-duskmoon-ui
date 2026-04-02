// Generated from: assets/south-america/ecuador.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for south-america/ecuador.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for south-america/ecuador.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get southAmericaEcuador50m {
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

/// Widget for rendering the south-america/ecuador.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Ecuador50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Ecuador50mWidget extends StatelessWidget {
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

  /// Creates a Ecuador50mWidget.
  const Ecuador50mWidget({
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
      geoJson: southAmericaEcuador50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
