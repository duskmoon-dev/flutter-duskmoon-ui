// Generated from: assets/asia/syria.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/syria.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/syria.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaSyria50m {
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

/// Widget for rendering the asia/syria.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Syria50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Syria50mWidget extends StatelessWidget {
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

  /// Creates a Syria50mWidget.
  const Syria50mWidget({
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
      geoJson: asiaSyria50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
