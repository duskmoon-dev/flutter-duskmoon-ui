// Generated from: assets/asia/palestine.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/palestine.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51Yy4obRxTd6ysarU1x3w/vQkh2BkOWwQThKEYgS4OmvRjM/LtpyWOPZ24vcrVouup2na4+93VKXzfTtJ0f7vbbt9P2z/1u/nLZ/34+Hvcf58P5tH2zmP+7Td9v305/b6Zpmr5er68XXh+/Gu4u57v9ZT5cFz09Pk3b0+7zdcH73XF/Px9OP5dM0/Zwf/5nR1fzX6/m+Tb/x3PDx/NpwTjNi+23+8Nu+932+GMjn/bnz/v58vDrNp72/e7LcT68Px8fPn3/1h/A58u/h9NufvbRt9/z+5ej1+NpYhnizsLx5rUNh4aEMb8wfXj5bInL4QziJa4EeyS2cDEDRbTEZSIDlxYuIdWglESh1AMV5VVcCAaIHrkSzFk7jZISM3u4CpjKNblGLtJzmpJqaNZBRmosPR6UBAmxxhU0hV4wNJJiszb65Y3/O0F1qKKYVHuhwakK3uFOh4SwV6FJQwDNoBPyOgTI2Kq8pyEKTVfr4DDHqGmQZEC3Hq4RQkqJq+Di4D1c4ICwGhcpObWFi8lkWPOrLELc4xdMgbNKJRpiIJK9eAAEFatSnwZzYHDHbzIyU3GFB4rlpR2/yUjV1BoWDZK94zYZ6bhEcIkL4UsINnFjJcxwZKIBNumNdLG6siYyBfY6YnowQd1hwkzAmri6lm44QpA0ex0mDZevrXGJly7c5JcBfAUXzdM6HVwHKBNRLbuCvV92yFGiKpO3/TarOmZAXR1wuBtjdNJCBwEvOVXjNhlQFqwd5izi1OsTwGJWw5ozCXXzAdKtzgcDopSeQryJS6qVEZs69Y4L4eTKtcM4LZplN5bwKlXDImgDrSloEzzWhD0rtuMWAdFxhQa7SpVePrgtiq4+jREFNKNXICyxLgsSlNhVkQqrBwbxpG55FFOhrMujGrFyrzhIpqDU7dKcuHeKXsR/ZEjNr5sqeROXl0N03YYzJJE6ebHgipvWqheBob1fJ/BSNtCg5c8E6Kn/xuFqszb6ef9097h5un7YPG6+ARLdyvvNEgAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/palestine.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaPalestine50m {
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

/// Widget for rendering the asia/palestine.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Palestine50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Palestine50mWidget extends StatelessWidget {
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

  /// Creates a Palestine50mWidget.
  const Palestine50mWidget({
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
      geoJson: asiaPalestine50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
