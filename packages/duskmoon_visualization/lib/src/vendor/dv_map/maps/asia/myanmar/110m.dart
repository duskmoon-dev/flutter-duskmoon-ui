// Generated from: assets/asia/myanmar.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/myanmar.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51Yy2ocVxDd6yuaWYui3g/vQiA7Q8g2mDA4EyOQZoQ0WQijfw89soTsagjlWTQ9ffse6nHuqar+erUsu/PT/WH3Ydn9dtif/304/Hq6vT18Pt+cjrvrdfmfl8ePuw/Ln1fLsixfL9e+8fL6ZeH+4XR/eDjfXDa9vr4su+P+7rLh49P+eLd/eNuwLLubx9Nfe74sfmzP5eX5H+8XPp+O55vj4Xhe1355vNnvvq09v5nx5XC6O5wfnr434tXq30+3T1++OfmGeXr4++a4P7/z9uX3/v7Hf8tCiEBkleHXPywxglKkln+38On6fwGFi5B4AzDSiSlmgASUiGjSAAlU3ELGeIYoW3CpVak6dVjJTSI2AM0ypUaAVVApmtUDSBDKJT4KYBWwYlZWw2MgSiEdBbAKTKiKu30MpYWSOcJLyMrQDX8FSDmYaYjnjuxsDU8BXThHhK4ARw2qnl6BrFDUWToCgtWxZ8MAU1yCp94GpeQGXFEGsg3hghhLunkOoWJiNTUv2Qup4QUYZhJP3WV1lo3wBYSuXJkdtoAiqtw4vAkiVmoz8gUIB9FG/BLYyZKnbFFkc+pkDshkE5/ah0aV2eU+wKvQcpbfABKpqq38YkqEzPjnoFSrqG/gsatlzcTKgFjDN/LrYCEWQ3ExIDMy0Q08RBKcVaNScBTWjfgZkLOWzfisYMZu0fmn4GEsObWP0EO3tDkNQ3FGFwFho61uQwEjzXzmrgCnC3t3VwDX5iCneOjIteEvQ6AQ4ez4CpA78Ya/DBypNuuuisGDgztbGFCJZXh6GdyYLToegfBa2qbmCQqLdrUi0DBNm7GPQTzNpOMheGCmzPBkJRlHTwcVpBnpTKwE3IVNW/GlgmAvp1n4BEyxMpu4UIG4a/EMT9ckJnkLHyUwiZHM6KJgItprBwVwBCuOtSUzsR82ckCJmtY2hcRU1G6fQaKoDRtdA/ES640uGQTpMHgOhhaerRKRw9rlKs7IF0CuJtXJ51CcIbM5pgKsAoN69BwI0TymnUFEhHAns0JKcI47SUJx7HACrqhWM2VOMCyLLThilhgqX4JyimxklwGFK306FIWrqfWjS6BKXENpSVALCm1KT3jpC3wKt6qyYXO3oITLapbbApQkxs49hHI0tVn0CiyDN4SKIIvDeQpH5WJ9yCKGRA0ddhkFTIxEHU+AvbhkOuFjRZh1oRJIDpsPgSqY1JtSUnBm5JieNSrGjbO2dufyEzOqSUhYa/rIQDC1YpaOhMK1rnX7HCgiWaczqpaE9+j5KnwpNv0AkVbE3NkSsKqyjkdACcvy7m6CrkVymN2AqDVK3b4E58DEaTrYJDbqRkFg8rDJSCgrjz5QrnDGlcOOvsBUBKsPgAiUbjUrHD/xAfZq6/717vnq9frp6vnqPwfYGb4mFwAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/myanmar.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaMyanmar110m {
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

/// Widget for rendering the asia/myanmar.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Myanmar110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Myanmar110mWidget extends StatelessWidget {
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

  /// Creates a Myanmar110mWidget.
  const Myanmar110mWidget({
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
      geoJson: asiaMyanmar110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
