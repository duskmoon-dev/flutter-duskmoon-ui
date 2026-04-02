import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_visualization/src/vendor/dv_vendor/dv_vendor.dart' as dv;

void main() {
  group('Array functions', () {
    test('min returns minimum value', () {
      expect(dv.min(<num>[3, 1, 4, 1, 5, 9]), equals(1));
      expect(dv.min(<num>[]), isNull);
    });

    test('max returns maximum value', () {
      expect(dv.max(<num>[3, 1, 4, 1, 5, 9]), equals(9));
      expect(dv.max(<num>[]), isNull);
    });

    test('extent returns min and max', () {
      final result = dv.extent(<num>[3, 1, 4, 1, 5, 9]);
      expect(result, equals((1, 9)));
      expect(dv.extent(<num>[]), isNull);
    });

    test('sum calculates total', () {
      expect(dv.sum([1, 2, 3, 4, 5]), equals(15));
      expect(dv.sum(<int>[]), equals(0));
    });

    test('mean calculates average', () {
      expect(dv.mean([1, 2, 3, 4, 5]), equals(3.0));
      expect(dv.mean(<int>[]), isNull);
    });

    test('median calculates middle value', () {
      expect(dv.median([1, 2, 3, 4, 5]), equals(3.0));
      expect(dv.median([1, 2, 3, 4]), equals(2.5));
    });

    test('quantile calculates percentiles', () {
      expect(dv.quantile([1, 2, 3, 4, 5], 0), equals(1.0));
      expect(dv.quantile([1, 2, 3, 4, 5], 1), equals(5.0));
      expect(dv.quantile([1, 2, 3, 4, 5], 0.5), equals(3.0));
    });

    test('variance calculates variance', () {
      expect(dv.variance([2, 4, 4, 4, 5, 5, 7, 9]), equals(4.0));
    });

    test('deviation calculates standard deviation', () {
      expect(dv.deviation([2, 4, 4, 4, 5, 5, 7, 9]), equals(2.0));
    });

    test('range generates sequence', () {
      expect(dv.range(5), equals([0, 1, 2, 3, 4]));
      expect(dv.range(1, 5), equals([1, 2, 3, 4]));
      expect(dv.range(0, 10, 2), equals([0, 2, 4, 6, 8]));
    });

    test('group groups by key', () {
      final data = [
        {'type': 'a', 'value': 1},
        {'type': 'b', 'value': 2},
        {'type': 'a', 'value': 3},
      ];
      final grouped = dv.group(data, (d) => d['type']);
      expect(grouped['a']?.length, equals(2));
      expect(grouped['b']?.length, equals(1));
    });

    test('histogram creates bins', () {
      final data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      final bins = dv.histogram(
        data: data,
        value: (x) => x,
        thresholds: 5,
      );
      expect(bins.length, equals(5));
      expect(bins.fold(0, (sum, bin) => sum + bin.length), equals(10));
    });

    test('distinct returns unique values', () {
      expect(dv.distinct([1, 2, 2, 3, 3, 3]), equals([1, 2, 3]));
    });
  });

  group('Bisect functions', () {
    test('bisectLeft finds left insertion point', () {
      expect(dv.bisectLeft(<num>[1, 2, 3, 4, 5], 3), equals(2));
      expect(dv.bisectLeft(<num>[1, 2, 3, 4, 5], 3.5), equals(3));
      expect(dv.bisectLeft(<num>[1, 2, 3, 4, 5], 0), equals(0));
      expect(dv.bisectLeft(<num>[1, 2, 3, 4, 5], 6), equals(5));
    });

    test('bisectRight finds right insertion point', () {
      expect(dv.bisectRight(<num>[1, 2, 3, 4, 5], 3), equals(3));
      expect(dv.bisectRight(<num>[1, 2, 3, 4, 5], 3.5), equals(3));
    });

    test('Bisector works with accessor', () {
      final data = [
        {'value': 1},
        {'value': 2},
        {'value': 3},
      ];
      final bisector = dv.Bisector<Map<String, int>, num>((d) => d['value']!);
      expect(bisector.left(data, 2), equals(1));
      expect(bisector.right(data, 2), equals(2));
    });
  });

  group('Interpolate functions', () {
    test('interpolateNumber interpolates numbers', () {
      final interp = dv.interpolateNumber(0, 100);
      expect(interp(0), equals(0));
      expect(interp(0.5), equals(50));
      expect(interp(1), equals(100));
    });

    test('interpolateRgb interpolates colors', () {
      final interp = dv.interpolateRgb(
        const dv.ArgbColor(255, 255, 0, 0),
        const dv.ArgbColor(255, 0, 0, 255),
      );
      final mid = interp(0.5);
      expect(mid.red, equals(128));
      expect(mid.blue, equals(128));
    });

    test('interpolateNumberArray interpolates arrays', () {
      final interp = dv.interpolateNumberArray([0, 0], [100, 200]);
      final result = interp(0.5);
      expect(result[0], equals(50));
      expect(result[1], equals(100));
    });

    test('interpolateDate interpolates dates', () {
      final start = DateTime(2020, 1, 1);
      final end = DateTime(2020, 12, 31);
      final interp = dv.interpolateDate(start, end);
      final mid = interp(0.5);
      expect(mid.isAfter(start), isTrue);
      expect(mid.isBefore(end), isTrue);
    });

    test('quantize samples interpolator', () {
      final interp = dv.interpolateNumber(0, 100);
      final samples = dv.quantize(interp, 5);
      expect(samples, equals([0, 25, 50, 75, 100]));
    });
  });
}
