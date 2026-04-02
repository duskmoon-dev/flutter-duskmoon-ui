// Generated from: assets/north-america/guatemala.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/guatemala.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52WS2sbQQyA7/4Vi8/pIGn0zK0U2lNLD72VUJZ0mxpsb3A2hxDy38s6cUiyA0XxYRmPZj70Gkn3q65bT3fXw/q8W38e+un2MHwat9vhctqM+/XZLP7zuH2zPu9+rrqu6+6P3+XF4/Gj4PowXg+HaXO8dDredet9vzte+HLbT8Ou3/bPV7puvbkZf/V0FP9Y7NfH/a8vBZfjftrsh/00y76Nh+lv93E3HDaX/frp0MOzRlfDuBumw91rfU4GfB+3d1dP9j7Dx8Pvzb6fXhj++Hu5fvuv6z4EFSIzOXsjQC5S3cn1leDi7D84LOphrNYAIimhUxZIlRiBFsBagswr1RwQioIrcYsHYYac5UGICGsDaFVqtaQLoYCymkUD6I6hISmgRzHCqEuLuWBlIs/ipPIMbPCI2VFyBs9At8rUypmqJK65nPEos99pGREuTIw1bzGySG09EjUHDMzyiIQIsAF0Y3qHwSjsuORJAVXGSPK8qINaLCMipbISW9Jiny0GIm8AjcyIkjntRdCrLnNaiotUz4bEiwKLa8uFBlod0sCooNi02N3IavoVEwUStmLirpGtM8ekAYflK7ECKGJq+VdSwWEZEysOXjHyddCiNp6dFceopLmQBBYAFIxlYZ2BJsFJDWcgkTYqoRUSVrGcCwMLSw3CNpDQLN09wVGtUWm0BDpngxxQDNEJlz7Uom7s7+jG4K15QQsbmFk6a7i6t3kICJGr/TNPma3RTLSAhiils9DYQhsDzQxUUU5qOE9wQexLDaWQILMmBxAq4EYoyxjP7YTFOZk0VAgqUbQaqFdAoGSQk0PrqrU+rR5Wp+/F6mH1D6K01ytjDAAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/guatemala.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaGuatemala110m {
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

/// Widget for rendering the north-america/guatemala.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Guatemala110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Guatemala110mWidget extends StatelessWidget {
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

  /// Creates a Guatemala110mWidget.
  const Guatemala110mWidget({
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
      geoJson: northAmericaGuatemala110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
