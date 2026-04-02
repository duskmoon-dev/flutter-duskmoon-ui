// Generated from: assets/africa/mozambique.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/mozambique.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51ZTWsbZxC+61csOrvDfH/kVgq9lfbcEorrKkFgW66jHNzg/15WsdM4GlOmOiyrHe3D8873jD5tlmV7fLjbbd8s2x93l8eP97sfDtfXu6vj/nC7vVjF7z4//rB9s/y2WZZl+XS6nr94+vlJcHd/uNvdH/enl55/vizb28ub0ws/Hf6+vPlj/9fHf99Zlu3+w+H3Sz7Jfz17LqfnP78QXB1uj/vb3e1xlX3/7n5/dbl9kj5+4fJ+d7jZHe8fXjJ5pv7L4frh/dNJv6Ae7v/c314evzry58/X999+WxZRMKvKuvhG8B0RGCPyi+dvL/4LjRMRnc7h+CRikyHga/QELKoqYohXGGQkLaCbstYI0IA9ypw7wMxI0ZkKDTw91RqGCk6EajkEjKBCjXNAgyxPyymgSKFzYxQHwlDFmZENUCQJmyM7JBJXTa0sSVzUM0wxmwNicHVuY6CRrmRTv6Zw9w4PSQLTh3hq5SLae40g1pQguiabdYBiNYQTiKxAbBLDSp1ScGYRASZF7rxaoIKG+kOgKE1qwlghyrGKhoAcymbZWdgwImfnRRDJsleiODFlSJCAQtAbhzFIx1KZESRwca1sNOiAQVXDWkKQxqjYxIiDUCnNCDIIJ0ubE6QYQ2cKZEgNl2ws7BAkUjkHrFX154ABFYUWs7zK4KaZ1vhMggdj1qzY8VqAqrRJgwVKJcmzUsIQwYGNCguCzIqnKnSrUDknyAiCyoVTQMP0kvO8tQKWcfHUJqxa2YQJExD5aq9pHBcpVsOQgY0Mh7WOwAOlzm3CAm5ZPvMZghK0bMKEFcRLyWepmiCMFfO8MrGBpnLKlGFKRMR53LFBqojQzKsJKi2iGhs7cFHEOO4wyL0pxuwQIsljt05BYuwBlanGybXIqifIZOkxS/4M7ije9DPsQJqWOgsTBgt14cYmBsEhlDOGsvZpTE1HwwZiYSHTUWdVFDcnVkhyIdURngEqhmjj1rr2rGI4U6GBWobaeUFmBWL2mQ8aOIZG0/WzQKCbT6cICYrQxiACJiY2nexMpETbRIiBkTEGdDbtgoQBp1iyxkA2ymOgqaNIiHI0ByVIxZSYWpbCiaOtcWwqTtPQCKQsbjSHoBWoMmOoEOmS0kw3BZGKNMx/BlQpVU2rVWDGSWOjZLlWNyEmpDI7zgAdOImjmt4t167JM2Z1OECJSLhp3gIsXXzY/ybYapK+/yUkHLZaBWrrBNYOEKful0YpXxEwi7uRad17YMTIIoqgEWzdgGOg64JllvEVIcI0XlkdFYWPAa3KGdutAiNV2FSD5rjGQrcfdFkpjmrSqkMJ7k5MEE5Bs7XCySYpGU1iQAg3VRz1goog5JadE66iwBpF3TNet298wov/Q7CJuRPcLIILjJsND57WjLMeOkE5zLr8R8DrZmCYDQKSo4tdAvZpKQ/QoG4BSmDjROpr2JI1iiOwUpNZXhEHI8WkphbRmvdKxvteYqlmPiIClSL1GcHhfw6b7v757nHzfH27edz8A8jKexUbGgAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/mozambique.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaMozambique110m {
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

/// Widget for rendering the africa/mozambique.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Mozambique110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Mozambique110mWidget extends StatelessWidget {
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

  /// Creates a Mozambique110mWidget.
  const Mozambique110mWidget({
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
      geoJson: africaMozambique110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
