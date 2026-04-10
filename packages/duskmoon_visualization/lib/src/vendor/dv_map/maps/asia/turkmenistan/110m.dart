// Generated from: assets/asia/turkmenistan.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/turkmenistan.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5VYS4sbRxC+61cMOi9FvR++hUAuIZBDbsEE4ShGeFezaOXDYva/h5GzxutuCCXB0Jrq/qjn11X6sluW/fX58bh/t+x/OR6uny/Hn9f7++OH62k97+828T9fXz/t3y1/7pZlWb7cnuPB2/ab4PGyPh4v19Pt0Ov2ZdmfDw+3A398vnx6OJ5PT9fD+dupZdmfnta/Dnzb8dvwXm7vf30j+LCer6fz8XzdZD89nQ77/2Qv33T5eFwfjtfL81tNXlX/fb1//rie32Kul79P58P1O5O/fr5f//hrWYzBkNUq736QKEGkCJm9Eby/+z+8JPXMGR6JSaA38Yo8tGKCl55E3sMTCKYgsQGPgVioSFt4CogpRBP1zIgJswkX4qkmAx5CGSFpNc1NS5Ka4bkQinbDW2RsE3sRMtxYpInnJRXsEzwUcS5q2isWiTnoJwUVxum98AoQEnLUBI8LLaSbfplYnIO9klDGWD33CYSY0RgOCSh0EucmXjFZTcwNoMqi7FZHIgrqBE6KlZvVYWBEFjnDK1ei6GWLAyVK6EBWG54YsUcTz6nEfQxHAjFJac99ASKoIqN+CcjFXD28BBUn05n/jFmwemxQwKLhPIFT4spWdB1BInxirINxSEoruE4bn2PgwPTioLVleas2nGBjc4oxuAZuiMGt2nUGFnSjUT8DDvQeUzlDpbrzwPRioLh9e9EQoBKTSa0ZpAW5tZjPBSo5y0ZqcUCMsmjlniuYukaN4XAQYozeTeQKoU5os2QmoqRocYEbWGZpzLhF0Ji8Fw+DUHPBoRGSAHeiZro4MIWkzpheSqKwVx0ORunoU3OdI7UXDt/CS4ZjOgdUqGcvWwy2e61GaxMU2Xu85woUyJNSS8hixd614bL5DmlyDRWIC5v31GOQUPbRd1tTZZLZ6wqcIJODdNbkYmqat5pSJzANGpsMJWB3CeylCoK61aRlJmBG4d6E4AiYIjoWmhIoG2mzp9oaT1fmgViUYbtzsweX4FxIOHqPIYzMei1QQKRPfMdbiptxb9xwKGGmkUS3aY0d2bvaYbkUzfCEWQh7eAbluc14MzxMV+o1fAZq83GIgK3SmuOLQpiJ2mw6RZUK6jVoChilNF5CyiCshM0GkqFUuWSWy0SOor1kbv/7sJutX1cvu9fn+93L7l+j50O5JxIAAA==';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/turkmenistan.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaTurkmenistan110m {
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

/// Widget for rendering the asia/turkmenistan.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Turkmenistan110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Turkmenistan110mWidget extends StatelessWidget {
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

  /// Creates a Turkmenistan110mWidget.
  const Turkmenistan110mWidget({
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
      geoJson: asiaTurkmenistan110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
