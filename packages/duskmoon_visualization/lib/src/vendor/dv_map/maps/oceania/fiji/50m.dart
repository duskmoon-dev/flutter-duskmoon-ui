// Generated from: assets/oceania/fiji.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for oceania/fiji.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for oceania/fiji.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get oceaniaFiji50m {
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

/// Widget for rendering the oceania/fiji.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Fiji50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Fiji50mWidget extends StatelessWidget {
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

  /// Creates a Fiji50mWidget.
  const Fiji50mWidget({
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
      geoJson: oceaniaFiji50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
