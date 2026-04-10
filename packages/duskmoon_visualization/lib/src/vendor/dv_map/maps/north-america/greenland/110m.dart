// Generated from: assets/north-america/greenland.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/greenland.110m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/greenland.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaGreenland110m {
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

/// Widget for rendering the north-america/greenland.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Greenland110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Greenland110mWidget extends StatelessWidget {
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

  /// Creates a Greenland110mWidget.
  const Greenland110mWidget({
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
      geoJson: northAmericaGreenland110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
