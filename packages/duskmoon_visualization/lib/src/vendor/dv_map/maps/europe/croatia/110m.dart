// Generated from: assets/europe/croatia.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/croatia.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52XTWsbSRCG7/oVg86mqO+PXEPCHpc97GUJQWS1QeBojDw+mOD/vki2jJNpAhUdhtHU9KO3q6rfbn3fTNN2ebzbb99N24/73fJw2r+fb2/3X5bDfNzenMP/PT++376b/tlM0zR9v1zXAy+vXwJ3p/luf1oOl0HX16dpe9x9uwx4f5p3y2H3OmCatof7+fOOz8E//lo9l+fnf78NfJmPy+G4Py7n2IeH8y9uX6JPr0K+7udv++X0+KOMq+4/59vHry/TfKXOp38Px93yZr7Pn7f3P3+bJnIw18TUm58i6mAoYVg/BD7d/JpnEJ4hXAMeSxImN3keZFy+4hmkKJl4kycsZbLWZxBCkWxtXnjoSJ8aC7m2eAolxio54gV5GTV5VkZYNuC5aGmzvgpKVJ480udObtHiCQQZWo3ma4jCkk2eRykKjfSlklYvfwJuXmGj/JF4SbMeAmXMprHiKSQysfT6T4EtQ2PUfywS4b38KRSSI6/9wADD0VG6PEbBksF8Q1KztzwMJJwN1/IUhKLIujwKVRvhWIWKem7lgGSSAzcQMAwm61XXoQQRbd0tAoxVlT1egGFV4LoaDKlVpT03TVBDJB/xNKqKeuW48tbu/MLjXj0SbF0KBu9mzUOLae0BAshp3twzArhCQkY8VRfFXhUcipzM110s4B7BTX0Oaq462MMVUImleh5/3vnLfdB1CmJEKj1PMQhDZF97vEJSBlFPn0FZicda3+95qINQkvloT8NzAr2bPxMtqZEnM5Fj9PolAJFpeGT5nekGpFPkoJ0N0CMUuyZgJkw62sIxybLZfgWIpiNTVkhHFu0tjwIp1BiY8jl/bmS9chRgcAw8z8CYjKh3wkhIrmQddV9hZnDfkx2dR+UNK82mvgAXRB+41XkdUnjzhOaQyUa2bhcHSXSh7upt/iPajO6vd0+b6/XT5mnzP3rArVy4DgAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/croatia.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeCroatia110m {
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

/// Widget for rendering the europe/croatia.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Croatia110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Croatia110mWidget extends StatelessWidget {
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

  /// Creates a Croatia110mWidget.
  const Croatia110mWidget({
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
      geoJson: europeCroatia110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
