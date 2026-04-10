// Generated from: assets/africa/eritrea.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/eritrea.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/eritrea.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaEritrea50m {
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

/// Widget for rendering the africa/eritrea.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Eritrea50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Eritrea50mWidget extends StatelessWidget {
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

  /// Creates a Eritrea50mWidget.
  const Eritrea50mWidget({
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
      geoJson: africaEritrea50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
