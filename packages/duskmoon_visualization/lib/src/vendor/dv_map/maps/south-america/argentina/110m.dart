// Generated from: assets/south-america/argentina.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for south-america/argentina.110m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for south-america/argentina.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get southAmericaArgentina110m {
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

/// Widget for rendering the south-america/argentina.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Argentina110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Argentina110mWidget extends StatelessWidget {
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

  /// Creates a Argentina110mWidget.
  const Argentina110mWidget({
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
      geoJson: southAmericaArgentina110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
