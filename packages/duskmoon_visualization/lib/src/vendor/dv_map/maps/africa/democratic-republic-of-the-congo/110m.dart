// Generated from: assets/africa/democratic-republic-of-the-congo.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/democratic-republic-of-the-congo.110m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/democratic-republic-of-the-congo.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaDemocraticRepublicOfTheCongo110m {
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

/// Widget for rendering the africa/democratic-republic-of-the-congo.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// DemocraticRepublicOfTheCongo110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class DemocraticRepublicOfTheCongo110mWidget extends StatelessWidget {
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

  /// Creates a DemocraticRepublicOfTheCongo110mWidget.
  const DemocraticRepublicOfTheCongo110mWidget({
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
      geoJson: africaDemocraticRepublicOfTheCongo110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
