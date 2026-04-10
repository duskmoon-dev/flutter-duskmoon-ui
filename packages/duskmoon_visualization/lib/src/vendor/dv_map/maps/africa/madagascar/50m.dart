// Generated from: assets/africa/madagascar.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/madagascar.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/madagascar.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaMadagascar50m {
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

/// Widget for rendering the africa/madagascar.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Madagascar50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Madagascar50mWidget extends StatelessWidget {
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

  /// Creates a Madagascar50mWidget.
  const Madagascar50mWidget({
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
      geoJson: africaMadagascar50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
