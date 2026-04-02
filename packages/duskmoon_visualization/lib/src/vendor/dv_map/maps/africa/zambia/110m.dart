// Generated from: assets/africa/zambia.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/zambia.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5VYTWsbZxC++1csOrvDfH/k1hZ6K/TcEoqaKkFgW8ZRDyb4v5eVY+Nkp5TRQax2dh/m63nmHX25Wpbd+fH+sHu37H457M//PBx+Pt3cHD6cj6e73fVq/vh8+/Pu3fLH1bIsy5fL9/bFy+MXw/3D6f7wcD5eXnp5fFl2d/vbywu/72//Ou5fn1+W3fHz6c89X2y/bu7L8/2f3ho+nO7Ox7vD3Xm1/fjx4fhhv/tqfXr149PhdHs4Pzx+68WL27+dbh4/fY3yFfX08Pfxbn9+E+7z5+3197+WRRBCEbHi+jvLDwmyWqy+Mby//j88Ucd0avBYks1tgscFiFzE3OApBgrlCC8hRNPdGzxjNysZ4qlWxjbcAnItyimch3jSthwFjlY8y16ClqNXbuAIIbIyJYaAEswmWzyCKHH1KZ4rK4V2gBVknjPAAlEyjdoCMohjqIwamgucHJEaDxkoMkunHe1VTtJ4KMAWzOMcliin9YCaZalDQGMxpy1HiMErHXUKSGaEue1qYuBgTfQRYIBkRmVbZRIOjVlRYmWrUkcUAscMzRmgg5lgRpNDgmJVqZlwGYSxYLWAkVpuNARUSqLcShcRiGDJrCYKkUKt1tAq/V4yS6GCkBr5VvpXQOdkn7WhrvQis4bKCGVUxTPmCayTiazxEKHYk30m/wpIkSXW5zC4hvNEoFDJpGEeQTBz0rTKGFXYhcxARVw+01eBEizmpg0ZzC01ZkVZc+gk3uSQoYhQnUeABCWS6c3QY8hKlZgCZkYqN1R2wEQhnAGuiWKNbEL2i4dGM6YIMBlqBxjrcCDymdgooEg6tYC8TiiZhazgyaLVtE2AmCjhrG0MMLwMmyoHWGSyzKhngKmq0qhNgDsl2dRDdmW2hssBIW7TkeIgSSXdaS4g1VF5VhSHQI+QFrCcmHMmDgGoqtwcr1dASeQhlwOskv+jKFyYMjyJJKhHYbPvkIN6Kg65nJBs6dmM0bVeFZpTD0tDvQvZAVVwKg4FRp6iTZUNXNUjRn0oCBzKZk3IBoYRsx1AEChKk5oZpRDlWDVSL1nlUJG1YZ6sW8qsIsLgmeQd7wSCOG2YQIYqCtd2R4mUDBwdvURAcNWadsqrWEROM0iknNWe5RyDKkc0WT0kE8JmoOBaY5sGrLnumk2FEYzNLGclEWAhaVhc4OHBNGtphrCSaI6uBSxo046+nNXSdbtArdskyvBfHwIzF212iYRwRh1mj4AswmjLkAQrtbkiDP/luuquX66erl6+3189Xf0LeRRSzIsUAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/zambia.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaZambia110m {
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

/// Widget for rendering the africa/zambia.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Zambia110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Zambia110mWidget extends StatelessWidget {
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

  /// Creates a Zambia110mWidget.
  const Zambia110mWidget({
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
      geoJson: africaZambia110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
