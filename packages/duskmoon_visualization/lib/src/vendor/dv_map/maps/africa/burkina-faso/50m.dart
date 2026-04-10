// Generated from: assets/africa/burkina-faso.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/burkina-faso.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/burkina-faso.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaBurkinaFaso50m {
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

/// Widget for rendering the africa/burkina-faso.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// BurkinaFaso50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class BurkinaFaso50mWidget extends StatelessWidget {
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

  /// Creates a BurkinaFaso50mWidget.
  const BurkinaFaso50mWidget({
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
      geoJson: africaBurkinaFaso50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
