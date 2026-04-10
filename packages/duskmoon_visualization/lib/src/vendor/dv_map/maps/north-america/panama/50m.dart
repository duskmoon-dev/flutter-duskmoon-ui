// Generated from: assets/north-america/panama.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for north-america/panama.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for north-america/panama.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get northAmericaPanama50m {
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

/// Widget for rendering the north-america/panama.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Panama50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Panama50mWidget extends StatelessWidget {
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

  /// Creates a Panama50mWidget.
  const Panama50mWidget({
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
      geoJson: northAmericaPanama50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
