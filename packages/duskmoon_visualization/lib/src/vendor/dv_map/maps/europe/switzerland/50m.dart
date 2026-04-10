// Generated from: assets/europe/switzerland.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/switzerland.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/switzerland.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeSwitzerland50m {
  if (_cached != null) return _cached!;

  // Decode base64 and decompress
  final compressed = base64Decode(_kCompressedData);
  final decompressed = GZipDecoder().decodeBytes(compressed);
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

/// Widget for rendering the europe/switzerland.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Switzerland50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Switzerland50mWidget extends StatelessWidget {
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

  /// Creates a Switzerland50mWidget.
  const Switzerland50mWidget({
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
      geoJson: europeSwitzerland50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
