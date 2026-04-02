// Generated from: assets/north-america/mexico.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/mexico.110m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/mexico.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaMexico110m {
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

/// Widget for rendering the north-america/mexico.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Mexico110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Mexico110mWidget extends StatelessWidget {
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

  /// Creates a Mexico110mWidget.
  const Mexico110mWidget({
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
      geoJson: northAmericaMexico110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
