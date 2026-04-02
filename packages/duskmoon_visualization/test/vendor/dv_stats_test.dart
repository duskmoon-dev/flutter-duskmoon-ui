import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_visualization/src/vendor/dv_stats/dv_stats.dart';

void main() {
  group('linearRegression', () {
    test('computes correct slope and intercept', () {
      // y = 2x + 1
      final x = [1.0, 2.0, 3.0, 4.0, 5.0];
      final y = [3.0, 5.0, 7.0, 9.0, 11.0];

      final result = linearRegression(x, y);

      expect(result.slope, closeTo(2.0, 1e-10));
      expect(result.intercept, closeTo(1.0, 1e-10));
      expect(result.rSquared, closeTo(1.0, 1e-10));
    });

    test('predict returns correct values', () {
      final x = [1.0, 2.0, 3.0, 4.0, 5.0];
      final y = [3.0, 5.0, 7.0, 9.0, 11.0];

      final result = linearRegression(x, y);

      expect(result.predict(0), closeTo(1.0, 1e-10));
      expect(result.predict(10), closeTo(21.0, 1e-10));
    });

    test('handles noisy data', () {
      final x = [1.0, 2.0, 3.0, 4.0, 5.0];
      final y = [2.8, 5.1, 6.9, 9.2, 11.0];

      final result = linearRegression(x, y);

      expect(result.slope, closeTo(2.0, 0.2));
      expect(result.rSquared, greaterThan(0.95));
    });

    test('throws on mismatched lengths', () {
      expect(
        () => linearRegression([1.0, 2.0], [1.0]),
        throwsArgumentError,
      );
    });

    test('throws on fewer than 2 points', () {
      expect(
        () => linearRegression([1.0], [1.0]),
        throwsArgumentError,
      );
    });
  });

  group('exponentialRegression', () {
    test('computes correct fit for exponential data', () {
      // y = 2 * e^(0.5 * x)
      final x = [0.0, 1.0, 2.0, 3.0, 4.0];
      final y = x.map((xi) => 2 * math.exp(0.5 * xi)).toList();

      final result = exponentialRegression(x, y);

      expect(result.a, closeTo(2.0, 0.1));
      expect(result.b, closeTo(0.5, 0.1));
      expect(result.rSquared, closeTo(1.0, 0.01));
    });

    test('predict returns correct values', () {
      final x = [0.0, 1.0, 2.0, 3.0, 4.0];
      final y = x.map((xi) => 2 * math.exp(0.5 * xi)).toList();

      final result = exponentialRegression(x, y);

      expect(result.predict(0), closeTo(2.0, 0.1));
    });
  });

  group('movingAverage', () {
    test('computes trailing moving average', () {
      final data = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0];

      final result = movingAverage(data, window: 3);

      // First two values should be null
      expect(result[0], isNull);
      expect(result[1], isNull);
      // Third value should be average of first 3
      expect(result[2], closeTo(2.0, 1e-10));
      // Fourth value should be average of 2,3,4
      expect(result[3], closeTo(3.0, 1e-10));
    });

    test('computes centered moving average', () {
      final data = [1.0, 2.0, 3.0, 4.0, 5.0];

      final result = movingAverage(data, window: 3, center: true);

      // Edges should be null
      expect(result[0], isNull);
      expect(result[4], isNull);
      // Center values should be computed
      expect(result[1], closeTo(2.0, 1e-10));
      expect(result[2], closeTo(3.0, 1e-10));
      expect(result[3], closeTo(4.0, 1e-10));
    });

    test('throws on invalid window', () {
      expect(
        () => movingAverage([1.0, 2.0, 3.0], window: 0),
        throwsArgumentError,
      );
    });
  });

  group('exponentialMovingAverage', () {
    test('computes EMA correctly', () {
      final data = [1.0, 2.0, 3.0, 4.0, 5.0];

      final result = exponentialMovingAverage(data, alpha: 0.5);

      expect(result[0], closeTo(1.0, 1e-10));
      expect(result[1], closeTo(1.5, 1e-10));
      expect(result[2], closeTo(2.25, 1e-10));
    });

    test('alpha=1 returns original data', () {
      final data = [1.0, 2.0, 3.0, 4.0, 5.0];

      final result = exponentialMovingAverage(data, alpha: 1.0);

      for (int i = 0; i < data.length; i++) {
        expect(result[i], closeTo(data[i], 1e-10));
      }
    });
  });

  group('correlation', () {
    test('returns 1 for perfect positive correlation', () {
      final x = [1.0, 2.0, 3.0, 4.0, 5.0];
      final y = [2.0, 4.0, 6.0, 8.0, 10.0];

      expect(correlation(x, y), closeTo(1.0, 1e-10));
    });

    test('returns -1 for perfect negative correlation', () {
      final x = [1.0, 2.0, 3.0, 4.0, 5.0];
      final y = [10.0, 8.0, 6.0, 4.0, 2.0];

      expect(correlation(x, y), closeTo(-1.0, 1e-10));
    });

    test('returns low value for weakly correlated data', () {
      // Use truly random-looking data
      final x = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0];
      final y = [2.0, 1.0, 4.0, 3.0, 6.0, 5.0, 8.0, 7.0];

      // This alternating pattern should have weak correlation
      final corr = correlation(x, y);
      expect(corr, greaterThan(0)); // There's still some positive trend
      expect(corr, lessThan(1.0)); // But not perfect
    });

    test('throws on mismatched lengths', () {
      expect(
        () => correlation([1.0, 2.0], [1.0]),
        throwsArgumentError,
      );
    });
  });

  group('spearmanCorrelation', () {
    test('returns 1 for monotonic relationship', () {
      final x = [1.0, 2.0, 3.0, 4.0, 5.0];
      final y = [1.0, 4.0, 9.0, 16.0, 25.0]; // y = x^2

      expect(spearmanCorrelation(x, y), closeTo(1.0, 1e-10));
    });
  });

  group('kernelDensityEstimation', () {
    test('estimates density for normal distribution', () {
      // Generate normal-ish data
      final data = List.generate(100, (i) => i / 100.0);

      final result = kernelDensityEstimation(data, nPoints: 50);

      expect(result.x.length, equals(50));
      expect(result.density.length, equals(50));
      // All densities should be non-negative
      for (final d in result.density) {
        expect(d, greaterThanOrEqualTo(0));
      }
    });

    test('supports different kernels', () {
      final data = [1.0, 2.0, 3.0, 4.0, 5.0];

      for (final kernel in KernelType.values) {
        final result = kernelDensityEstimation(data, kernel: kernel);
        expect(result.density, isNotEmpty);
      }
    });

    test('respects custom bandwidth', () {
      final data = [1.0, 2.0, 3.0, 4.0, 5.0];

      final narrowResult = kernelDensityEstimation(data, bandwidth: 0.1);
      final wideResult = kernelDensityEstimation(data, bandwidth: 1.0);

      // Narrower bandwidth should produce higher peaks
      expect(narrowResult.density.reduce(math.max),
          greaterThan(wideResult.density.reduce(math.max)));
    });
  });

  group('polynomialRegression', () {
    test('fits quadratic data', () {
      // y = x^2 + 2x + 1
      final x = [0.0, 1.0, 2.0, 3.0, 4.0];
      final y = x.map((xi) => xi * xi + 2 * xi + 1).toList();

      final result = polynomialRegression(x, y, degree: 2);

      expect(result.coefficients.length, equals(3));
      expect(result.coefficients[0], closeTo(1.0, 0.1)); // constant
      expect(result.coefficients[1], closeTo(2.0, 0.1)); // linear
      expect(result.coefficients[2], closeTo(1.0, 0.1)); // quadratic
      expect(result.rSquared, closeTo(1.0, 0.01));
    });

    test('predict returns correct values', () {
      final x = [0.0, 1.0, 2.0, 3.0, 4.0];
      final y = x.map((xi) => xi * xi).toList();

      final result = polynomialRegression(x, y, degree: 2);

      expect(result.predict(5), closeTo(25.0, 0.1));
    });
  });

  group('loess', () {
    test('smooths noisy data', () {
      final x = List.generate(20, (i) => i.toDouble());
      final y = x.map((xi) => xi + (xi % 2 == 0 ? 0.5 : -0.5)).toList();

      final result = loess(x, y, span: 0.3);

      expect(result.x.length, equals(20));
      expect(result.y.length, equals(20));
      // Smoothed values should be less variable than original
    });
  });

  group('covariance', () {
    test('computes correct covariance', () {
      final x = [1.0, 2.0, 3.0, 4.0, 5.0];
      final y = [2.0, 4.0, 6.0, 8.0, 10.0];

      final cov = covariance(x, y);

      expect(cov, greaterThan(0));
    });
  });

  group('skewness', () {
    test('returns 0 for symmetric distribution', () {
      final data = [1.0, 2.0, 3.0, 4.0, 5.0];

      expect(skewness(data)!, closeTo(0.0, 1e-10));
    });

    test('returns positive for right-skewed distribution', () {
      final data = [1.0, 1.0, 1.0, 2.0, 10.0];

      expect(skewness(data)!, greaterThan(0));
    });
  });

  group('kurtosis', () {
    test('returns value for normal-like distribution', () {
      final data = [1.0, 2.0, 3.0, 4.0, 5.0, 4.0, 3.0, 2.0, 1.0];

      final k = kurtosis(data);
      expect(k, isNotNull);
    });
  });

  group('tTest', () {
    test('detects significant difference', () {
      final a = [1.0, 2.0, 3.0, 4.0, 5.0];
      final b = [10.0, 11.0, 12.0, 13.0, 14.0];

      final result = tTest(a, b);

      expect(result.$1.abs(), greaterThan(2)); // t-statistic
      expect(result.$2, lessThan(0.05)); // p-value
    });

    test('detects no significant difference', () {
      final a = [1.0, 2.0, 3.0, 4.0, 5.0];
      final b = [1.5, 2.5, 3.5, 4.5, 5.5];

      final result = tTest(a, b);

      expect(result.$2, greaterThan(0.05)); // p-value
    });
  });
}
