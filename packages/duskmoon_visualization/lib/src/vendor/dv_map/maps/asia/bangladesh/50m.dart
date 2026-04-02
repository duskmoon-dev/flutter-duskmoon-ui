// Generated from: assets/asia/bangladesh.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/bangladesh.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/bangladesh.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaBangladesh50m {
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

/// Widget for rendering the asia/bangladesh.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Bangladesh50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Bangladesh50mWidget extends StatelessWidget {
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

  /// Creates a Bangladesh50mWidget.
  const Bangladesh50mWidget({
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
      geoJson: asiaBangladesh50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
