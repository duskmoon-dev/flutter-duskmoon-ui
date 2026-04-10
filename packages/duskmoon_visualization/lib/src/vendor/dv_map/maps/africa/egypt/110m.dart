// Generated from: assets/africa/egypt.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/egypt.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE6WXTWsbQQyG7/4Vy56D0OhrpNxKaXvttZRQTOoGQ+I1zvZgQv57WScOSWagFfVh2Z2PB+md15qZh9UwjPNxvxkvh/HzZj3/Pmw+Tre3m+t5O+3Gi6X711Pz/Xg5fF8NwzA8nJ7txNPwU8f+MO03h3l7mnQePgzjbn13mvDp5rifX4YPw7i9n36s6dT1pWnnp/Zvrzuup9283W1289L34ddhe70en3sfX8K42Ux3m/lwfBvEOeqv0+3x5jnJF+p0+LndredX2T79Xr+//xoGNnAz4ot37USAb5quLv7GsUCLDodQXFMsBSUNb1gMBUkkyZLgSh1WVeKaZFmQlA4ryGpJsQRqKNaGpYDMNaeXgFT2HkvD1ZKsgqLasAyKEOX0YmDxag2rgkV4pFgElcXbdXSoqMRJFhNKG1dANZQsS4g7/58A14Ke1KuwdfRykFIt5wkGdS+tVytELZzzxOLvwt11FM9ZQqCoaC8sJ84pLyBkHac6sHDk3CVgUqp0VhEjhJKsIOqZS7GkU3RiEu7Zq1pBTxpMgEylSZMLUImkKZ5YLE3ZeaZpzeXKUCu3oSGEVcmFRhDB0dQKLoAkmDMsQQnqJ2nIub2oQBi2+8eSIyfVL2Beo3EZFxCKHAohqkVjMS6gqp5lYSj2WFJzYlGAOUtvEYtbLixyiMLahoXgFTFVWJdirCjN4eRkLq0pc1EF0Wq9HJkK5XI0kNC2UizL6GqpOkEKxTqb7cKyKDm9BBypPZwsenlQqkyTQHT1QjArObkEKmJ7/locLFJyYSlgp0ATu6nkxOqRFMzp/zHJA/2y9bWnreytgKB3I8jeLP7xhrLqvZ/fHlfn59XqcfUHEENIxT4OAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/egypt.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaEgypt110m {
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

/// Widget for rendering the africa/egypt.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Egypt110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Egypt110mWidget extends StatelessWidget {
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

  /// Creates a Egypt110mWidget.
  const Egypt110mWidget({
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
      geoJson: africaEgypt110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
