// Generated from: assets/europe/croatia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/croatia.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/croatia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeCroatia50m {
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

/// Widget for rendering the europe/croatia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Croatia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Croatia50mWidget extends StatelessWidget {
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

  /// Creates a Croatia50mWidget.
  const Croatia50mWidget({
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
      geoJson: europeCroatia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
