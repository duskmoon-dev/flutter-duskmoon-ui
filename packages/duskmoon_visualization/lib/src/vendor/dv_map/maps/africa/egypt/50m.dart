// Generated from: assets/africa/egypt.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/egypt.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/egypt.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaEgypt50m {
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

/// Widget for rendering the africa/egypt.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Egypt50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Egypt50mWidget extends StatelessWidget {
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

  /// Creates a Egypt50mWidget.
  const Egypt50mWidget({
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
      geoJson: africaEgypt50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
