// Generated from: assets/north-america/guatemala.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/guatemala.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/guatemala.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaGuatemala50m {
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

/// Widget for rendering the north-america/guatemala.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Guatemala50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Guatemala50mWidget extends StatelessWidget {
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

  /// Creates a Guatemala50mWidget.
  const Guatemala50mWidget({
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
      geoJson: northAmericaGuatemala50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
