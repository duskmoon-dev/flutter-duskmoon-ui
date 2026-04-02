// Generated from: assets/asia/tajikistan.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/tajikistan.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/tajikistan.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaTajikistan50m {
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

/// Widget for rendering the asia/tajikistan.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Tajikistan50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Tajikistan50mWidget extends StatelessWidget {
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

  /// Creates a Tajikistan50mWidget.
  const Tajikistan50mWidget({
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
      geoJson: asiaTajikistan50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
