// Generated from: assets/africa/burundi.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/burundi.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52Yy4pbSQyG936Kg9c9B90v2c2FgdnNfghD03GCoWM3jrMIIe8+VDkd0rHMoPTCuE/5fEhVkn6pPm+WZXv+9LTbvlq2f+7uzx9Pu9+Pj4+7h/P+eNjejeW3l8cftq+WfzbLsiyf5+f1i/Pnc+HpdHzanc77+dLzz5dle7h/P1/47ePp4+HN/tsLy7Ldfzj+e09z8a+r5zyf//Fi4eF4OO8Pu8N5rP369rR/uN9+Xf3yzZB3u+P73fn06aUZz3b/fXz89O6rm9+ox9Ob/eH+/J2/l7/vv//437IwrKpsyHz3w8ovtAoApPuLhdd3/8ujSLCKx6kGqk2eBBGZVTw3cKEuD0LSsOIhZQQ3eeSQN3jioWhdHrNH3uCBQ9c+DGaAKPfPQSG6PCEKpSpekNOkzUO/yTOD9v5BYqRoyUMllg6Pck1nYa94zI6QbR4DupbnwanN8xg8JAGq8k0ljKnLiyT1qOLPTEyi629YoEnFczQBa8Uz5erBnCEVz36GZxkglhUvxcla8Td4imxexbMnubfjT4zNsbIvIMZONHmcQCzV/gWEJnfjhWVsoJf+ogJnk0c5q1wVf87jpJo8TFeNSj+MgJFaejR4QKNqVvmW6sDY5IExBpf2ASlnm0dxQ8/N5CfqC6CwalX/nICwV+8vPDQo80NjKFWbN1WijL+0fn0GE5dSz0PBA7v1BZWJqMqPVKV+PSASwaKe8grKitqtV0Sziyp4yDEqT5eHxFU94JWin22EAFX28spD27DV/U2eYxRqzqu4WnB799A8C/Xg1UabCf3dwyGXBS8ufWH7dJmEqtNNnPLRrfaMLH59urJCqiB0z4M9MfPaPlkphxB0xRLqZJNVJBmtm2yOPiS74qmGtouLWypj5a5ggLXtmx2KXqeHrAw+Tr7Dm829o11rm6wQo7h0e3GM2SFX0ZcUjq1oHrORhWpZW0JB+rMbS5S9Pa/u6aHd7RvRXGkRr87ght1Zuto5U85mlztIVHmpEWHe9VLHmEzXUcKrJElAd8I3xuSiA+KRFKbU9dVIrI46jraiDR5C1lHC/Ylj2ndLcVmcjdu8wGCtNIin4U2c3xgQeCWXbkPFsAaiUDHw8kpD27V7HIGIXIYf9gfK6S/fKCpgydy2z9PqDgNwjoZdXABVEkRrxhjw2+7CEI2yH3UnsW5NNhCqOiBak3UMMN3qMofGqv9O9HEz0a18qmpFR0VrzI6gzWO+cX8YLor9Gj+vb0r7LitdniBDOe+6JUhbOC7CWo5rs9fq8pzH/U01nqb8RLbJrds5u4hb/zQIozRvjK3tDkhktLfVtGujke7dLo3sYLbEKlqEjCy7xb55+7+pvj9/+7J5/ny9+bL5D8mELp6kGQAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/burundi.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaBurundi50m {
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

/// Widget for rendering the africa/burundi.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Burundi50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Burundi50mWidget extends StatelessWidget {
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

  /// Creates a Burundi50mWidget.
  const Burundi50mWidget({
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
      geoJson: africaBurundi50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
