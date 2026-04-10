// Generated from: assets/africa/uganda.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/uganda.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/uganda.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaUganda50m {
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

/// Widget for rendering the africa/uganda.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Uganda50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Uganda50mWidget extends StatelessWidget {
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

  /// Creates a Uganda50mWidget.
  const Uganda50mWidget({
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
      geoJson: africaUganda50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
