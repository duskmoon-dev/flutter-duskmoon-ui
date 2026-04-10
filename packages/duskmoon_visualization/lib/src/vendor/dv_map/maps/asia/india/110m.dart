// Generated from: assets/asia/india.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/india.110m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/india.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaIndia110m {
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

/// Widget for rendering the asia/india.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// India110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class India110mWidget extends StatelessWidget {
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

  /// Creates a India110mWidget.
  const India110mWidget({
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
      geoJson: asiaIndia110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
