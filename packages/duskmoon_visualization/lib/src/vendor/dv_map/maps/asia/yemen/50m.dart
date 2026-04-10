// Generated from: assets/asia/yemen.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/yemen.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/yemen.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaYemen50m {
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

/// Widget for rendering the asia/yemen.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Yemen50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Yemen50mWidget extends StatelessWidget {
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

  /// Creates a Yemen50mWidget.
  const Yemen50mWidget({
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
      geoJson: asiaYemen50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
