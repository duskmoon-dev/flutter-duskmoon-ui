// Generated from: assets/europe/romania.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/romania.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5VXy4pbSQzd+ysuXjdC70e2IdkmDGQVwmAynmDothvHWTSh/3247nTTSRUM8uJSLt061pGOpPLPzbJsLw/3++2bZft+v7v8OO/fnm5v918vh9Nxe7Oa/33a/r59s3zeLMuy/Lw+x4PX16+G+/Ppfn++HK6Hnl9flu1xd3c98Nfpbnc87F4OLMv28P30946vxg/Dvjztf3pt+Ho6Xg7H/fGy2t79WH9x+8v6+OLIt/3pbn85P/zuxrPfH0+3D99+0XxBPZ3/ORx3l1d8nz6v139+WxZOYBEzsZs/LGqgmZzCvxm+3PwfHpqqygSuVC2dmnDkiBQ14DlIkDl7F48TBXmCl4Qari28ADMi9xEvQNGIosc31nRk8Mg3INkjsFp4DsVK4TTgrZEQdrUmnlOJeE7wmDHYe3JxoAo11DleJkkLb1WZldIsH5VBmtHEY4xQGf0LyCK0pl4U0l0oZv6FhLH1/FNQZLRJfle+lBHZwhMIx7Ic63fFM6vs6UWAlFl8ll8sF6VefTAEoQlN85FMJb36YMCq8IgJngerVE9/BM5upLN+VaUszXwQIFMZj/lwEHLMHhyuRUXFY7d3IA71XvQQwpliwtYgRC2kl12EDBXisbsYKLmE9aqNQFOMJ93ZgJIosNetCMwZmUe1KIRnafTUwkBqmJPppqCRa+U08dQKeaIWhUA2ih5fhkALtlEuChaJyD35MWgoYo7Vu/axYo7eNGdwC9Ka5YNFqx2+Uk3h0T2BXEvXengCIiw4SYdAViBhL3wKhOhRo5wFQgmtPSzNi4PG8Al4pqr2hpEDupHlDK9UtKTHN4CVpWomPwqr7Kkl4BrzmXdJrJ7dm65ZYtLonUBgqFMvegm5SmwyihSKJKMZvQJScqKxmSokIxP21FLX0Ta7ChmgmFTzalrgKJyz2cEl0qyNlW3FZLAZqGtxc3IkeFTERHoGgorSJNv+m7WZrZ9Xj5vn55fN4+Y/gE05Sg0PAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/romania.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeRomania110m {
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

/// Widget for rendering the europe/romania.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Romania110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Romania110mWidget extends StatelessWidget {
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

  /// Creates a Romania110mWidget.
  const Romania110mWidget({
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
      geoJson: europeRomania110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
