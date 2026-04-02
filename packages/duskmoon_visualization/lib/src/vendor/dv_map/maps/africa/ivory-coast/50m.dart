// Generated from: assets/africa/ivory-coast.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/ivory-coast.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/ivory-coast.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaIvoryCoast50m {
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

/// Widget for rendering the africa/ivory-coast.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// IvoryCoast50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class IvoryCoast50mWidget extends StatelessWidget {
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

  /// Creates a IvoryCoast50mWidget.
  const IvoryCoast50mWidget({
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
      geoJson: africaIvoryCoast50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
