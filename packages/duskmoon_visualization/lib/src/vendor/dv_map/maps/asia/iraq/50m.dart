// Generated from: assets/asia/iraq.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/iraq.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/iraq.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaIraq50m {
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

/// Widget for rendering the asia/iraq.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Iraq50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Iraq50mWidget extends StatelessWidget {
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

  /// Creates a Iraq50mWidget.
  const Iraq50mWidget({
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
      geoJson: asiaIraq50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
