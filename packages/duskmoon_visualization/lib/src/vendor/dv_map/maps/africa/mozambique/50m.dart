// Generated from: assets/africa/mozambique.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/mozambique.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/mozambique.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaMozambique50m {
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

/// Widget for rendering the africa/mozambique.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Mozambique50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Mozambique50mWidget extends StatelessWidget {
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

  /// Creates a Mozambique50mWidget.
  const Mozambique50mWidget({
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
      geoJson: africaMozambique50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
