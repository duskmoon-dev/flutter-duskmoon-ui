// Generated from: assets/europe/netherlands.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/netherlands.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/netherlands.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeNetherlands50m {
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

/// Widget for rendering the europe/netherlands.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Netherlands50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Netherlands50mWidget extends StatelessWidget {
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

  /// Creates a Netherlands50mWidget.
  const Netherlands50mWidget({
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
      geoJson: europeNetherlands50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
