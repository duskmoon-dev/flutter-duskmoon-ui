// Generated from: assets/north-america/costa-rica.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/costa-rica.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/costa-rica.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaCostaRica50m {
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

/// Widget for rendering the north-america/costa-rica.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// CostaRica50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class CostaRica50mWidget extends StatelessWidget {
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

  /// Creates a CostaRica50mWidget.
  const CostaRica50mWidget({
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
      geoJson: northAmericaCostaRica50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
