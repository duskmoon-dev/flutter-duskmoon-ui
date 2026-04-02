// Generated from: assets/africa/botswana.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/botswana.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WXTWvcSBCG7/MrxJy9RX1/5JYs7Dm3PSxhGbyTMOCMzFjLYoL/e9A4Nk7ULNQchKZL/fB2dddb0rfdNO2Xx/vj/t20/+N4WP69HH+f7+6Ot8tpPu9v1vDn5+GH/bvpr900TdO363U78fr4NXB/me+Pl+V0nfTy+DTtz4ev1wkf5uXhv8P58Dpjmvanh/nvA1+jf27G5Xn8/dvA7XxeTufjeVlj7z9fTreH/Y/o06uSL8f563G5PP6s40X4x/nu8cuPdb5S58s/p/NhebPg59/b+1//TRMXqDBlys0vkd+YAYuEOH+KfLr5f2BClLo5b4EELqWmTR4ySSCNeJpWYS1eQHAwR255CGmUSNUGamgMMoigVWjZVcjlhjpUKEVG1VPoQK5RWBsgFXAJpnkLaJCGq5ItMCFIlbin0MC1yEVHQBNHti6QXZkttsCAEDep3rE2wFTVkcIAd0qyaAEVjDHQtnVCAZlBrL0lKzCFuA42ZQWWaE+ggEUhmo/2hJPYiZpAKk/LYQrTCyW5BSRwM1TcVt6qkIq0d6wRitCVxjxjpuxtCUImkejQu5JUOFoppIIsUxuZF0FqNQ/hMy88ts7ACuERhb0tQSC3YNseQlYoivKmuyKEpWMN2olBepJ4z10R3F0DB0AHjVATaW9y+cBc2SE5TXs4AkfL2lYdOwS7ifTKmIHQynOojxO56f282oIJbZ2VDSpKtdmQGZKVY1B1bGCIatk1LiHG8kGRrG0hPZv9UyBEzGsIlELi6i15tWpi92EOPZDJ2t2JjQIHZWcQVB7Y82oDd10LZQTUte68Cwy31BzmkEJTrZdDg1Jy44G3Kni5hPReNH19mwyTgTEoOLmw9yrFIdIVR7uswIpe2AMGEJXiyBvWZq3CPatJQAqWAW6tyQiTnr7+t8RudP9y97R7uX7aPe2+A/wjD3P0DQAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/botswana.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaBotswana110m {
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

/// Widget for rendering the africa/botswana.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Botswana110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Botswana110mWidget extends StatelessWidget {
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

  /// Creates a Botswana110mWidget.
  const Botswana110mWidget({
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
      geoJson: africaBotswana110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
