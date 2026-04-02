// Generated from: assets/asia/indonesia.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/indonesia.110m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/indonesia.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaIndonesia110m {
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

/// Widget for rendering the asia/indonesia.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Indonesia110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Indonesia110mWidget extends StatelessWidget {
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

  /// Creates a Indonesia110mWidget.
  const Indonesia110mWidget({
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
      geoJson: asiaIndonesia110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
