// Generated from: assets/africa/libya.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/libya.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/libya.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaLibya50m {
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

/// Widget for rendering the africa/libya.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Libya50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Libya50mWidget extends StatelessWidget {
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

  /// Creates a Libya50mWidget.
  const Libya50mWidget({
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
      geoJson: africaLibya50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
