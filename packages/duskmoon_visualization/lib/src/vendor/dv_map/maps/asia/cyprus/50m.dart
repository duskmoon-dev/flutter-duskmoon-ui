// Generated from: assets/asia/cyprus.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/cyprus.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51YTWsTYRC+51csOZdlvj+8ieC5VxGRoFECNSlpPJTS/y7v1pZqJsiYw7LZ2ffJfD4zk4fVNK1P97fb9Ztp/X67Of08bt8dbm62X067w359NcTfnh7frd9MH1fTNE0Py/X84PL6Irg9Hm63x9NuOfT8+jSt95sfy4F397fHn3cv70/Tend3+LyhRfbh7Dk/Pb9+Lfhy2J92++3+NGRv73ab9W/Z44sW37eHH9vT8f5PHZ6Vvj7c3H//beML5uH4dbffnF4Z+/R5ff/3t2limh3JUvnqb4nO6Agi+Yfg09W/8EyJhaPCCzKzJpyqpnqFpuqG3oQT1wILIjOBmlickFgZCpIB0lWNAdLNSvUotRsHRscorJU5lZmAu55DdssKzz2AvI0nCcRS4VGKsHQTBVTNSjww0m4WJ6XFeXBlNkk27eaK64jueR4PvMV9TbywS9E1Q2SKJl6ikHppL6tkG07Q07KAU9fw6CUzzwCeCFThWWoAdvGIk7Q0t4205HHpOEuUtmZGDFImikubVXhGVCUv9UsdFdPFcwOXKhI2SM+6kaU0jQrO0Z2kq56gpGDJAgr/kXiKIspY4AXYEDXxLId6FV5aRpNEeXaNDKnMTWcS6tEUz0EkBlXdpmlijwZ4Xpiy5Ph0lJAex8sMCljNKjJnBHejK4MGjKlu4f3ikBnGvETn2awzLI7o2cvD6U5UTT+g5uFdcklYOn85YuhQvZsuZgJW4iUbcK/r8hxDO6z9t/S7bnkkUWiJJ4HZnDFGuVkylyMap4t14+Gj52LpP3buk725ckKpH4506epnF9hPZyAav9VlU1KLC/4bE00XT/yi/wBY2nwlNtQo8wUkGdvd6OLyAih9NBLCYibVGQX65MwLY1bBRVtWwi4eqYae946xqrEhd/FIgjlLc5/KsDu5JAJqlXzoPBK9O6n5qIDSf2KY2F1gMjS5XE8RB812V44crbIujvDoFsdYOVIukF+kgHQXQA+BYvIb5qo7djc2JyCUujqW/Ovi9f4XWVX3z3ePq+frp9Xj6hf3cx5HuxIAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/cyprus.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaCyprus50m {
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

/// Widget for rendering the asia/cyprus.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Cyprus50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Cyprus50mWidget extends StatelessWidget {
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

  /// Creates a Cyprus50mWidget.
  const Cyprus50mWidget({
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
      geoJson: asiaCyprus50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
