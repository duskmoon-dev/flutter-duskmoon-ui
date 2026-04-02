import 'package:flutter/widgets.dart';

import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';

/// A CustomPainter that renders geographic shapes from GeoJSON data.
///
/// [GeoShape] uses a [Projection] to transform geographic coordinates
/// into screen coordinates and renders them as paths.
class GeoShape extends CustomPainter {
  /// The projection to use for coordinate transformation.
  final Projection projection;

  /// The GeoJSON data to render.
  final dynamic geoJson;

  /// The color to use for filling shapes.
  final Color? fillColor;

  /// The color to use for stroking shapes.
  final Color? strokeColor;

  /// The stroke width for shape outlines.
  final double strokeWidth;

  /// Whether to enable anti-aliasing.
  final bool antiAlias;

  /// The GeoPath generator.
  late final GeoPath _geoPath;

  /// Creates a GeoShape painter.
  GeoShape({
    required this.projection,
    required this.geoJson,
    this.fillColor,
    this.strokeColor,
    this.strokeWidth = 1.0,
    this.antiAlias = true,
  }) {
    _geoPath = GeoPath(projection);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paths = _geoPath.generate(geoJson);

    for (final pathPoints in paths) {
      if (pathPoints.isEmpty) continue;

      final path = _createPath(pathPoints);

      if (fillColor != null) {
        final fillPaint = Paint()
          ..color = fillColor!
          ..style = PaintingStyle.fill
          ..isAntiAlias = antiAlias;
        canvas.drawPath(path, fillPaint);
      }

      if (strokeColor != null) {
        final strokePaint = Paint()
          ..color = strokeColor!
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..isAntiAlias = antiAlias;
        canvas.drawPath(path, strokePaint);
      }
    }
  }

  Path _createPath(List<Point> points) {
    final path = Path();

    if (points.isEmpty) return path;

    path.moveTo(points.first.x, points.first.y);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].x, points[i].y);
    }

    // Close the path if it's a polygon (first and last points are the same)
    if (points.length > 2 &&
        points.first.x == points.last.x &&
        points.first.y == points.last.y) {
      path.close();
    }

    return path;
  }

  @override
  bool shouldRepaint(GeoShape oldDelegate) {
    return oldDelegate.projection != projection ||
        oldDelegate.geoJson != geoJson ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.strokeColor != strokeColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.antiAlias != antiAlias;
  }
}

/// Creates a GeoShape painter with the given parameters.
GeoShape geoShape({
  required Projection projection,
  required dynamic geoJson,
  Color? fillColor,
  Color? strokeColor,
  double strokeWidth = 1.0,
  bool antiAlias = true,
}) {
  return GeoShape(
    projection: projection,
    geoJson: geoJson,
    fillColor: fillColor,
    strokeColor: strokeColor,
    strokeWidth: strokeWidth,
    antiAlias: antiAlias,
  );
}
