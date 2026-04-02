// Generated from: assets/africa/united-republic-of-tanzania.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/united-republic-of-tanzania.50m.json (base64 encoded)
const String _kCompressedData =
    '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';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/united-republic-of-tanzania.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaUnitedRepublicOfTanzania50m {
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

/// Widget for rendering the africa/united-republic-of-tanzania.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// UnitedRepublicOfTanzania50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class UnitedRepublicOfTanzania50mWidget extends StatelessWidget {
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

  /// Creates a UnitedRepublicOfTanzania50mWidget.
  const UnitedRepublicOfTanzania50mWidget({
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
      geoJson: africaUnitedRepublicOfTanzania50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
