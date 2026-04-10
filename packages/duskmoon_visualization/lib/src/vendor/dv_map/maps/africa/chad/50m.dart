// Generated from: assets/africa/chad.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/chad.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/chad.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaChad50m {
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

/// Widget for rendering the africa/chad.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Chad50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Chad50mWidget extends StatelessWidget {
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

  /// Creates a Chad50mWidget.
  const Chad50mWidget({
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
      geoJson: africaChad50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
