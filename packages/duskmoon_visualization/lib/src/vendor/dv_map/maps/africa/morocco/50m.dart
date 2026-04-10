// Generated from: assets/africa/morocco.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/morocco.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/morocco.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaMorocco50m {
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

/// Widget for rendering the africa/morocco.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Morocco50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Morocco50mWidget extends StatelessWidget {
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

  /// Creates a Morocco50mWidget.
  const Morocco50mWidget({
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
      geoJson: africaMorocco50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
