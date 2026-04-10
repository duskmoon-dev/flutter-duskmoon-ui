// Generated from: assets/africa/ghana.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/ghana.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/ghana.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaGhana50m {
  if (_cached != null) return _cached!;

  // Decode base64 and decompress
  final compressed = base64Decode(_kCompressedData);
  final decompressed = GZipDecoder().decodeBytes(compressed);
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

/// Widget for rendering the africa/ghana.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Ghana50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Ghana50mWidget extends StatelessWidget {
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

  /// Creates a Ghana50mWidget.
  const Ghana50mWidget({
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
      geoJson: africaGhana50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
