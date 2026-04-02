// Generated from: assets/south-america/chile.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for south-america/chile.110m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for south-america/chile.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get southAmericaChile110m {
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

/// Widget for rendering the south-america/chile.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Chile110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Chile110mWidget extends StatelessWidget {
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

  /// Creates a Chile110mWidget.
  const Chile110mWidget({
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
      geoJson: southAmericaChile110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
