// Generated from: assets/asia/malaysia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/malaysia.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/malaysia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaMalaysia50m {
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

/// Widget for rendering the asia/malaysia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Malaysia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Malaysia50mWidget extends StatelessWidget {
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

  /// Creates a Malaysia50mWidget.
  const Malaysia50mWidget({
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
      geoJson: asiaMalaysia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
