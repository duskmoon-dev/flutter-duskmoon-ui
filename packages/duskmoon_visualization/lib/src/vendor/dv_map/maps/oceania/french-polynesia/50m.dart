// Generated from: assets/oceania/french-polynesia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for oceania/french-polynesia.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for oceania/french-polynesia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get oceaniaFrenchPolynesia50m {
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

/// Widget for rendering the oceania/french-polynesia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// FrenchPolynesia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class FrenchPolynesia50mWidget extends StatelessWidget {
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

  /// Creates a FrenchPolynesia50mWidget.
  const FrenchPolynesia50mWidget({
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
      geoJson: oceaniaFrenchPolynesia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
