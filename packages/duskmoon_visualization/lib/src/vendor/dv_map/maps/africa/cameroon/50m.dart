// Generated from: assets/africa/cameroon.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/cameroon.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/cameroon.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaCameroon50m {
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

/// Widget for rendering the africa/cameroon.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Cameroon50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Cameroon50mWidget extends StatelessWidget {
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

  /// Creates a Cameroon50mWidget.
  const Cameroon50mWidget({
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
      geoJson: africaCameroon50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
