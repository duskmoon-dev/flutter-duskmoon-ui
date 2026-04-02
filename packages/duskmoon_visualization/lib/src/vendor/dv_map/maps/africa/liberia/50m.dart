// Generated from: assets/africa/liberia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/liberia.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/liberia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaLiberia50m {
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

/// Widget for rendering the africa/liberia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Liberia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Liberia50mWidget extends StatelessWidget {
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

  /// Creates a Liberia50mWidget.
  const Liberia50mWidget({
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
      geoJson: africaLiberia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
