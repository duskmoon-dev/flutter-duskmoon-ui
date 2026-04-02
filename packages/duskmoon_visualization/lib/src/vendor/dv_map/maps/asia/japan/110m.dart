// Generated from: assets/asia/japan.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/japan.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7VYTasbVwzd+1cMXgeh74/sSqGLQkv2JRSTusHwYj/ecxYh5L+X6zQheU9ZVFAvhpnRzLFGVzo6uh9327a/frg/7l9u+1+Oh+v7h+PPl7u745vr6XLev1jmvz/ffty/3P7Ybdu2fbwdn794e/xmuH+43B8frqfbS18e37b9+fDu9sKvh/vD+evj27Y/PV7+PPDN9OrZffl8//dvDW8u5+vpfDxfl+2nx9Nh/6/t01cn3h4v747Xhw/fu/DF59/e311Pry53H95ezt8DXx7+Op0P128++PPv2/OnV8+vt42UIFMdsV48M0oBJaarPzG9fvpsD1yk7EItcBU5Oc2AxbNC9DnwskWaVU2AEQQtkq0FpjJE4wGwFGSKREkDjGAuQmwzj9E0CvsYq2RiTIDXy+yKGg1wApOV8ygUCWnhyNwABySH5ijdJEAKncgbYF/AUhgTYIdgScEOOEBQK3UUCgOPMImu8gyMg0QnBSIKjimI2QKHkFOMQsHgFB5NGouBikjJyOEbBzFXU9GiEFpBMqloQchIta48FFg4lHOGKyYl1mWxgKOSjZKNCxRTXXpgLkezicdckKRebXmsZUXBGtUdgmp4eOcxg1BpzAoagZGVqisPAqVkiSGwpwt11UGAXBY1qmcCEY7CLhIEaiimIzJmQESUNsQCpFXFOotEpZNqlxQCuZiaRsAMZB7RigqBQi2REbCAKAq1oVCQsJIckjFGqWiXFQpWbqojCjIgxkruOqlAamHQ0OMoruzIWEBdcyhWApjCKru1W53FOW0UiYQKM44+xO6jalYEtlV2fVMiSZr1DkWIUAztgVM5I0b6FcGqwqvLCAdRqZShGqxwyeiVCimvrxkCW2m2/TmBQhGHSn4we+x+dPXdX/73QUjBSZS9U/8C5ZjJo0QSKMKWslRvwauatHRd1M8Z2E0VCkYolhOSXZObh6s2y6IGZqTDBCXwoDLuPY5gYht6LImmHWepgGQm6yjGCEKM2ZTqwl39nkcaZMmxMJWmVJXXRBiWI5ItKDPCNtsIzMtsOM2jB6f3Q7elrs47zAkirY4DlMEjo3DksQClpHY0uzK8jEknGl0V0Mqdeo8rUyxHNGtgKiTRrZ0AO2NOgYUxuRtXVEFSQ0a4I8r8n/h7DRtBFF2G3gSRuI42WRawy8rRdsKpnEpOASRN6+QQQ6Cax1AjcyJ7/mCGzLLAIfBSnNbuNgkYU+VMciowirazqQAjUcSIDBXCvd9gEUh0kREDLLUqSwD2UwhpscgI+DYbEXq/YSGuJTTaYRHQ4vLsi6NUnXEUYoZileBu7RTQkStHHXJUzj/mlt3Ts0+7L8fXu0+7fwC+USQlZBgAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/japan.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaJapan110m {
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

/// Widget for rendering the asia/japan.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Japan110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Japan110mWidget extends StatelessWidget {
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

  /// Creates a Japan110mWidget.
  const Japan110mWidget({
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
      geoJson: asiaJapan110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
