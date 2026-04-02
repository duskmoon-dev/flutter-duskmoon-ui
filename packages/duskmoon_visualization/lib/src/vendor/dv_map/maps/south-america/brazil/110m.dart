// Generated from: assets/south-america/brazil.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for south-america/brazil.110m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for south-america/brazil.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get southAmericaBrazil110m {
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

/// Widget for rendering the south-america/brazil.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Brazil110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Brazil110mWidget extends StatelessWidget {
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

  /// Creates a Brazil110mWidget.
  const Brazil110mWidget({
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
      geoJson: southAmericaBrazil110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
