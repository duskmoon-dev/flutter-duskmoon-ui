// Generated from: assets/africa/nigeria.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/nigeria.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/nigeria.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaNigeria50m {
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

/// Widget for rendering the africa/nigeria.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Nigeria50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Nigeria50mWidget extends StatelessWidget {
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

  /// Creates a Nigeria50mWidget.
  const Nigeria50mWidget({
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
      geoJson: africaNigeria50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
