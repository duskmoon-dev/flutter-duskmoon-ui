// Generated from: assets/asia/yemen.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/yemen.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WXTWsjRxCG7/oVg86m6Pqu2tsSsrdAriEsQWwmi8DWGFl7MIv/e2gpXuztJlBzGFpT3Q9vd3106ftuWfaX58d1/2HZf1oPl2/n9Zft/n79cjlup/1dN/9z+/y0/7D8uVuWZfl+fY8Lr9Ovhsfz9rieL8frotfpy7I/HR6uC/5YH9bTj+nLsj8+bX8d6Gr6dfjOt++/vTV82U6X42k9Xbrt49PxsP/P9vJDxNd1e1gv5+f3El41/77dP3/dTu+Z2/nv4+lwebPX2/N2/POvZVGC1p+Mu58smDcLyzvD57v/5UkCopmjDbwAQzNzK/ECMJiFdcLrOEsq8RykL5Jxv35VHljT57dTkhx4BimZmVziGXhfJTzRR8HMgUUem5nG6A8HYmbUmj4F7ptKmvC4P1rTp0BopjjjCTNTlnACzciQpzhsrBElHoMnKk6PjzHTzYs8juZz96pnRpmHqJ4+09ciRJoWeYTBrqM+AzOLmjcI3JOZZjQWj8Ra8BEEsXnzgaeQiC5U5XkjYR+LgYJjRGgtWgiiaUMdi5UCGaZRlWdNwmm2X8KebOXzSyKZeFcgGpEUixVDC0+RCa6nIbcqjhRFYkxeBjfX4GpyEFE44oRH1FJb7W5jkKCc1VICY6v5VgBdESe+JdDQsjgBSVG3MfYInNCUaocnkJHKPMYKgWU/hVotUEARVh0vSoJUTo7qRSTNRGPMXYZGlk1r56dgpD17Z8GSLcVqjYZCuGvSTB+Lu0lNn4Gjt5l/uV/JluVGiFVEeQxmBk0izFo8OyRH4rQWNCfmmrwA4kjxkceQEi2ydrEFmCdxG7fb9TE1qva56vN0E/AWblbqIxUBnRR1DD/thYIkS+mrBNh72UlfqqDpQrXy0nmJTjn6Q7vjhbnU9ykBh1KblAMDDhLEUrwoA7ZQp9G/BqbYFKv6PAhj2qixZLXVqP/P2s3Gr6OX3ev78+5l9y/tuctzCg8AAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/yemen.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaYemen110m {
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

/// Widget for rendering the asia/yemen.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Yemen110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Yemen110mWidget extends StatelessWidget {
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

  /// Creates a Yemen110mWidget.
  const Yemen110mWidget({
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
      geoJson: asiaYemen110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
