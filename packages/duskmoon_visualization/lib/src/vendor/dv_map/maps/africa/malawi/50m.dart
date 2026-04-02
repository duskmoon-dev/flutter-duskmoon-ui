// Generated from: assets/africa/malawi.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/malawi.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/malawi.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaMalawi50m {
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

/// Widget for rendering the africa/malawi.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Malawi50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Malawi50mWidget extends StatelessWidget {
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

  /// Creates a Malawi50mWidget.
  const Malawi50mWidget({
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
      geoJson: africaMalawi50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
