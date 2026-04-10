// Generated from: assets/europe/lithuania.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/lithuania.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/lithuania.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeLithuania50m {
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

/// Widget for rendering the europe/lithuania.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Lithuania50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Lithuania50mWidget extends StatelessWidget {
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

  /// Creates a Lithuania50mWidget.
  const Lithuania50mWidget({
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
      geoJson: europeLithuania50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
