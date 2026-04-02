// Generated from: assets/north-america/saint-barthelemy.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/saint-barthelemy.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WTTWvDMAyG7/kVwueuxF+y3Ns62Gkbgx1HGaHz2kASF9c7hNL/Ppo2pR+GYR+MrFd6eGXjXQHAYr9xbAbs2VXxN7gn3zRuGWvfsclB/jmmt2wGnwUAwG7Y7xuH8kHYBL9xIdZD01gOwLqqHRo+qrqLMK9CXLvGtf25E4DVW/9ViUPV/OUuL4/510th6btYd66LB+3Nh7iGx9aFelmxU9H+bGzlfOti6K9tjXO8+6ZfncY+w334rrsqXsx/XJfx7QngAcWUJLdS4uRG4mZKBhUquhIWk/+BnDgqngKSVsqKbGBpSslFCmgNaswGGmtNaRI8WxJarrINolbCJoGcBHKTDTRKcEoChRCoMR+olbQ66VBqo/LfBK0kRck3IU35V6jJSp0ySCRRifyJFVohkwaN5lbLbGDePylS8Rjti3FfFPviD4483CDfBAAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/saint-barthelemy.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaSaintBarthelemy50m {
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

/// Widget for rendering the north-america/saint-barthelemy.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// SaintBarthelemy50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class SaintBarthelemy50mWidget extends StatelessWidget {
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

  /// Creates a SaintBarthelemy50mWidget.
  const SaintBarthelemy50mWidget({
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
      geoJson: northAmericaSaintBarthelemy50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
