// Generated from: assets/asia/cambodia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/cambodia.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/cambodia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaCambodia50m {
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

/// Widget for rendering the asia/cambodia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Cambodia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Cambodia50mWidget extends StatelessWidget {
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

  /// Creates a Cambodia50mWidget.
  const Cambodia50mWidget({
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
      geoJson: asiaCambodia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
