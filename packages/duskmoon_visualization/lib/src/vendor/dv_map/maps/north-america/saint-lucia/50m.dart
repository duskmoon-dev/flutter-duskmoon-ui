// Generated from: assets/north-america/saint-lucia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/saint-lucia.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52STWsCMRCG7/srhpztksnXJN5E6ElKocciZbGpDehG1ngQ8b+XXV3R7kJJcwiTeWceMh+nAoCl486zKbBnX6VD4+dxs/GrFGLNJq38dXHv2RTeCwCAU3cPE7vwTtg1ceebFLqkPhyA1dW2S3irQp1gcViF6pYEwMI+flSiDVjMB3558c/uhVWsU6h9nVrtJTbpG2Zb34RVxa5B59uf1j5ufWqOjz/qS3iNm+P6WvENHpvPUFfprvTLubd/vwCeDC+t0wKVnfySUJZWoCNBD8Jy8jfQGjJkBkBVckSUwuYCHbfItR4DOim1U9lApbTlOAYkYTWabKAzhhyNlsydJJ0HxJIbqUmJkaE41JqMyAaSRKWGPZSlNf8DGm7GgWRlO67sHmpUONwaWRKSJovZa5i318WY3Vvnor+Xxbn4AWNt2jCKBAAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/saint-lucia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaSaintLucia50m {
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

/// Widget for rendering the north-america/saint-lucia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// SaintLucia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class SaintLucia50mWidget extends StatelessWidget {
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

  /// Creates a SaintLucia50mWidget.
  const SaintLucia50mWidget({
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
      geoJson: northAmericaSaintLucia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
