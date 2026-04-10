// Generated from: assets/asia/nepal.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/nepal.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/nepal.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaNepal50m {
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

/// Widget for rendering the asia/nepal.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Nepal50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Nepal50mWidget extends StatelessWidget {
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

  /// Creates a Nepal50mWidget.
  const Nepal50mWidget({
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
      geoJson: asiaNepal50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
