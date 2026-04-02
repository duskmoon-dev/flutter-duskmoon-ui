import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';

import 'curve.dart';

/// A cardinal spline curve with adjustable tension.
class CurveCardinal implements Curve {
  /// The tension parameter (0 to 1). 0 = Catmull-Rom, 1 = linear.
  final double tension;

  CurveCardinal({this.tension = 0});

  @override
  List<Point> generate(List<Point> points) {
    if (points.length < 2) return List.from(points);
    if (points.length == 2) return List.from(points);

    final result = <Point>[];
    final k = (1 - tension) / 6;
    const segments = 10;

    result.add(points.first);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = i > 0 ? points[i - 1] : points[0];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 =
          i < points.length - 2 ? points[i + 2] : points[points.length - 1];

      for (int j = 1; j <= segments; j++) {
        final t = j / segments;
        final point = _cardinalPoint(p0, p1, p2, p3, t, k);
        result.add(point);
      }
    }

    return result;
  }

  Point _cardinalPoint(
    Point p0,
    Point p1,
    Point p2,
    Point p3,
    double t,
    double k,
  ) {
    final t2 = t * t;
    final t3 = t2 * t;

    // Cardinal spline basis matrix
    final h1 = 2 * t3 - 3 * t2 + 1;
    final h2 = -2 * t3 + 3 * t2;
    final h3 = t3 - 2 * t2 + t;
    final h4 = t3 - t2;

    // Tangents
    final m1x = k * (p2.x - p0.x);
    final m1y = k * (p2.y - p0.y);
    final m2x = k * (p3.x - p1.x);
    final m2y = k * (p3.y - p1.y);

    return Point(
      h1 * p1.x + h2 * p2.x + h3 * m1x + h4 * m2x,
      h1 * p1.y + h2 * p2.y + h3 * m1y + h4 * m2y,
    );
  }

  @override
  bool get isClosed => false;
}

/// Creates a cardinal curve with the given tension.
Curve curveCardinal({double tension = 0}) => CurveCardinal(tension: tension);

/// A closed cardinal spline curve.
class CurveCardinalClosed implements Curve {
  final double tension;

  CurveCardinalClosed({this.tension = 0});

  @override
  List<Point> generate(List<Point> points) {
    if (points.length < 3) return List.from(points);

    final result = <Point>[];
    final k = (1 - tension) / 6;
    const segments = 10;
    final n = points.length;

    for (int i = 0; i < n; i++) {
      final p0 = points[(i - 1 + n) % n];
      final p1 = points[i];
      final p2 = points[(i + 1) % n];
      final p3 = points[(i + 2) % n];

      for (int j = 0; j < segments; j++) {
        final t = j / segments;
        final point = _cardinalPoint(p0, p1, p2, p3, t, k);
        result.add(point);
      }
    }

    if (result.isNotEmpty) {
      result.add(result.first);
    }

    return result;
  }

  Point _cardinalPoint(
    Point p0,
    Point p1,
    Point p2,
    Point p3,
    double t,
    double k,
  ) {
    final t2 = t * t;
    final t3 = t2 * t;

    final h1 = 2 * t3 - 3 * t2 + 1;
    final h2 = -2 * t3 + 3 * t2;
    final h3 = t3 - 2 * t2 + t;
    final h4 = t3 - t2;

    final m1x = k * (p2.x - p0.x);
    final m1y = k * (p2.y - p0.y);
    final m2x = k * (p3.x - p1.x);
    final m2y = k * (p3.y - p1.y);

    return Point(
      h1 * p1.x + h2 * p2.x + h3 * m1x + h4 * m2x,
      h1 * p1.y + h2 * p2.y + h3 * m1y + h4 * m2y,
    );
  }

  @override
  bool get isClosed => true;
}

/// Creates a closed cardinal curve.
Curve curveCardinalClosed({double tension = 0}) =>
    CurveCardinalClosed(tension: tension);

/// An open cardinal spline curve.
class CurveCardinalOpen implements Curve {
  final double tension;

  CurveCardinalOpen({this.tension = 0});

  @override
  List<Point> generate(List<Point> points) {
    if (points.length < 4) return [];

    final result = <Point>[];
    final k = (1 - tension) / 6;
    const segments = 10;

    for (int i = 1; i < points.length - 2; i++) {
      final p0 = points[i - 1];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = points[i + 2];

      for (int j = 0; j <= segments; j++) {
        final t = j / segments;
        final point = _cardinalPoint(p0, p1, p2, p3, t, k);
        result.add(point);
      }
    }

    return result;
  }

  Point _cardinalPoint(
    Point p0,
    Point p1,
    Point p2,
    Point p3,
    double t,
    double k,
  ) {
    final t2 = t * t;
    final t3 = t2 * t;

    final h1 = 2 * t3 - 3 * t2 + 1;
    final h2 = -2 * t3 + 3 * t2;
    final h3 = t3 - 2 * t2 + t;
    final h4 = t3 - t2;

    final m1x = k * (p2.x - p0.x);
    final m1y = k * (p2.y - p0.y);
    final m2x = k * (p3.x - p1.x);
    final m2y = k * (p3.y - p1.y);

    return Point(
      h1 * p1.x + h2 * p2.x + h3 * m1x + h4 * m2x,
      h1 * p1.y + h2 * p2.y + h3 * m1y + h4 * m2y,
    );
  }

  @override
  bool get isClosed => false;
}

/// Creates an open cardinal curve.
Curve curveCardinalOpen({double tension = 0}) =>
    CurveCardinalOpen(tension: tension);
