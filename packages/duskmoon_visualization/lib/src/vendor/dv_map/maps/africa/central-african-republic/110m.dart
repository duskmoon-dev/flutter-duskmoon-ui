// Generated from: assets/africa/central-african-republic.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/central-african-republic.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5VYTWsbSRC961cMOpuivj9yC4Gcl70uISheJQgcySjKwQT/96Xl2MTugaV0EKPpmaeq6qpXr/rXZlm2l4f7/fbdsv24311+nvcfTnd3+9vL4XTc3ozlr0+3f2zfLf9slmVZfl2/5xevj18X7s+n+/35cri+9Pz4smyPu+/XFz7sj5fz7m55//V8uN0dl7/39z+/3B1uXxCWZXv4cfq84+vTH6f7cr3//tXC7el4ORz3x8tYe0Le/l59fLHs2/70fX85P7y269mRv053D99++/2Cejr/ezjuLn8E4Onz5/XbX8vCARLK7HTzZsWARUpVX93/dPN/cEyiWCtwZlgm1oJzULfCshmu1IOiZ51fraPUt3AOpu4o0oIziHLXnNEqSsiqiUasJFhv4QIMEdO4C0dawlPoApKNUKkFp2Ae4pNxCcxFGT1fBRItSaaNSHB3oezCqRUSr1hXppyWTTgpjZiTuIDd0NvOmgVrTXlS4ElM2dvYAaeCym/hCAGz2KyXxQwVYSq+ghek6uxNvHQltynxiICUpayXeQwsRFxr/lZQZkYLjyBYkmnNX/NAs56/BKM6fSaVAg2rbt0ioJXnHL4CJA5sGUcFWIq4knoYmuqtTKaEJEasWKmz5CJtsTslFBEyTdYluGCWtjaWEiTLTNc4KklQeqELKNfimvIkIAuLWq2HHAKtcs6Swe4pHL3QOag5pa6we4hGSC90DlxoPtdEwKAG7PVZciB0FpryJEArsNktyICj1HHFWWUqbqadQoSb2ooKUEytVrMgBRM3x6lZODB7WY+dSEcrU4yJ7QzUKLxZ/wpmWTO3G6CgVXTRNFKCp8gphLCjdTeirppwBY4JJavVyGj45EyzWBRII/HowimalE10IiBigs2dMEjnkDl2Akhi0rauMCRnZuehNiSrW7FInDZbx8AeLtXlE5MYCm92lirZmsweQDIUz0rsgpPKe3kXkFiFKDPcKOTyXuwS1ATdppIVMFTJ3hxACaZcyROcAiNFU0+MJissNM8BCoFl6C01RgXqEbnOKGQcPamNo/F4zOJOwYvGPzXhisOKVuCEObJHUEzgA4ynIlNgVlHqDQI8GIVYpraogFzk2BXGgUo8b4WCi6BhL3YMqaQx06dCEBJ7d0zhCqYVbncsL+mOn0posnKsQJiR7WE20ZBzonaFrGD13gQwJvdMWetjxcGqvY0YciejcuXQgwIVm/OigRuqzXLHgM1H9FpwQyRx+HxMYUCGGT0xxgGoir5mHY2C5d5w1z3O2qxdP189bp6/P20eN/8B/qywFIUUAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/central-african-republic.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaCentralAfricanRepublic110m {
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

/// Widget for rendering the africa/central-african-republic.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// CentralAfricanRepublic110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class CentralAfricanRepublic110mWidget extends StatelessWidget {
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

  /// Creates a CentralAfricanRepublic110mWidget.
  const CentralAfricanRepublic110mWidget({
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
      geoJson: africaCentralAfricanRepublic110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
