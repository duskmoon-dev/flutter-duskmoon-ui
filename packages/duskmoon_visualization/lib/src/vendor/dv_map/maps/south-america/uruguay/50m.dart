// Generated from: assets/south-america/uruguay.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for south-america/uruguay.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for south-america/uruguay.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get southAmericaUruguay50m {
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

/// Widget for rendering the south-america/uruguay.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Uruguay50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Uruguay50mWidget extends StatelessWidget {
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

  /// Creates a Uruguay50mWidget.
  const Uruguay50mWidget({
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
      geoJson: southAmericaUruguay50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
