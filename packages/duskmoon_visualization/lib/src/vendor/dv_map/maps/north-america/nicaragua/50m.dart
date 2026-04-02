// Generated from: assets/north-america/nicaragua.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/nicaragua.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/nicaragua.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaNicaragua50m {
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

/// Widget for rendering the north-america/nicaragua.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Nicaragua50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Nicaragua50mWidget extends StatelessWidget {
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

  /// Creates a Nicaragua50mWidget.
  const Nicaragua50mWidget({
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
      geoJson: northAmericaNicaragua50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
