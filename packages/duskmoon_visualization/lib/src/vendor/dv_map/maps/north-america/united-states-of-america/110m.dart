// Generated from: assets/north-america/united-states-of-america.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/united-states-of-america.110m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/united-states-of-america.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaUnitedStatesOfAmerica110m {
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

/// Widget for rendering the north-america/united-states-of-america.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// UnitedStatesOfAmerica110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class UnitedStatesOfAmerica110mWidget extends StatelessWidget {
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

  /// Creates a UnitedStatesOfAmerica110mWidget.
  const UnitedStatesOfAmerica110mWidget({
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
      geoJson: northAmericaUnitedStatesOfAmerica110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
