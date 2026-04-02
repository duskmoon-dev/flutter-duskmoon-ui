// Generated from: assets/europe/slovenia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/slovenia.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/slovenia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeSlovenia50m {
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

/// Widget for rendering the europe/slovenia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Slovenia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Slovenia50mWidget extends StatelessWidget {
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

  /// Creates a Slovenia50mWidget.
  const Slovenia50mWidget({
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
      geoJson: europeSlovenia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
