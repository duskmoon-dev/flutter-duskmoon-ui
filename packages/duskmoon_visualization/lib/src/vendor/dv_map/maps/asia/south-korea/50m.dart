// Generated from: assets/asia/south-korea.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/south-korea.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/south-korea.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaSouthKorea50m {
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

/// Widget for rendering the asia/south-korea.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// SouthKorea50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class SouthKorea50mWidget extends StatelessWidget {
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

  /// Creates a SouthKorea50mWidget.
  const SouthKorea50mWidget({
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
      geoJson: asiaSouthKorea50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
