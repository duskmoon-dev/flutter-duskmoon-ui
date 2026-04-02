// Generated from: assets/europe/portugal.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/portugal.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/portugal.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europePortugal50m {
  if (_cached != null) return _cached!;

  // Decode base64 and decompress
  final compressed = base64Decode(_kCompressedData);
  final decompressed = gzip.decode(compressed);
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

/// Widget for rendering the europe/portugal.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Portugal50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Portugal50mWidget extends StatelessWidget {
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

  /// Creates a Portugal50mWidget.
  const Portugal50mWidget({
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
      geoJson: europePortugal50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
