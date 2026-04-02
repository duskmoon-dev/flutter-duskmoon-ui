// Generated from: assets/africa/tunisia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/tunisia.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/tunisia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaTunisia50m {
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

/// Widget for rendering the africa/tunisia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Tunisia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Tunisia50mWidget extends StatelessWidget {
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

  /// Creates a Tunisia50mWidget.
  const Tunisia50mWidget({
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
      geoJson: africaTunisia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
