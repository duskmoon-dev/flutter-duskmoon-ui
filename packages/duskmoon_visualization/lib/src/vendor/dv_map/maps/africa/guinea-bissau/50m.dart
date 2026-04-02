// Generated from: assets/africa/guinea-bissau.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/guinea-bissau.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/guinea-bissau.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaGuineaBissau50m {
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

/// Widget for rendering the africa/guinea-bissau.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// GuineaBissau50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class GuineaBissau50mWidget extends StatelessWidget {
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

  /// Creates a GuineaBissau50mWidget.
  const GuineaBissau50mWidget({
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
      geoJson: africaGuineaBissau50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
