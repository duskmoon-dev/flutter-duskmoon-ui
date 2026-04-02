// Generated from: assets/seven-seas-open-ocean/mauritius.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for seven-seas-open-ocean/mauritius.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52UTYvbMBCG7/4VwqcW0qDRfGi010JvhcLSU1mKSdXFkJWC7RTCkv9e7GxCdqNStD4IWa/m8Wj0jp8bY9rpsIvtnWm/xG7aD/Fz3m7jZupzalez/Pu0PLZ35kdjjDHPy3gbuGxfhN2Qd3GY+iXovN2YNnVPS8DXbj/0U78fLyHGtP2Yf3Zukb/frONp/f5a2OQ09Smmadbu45+YzBi70XzIu5hM3sQufWxfth8vuT3G/BSn4fA6s/NRvuXt4fHl5JfP5OFXn7rpqgSn53r+9s0Y9mthcBJ49Ub55OyalFQQXykPq/8BvRUhK0UgvgvoitmhqJL3tTCd04MicK4DQi0wQAjOlYAOHIf6DNE760s8G5TQcyVPWJjwhgdhHTQEAqrksWevUAYGD6K1PGCLoXgjljlwbf1IhRxriQeEgbjWfwRigYuGBkWvodYyqOzpH5ZxKlDdISgObKCiqdG/w4MoDChFE5IVqq8hghdfvhRyXlCqM3SKzt66cAbWdggqorXF5NiiBxtqLe1ILRXLx4CgKNU9XPeTbkrz8+zYnMeH5tj8BXTFW+VfBwAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for seven-seas-open-ocean/mauritius.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get sevenSeasOpenOceanMauritius50m {
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

/// Widget for rendering the seven-seas-open-ocean/mauritius.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Mauritius50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Mauritius50mWidget extends StatelessWidget {
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

  /// Creates a Mauritius50mWidget.
  const Mauritius50mWidget({
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
      geoJson: sevenSeasOpenOceanMauritius50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
