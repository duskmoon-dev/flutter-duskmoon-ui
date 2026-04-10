// Generated from: assets/south-america/guyana.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for south-america/guyana.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for south-america/guyana.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get southAmericaGuyana50m {
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

/// Widget for rendering the south-america/guyana.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Guyana50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Guyana50mWidget extends StatelessWidget {
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

  /// Creates a Guyana50mWidget.
  const Guyana50mWidget({
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
      geoJson: southAmericaGuyana50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
