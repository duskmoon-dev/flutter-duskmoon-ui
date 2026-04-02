// Generated from: assets/africa/south-africa.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/south-africa.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/south-africa.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaSouthAfrica50m {
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

/// Widget for rendering the africa/south-africa.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// SouthAfrica50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class SouthAfrica50mWidget extends StatelessWidget {
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

  /// Creates a SouthAfrica50mWidget.
  const SouthAfrica50mWidget({
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
      geoJson: africaSouthAfrica50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
