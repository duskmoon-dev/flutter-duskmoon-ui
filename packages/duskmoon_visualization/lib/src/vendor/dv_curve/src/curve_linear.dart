import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';

import 'curve.dart';

/// A linear curve that connects points with straight lines.
class CurveLinear implements Curve {
  @override
  List<Point> generate(List<Point> points) {
    return List.from(points);
  }

  @override
  bool get isClosed => false;
}

/// Creates a linear curve.
Curve curveLinear() => CurveLinear();

/// A closed linear curve.
class CurveLinearClosed implements Curve {
  @override
  List<Point> generate(List<Point> points) {
    if (points.isEmpty) return [];
    return [...points, points.first];
  }

  @override
  bool get isClosed => true;
}

/// Creates a closed linear curve.
Curve curveLinearClosed() => CurveLinearClosed();
