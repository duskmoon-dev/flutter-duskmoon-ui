// Generated from: assets/asia/oman.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/oman.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/oman.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaOman50m {
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

/// Widget for rendering the asia/oman.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Oman50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Oman50mWidget extends StatelessWidget {
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

  /// Creates a Oman50mWidget.
  const Oman50mWidget({
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
      geoJson: asiaOman50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
