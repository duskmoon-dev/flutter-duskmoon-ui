// Generated from: assets/africa/botswana.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/botswana.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/botswana.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaBotswana50m {
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

/// Widget for rendering the africa/botswana.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Botswana50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Botswana50mWidget extends StatelessWidget {
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

  /// Creates a Botswana50mWidget.
  const Botswana50mWidget({
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
      geoJson: africaBotswana50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
