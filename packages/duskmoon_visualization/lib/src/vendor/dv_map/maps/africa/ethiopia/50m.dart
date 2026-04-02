// Generated from: assets/africa/ethiopia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/ethiopia.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/ethiopia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaEthiopia50m {
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

/// Widget for rendering the africa/ethiopia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Ethiopia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Ethiopia50mWidget extends StatelessWidget {
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

  /// Creates a Ethiopia50mWidget.
  const Ethiopia50mWidget({
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
      geoJson: africaEthiopia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
