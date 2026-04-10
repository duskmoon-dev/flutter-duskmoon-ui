// Generated from: assets/asia/philippines.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/philippines.110m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/philippines.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaPhilippines110m {
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

/// Widget for rendering the asia/philippines.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Philippines110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Philippines110mWidget extends StatelessWidget {
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

  /// Creates a Philippines110mWidget.
  const Philippines110mWidget({
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
      geoJson: asiaPhilippines110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
