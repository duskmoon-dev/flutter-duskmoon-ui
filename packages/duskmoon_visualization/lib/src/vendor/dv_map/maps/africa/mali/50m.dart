// Generated from: assets/africa/mali.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/mali.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/mali.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaMali50m {
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

/// Widget for rendering the africa/mali.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Mali50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Mali50mWidget extends StatelessWidget {
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

  /// Creates a Mali50mWidget.
  const Mali50mWidget({
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
      geoJson: africaMali50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
