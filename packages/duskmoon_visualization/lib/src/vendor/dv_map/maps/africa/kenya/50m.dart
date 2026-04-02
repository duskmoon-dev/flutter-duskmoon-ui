// Generated from: assets/africa/kenya.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/kenya.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/kenya.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaKenya50m {
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

/// Widget for rendering the africa/kenya.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Kenya50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Kenya50mWidget extends StatelessWidget {
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

  /// Creates a Kenya50mWidget.
  const Kenya50mWidget({
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
      geoJson: africaKenya50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
