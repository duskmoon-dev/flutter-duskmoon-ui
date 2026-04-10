// Generated from: assets/north-america/el-salvador.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/el-salvador.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51Yy2ocVxDd6yuaWSuXej+8CyFZhRAwZBNMGOSJI5A0YjwJCKN/D7f1wPKUMKVZND19uw91br3uqS9ny7I53t3uNu+WzS+77fHfw+6n/dXV7uJ4ub/ZnM/lvx8ef968W/48W5Zl+bJeTz9cX18Xbg/7293heLl+9PT6smxuttfrBz9fLe+3V/9tP+4Pzx8ty+by8/6vLc0X3v9x8pzX57++WLjY3xwvb3Y3x7n22/5w/Gf58Xp3uLzYbh5fun+26dNuf707Hu5eWvRE4ff91d2nR8bP4PvDx8ub7fEr6g+/r++//bcsP0QONtJ0P/9mCWUIGqDai4UP598HDCalCo/c2LyLJxghtYGMCKxdQAUIjywZs1v2AQWUnCtAyETCNqCzMUUByDmNzz6gpTJWgOLgwG1AVaCsKJM7ifUpi6NVjEmQNKPPGMi4ihoiMQ3qApojRVZbiEGO0rbQEbF2MgoyRDvxXJKtzDxwB2gz9mQHLPEUIL2dycGZglICKni0gyacHLTyCYgaaDuTU8hcT33CI3PmZC9PEgZIoIhWgLBWjS4ggkxDCsBgcWuW6xVQE+LUyzw8GMB7cT0ppxJKtYc+w5Ol7RQH0dNyzcOCUaVduwIEMyvGaoDgbQOVmIRKQEhkaJdr8rVTFoDiAW7NVI4R5iCnecKD1mbdhVMkQKzsw+Dkbt7FkOCIkjDm7AttA2MGRsVXJB2alSuGqYbmaeXiQZro2QcMtbouUKCkNEthDE1UpWoHKRBU2hYKOnKUgMhK2sySGBhgVgYhmgBy20IgFvZqD9HCmzHoIxle8fGj5V3AeMjVagdJBN8ASPOoVqexonbLgo/g4OokzINDPfsGohCUcJlo2ayDPnweQMo6I4ps3ibsPGPNKsBgbB8YfPiaxlWlUTAA7VOOKXeq7qmEHF355MNdCMs81gAmarbPSTlUpOzHkqnYdwoqc5UmgTRlyxuc/IpPQhBM2k4OmJqhyruIzOyerH1EzgNISTnf0J98ZOKU6hWgp3H0ayuHE1RRkyBvAgwQK8MwDTS1DYiKQFqV6wxn7Y4FYpAbvUL5QRW0OyiEZB02rpzQFHgxROYwoQRUSLc+YJBZGTUq1FW0MSSnAKnCOkH0DWcaEBatY2Y2mjYekkqU6s4jVfsGPgiQSn8CoFg7Bm3u3+mJRgasp7tmKYzh4IZeSngmCGgz9lV9loydqCs/pzIRTSlnZ0ji2m2gU+qsnbwCnJoK22JsujKLdiKDpkukLReBLFQrCyktvTkTmIC6zqaq6R4lKrQtRII5j6kAHegNsy5cz3FVHLIBQ58ys5MWQ4E5w0Xuj6aaU/Cz6v7p7v7s6frh7P7sf5IORoS4GAAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/el-salvador.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaElSalvador50m {
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

/// Widget for rendering the north-america/el-salvador.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// ElSalvador50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class ElSalvador50mWidget extends StatelessWidget {
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

  /// Creates a ElSalvador50mWidget.
  const ElSalvador50mWidget({
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
      geoJson: northAmericaElSalvador50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
