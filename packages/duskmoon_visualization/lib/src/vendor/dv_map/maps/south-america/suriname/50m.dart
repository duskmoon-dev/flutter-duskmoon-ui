// Generated from: assets/south-america/suriname.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for south-america/suriname.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for south-america/suriname.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get southAmericaSuriname50m {
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

/// Widget for rendering the south-america/suriname.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Suriname50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Suriname50mWidget extends StatelessWidget {
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

  /// Creates a Suriname50mWidget.
  const Suriname50mWidget({
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
      geoJson: southAmericaSuriname50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
