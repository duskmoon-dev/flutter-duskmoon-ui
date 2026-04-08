import 'package:flutter/material.dart';

import '../dm_chart_palette.dart';
import '../vendor/dv_geo_core/dv_geo_core.dart';
import '../vendor/dv_map/dv_map.dart';
import '../vendor/dv_point/dv_point.dart';

/// A curated DuskMoon wrapper for geographic map visualization.
///
/// Renders [GeoJsonFeatureCollection] data using a configurable [Projection].
/// Theme-aware via [DmChartPalette] — automatically derives fill and stroke
/// colors from the current theme when not explicitly provided.
///
/// ```dart
/// DmVizMapChart(
///   geoJson: myFeatureCollection,
///   projection: MercatorProjection()
///     ..center = (0, 20)
///     ..scale = 120,
///   onFeatureTap: (feature) {
///     print(feature.properties['name']);
///   },
/// )
/// ```
class DmVizMapChart extends StatelessWidget {
  /// The GeoJSON feature collection to render.
  final GeoJsonFeatureCollection geoJson;

  /// The geographic projection used to map coordinates to screen space.
  final Projection projection;

  /// Fill color for rendered features. Defaults to a translucent primary color.
  final Color? fillColor;

  /// Stroke color for feature outlines. Defaults to the palette's primary.
  final Color? strokeColor;

  /// Width of feature outlines in logical pixels.
  final double strokeWidth;

  /// Whether to enable anti-aliasing for rendered shapes.
  final bool antiAlias;

  /// Called when a geographic feature is tapped.
  final void Function(GeoJsonFeature feature, Point position)? onFeatureTap;

  /// Optional chart palette. When null, derived from the ambient [ThemeData].
  final DmChartPalette? palette;

  const DmVizMapChart({
    super.key,
    required this.geoJson,
    required this.projection,
    this.fillColor,
    this.strokeColor,
    this.strokeWidth = 1.0,
    this.antiAlias = true,
    this.onFeatureTap,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedPalette =
        palette ?? DmChartPalette.fromTheme(Theme.of(context));
    final resolvedFillColor =
        fillColor ?? resolvedPalette.primary.withValues(alpha: 0.15);
    final resolvedStrokeColor = strokeColor ?? resolvedPalette.primary;

    return MapWidget(
      geoJson: geoJson,
      projection: projection,
      fillColor: resolvedFillColor,
      strokeColor: resolvedStrokeColor,
      strokeWidth: strokeWidth,
      antiAlias: antiAlias,
      onFeatureTap: onFeatureTap,
    );
  }
}
