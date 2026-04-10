// Generated from: assets/africa/madagascar.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/madagascar.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WXS4sbRxDH7/spBp03Rb0fvpmE5BTIPZgg1vIiWEuLVjksZr97GNm72FZBKB2GUdf0j393dT36y82ybM7Pj7vNu2Xz+257/ve0+/X48LC7O++Ph83tav70dfhp8275+2ZZluXL5Xk98fL5xfB4Oj7uTuf9ZdLr58uyOWw/Xyb8uf24vd8+3W1Pb3OWZbN/Ov6z5Yv9j6txuYz/9oPh7ng47w+7w3m1vf902t9tN9+sL29a7nfHz7vz6flHJa/S/zo+PN9/W+kb9Xj6uD9sz98t+evv+/ef/y2LFpiKUdbtT5ZfiEG9Urh+sHy4/T8glbqRdEBUNPMYARPSxTCjVZiRHjOFCamGjo1CAcyi0CmQS5IjO2Ck4lRhQHqhhnVAd0lPGypENCZtvKyARSzsQ4WBRlzNkhWsVJBnXnbIZEpuvGzAhJSsQ6AQs0rjZYNIRMoZ0CCDq8RbYImayhBoyCHc8SpUQmZOVijVEm8EOlCUhMyOoYKukRzaAZmcqXgIFGL1LpQd0lDLZqdGoFwwtXFygGKVag4VonKF0zUwQYQkY7pkFlamJvISyqlKZ0tWUFepzikFKqamY6eECts1kBEwWNxnQIEsl8DrPWSEFFSr2cFegeLJ13vIBOQiGLNQFlCR1c0dUMQ1jIZANqXmXDMDWijNMoOAqLk1x5oZItbaMOR5RURTT1hglUc+FRgu4dkIXM8neozDBKWCsVGoUJmiNgWmiIVcFyg2EHVCmgFtzSeG0fjYwJFUdFqgOFmjB1KkOs9yVwCWhTed17qHSs41SzUBphEsTWZY+xoqy2lfU2usVpMZGKTIpk5JME1TbDIDgpZn5iyQC1ApitvsSpQx5qmYUzadXECZoOsYWOnETYEKoLWrHZbQggg116YNccgwHJaTWtt1UW2bBjVC8emFwoMdu7bGIAgZh33SqhAdrfGJgZKyzZphQ2BEDm3bGkRkl1FqMASJIKJmDw0CHb2mQA038aYLMWB2Ix4dw3XJFCrdLU8hLCNzlLwMAc2NmkgmAbM1r83Sa0FiVmJ7bcwyzuEtb35TvuneX99ebl6fH25ebv4DxaoIO9QQAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/madagascar.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaMadagascar110m {
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

/// Widget for rendering the africa/madagascar.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Madagascar110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Madagascar110mWidget extends StatelessWidget {
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

  /// Creates a Madagascar110mWidget.
  const Madagascar110mWidget({
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
      geoJson: africaMadagascar110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
