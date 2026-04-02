// Generated from: assets/asia/united-arab-emirates.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/united-arab-emirates.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/united-arab-emirates.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaUnitedArabEmirates50m {
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

/// Widget for rendering the asia/united-arab-emirates.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// UnitedArabEmirates50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class UnitedArabEmirates50mWidget extends StatelessWidget {
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

  /// Creates a UnitedArabEmirates50mWidget.
  const UnitedArabEmirates50mWidget({
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
      geoJson: asiaUnitedArabEmirates50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
