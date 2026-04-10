// Generated from: assets/north-america/the-bahamas.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/the-bahamas.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/the-bahamas.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaTheBahamas50m {
  if (_cached != null) return _cached!;

  // Decode base64 and decompress
  final compressed = base64Decode(_kCompressedData);
  final decompressed = GZipDecoder().decodeBytes(compressed);
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

/// Widget for rendering the north-america/the-bahamas.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// TheBahamas50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class TheBahamas50mWidget extends StatelessWidget {
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

  /// Creates a TheBahamas50mWidget.
  const TheBahamas50mWidget({
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
      geoJson: northAmericaTheBahamas50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
