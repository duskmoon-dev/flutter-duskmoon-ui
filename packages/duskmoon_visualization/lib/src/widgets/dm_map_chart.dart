import 'package:flutter/material.dart';

import '../dm_chart_palette.dart';
import '../dm_viz_interaction.dart';
import '../dm_viz_series.dart';
import 'dm_viz_scene_plot.dart';
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

  final bool _mercator;
  final DmVizOptions options;
  final DmVizInteraction interaction;
  final Offset? center;
  final double padding;
  final double height;

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
  })  : _mercator = false,
        options = const DmVizOptions(),
        interaction = const DmVizInteraction(),
        center = null,
        padding = 16,
        height = 300;

  /// Fits an offline GeoJSON collection using the shared Mercator projection.
  DmVizMapChart.mercator({
    super.key,
    required this.geoJson,
    this.center,
    this.padding = 16,
    this.height = 300,
    this.options = const DmVizOptions(),
    this.interaction = const DmVizInteraction(),
    this.palette,
  })  : _mercator = true,
        projection = MercatorProjection(),
        fillColor = null,
        strokeColor = null,
        strokeWidth = 1.0,
        antiAlias = true,
        onFeatureTap = null;

  @override
  Widget build(BuildContext context) {
    if (_mercator) {
      return DmVizScenePlot(
        map: geoJson,
        center: center,
        padding: padding,
        options: options,
        palette: palette,
        interaction: interaction,
        height: height,
      );
    }
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
