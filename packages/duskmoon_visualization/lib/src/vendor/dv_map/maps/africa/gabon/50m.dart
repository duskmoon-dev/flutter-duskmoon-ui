// Generated from: assets/africa/gabon.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/gabon.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/gabon.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaGabon50m {
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

/// Widget for rendering the africa/gabon.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Gabon50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Gabon50mWidget extends StatelessWidget {
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

  /// Creates a Gabon50mWidget.
  const Gabon50mWidget({
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
      geoJson: africaGabon50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
