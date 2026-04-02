// Generated from: assets/asia/taiwan.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/taiwan.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WSTWsCMRBA7/srQs425Hsy3orQo/QgeChSQptKQBNZU4qI/724dkXdhZIcwiRv5jFDcmwIoeWwC3RK6Evw5bsNs7zZhI8Sc6KTM/66XO/plLw1hBBy7PZhYZfegV2bd6EtsSvq0wmhyW+7goWPPz5d8wmhcZ/fvTyz2fxpsRwg1ZUt57fgI6cSU0jlzJ730dM/dro2sg55G0p7uG+j7/s1bw7rnO6duf2MyZebeS/rNn48ESKkYADgBLjJA5KaKdQSlL0Dq8m/QjRCaoUjQkQwaLBWqNFwrfVAaJhEo42rFHJmUVvAsZGNctpwVysU3Arn7EComDFWWgm1Qik5d2o4smROaGd59ciggQPCQCgYAjcgdO2jCDBWybEOAbkzIGuFlf+wGYv76NT0+6o5Nb/5vIR2LwQAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/taiwan.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaTaiwan110m {
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

/// Widget for rendering the asia/taiwan.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Taiwan110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Taiwan110mWidget extends StatelessWidget {
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

  /// Creates a Taiwan110mWidget.
  const Taiwan110mWidget({
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
      geoJson: asiaTaiwan110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
