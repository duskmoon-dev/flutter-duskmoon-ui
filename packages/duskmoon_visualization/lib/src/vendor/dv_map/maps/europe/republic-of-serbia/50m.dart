// Generated from: assets/europe/republic-of-serbia.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/republic-of-serbia.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/republic-of-serbia.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeRepublicOfSerbia50m {
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

/// Widget for rendering the europe/republic-of-serbia.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// RepublicOfSerbia50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class RepublicOfSerbia50mWidget extends StatelessWidget {
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

  /// Creates a RepublicOfSerbia50mWidget.
  const RepublicOfSerbia50mWidget({
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
      geoJson: europeRepublicOfSerbia50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
