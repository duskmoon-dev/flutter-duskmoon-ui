// Generated from: assets/asia/israel.110m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for asia/israel.110m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE52VTWsbMRCG7/4VYs9GzIfmK7dSKBR6KO2xhGLSTTA4XmNvDyb4vxdvYpNkVYq6B6HVKz280mhGT4uUuvG467ub1H3qV+Pvff9x2Gz6u3E9bLvlWb5/Hj50N+nHIqWUnqZ2vnCaPgm7/bDr9+N6WnSZnlK3XT1OCz4f9qt+c52fUrc+DD9XNGlfZuM8jX//9lq4G7bjettvx7P24bBedS/a6erioR8e+3F/fOvhYvrrsDk+vOzxyhz2v9bb1fhqs8/f6/77v5RYsmEEOi3fK5QNAoPKG+F2+U8egIXXcKiAbI04Z+XQqPBcHYm5lUeIADbjcSazQiqNPBGy0CpPC1nxRl5RMAiu8MADWoOBpCBUcwcBAc08CC9iUnUHwtEWjZJDpKBhLbpkbNrmr2QTEq/ywChIW/0Vd4QKD7OCCHtbdEsWUTacxwOzFPfGXCuZVApzqeAIgxXif3ilZu/ME2s9vjPvr+4aWU5MhWeJQZFNERxaQxFECqQVngAyKbUmLkGg13aLAKDSWgg4TLRSqDAXD/DW4wuyAj7PXMwsXFhar14YCOjs+M6ZgWrmrXWUSDywxrPznURs9le0VI/PVcWp9d1A52CY12XKwiQIre+aFFGVGo+DI1pvX+Mrvqj1L73T4tLeLk6LP/QKtEFpCQAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for asia/israel.110m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get asiaIsrael110m {
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

/// Widget for rendering the asia/israel.110m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Israel110mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Israel110mWidget extends StatelessWidget {
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

  /// Creates a Israel110mWidget.
  const Israel110mWidget({
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
      geoJson: asiaIsrael110m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
