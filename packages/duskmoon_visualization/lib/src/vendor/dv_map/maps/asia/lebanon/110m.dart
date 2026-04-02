// Generated from: assets/asia/lebanon.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/lebanon.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE5WTTWvDMAyG7/kVJudiZFn+UG/bYKcxdh9lZJ1XAm1cUu9QSv/7aNqMtjED52AUPdaDXkIOlRB12m9DPRf1c2jSTx+e4nodlqmNXT074e9ze1fPxXslhBCH4ZwODtcHsO3jNvSpHYbG60LUXbMZBl7CZ9Nd/BfU7uJHgwN8nPT1uf96DZaxS20XunRiD7u2qS/s+LfGKsRNSP3+dolx67e43q9ul1jG2H+1XZOu0p6f6/r+TQhtpEelANzsnmiJzhFacwMWs/99VoK1ZIEyPo/ECqnQZ5VyBtTERxJBOe9toY/IKybM+Axr1gaLfEYyewI0GZ8lYlUW10h2bBh1TqcAjNeFPvKIYHOfl8GQAVXoU2jBYM4HDAxQmpcsOOBpXi3Bc7HNGHScTYuW0JEv9BX+HFWuHqtjNZ6L6lj9AuUD9l/BBAAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/lebanon.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaLebanon110m {
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

/// Widget for rendering the asia/lebanon.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Lebanon110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Lebanon110mWidget extends StatelessWidget {
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

  /// Creates a Lebanon110mWidget.
  const Lebanon110mWidget({
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
      geoJson: asiaLebanon110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
