// Generated from: assets/south-america/paraguay.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for south-america/paraguay.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for south-america/paraguay.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get southAmericaParaguay50m {
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

/// Widget for rendering the south-america/paraguay.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Paraguay50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Paraguay50mWidget extends StatelessWidget {
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

  /// Creates a Paraguay50mWidget.
  const Paraguay50mWidget({
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
      geoJson: southAmericaParaguay50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
