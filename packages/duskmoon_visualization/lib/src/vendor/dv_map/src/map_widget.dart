import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo/dv_geo.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';

/// Base widget for rendering map data.
///
/// This widget wraps [GeoView] from dv_geo and provides a convenient
/// interface for rendering map data with projections.
///
/// Example:
/// ```dart
/// import 'package:dv_map/maps/world/110m.dart';
///
/// MapWidget(
///   geoJson: world110m,
///   projection: Equirectangular(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
/// )
/// ```
class MapWidget extends StatelessWidget {
  /// The GeoJSON data to render.
  final GeoJsonFeatureCollection geoJson;

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

  /// Creates a MapWidget.
  const MapWidget({
    super.key,
    required this.geoJson,
    required this.projection,
    this.fillColor,
    this.strokeColor,
    this.strokeWidth = 1.0,
    this.onFeatureTap,
    this.antiAlias = true,
  });

  @override
  Widget build(BuildContext context) {
    return GeoView(
      projection: projection,
      geoJson: geoJson,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap != null
          ? (feature, position) {
              if (feature is GeoJsonFeature) {
                onFeatureTap!(feature, position);
              }
            }
          : null,
      antiAlias: antiAlias,
    );
  }
}
