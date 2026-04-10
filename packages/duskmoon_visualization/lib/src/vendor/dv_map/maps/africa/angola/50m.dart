// Generated from: assets/africa/angola.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/angola.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/angola.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaAngola50m {
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

/// Widget for rendering the africa/angola.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Angola50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Angola50mWidget extends StatelessWidget {
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

  /// Creates a Angola50mWidget.
  const Angola50mWidget({
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
      geoJson: africaAngola50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
