// Generated from: assets/oceania/vanuatu.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for oceania/vanuatu.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for oceania/vanuatu.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get oceaniaVanuatu50m {
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

/// Widget for rendering the oceania/vanuatu.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Vanuatu50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Vanuatu50mWidget extends StatelessWidget {
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

  /// Creates a Vanuatu50mWidget.
  const Vanuatu50mWidget({
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
      geoJson: oceaniaVanuatu50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
