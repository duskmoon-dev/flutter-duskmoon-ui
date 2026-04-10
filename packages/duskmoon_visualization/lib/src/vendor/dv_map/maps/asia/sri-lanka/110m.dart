// Generated from: assets/asia/sri-lanka.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/sri-lanka.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WSTWsCMRCG7/srhpwl5Hsm3qTQSz0UeixSFpvK0nUja3oQ8b8XV1d0UyjJIUzmnXl4k8yxAmDpsAtsDuw51OmnD0+xbcM6NbFjs7P8dUnv2RzeKwCA47DnjUP5IOz6uAt9aoamsRyAdfV2aHjrG1jW3Xd9awFgzT5+1OosL1+yvL7kF/fCOnap6UKXztpi39Tsqp1uRjYhbkPqD482Rt+vsT1srte8MWP/2XR1urvvZd3H0xMASY6E3vrZREBulRbW6of8avYfTQujpddTHHHrjBJOFeEEJ00kaUrzXDkyylEhTRokITDHkTICEUtw6LnzVjqXPR1xJQQZbQpxhMo4ytw5jk4bV4YjwbUhbTOa5d6Rdt4X/quSJKR3uTnpURpZZk5yp1ErpXKcIYloy8akcIarv+IxOlXjvqpO1S8Ll8fUaAQAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/sri-lanka.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaSriLanka110m {
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

/// Widget for rendering the asia/sri-lanka.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// SriLanka110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class SriLanka110mWidget extends StatelessWidget {
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

  /// Creates a SriLanka110mWidget.
  const SriLanka110mWidget({
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
      geoJson: asiaSriLanka110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
