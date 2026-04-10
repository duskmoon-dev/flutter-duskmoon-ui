// Generated from: assets/asia/afghanistan.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/afghanistan.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/afghanistan.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaAfghanistan50m {
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

/// Widget for rendering the asia/afghanistan.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Afghanistan50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Afghanistan50mWidget extends StatelessWidget {
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

  /// Creates a Afghanistan50mWidget.
  const Afghanistan50mWidget({
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
      geoJson: asiaAfghanistan50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
