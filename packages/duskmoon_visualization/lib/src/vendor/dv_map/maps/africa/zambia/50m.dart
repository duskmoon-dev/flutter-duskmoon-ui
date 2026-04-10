// Generated from: assets/africa/zambia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/zambia.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/zambia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaZambia50m {
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

/// Widget for rendering the africa/zambia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Zambia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Zambia50mWidget extends StatelessWidget {
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

  /// Creates a Zambia50mWidget.
  const Zambia50mWidget({
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
      geoJson: africaZambia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
