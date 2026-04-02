// Generated from: assets/africa/zimbabwe.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/zimbabwe.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/zimbabwe.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaZimbabwe50m {
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

/// Widget for rendering the africa/zimbabwe.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Zimbabwe50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Zimbabwe50mWidget extends StatelessWidget {
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

  /// Creates a Zimbabwe50mWidget.
  const Zimbabwe50mWidget({
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
      geoJson: africaZimbabwe50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
