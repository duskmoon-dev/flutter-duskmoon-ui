// Generated from: assets/africa/namibia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/namibia.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/namibia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaNamibia50m {
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

/// Widget for rendering the africa/namibia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Namibia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Namibia50mWidget extends StatelessWidget {
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

  /// Creates a Namibia50mWidget.
  const Namibia50mWidget({
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
      geoJson: africaNamibia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
