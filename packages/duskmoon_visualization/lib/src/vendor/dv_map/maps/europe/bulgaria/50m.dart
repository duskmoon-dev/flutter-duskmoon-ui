// Generated from: assets/europe/bulgaria.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/bulgaria.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/bulgaria.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeBulgaria50m {
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

/// Widget for rendering the europe/bulgaria.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Bulgaria50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Bulgaria50mWidget extends StatelessWidget {
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

  /// Creates a Bulgaria50mWidget.
  const Bulgaria50mWidget({
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
      geoJson: europeBulgaria50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
