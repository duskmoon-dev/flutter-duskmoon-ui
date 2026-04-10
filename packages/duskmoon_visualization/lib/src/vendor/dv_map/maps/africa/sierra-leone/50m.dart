// Generated from: assets/africa/sierra-leone.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/sierra-leone.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/sierra-leone.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaSierraLeone50m {
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

/// Widget for rendering the africa/sierra-leone.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// SierraLeone50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class SierraLeone50mWidget extends StatelessWidget {
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

  /// Creates a SierraLeone50mWidget.
  const SierraLeone50mWidget({
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
      geoJson: africaSierraLeone50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
