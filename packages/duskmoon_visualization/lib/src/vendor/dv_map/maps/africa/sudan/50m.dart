// Generated from: assets/africa/sudan.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/sudan.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/sudan.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaSudan50m {
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

/// Widget for rendering the africa/sudan.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Sudan50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Sudan50mWidget extends StatelessWidget {
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

  /// Creates a Sudan50mWidget.
  const Sudan50mWidget({
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
      geoJson: africaSudan50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
