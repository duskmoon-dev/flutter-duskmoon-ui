// Generated from: assets/asia/laos.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/laos.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/laos.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaLaos50m {
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

/// Widget for rendering the asia/laos.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Laos50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Laos50mWidget extends StatelessWidget {
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

  /// Creates a Laos50mWidget.
  const Laos50mWidget({
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
      geoJson: asiaLaos50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
