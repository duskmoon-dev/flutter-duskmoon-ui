import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';

/// A curve generator interface.
abstract class Curve {
  /// Generates curve points from the given data points.
  List<Point> generate(List<Point> points);

  /// Returns true if this curve is closed.
  bool get isClosed => false;
}

/// Context for building paths from curve data.
class CurveContext {
  final List<Point> _points = [];
  Point? _currentPoint;

  /// Moves to the given point.
  void moveTo(double x, double y) {
    _currentPoint = Point(x, y);
    _points.add(_currentPoint!);
  }

  /// Draws a line to the given point.
  void lineTo(double x, double y) {
    _currentPoint = Point(x, y);
    _points.add(_currentPoint!);
  }

  /// Draws a cubic bezier curve to the given point.
  void bezierCurveTo(
    double cp1x,
    double cp1y,
    double cp2x,
    double cp2y,
    double x,
    double y,
  ) {
    // Approximate bezier curve with line segments
    final p0 = _currentPoint ?? Point.zero;
    final p1 = Point(cp1x, cp1y);
    final p2 = Point(cp2x, cp2y);
    final p3 = Point(x, y);

    const segments = 10;
    for (int i = 1; i <= segments; i++) {
      final t = i / segments;
      final point = _cubicBezier(p0, p1, p2, p3, t);
      _points.add(point);
    }

    _currentPoint = p3;
  }

  /// Draws a quadratic bezier curve to the given point.
  void quadraticCurveTo(double cpx, double cpy, double x, double y) {
    final p0 = _currentPoint ?? Point.zero;
    final p1 = Point(cpx, cpy);
    final p2 = Point(x, y);

    const segments = 10;
    for (int i = 1; i <= segments; i++) {
      final t = i / segments;
      final point = _quadraticBezier(p0, p1, p2, t);
      _points.add(point);
    }

    _currentPoint = p2;
  }

  /// Closes the path.
  void closePath() {
    if (_points.isNotEmpty) {
      _points.add(_points.first);
    }
  }

  /// Returns the generated points.
  List<Point> get points => List.unmodifiable(_points);

  Point _cubicBezier(Point p0, Point p1, Point p2, Point p3, double t) {
    final t2 = t * t;
    final t3 = t2 * t;
    final mt = 1 - t;
    final mt2 = mt * mt;
    final mt3 = mt2 * mt;

    return Point(
      mt3 * p0.x + 3 * mt2 * t * p1.x + 3 * mt * t2 * p2.x + t3 * p3.x,
      mt3 * p0.y + 3 * mt2 * t * p1.y + 3 * mt * t2 * p2.y + t3 * p3.y,
    );
  }

  Point _quadraticBezier(Point p0, Point p1, Point p2, double t) {
    final mt = 1 - t;
    final mt2 = mt * mt;
    final t2 = t * t;

    return Point(
      mt2 * p0.x + 2 * mt * t * p1.x + t2 * p2.x,
      mt2 * p0.y + 2 * mt * t * p1.y + t2 * p2.y,
    );
  }
}

/// Type of curve generator factory.
typedef CurveFactory = Curve Function();
