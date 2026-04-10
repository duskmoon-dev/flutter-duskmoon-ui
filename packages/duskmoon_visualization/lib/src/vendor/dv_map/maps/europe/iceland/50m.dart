// Generated from: assets/europe/iceland.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/iceland.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/iceland.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeIceland50m {
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

/// Widget for rendering the europe/iceland.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Iceland50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Iceland50mWidget extends StatelessWidget {
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

  /// Creates a Iceland50mWidget.
  const Iceland50mWidget({
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
      geoJson: europeIceland50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
