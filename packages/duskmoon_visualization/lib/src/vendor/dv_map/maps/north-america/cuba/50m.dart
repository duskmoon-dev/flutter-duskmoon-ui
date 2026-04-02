// Generated from: assets/north-america/cuba.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/cuba.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/cuba.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaCuba50m {
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

/// Widget for rendering the north-america/cuba.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Cuba50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Cuba50mWidget extends StatelessWidget {
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

  /// Creates a Cuba50mWidget.
  const Cuba50mWidget({
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
      geoJson: northAmericaCuba50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
