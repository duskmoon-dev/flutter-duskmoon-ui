// Generated from: assets/asia/uzbekistan.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/uzbekistan.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WYS2sjRxDH7/4Ug86mqPdjb0kg51xySViCslEWEa9kbOXgLP7uoe14sd1NoHQYRtPTP6rr8e/q+Xq1bbvLw+1h92Hb/XjYX/6+O/xwvrk5fLocz6fd9Rj+8/nx/e7D9uvVtm3b16frPPHp9aeB27vz7eHucnya9PL6tu1O+y9PE37+5/fDX8f7y/70bc627Y7359/2/DT+y/Rcnp9//3rg0/l0OZ4Op8sY++7+uN/9N/b4zZLPh/OXw+Xu4a0dL4b/dL55+Hw+vWWe7/44nvaXVwt+/r2+f/9v28ygPKlIr9+NKIFgulK8Gfh4/f+8ACyXIl7xmIWQWjyHEmayFS/Zkb3HC4h0k4nGQIFmXC1agnMhYS14YWTWM66gwpV5XiwDs2ByB+cImCKKsfCdspF6l6dutXAeATMKu7dwBKZBMfuOgN0lUJq4TA5SWvAwNc1bsXUGCWXHebkIaJLZ9J6AUSJpvudJgbiwubV4OjKWeTJPErJY0VuF6wZMVjVFQxIU2atnnIOpk83Ok4AK9WzjKB199l2AOEdqL1cCMCySp1wZPHNS6eVKQHJVlS94pFqlLVyC1CgoWwSDLJCtt9wECsclrpDMpBeNAFVmqklXpIAUSdu8QFLOFc8SNbLrPhNX8nm9BSaiTZX3AiRy4VmphsI6WbZk3guES0tnXUYIjmRtrTcQ3N0XUqAI5cgkrXQJBLUkm7NZEbRcS1v+G/YhDUFa8JjSOHr2ESAp1SQGA6cqbq30C4IIzbB540AgtdRmOATQTClWvHTHZjQIMpAW+8boqIoLex1V0JCQtJyqQwlG6Wb0eAjKiMyrDtKoqrK7XrZijTlbGMgjCFsbW4waYCFd9WjsTtbbOwJBMkcVLHiYJBi9jbcAA5Fj1VZJ6sjopvq5sOZSrdzTs+c/zxGPLFvzWFi7al8j+2zVlZJYVdM+hyBFXZQbAXlqdzcavQa65qx+BJXhqr2+zwFZpGjJK3X1XnwdsBJpofYMVdFswhUKcew4E00gODGxxxOgtJi3chVwQ4xeLBiQRBBX1hmqdldLgJZCc5erCoqWvcOuI7BUxXxcU4hUFM8Obpwmsypn4wwMEUl6R/EEQyFeFIaBDR3oCcv4VMBZtBAqhSobRd3l9T49XK3uX+4er16uH68er/4FNSEboiISAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/uzbekistan.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaUzbekistan110m {
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

/// Widget for rendering the asia/uzbekistan.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Uzbekistan110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Uzbekistan110mWidget extends StatelessWidget {
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

  /// Creates a Uzbekistan110mWidget.
  const Uzbekistan110mWidget({
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
      geoJson: asiaUzbekistan110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
