import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';

import 'curve.dart';

/// A natural cubic spline curve that passes through all data points
/// with continuous first and second derivatives.
class CurveNatural implements Curve {
  @override
  List<Point> generate(List<Point> points) {
    if (points.length < 2) return List.from(points);
    if (points.length == 2) return List.from(points);

    final n = points.length;
    final result = <Point>[];
    const segments = 10;

    // Calculate spline coefficients
    final px = _naturalSpline(points.map((p) => p.x).toList());
    final py = _naturalSpline(points.map((p) => p.y).toList());

    result.add(points.first);

    for (int i = 0; i < n - 1; i++) {
      for (int j = 1; j <= segments; j++) {
        final t = j / segments;
        final x = _evaluateSpline(px, i, t);
        final y = _evaluateSpline(py, i, t);
        result.add(Point(x, y));
      }
    }

    return result;
  }

  /// Calculates natural cubic spline coefficients.
  List<List<double>> _naturalSpline(List<double> values) {
    final n = values.length;
    final a = List<double>.from(values);
    final b = List<double>.filled(n, 0);
    final c = List<double>.filled(n, 0);
    final d = List<double>.filled(n, 0);

    // Tridiagonal system
    final h = List<double>.filled(n - 1, 1); // Uniform spacing
    final alpha = List<double>.filled(n, 0);

    for (int i = 1; i < n - 1; i++) {
      alpha[i] =
          3 / h[i] * (a[i + 1] - a[i]) - 3 / h[i - 1] * (a[i] - a[i - 1]);
    }

    final l = List<double>.filled(n, 1);
    final mu = List<double>.filled(n, 0);
    final z = List<double>.filled(n, 0);

    for (int i = 1; i < n - 1; i++) {
      l[i] = 2 * (h[i - 1] + h[i]) - h[i - 1] * mu[i - 1];
      mu[i] = h[i] / l[i];
      z[i] = (alpha[i] - h[i - 1] * z[i - 1]) / l[i];
    }

    for (int j = n - 2; j >= 0; j--) {
      c[j] = z[j] - mu[j] * c[j + 1];
      b[j] = (a[j + 1] - a[j]) / h[j] - h[j] * (c[j + 1] + 2 * c[j]) / 3;
      d[j] = (c[j + 1] - c[j]) / (3 * h[j]);
    }

    return [a, b, c, d];
  }

  double _evaluateSpline(List<List<double>> coeffs, int i, double t) {
    final a = coeffs[0][i];
    final b = coeffs[1][i];
    final c = coeffs[2][i];
    final d = coeffs[3][i];

    final t2 = t * t;
    final t3 = t2 * t;

    return a + b * t + c * t2 + d * t3;
  }

  @override
  bool get isClosed => false;
}

/// Creates a natural cubic spline curve.
Curve curveNatural() => CurveNatural();
