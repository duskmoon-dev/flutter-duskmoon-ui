// Generated from: assets/europe/estonia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/estonia.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/estonia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeEstonia50m {
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

/// Widget for rendering the europe/estonia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Estonia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Estonia50mWidget extends StatelessWidget {
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

  /// Creates a Estonia50mWidget.
  const Estonia50mWidget({
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
      geoJson: europeEstonia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
