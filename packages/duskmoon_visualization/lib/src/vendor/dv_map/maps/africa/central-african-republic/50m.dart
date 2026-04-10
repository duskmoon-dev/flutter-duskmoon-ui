// Generated from: assets/africa/central-african-republic.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/central-african-republic.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/central-african-republic.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaCentralAfricanRepublic50m {
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

/// Widget for rendering the africa/central-african-republic.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// CentralAfricanRepublic50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class CentralAfricanRepublic50mWidget extends StatelessWidget {
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

  /// Creates a CentralAfricanRepublic50mWidget.
  const CentralAfricanRepublic50mWidget({
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
      geoJson: africaCentralAfricanRepublic50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
