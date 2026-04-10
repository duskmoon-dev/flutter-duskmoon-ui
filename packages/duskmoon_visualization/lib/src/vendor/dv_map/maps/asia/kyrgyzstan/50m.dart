// Generated from: assets/asia/kyrgyzstan.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/kyrgyzstan.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/kyrgyzstan.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaKyrgyzstan50m {
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

/// Widget for rendering the asia/kyrgyzstan.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Kyrgyzstan50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Kyrgyzstan50mWidget extends StatelessWidget {
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

  /// Creates a Kyrgyzstan50mWidget.
  const Kyrgyzstan50mWidget({
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
      geoJson: asiaKyrgyzstan50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
