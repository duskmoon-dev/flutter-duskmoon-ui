// Generated from: assets/asia/north-korea.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/north-korea.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/north-korea.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaNorthKorea50m {
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

/// Widget for rendering the asia/north-korea.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// NorthKorea50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class NorthKorea50mWidget extends StatelessWidget {
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

  /// Creates a NorthKorea50mWidget.
  const NorthKorea50mWidget({
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
      geoJson: asiaNorthKorea50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
