// Generated from: assets/europe/belgium.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/belgium.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/belgium.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeBelgium50m {
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

/// Widget for rendering the europe/belgium.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Belgium50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Belgium50mWidget extends StatelessWidget {
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

  /// Creates a Belgium50mWidget.
  const Belgium50mWidget({
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
      geoJson: europeBelgium50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
