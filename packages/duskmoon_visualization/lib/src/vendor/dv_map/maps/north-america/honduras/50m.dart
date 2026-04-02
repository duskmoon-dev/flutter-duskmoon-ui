// Generated from: assets/north-america/honduras.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/honduras.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/honduras.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaHonduras50m {
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

/// Widget for rendering the north-america/honduras.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Honduras50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Honduras50mWidget extends StatelessWidget {
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

  /// Creates a Honduras50mWidget.
  const Honduras50mWidget({
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
      geoJson: northAmericaHonduras50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
