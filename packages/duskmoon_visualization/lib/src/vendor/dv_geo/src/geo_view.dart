import 'package:flutter/widgets.dart';

import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';

import 'geo_shape.dart';

/// A widget that displays geographic data using a projection.
///
/// [GeoView] wraps a [CustomPaint] widget and renders geographic features
/// using the provided [projection] and [geoJson] data.
class GeoView extends StatelessWidget {
  /// The projection to use for rendering.
  final Projection projection;

  /// The GeoJSON data to render.
  final dynamic geoJson;

  /// The color to use for filling shapes.
  final Color? fillColor;

  /// The color to use for stroking shapes.
  final Color? strokeColor;

  /// The stroke width for shape outlines.
  final double strokeWidth;

  /// Optional callback when a feature is tapped.
  final void Function(dynamic feature, Point position)? onFeatureTap;

  /// Whether to enable anti-aliasing.
  final bool antiAlias;

  /// Creates a GeoView widget.
  const GeoView({
    super.key,
    required this.projection,
    required this.geoJson,
    this.fillColor,
    this.strokeColor,
    this.strokeWidth = 1.0,
    this.onFeatureTap,
    this.antiAlias = true,
  });

  @override
  Widget build(BuildContext context) {
    final painter = GeoShape(
      projection: projection,
      geoJson: geoJson,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      antiAlias: antiAlias,
    );

    if (onFeatureTap != null) {
      return GestureDetector(
        onTapDown: (details) {
          _handleTap(details.localPosition);
        },
        child: CustomPaint(
          painter: painter,
          size: Size.infinite,
        ),
      );
    }

    return CustomPaint(
      painter: painter,
      size: Size.infinite,
    );
  }

  void _handleTap(Offset position) {
    if (onFeatureTap == null) return;

    final point = Point(position.dx, position.dy);
    final geoPath = GeoPath(projection);

    if (geoJson is GeoJsonFeatureCollection) {
      for (final feature in (geoJson as GeoJsonFeatureCollection).features) {
        if (_isPointInFeature(geoPath, feature, point)) {
          onFeatureTap!(feature, point);
          return;
        }
      }
    } else if (geoJson is GeoJsonFeature) {
      if (_isPointInFeature(geoPath, geoJson, point)) {
        onFeatureTap!(geoJson, point);
      }
    }
  }

  bool _isPointInFeature(GeoPath geoPath, dynamic feature, Point point) {
    final bounds = geoPath.bounds(feature);
    if (bounds == null) return false;

    final (minPoint, maxPoint) = bounds;
    return point.x >= minPoint.x &&
        point.x <= maxPoint.x &&
        point.y >= minPoint.y &&
        point.y <= maxPoint.y;
  }
}

/// Creates a GeoView widget with the given parameters.
GeoView geoView({
  required Projection projection,
  required dynamic geoJson,
  Color? fillColor,
  Color? strokeColor,
  double strokeWidth = 1.0,
  void Function(dynamic feature, Point position)? onFeatureTap,
  bool antiAlias = true,
}) {
  return GeoView(
    projection: projection,
    geoJson: geoJson,
    fillColor: fillColor,
    strokeColor: strokeColor,
    strokeWidth: strokeWidth,
    onFeatureTap: onFeatureTap,
    antiAlias: antiAlias,
  );
}
