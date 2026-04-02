// Generated from: assets/asia/azerbaijan.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/azerbaijan.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/azerbaijan.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaAzerbaijan50m {
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

/// Widget for rendering the asia/azerbaijan.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Azerbaijan50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Azerbaijan50mWidget extends StatelessWidget {
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

  /// Creates a Azerbaijan50mWidget.
  const Azerbaijan50mWidget({
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
      geoJson: asiaAzerbaijan50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
