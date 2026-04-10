// Generated from: assets/africa/south-sudan.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/south-sudan.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/south-sudan.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaSouthSudan50m {
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

/// Widget for rendering the africa/south-sudan.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// SouthSudan50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class SouthSudan50mWidget extends StatelessWidget {
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

  /// Creates a SouthSudan50mWidget.
  const SouthSudan50mWidget({
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
      geoJson: africaSouthSudan50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
