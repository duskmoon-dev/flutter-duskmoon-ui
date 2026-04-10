// Generated from: assets/europe/czechia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/czechia.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/czechia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeCzechia50m {
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

/// Widget for rendering the europe/czechia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Czechia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Czechia50mWidget extends StatelessWidget {
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

  /// Creates a Czechia50mWidget.
  const Czechia50mWidget({
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
      geoJson: europeCzechia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
