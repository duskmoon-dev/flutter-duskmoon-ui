// Generated from: assets/oceania/new-caledonia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for oceania/new-caledonia.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for oceania/new-caledonia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get oceaniaNewCaledonia50m {
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

/// Widget for rendering the oceania/new-caledonia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// NewCaledonia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class NewCaledonia50mWidget extends StatelessWidget {
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

  /// Creates a NewCaledonia50mWidget.
  const NewCaledonia50mWidget({
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
      geoJson: oceaniaNewCaledonia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
