// Generated from: assets/europe/hungary.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/hungary.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/hungary.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeHungary50m {
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

/// Widget for rendering the europe/hungary.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Hungary50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Hungary50mWidget extends StatelessWidget {
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

  /// Creates a Hungary50mWidget.
  const Hungary50mWidget({
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
      geoJson: europeHungary50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
