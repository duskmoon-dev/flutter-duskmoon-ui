// Generated from: assets/oceania/australia.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for oceania/australia.110m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for oceania/australia.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get oceaniaAustralia110m {
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

/// Widget for rendering the oceania/australia.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Australia110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Australia110mWidget extends StatelessWidget {
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

  /// Creates a Australia110mWidget.
  const Australia110mWidget({
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
      geoJson: oceaniaAustralia110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
