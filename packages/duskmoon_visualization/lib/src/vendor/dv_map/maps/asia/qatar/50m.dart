// Generated from: assets/asia/qatar.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/qatar.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WWTWvcQAyG7/srjM9h0OhbuYVAzy30VkIxqRsWknXYuIcQ8t+LnWxI4ilFPpjxaOZBsqR35mnXdf38eD/2513/ZRzmP8fxcrq9Ha/n/XTozxbz75fph/68+7Hruq57Wt/bjevy1XB/nO7H47xfN52Wd11/GO7WDd+GeTi+Le+6fv8w/RxwNV1s5ull/vt7w/V0mPeH8TAvtouH/dC/2p7fnLgZp7txPj5+dOHk89fp9vHmNcQ35nT8tT8M87tYX573489fXSe1oFqo+9knC3JRMETVD4ars//xKJSducVjqdUwyWO0wLAWTx21WpInRBTe8s8DXKNmecserg3e+iPIkzwFd9dtvFJA0B0izashtPVPSmULjmw+RCujbOtFCjqzYTofq3vY4JGHsabzUQGFosFjQWLK+scuJFUbPEE2SIeL+o90qGNFz6ZXlh6VlnvmFUDSPCZQ3baHlACkwLQceICibHhaoNZKmG0PVCTgbXtoqUJoVZK8Cl5Bmv45iConeQBUG+FKCa/MQikclABy8GZ6kcEwy3N1FaRW+dW1MrM8QKWmWnEYGGR5prgUTIu3iEvyNIJiwuLRUiuKQLU0z4yYWrxqxlxz5QLFWRdk6zRyF+OcOkNxkiDb1h8XF6CAbLwOTMEtnnmgWK59obgsPdU6LZdrCHlOTqEEOiG0/p9E/rYBJVShNuSUixgFSlauANFapxEXWfqQ0/ISRBKt24soL/eNrPyZAzbrT1ytel6eU7fJXWt8Gj3vTu+r3fPuL6H7AP7wCwAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/qatar.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaQatar50m {
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

/// Widget for rendering the asia/qatar.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Qatar50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Qatar50mWidget extends StatelessWidget {
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

  /// Creates a Qatar50mWidget.
  const Qatar50mWidget({
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
      geoJson: asiaQatar50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
