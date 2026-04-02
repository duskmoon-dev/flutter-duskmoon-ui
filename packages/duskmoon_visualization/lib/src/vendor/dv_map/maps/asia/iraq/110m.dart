// Generated from: assets/asia/iraq.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/iraq.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WWS2vcQAzH7/spjM9B6P3IrRQKvbW9llCW1g0LyTrduIcQ8t3Lbh4kGVMYH8x4/jM/JI2k8f1mGMbl7mYaz4fx07Rd/h6mj/PV1fRz2c378ewo/36cvh3Ph++bYRiG+9O73XhafhJuDvPNdFh2p03Py4dh3G+vTxs+H7Z/XlYPw7i7nX9s+aR8beblNP/tjfBz3i+7/bRfjtqH2912fNIeXmy4nObraTncvbXg2eQv89Xd5ZOHL8z58Gu33y6vXH18Xo/ffw2DFFCZeurZe4WBnBAz3wgXZ//lKYJUVak0PILMqqI+3uOuxFrhUSFiRhdPIbC0Mt7zuIAis4i6eA7mGSRN/LgAq5CNu3gBguzM1PiLgFboVZ28CjWqhscFFZZUffYlmEcF8RqPPSKlk4ek5tnmC4IaH6VeHqpXrsWv0khCO+PnaZy+ztM06T3f1GKUJv+EjplJYb3nK6LuZCv1q15k1uevA2GJkzc8AaTgjL7zNVByL2z9FSiPqOg7XwPXVKvWX4XQJIm+fuBAdqz7BmeAJWyd7c8Bw0WxbacGHiEp3eFjdFpJZ4OKMO1MF4WIY5W2vAAKVPFeHpeoURu/AEQy0r70EyhltrY9SwCbM4d18RgiitjadA6QNHbxTp5oWdFa/Jgrg/vsI0gJdG3aqTg4Wpr0XpecFRhteTiIZZL2+UsgKeXWtmcD5xTyXh6ik2V7nSsolQR31YckRLEotv4KSKSnd+Vf/+/QZm38PHrYPL8vNg+bf2O6OT6wCgAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/iraq.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaIraq110m {
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

/// Widget for rendering the asia/iraq.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Iraq110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Iraq110mWidget extends StatelessWidget {
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

  /// Creates a Iraq110mWidget.
  const Iraq110mWidget({
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
      geoJson: asiaIraq110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
