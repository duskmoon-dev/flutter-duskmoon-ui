// Generated from: assets/asia/turkmenistan.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/turkmenistan.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/turkmenistan.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaTurkmenistan50m {
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

/// Widget for rendering the asia/turkmenistan.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Turkmenistan50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Turkmenistan50mWidget extends StatelessWidget {
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

  /// Creates a Turkmenistan50mWidget.
  const Turkmenistan50mWidget({
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
      geoJson: asiaTurkmenistan50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
