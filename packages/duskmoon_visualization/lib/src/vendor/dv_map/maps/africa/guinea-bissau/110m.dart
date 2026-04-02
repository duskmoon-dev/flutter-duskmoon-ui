// Generated from: assets/africa/guinea-bissau.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/guinea-bissau.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WUTWvjMBCG7/4VwudUaKT5Um/bhfZW9raHpSwmdYshtYPjHELJfy91m5DWgjI+CFnvzMO88nheK+fq6bBt62tX37bNtB/b38Nm066nbujr1bv89HG8q6/dv8o5517ndZk4h8/Cdhy27Th1c9Ip3Lm6b17mhLt917fN1U232zX7c5pzdbcb/jdxDvm7OE/z+f3NpbAe+qnr23561349jd26qT/V47mc53Z4aafx8LWYU/V/hs3h+dPsmTqMj13fTBeuP57L/fc3566APYsgxdU3BaJPikrAX4SH1c88SJo0FYAgIQNEKzAFzShLIPhMKgGyGQgoylIAamACVCswKEXA5R2Cp4iU0cYjz4yggQo8JEUx8yCFBFCqL2BAALEB0bMSq5QNi8ZkvEH0SSNkKDmmkKMYewY9RMDAWOCxiNlw8jkEybnUMiwq1hZMXjABBy21IEBkM0+jRoFc+ukwMqLxApMXUMG0NBx9RAEl41hIXkJA4QKPlEGTtaUJFYVLhjkqSAArUIFJsDS2CIhYjED2gCLAy08cPaEIA5kHq2lQV6X9aXesTutDdazeAEA33G9VBwAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/guinea-bissau.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaGuineaBissau110m {
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

/// Widget for rendering the africa/guinea-bissau.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// GuineaBissau110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class GuineaBissau110mWidget extends StatelessWidget {
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

  /// Creates a GuineaBissau110mWidget.
  const GuineaBissau110mWidget({
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
      geoJson: africaGuineaBissau110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
