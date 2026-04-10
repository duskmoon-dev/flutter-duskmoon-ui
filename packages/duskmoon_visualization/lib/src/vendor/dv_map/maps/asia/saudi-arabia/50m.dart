// Generated from: assets/asia/saudi-arabia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/saudi-arabia.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/saudi-arabia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaSaudiArabia50m {
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

/// Widget for rendering the asia/saudi-arabia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// SaudiArabia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class SaudiArabia50mWidget extends StatelessWidget {
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

  /// Creates a SaudiArabia50mWidget.
  const SaudiArabia50mWidget({
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
      geoJson: asiaSaudiArabia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
