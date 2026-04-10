// Generated from: assets/africa/algeria.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/algeria.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/algeria.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaAlgeria50m {
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

/// Widget for rendering the africa/algeria.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Algeria50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Algeria50mWidget extends StatelessWidget {
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

  /// Creates a Algeria50mWidget.
  const Algeria50mWidget({
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
      geoJson: africaAlgeria50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
