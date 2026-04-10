// Generated from: assets/africa/benin.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/benin.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/benin.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaBenin50m {
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

/// Widget for rendering the africa/benin.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Benin50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Benin50mWidget extends StatelessWidget {
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

  /// Creates a Benin50mWidget.
  const Benin50mWidget({
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
      geoJson: africaBenin50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
