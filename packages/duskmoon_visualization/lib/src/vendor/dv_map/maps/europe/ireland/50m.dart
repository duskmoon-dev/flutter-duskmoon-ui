// Generated from: assets/europe/ireland.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/ireland.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/ireland.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeIreland50m {
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

/// Widget for rendering the europe/ireland.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Ireland50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Ireland50mWidget extends StatelessWidget {
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

  /// Creates a Ireland50mWidget.
  const Ireland50mWidget({
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
      geoJson: europeIreland50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
