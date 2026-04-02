import 'dart:math' as math;

import 'package:duskmoon_visualization/src/vendor/dv_vendor/dv_vendor.dart';

/// Base class for continuous scales that map a continuous domain to a range.
abstract class ContinuousScale<D extends num, R> {
  /// The input domain.
  List<D> get domain;
  set domain(List<D> value);

  /// The output range.
  List<R> get range;
  set range(List<R> value);

  /// Whether output values are clamped to the range.
  bool get clamp;
  set clamp(bool value);

  /// Maps a domain value to a range value.
  R call(D value);

  /// Maps a range value back to a domain value.
  D invert(R value);

  /// Returns nicely rounded domain values.
  ContinuousScale<D, R> nice([int count]);

  /// Returns tick values for the scale.
  List<D> ticks([int count]);

  /// Returns a tick format function.
  String Function(D) tickFormat([int count, String? specifier]);

  /// Creates a copy of this scale.
  ContinuousScale<D, R> copy();
}

/// Helper to normalize a value within a domain.
double normalize(num value, num min, num max) {
  if (min == max) return 0.5;
  return (value - min) / (max - min);
}

/// Helper to interpolate within a range.
T interpolateRange<T>(double t, T start, T end,
    Interpolator<T> Function(T, T) interpolatorFactory) {
  return interpolatorFactory(start, end)(t);
}

/// Rescales a value from one domain/range to another.
double rescale(double t, double oMin, double oMax, double nMin, double nMax) {
  return nMin + (nMax - nMin) * normalize(t, oMin, oMax);
}

/// Nice number calculation for axis ticks.
double niceNumber(double x, {bool round = false}) {
  if (x == 0) return 0;

  final sign = x < 0 ? -1 : 1;
  x = x.abs();

  final exp = (x == 0 ? 0 : (math.log(x.abs()) / math.log(10.0)).floor());
  final f = x / _pow10(exp);

  double nf;
  if (round) {
    if (f < 1.5) {
      nf = 1;
    } else if (f < 3) {
      nf = 2;
    } else if (f < 7) {
      nf = 5;
    } else {
      nf = 10;
    }
  } else {
    if (f <= 1) {
      nf = 1;
    } else if (f <= 2) {
      nf = 2;
    } else if (f <= 5) {
      nf = 5;
    } else {
      nf = 10;
    }
  }

  return sign * nf * _pow10(exp);
}

double _pow10(int exp) {
  if (exp >= 0) {
    double result = 1;
    for (int i = 0; i < exp; i++) {
      result *= 10;
    }
    return result;
  } else {
    double result = 1;
    for (int i = 0; i > exp; i--) {
      result /= 10;
    }
    return result;
  }
}
