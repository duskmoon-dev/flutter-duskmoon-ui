// Generated from: assets/africa/togo.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/togo.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/togo.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaTogo50m {
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

/// Widget for rendering the africa/togo.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Togo50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Togo50mWidget extends StatelessWidget {
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

  /// Creates a Togo50mWidget.
  const Togo50mWidget({
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
      geoJson: africaTogo50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
