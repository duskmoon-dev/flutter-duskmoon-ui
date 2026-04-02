// Generated from: assets/europe/slovakia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/slovakia.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/slovakia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeSlovakia50m {
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

/// Widget for rendering the europe/slovakia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Slovakia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Slovakia50mWidget extends StatelessWidget {
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

  /// Creates a Slovakia50mWidget.
  const Slovakia50mWidget({
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
      geoJson: europeSlovakia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
