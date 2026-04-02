// Generated from: assets/africa/somalia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/somalia.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/somalia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaSomalia50m {
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

/// Widget for rendering the africa/somalia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Somalia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Somalia50mWidget extends StatelessWidget {
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

  /// Creates a Somalia50mWidget.
  const Somalia50mWidget({
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
      geoJson: africaSomalia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
