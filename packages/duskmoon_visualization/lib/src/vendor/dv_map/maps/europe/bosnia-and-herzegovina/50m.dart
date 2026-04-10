// Generated from: assets/europe/bosnia-and-herzegovina.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/bosnia-and-herzegovina.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/bosnia-and-herzegovina.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeBosniaAndHerzegovina50m {
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

/// Widget for rendering the europe/bosnia-and-herzegovina.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// BosniaAndHerzegovina50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class BosniaAndHerzegovina50mWidget extends StatelessWidget {
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

  /// Creates a BosniaAndHerzegovina50mWidget.
  const BosniaAndHerzegovina50mWidget({
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
      geoJson: europeBosniaAndHerzegovina50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
