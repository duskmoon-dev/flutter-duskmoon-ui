import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_visualization/src/vendor/dv_scale/dv_scale.dart';

void main() {
  group('LinearScale', () {
    test('maps domain to range', () {
      final scale = scaleLinear(domain: [0, 100], range: [0, 1]);
      expect(scale(0), equals(0));
      expect(scale(50), equals(0.5));
      expect(scale(100), equals(1));
    });

    test('inverts range to domain', () {
      final scale = scaleLinear(domain: [0, 100], range: [0, 1]);
      expect(scale.invert(0), equals(0));
      expect(scale.invert(0.5), equals(50));
      expect(scale.invert(1), equals(100));
    });

    test('clamps values when clamp is true', () {
      final scale = scaleLinear(domain: [0, 100], range: [0, 1], clamp: true);
      expect(scale(-50), equals(0));
      expect(scale(150), equals(1));
    });

    test('generates ticks', () {
      final scale = scaleLinear(domain: [0, 100]);
      final ticks = scale.ticks(5);
      expect(ticks, isNotEmpty);
      expect(ticks.first, equals(0));
      expect(ticks.last, equals(100));
    });

    test('nice rounds domain', () {
      final scale = scaleLinear(domain: [0.123, 0.987]);
      scale.nice(5);
      expect(scale.domain.first, lessThanOrEqualTo(0.123));
      expect(scale.domain.last, greaterThanOrEqualTo(0.987));
    });
  });

  group('LogScale', () {
    test('maps domain to range', () {
      final scale = scaleLog(domain: [1, 100], range: [0, 1]);
      expect(scale(1), equals(0));
      expect(scale(10), closeTo(0.5, 0.01));
      expect(scale(100), equals(1));
    });

    test('inverts range to domain', () {
      final scale = scaleLog(domain: [1, 100], range: [0, 1]);
      expect(scale.invert(0), closeTo(1, 0.01));
      expect(scale.invert(0.5), closeTo(10, 0.01));
      expect(scale.invert(1), closeTo(100, 0.01));
    });
  });

  group('PowerScale', () {
    test('sqrt scale with exponent 0.5', () {
      final scale = scaleSqrt(domain: [0, 100], range: [0, 10]);
      expect(scale(0), equals(0));
      expect(scale(25), closeTo(5, 0.01));
      expect(scale(100), closeTo(10, 0.01));
    });

    test('square scale with exponent 2', () {
      final scale = scalePow(domain: [0, 10], range: [0, 100], exponent: 2);
      expect(scale(0), equals(0));
      expect(scale(5), closeTo(25, 0.01));
      expect(scale(10), closeTo(100, 0.01));
    });
  });

  group('BandScale', () {
    test('maps discrete values to bands', () {
      final scale = scaleBand<String>(
        domain: ['a', 'b', 'c'],
        range: [0, 300],
      );
      expect(scale('a'), equals(0));
      expect(scale('b'), equals(100));
      expect(scale('c'), equals(200));
      expect(scale.bandwidth, equals(100));
    });

    test('applies padding', () {
      final scale = scaleBand<String>(
        domain: ['a', 'b'],
        range: [0, 100],
        paddingInner: 0.5,
      );
      expect(scale.bandwidth, lessThan(50));
    });
  });

  group('PointScale', () {
    test('maps discrete values to points', () {
      final scale = scalePoint<String>(
        domain: ['a', 'b', 'c'],
        range: [0, 100],
      );
      expect(scale('a'), equals(0));
      expect(scale('b'), equals(50));
      expect(scale('c'), equals(100));
      expect(scale.bandwidth, equals(0));
    });
  });

  group('OrdinalScale', () {
    test('maps discrete values to discrete range', () {
      final scale = scaleOrdinal<String, String>(
        domain: ['a', 'b', 'c'],
        range: ['red', 'green', 'blue'],
      );
      expect(scale('a'), equals('red'));
      expect(scale('b'), equals('green'));
      expect(scale('c'), equals('blue'));
    });

    test('cycles through range for unknown values', () {
      final scale = scaleOrdinal<String, String>(
        range: ['red', 'green'],
      );
      expect(scale('a'), equals('red'));
      expect(scale('b'), equals('green'));
      expect(scale('c'), equals('red'));
    });
  });

  group('QuantizeScale', () {
    test('maps continuous to discrete', () {
      final scale = scaleQuantize<String>(
        domain: [0, 100],
        range: ['a', 'b', 'c', 'd'],
      );
      expect(scale(10), equals('a'));
      expect(scale(30), equals('b'));
      expect(scale(60), equals('c'));
      expect(scale(90), equals('d'));
    });

    test('invertExtent returns domain extent', () {
      final scale = scaleQuantize<String>(
        domain: [0, 100],
        range: ['a', 'b'],
      );
      expect(scale.invertExtent('a'), equals((0, 50)));
      expect(scale.invertExtent('b'), equals((50, 100)));
    });
  });

  group('ThresholdScale', () {
    test('maps values based on thresholds', () {
      final scale = scaleThreshold<num, String>(
        domain: [0, 50, 100],
        range: ['cold', 'cool', 'warm', 'hot'],
      );
      expect(scale(-10), equals('cold'));
      expect(scale(25), equals('cool'));
      expect(scale(75), equals('warm'));
      expect(scale(150), equals('hot'));
    });
  });

  group('TimeScale', () {
    test('maps DateTime to range', () {
      final start = DateTime(2020, 1, 1);
      final end = DateTime(2020, 12, 31);
      final scale = scaleTime(domain: [start, end], range: [0, 100]);

      expect(scale(start), equals(0));
      expect(scale(end), equals(100));
    });

    test('inverts range to DateTime', () {
      final start = DateTime(2020, 1, 1);
      final end = DateTime(2020, 12, 31);
      final scale = scaleTime(domain: [start, end], range: [0, 100]);

      expect(scale.invert(0), equals(start));
    });
  });

  group('Ticks', () {
    test('linearTicks generates ticks', () {
      final ticks = linearTicks(0, 100, 10);
      expect(ticks.first, equals(0));
      expect(ticks.last, equals(100));
      expect(ticks.length, lessThanOrEqualTo(12));
    });

    test('tickStep calculates step', () {
      expect(tickStep(0, 100, 10), equals(10));
      expect(tickStep(0, 10, 5), equals(2));
    });
  });
}
