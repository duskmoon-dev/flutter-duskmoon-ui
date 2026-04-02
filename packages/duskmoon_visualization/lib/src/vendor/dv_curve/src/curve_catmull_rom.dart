import 'dart:math' as math;

import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';

import 'curve.dart';

/// A Catmull-Rom spline curve with configurable alpha.
class CurveCatmullRom implements Curve {
  /// The alpha parameter (0 = uniform, 0.5 = centripetal, 1 = chordal).
  final double alpha;

  CurveCatmullRom({this.alpha = 0.5});

  @override
  List<Point> generate(List<Point> points) {
    if (points.length < 2) return List.from(points);
    if (points.length == 2) return List.from(points);

    final result = <Point>[];
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
        final point = _catmullRomPoint(p0, p1, p2, p3, t);
        result.add(point);
      }
    }

    return result;
  }

  Point _catmullRomPoint(Point p0, Point p1, Point p2, Point p3, double t) {
    // Calculate knot intervals
    final t0 = 0.0;
    final t1 = t0 + _knotInterval(p0, p1);
    final t2 = t1 + _knotInterval(p1, p2);
    final t3 = t2 + _knotInterval(p2, p3);

    // Remap t to the interval [t1, t2]
    final tt = t1 + t * (t2 - t1);

    // Compute point using Barry and Goldman's pyramid algorithm
    final a1 = _lerp(p0, p1, t0, t1, tt);
    final a2 = _lerp(p1, p2, t1, t2, tt);
    final a3 = _lerp(p2, p3, t2, t3, tt);

    final b1 = _lerp(a1, a2, t0, t2, tt);
    final b2 = _lerp(a2, a3, t1, t3, tt);

    return _lerp(b1, b2, t1, t2, tt);
  }

  double _knotInterval(Point p1, Point p2) {
    final dx = p2.x - p1.x;
    final dy = p2.y - p1.y;
    return math.pow(dx * dx + dy * dy, alpha / 2).toDouble();
  }

  Point _lerp(Point p1, Point p2, double t1, double t2, double t) {
    if (t1 == t2) return p1;
    final ratio = (t - t1) / (t2 - t1);
    return Point(
      p1.x + ratio * (p2.x - p1.x),
      p1.y + ratio * (p2.y - p1.y),
    );
  }

  @override
  bool get isClosed => false;
}

/// Creates a Catmull-Rom curve with the given alpha.
Curve curveCatmullRom({double alpha = 0.5}) => CurveCatmullRom(alpha: alpha);

/// A closed Catmull-Rom spline curve.
class CurveCatmullRomClosed implements Curve {
  final double alpha;

  CurveCatmullRomClosed({this.alpha = 0.5});

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
        final point = _catmullRomPoint(p0, p1, p2, p3, t);
        result.add(point);
      }
    }

    if (result.isNotEmpty) {
      result.add(result.first);
    }

    return result;
  }

  Point _catmullRomPoint(Point p0, Point p1, Point p2, Point p3, double t) {
    final t0 = 0.0;
    final t1 = t0 + _knotInterval(p0, p1);
    final t2 = t1 + _knotInterval(p1, p2);
    final t3 = t2 + _knotInterval(p2, p3);

    final tt = t1 + t * (t2 - t1);

    final a1 = _lerp(p0, p1, t0, t1, tt);
    final a2 = _lerp(p1, p2, t1, t2, tt);
    final a3 = _lerp(p2, p3, t2, t3, tt);

    final b1 = _lerp(a1, a2, t0, t2, tt);
    final b2 = _lerp(a2, a3, t1, t3, tt);

    return _lerp(b1, b2, t1, t2, tt);
  }

  double _knotInterval(Point p1, Point p2) {
    final dx = p2.x - p1.x;
    final dy = p2.y - p1.y;
    return math.pow(dx * dx + dy * dy, alpha / 2).toDouble();
  }

  Point _lerp(Point p1, Point p2, double t1, double t2, double t) {
    if (t1 == t2) return p1;
    final ratio = (t - t1) / (t2 - t1);
    return Point(
      p1.x + ratio * (p2.x - p1.x),
      p1.y + ratio * (p2.y - p1.y),
    );
  }

  @override
  bool get isClosed => true;
}

/// Creates a closed Catmull-Rom curve.
Curve curveCatmullRomClosed({double alpha = 0.5}) =>
    CurveCatmullRomClosed(alpha: alpha);

/// An open Catmull-Rom spline curve.
class CurveCatmullRomOpen implements Curve {
  final double alpha;

  CurveCatmullRomOpen({this.alpha = 0.5});

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
        final point = _catmullRomPoint(p0, p1, p2, p3, t);
        result.add(point);
      }
    }

    return result;
  }

  Point _catmullRomPoint(Point p0, Point p1, Point p2, Point p3, double t) {
    final t0 = 0.0;
    final t1 = t0 + _knotInterval(p0, p1);
    final t2 = t1 + _knotInterval(p1, p2);
    final t3 = t2 + _knotInterval(p2, p3);

    final tt = t1 + t * (t2 - t1);

    final a1 = _lerp(p0, p1, t0, t1, tt);
    final a2 = _lerp(p1, p2, t1, t2, tt);
    final a3 = _lerp(p2, p3, t2, t3, tt);

    final b1 = _lerp(a1, a2, t0, t2, tt);
    final b2 = _lerp(a2, a3, t1, t3, tt);

    return _lerp(b1, b2, t1, t2, tt);
  }

  double _knotInterval(Point p1, Point p2) {
    final dx = p2.x - p1.x;
    final dy = p2.y - p1.y;
    return math.pow(dx * dx + dy * dy, alpha / 2).toDouble();
  }

  Point _lerp(Point p1, Point p2, double t1, double t2, double t) {
    if (t1 == t2) return p1;
    final ratio = (t - t1) / (t2 - t1);
    return Point(
      p1.x + ratio * (p2.x - p1.x),
      p1.y + ratio * (p2.y - p1.y),
    );
  }

  @override
  bool get isClosed => false;
}

/// Creates an open Catmull-Rom curve.
Curve curveCatmullRomOpen({double alpha = 0.5}) =>
    CurveCatmullRomOpen(alpha: alpha);
