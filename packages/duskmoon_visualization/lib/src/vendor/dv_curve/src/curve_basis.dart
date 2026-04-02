import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';

import 'curve.dart';

/// A basis spline curve.
class CurveBasis implements Curve {
  @override
  List<Point> generate(List<Point> points) {
    if (points.length < 2) return List.from(points);

    final result = <Point>[];

    // Add first point
    result.add(points.first);

    if (points.length == 2) {
      result.add(points.last);
      return result;
    }

    // Generate basis spline points
    const segments = 10;

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = i > 0 ? points[i - 1] : points[0];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 =
          i < points.length - 2 ? points[i + 2] : points[points.length - 1];

      for (int j = 1; j <= segments; j++) {
        final t = j / segments;
        final point = _basisPoint(p0, p1, p2, p3, t);
        result.add(point);
      }
    }

    return result;
  }

  Point _basisPoint(Point p0, Point p1, Point p2, Point p3, double t) {
    final t2 = t * t;
    final t3 = t2 * t;

    final x = ((1 - 3 * t + 3 * t2 - t3) * p0.x +
            (4 - 6 * t2 + 3 * t3) * p1.x +
            (1 + 3 * t + 3 * t2 - 3 * t3) * p2.x +
            t3 * p3.x) /
        6;

    final y = ((1 - 3 * t + 3 * t2 - t3) * p0.y +
            (4 - 6 * t2 + 3 * t3) * p1.y +
            (1 + 3 * t + 3 * t2 - 3 * t3) * p2.y +
            t3 * p3.y) /
        6;

    return Point(x, y);
  }

  @override
  bool get isClosed => false;
}

/// Creates a basis curve.
Curve curveBasis() => CurveBasis();

/// A closed basis spline curve.
class CurveBasisClosed implements Curve {
  @override
  List<Point> generate(List<Point> points) {
    if (points.length < 3) return List.from(points);

    final result = <Point>[];
    const segments = 10;
    final n = points.length;

    for (int i = 0; i < n; i++) {
      final p0 = points[(i - 1 + n) % n];
      final p1 = points[i];
      final p2 = points[(i + 1) % n];
      final p3 = points[(i + 2) % n];

      for (int j = 0; j < segments; j++) {
        final t = j / segments;
        final point = _basisPoint(p0, p1, p2, p3, t);
        result.add(point);
      }
    }

    // Close the curve
    if (result.isNotEmpty) {
      result.add(result.first);
    }

    return result;
  }

  Point _basisPoint(Point p0, Point p1, Point p2, Point p3, double t) {
    final t2 = t * t;
    final t3 = t2 * t;

    final x = ((1 - 3 * t + 3 * t2 - t3) * p0.x +
            (4 - 6 * t2 + 3 * t3) * p1.x +
            (1 + 3 * t + 3 * t2 - 3 * t3) * p2.x +
            t3 * p3.x) /
        6;

    final y = ((1 - 3 * t + 3 * t2 - t3) * p0.y +
            (4 - 6 * t2 + 3 * t3) * p1.y +
            (1 + 3 * t + 3 * t2 - 3 * t3) * p2.y +
            t3 * p3.y) /
        6;

    return Point(x, y);
  }

  @override
  bool get isClosed => true;
}

/// Creates a closed basis curve.
Curve curveBasisClosed() => CurveBasisClosed();

/// A basis spline curve that passes through endpoints.
class CurveBasisOpen implements Curve {
  @override
  List<Point> generate(List<Point> points) {
    if (points.length < 4) return [];

    final result = <Point>[];
    const segments = 10;

    for (int i = 1; i < points.length - 2; i++) {
      final p0 = points[i - 1];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = points[i + 2];

      for (int j = 0; j <= segments; j++) {
        final t = j / segments;
        final point = _basisPoint(p0, p1, p2, p3, t);
        result.add(point);
      }
    }

    return result;
  }

  Point _basisPoint(Point p0, Point p1, Point p2, Point p3, double t) {
    final t2 = t * t;
    final t3 = t2 * t;

    final x = ((1 - 3 * t + 3 * t2 - t3) * p0.x +
            (4 - 6 * t2 + 3 * t3) * p1.x +
            (1 + 3 * t + 3 * t2 - 3 * t3) * p2.x +
            t3 * p3.x) /
        6;

    final y = ((1 - 3 * t + 3 * t2 - t3) * p0.y +
            (4 - 6 * t2 + 3 * t3) * p1.y +
            (1 + 3 * t + 3 * t2 - 3 * t3) * p2.y +
            t3 * p3.y) /
        6;

    return Point(x, y);
  }

  @override
  bool get isClosed => false;
}

/// Creates an open basis curve.
Curve curveBasisOpen() => CurveBasisOpen();
