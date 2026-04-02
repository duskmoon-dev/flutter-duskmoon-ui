import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_curve/dv_curve.dart';

void main() {
  final testPoints = [
    Point(0, 0),
    Point(10, 50),
    Point(20, 30),
    Point(30, 70),
    Point(40, 20),
  ];

  group('CurveLinear', () {
    test('returns same points', () {
      final curve = curveLinear();
      final result = curve.generate(testPoints);
      expect(result.length, equals(testPoints.length));
      expect(result.first, equals(testPoints.first));
      expect(result.last, equals(testPoints.last));
    });

    test('handles empty input', () {
      final curve = curveLinear();
      expect(curve.generate([]), isEmpty);
    });

    test('handles single point', () {
      final curve = curveLinear();
      final result = curve.generate([Point(5, 5)]);
      expect(result.length, equals(1));
    });
  });

  group('CurveStep', () {
    test('creates step pattern', () {
      final curve = curveStep();
      final result = curve.generate(testPoints);
      expect(result.length, greaterThan(testPoints.length));
      expect(result.first, equals(testPoints.first));
      expect(result.last, equals(testPoints.last));
    });

    test('stepAfter goes horizontal first', () {
      final curve = curveStepAfter();
      final result = curve.generate([Point(0, 0), Point(10, 10)]);
      expect(result[1].y, equals(0)); // Horizontal at original y
    });

    test('stepBefore goes vertical first', () {
      final curve = curveStepBefore();
      final result = curve.generate([Point(0, 0), Point(10, 10)]);
      expect(result[1].x, equals(0)); // Vertical at original x
    });
  });

  group('CurveBasis', () {
    test('generates smooth curve', () {
      final curve = curveBasis();
      final result = curve.generate(testPoints);
      expect(result.length, greaterThan(testPoints.length));
    });

    test('closed basis wraps around', () {
      final curve = curveBasisClosed();
      final result = curve.generate(testPoints);
      expect(curve.isClosed, isTrue);
      expect(result.last, equals(result.first));
    });
  });

  group('CurveCardinal', () {
    test('generates curve with default tension', () {
      final curve = curveCardinal();
      final result = curve.generate(testPoints);
      expect(result.length, greaterThan(testPoints.length));
      expect(result.first, equals(testPoints.first));
    });

    test('tension affects curve shape', () {
      final curve0 = curveCardinal(tension: 0);
      final curve1 = curveCardinal(tension: 1);
      final result0 = curve0.generate(testPoints);
      final result1 = curve1.generate(testPoints);
      // Different tensions should produce different results
      expect(result0[5], isNot(equals(result1[5])));
    });
  });

  group('CurveCatmullRom', () {
    test('generates smooth curve', () {
      final curve = curveCatmullRom();
      final result = curve.generate(testPoints);
      expect(result.length, greaterThan(testPoints.length));
    });

    test('alpha parameter affects curve', () {
      final uniform = curveCatmullRom(alpha: 0);
      final centripetal = curveCatmullRom(alpha: 0.5);
      final chordal = curveCatmullRom(alpha: 1);

      final r1 = uniform.generate(testPoints);
      final r2 = centripetal.generate(testPoints);
      final r3 = chordal.generate(testPoints);

      // Different alphas should produce different results
      expect(r1[5], isNot(equals(r2[5])));
      expect(r2[5], isNot(equals(r3[5])));
    });
  });

  group('CurveMonotone', () {
    test('monotoneX generates curve', () {
      final curve = curveMonotoneX();
      final result = curve.generate(testPoints);
      expect(result.length, greaterThan(testPoints.length));
    });

    test('monotoneY generates curve', () {
      final curve = curveMonotoneY();
      final result = curve.generate(testPoints);
      expect(result.length, greaterThan(testPoints.length));
    });
  });

  group('CurveNatural', () {
    test('generates natural spline', () {
      final curve = curveNatural();
      final result = curve.generate(testPoints);
      expect(result.length, greaterThan(testPoints.length));
      expect(result.first, equals(testPoints.first));
    });

    test('passes through all control points', () {
      final curve = curveNatural();
      final result = curve.generate(testPoints);

      // First and last points should match
      expect(result.first.x, closeTo(testPoints.first.x, 0.01));
      expect(result.first.y, closeTo(testPoints.first.y, 0.01));
      expect(result.last.x, closeTo(testPoints.last.x, 0.01));
      expect(result.last.y, closeTo(testPoints.last.y, 0.01));
    });
  });
}
