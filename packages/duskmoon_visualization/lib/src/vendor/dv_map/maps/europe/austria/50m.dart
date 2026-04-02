// Generated from: assets/europe/austria.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/austria.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/austria.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeAustria50m {
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

/// Widget for rendering the europe/austria.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Austria50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Austria50mWidget extends StatelessWidget {
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

  /// Creates a Austria50mWidget.
  const Austria50mWidget({
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
      geoJson: europeAustria50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
