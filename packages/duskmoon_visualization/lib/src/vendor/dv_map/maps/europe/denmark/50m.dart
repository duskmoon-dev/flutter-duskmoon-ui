// Generated from: assets/europe/denmark.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/denmark.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/denmark.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeDenmark50m {
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

/// Widget for rendering the europe/denmark.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Denmark50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Denmark50mWidget extends StatelessWidget {
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

  /// Creates a Denmark50mWidget.
  const Denmark50mWidget({
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
      geoJson: europeDenmark50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
