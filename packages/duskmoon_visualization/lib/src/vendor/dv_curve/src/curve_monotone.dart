import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';

import 'curve.dart';

/// A monotone cubic interpolation curve for the X direction.
/// Preserves monotonicity in data to avoid spurious oscillations.
class CurveMonotoneX implements Curve {
  @override
  List<Point> generate(List<Point> points) {
    if (points.length < 2) return List.from(points);
    if (points.length == 2) return List.from(points);

    final n = points.length;
    final result = <Point>[];
    const segments = 10;

    // Calculate slopes
    final tangents = _calculateTangents(points);

    result.add(points.first);

    for (int i = 0; i < n - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final m1 = tangents[i];
      final m2 = tangents[i + 1];
      final dx = p2.x - p1.x;

      for (int j = 1; j <= segments; j++) {
        final t = j / segments;
        final point = _hermitePoint(p1, p2, m1 * dx, m2 * dx, t);
        result.add(point);
      }
    }

    return result;
  }

  List<double> _calculateTangents(List<Point> points) {
    final n = points.length;
    final tangents = List<double>.filled(n, 0);

    // Calculate secants
    final secants = <double>[];
    for (int i = 0; i < n - 1; i++) {
      final dx = points[i + 1].x - points[i].x;
      final dy = points[i + 1].y - points[i].y;
      secants.add(dx == 0 ? 0 : dy / dx);
    }

    // Calculate tangents using monotone method
    tangents[0] = secants[0];
    for (int i = 1; i < n - 1; i++) {
      final s0 = secants[i - 1];
      final s1 = secants[i];

      // If signs differ or either is zero, tangent is zero
      if (s0 * s1 <= 0) {
        tangents[i] = 0;
      } else {
        // Use harmonic mean
        tangents[i] = 3 *
            (s0 + s1) /
            ((s0 + 2 * s1).sign / s0.abs() + (2 * s0 + s1).sign / s1.abs() + 4);
      }
    }
    tangents[n - 1] = secants[n - 2];

    // Ensure monotonicity
    for (int i = 0; i < n - 1; i++) {
      final s = secants[i];
      if (s == 0) {
        tangents[i] = 0;
        tangents[i + 1] = 0;
      } else {
        final a = tangents[i] / s;
        final b = tangents[i + 1] / s;
        final mag = a * a + b * b;
        if (mag > 9) {
          final scale = 3 / (mag.sqrt());
          tangents[i] = s * a * scale;
          tangents[i + 1] = s * b * scale;
        }
      }
    }

    return tangents;
  }

  Point _hermitePoint(Point p1, Point p2, double m1, double m2, double t) {
    final t2 = t * t;
    final t3 = t2 * t;

    final h00 = 2 * t3 - 3 * t2 + 1;
    final h10 = t3 - 2 * t2 + t;
    final h01 = -2 * t3 + 3 * t2;
    final h11 = t3 - t2;

    return Point(
      h00 * p1.x + h10 * (p2.x - p1.x) + h01 * p2.x,
      h00 * p1.y + h10 * m1 + h01 * p2.y + h11 * m2,
    );
  }

  @override
  bool get isClosed => false;
}

/// Creates a monotone X curve.
Curve curveMonotoneX() => CurveMonotoneX();

/// A monotone cubic interpolation curve for the Y direction.
class CurveMonotoneY implements Curve {
  @override
  List<Point> generate(List<Point> points) {
    if (points.length < 2) return List.from(points);
    if (points.length == 2) return List.from(points);

    // Swap x and y, apply monotone X, then swap back
    final swapped = points.map((p) => Point(p.y, p.x)).toList();
    final monotoneX = CurveMonotoneX();
    final result = monotoneX.generate(swapped);
    return result.map((p) => Point(p.y, p.x)).toList();
  }

  @override
  bool get isClosed => false;
}

/// Creates a monotone Y curve.
Curve curveMonotoneY() => CurveMonotoneY();

extension on double {
  double sqrt() => this < 0 ? 0 : this.sqrt();
}
