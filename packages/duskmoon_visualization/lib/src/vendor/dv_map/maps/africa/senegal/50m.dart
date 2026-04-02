// Generated from: assets/africa/senegal.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/senegal.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/senegal.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaSenegal50m {
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

/// Widget for rendering the africa/senegal.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Senegal50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Senegal50mWidget extends StatelessWidget {
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

  /// Creates a Senegal50mWidget.
  const Senegal50mWidget({
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
      geoJson: africaSenegal50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
