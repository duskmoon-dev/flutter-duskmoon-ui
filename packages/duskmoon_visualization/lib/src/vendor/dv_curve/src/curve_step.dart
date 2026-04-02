import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';

import 'curve.dart';

/// A step curve that creates horizontal then vertical steps.
class CurveStep implements Curve {
  @override
  List<Point> generate(List<Point> points) {
    if (points.isEmpty) return [];
    if (points.length == 1) return [points.first];

    final result = <Point>[];
    result.add(points.first);

    for (int i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];
      final midX = (prev.x + curr.x) / 2;

      result.add(Point(midX, prev.y));
      result.add(Point(midX, curr.y));
      result.add(curr);
    }

    return result;
  }

  @override
  bool get isClosed => false;
}

/// Creates a step curve.
Curve curveStep() => CurveStep();

/// A step curve that goes horizontal first, then vertical.
class CurveStepAfter implements Curve {
  @override
  List<Point> generate(List<Point> points) {
    if (points.isEmpty) return [];
    if (points.length == 1) return [points.first];

    final result = <Point>[];
    result.add(points.first);

    for (int i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];

      result.add(Point(curr.x, prev.y));
      result.add(curr);
    }

    return result;
  }

  @override
  bool get isClosed => false;
}

/// Creates a step-after curve.
Curve curveStepAfter() => CurveStepAfter();

/// A step curve that goes vertical first, then horizontal.
class CurveStepBefore implements Curve {
  @override
  List<Point> generate(List<Point> points) {
    if (points.isEmpty) return [];
    if (points.length == 1) return [points.first];

    final result = <Point>[];
    result.add(points.first);

    for (int i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];

      result.add(Point(prev.x, curr.y));
      result.add(curr);
    }

    return result;
  }

  @override
  bool get isClosed => false;
}

/// Creates a step-before curve.
Curve curveStepBefore() => CurveStepBefore();
