import 'dart:math' as math;

import 'package:duskmoon_visualization/src/vendor/dv_vendor/dv_vendor.dart';

import 'continuous_scale.dart';
import 'ticks.dart';

/// A power scale applies an exponential transform to the domain.
class PowerScale implements ContinuousScale<double, double> {
  List<double> _domain;
  List<double> _range;
  bool _clamp;
  double _exponent;

  /// Creates a power scale with the given parameters.
  PowerScale({
    List<double>? domain,
    List<double>? range,
    bool clamp = false,
    double exponent = 1,
  })  : _domain = domain ?? [0, 1],
        _range = range ?? [0, 1],
        _clamp = clamp,
        _exponent = exponent;

  /// The exponent of the power transform.
  double get exponent => _exponent;
  set exponent(double value) => _exponent = value;

  @override
  List<double> get domain => List.unmodifiable(_domain);

  @override
  set domain(List<double> value) {
    assert(value.length >= 2, 'Domain must have at least 2 values');
    _domain = List.from(value);
  }

  @override
  List<double> get range => List.unmodifiable(_range);

  @override
  set range(List<double> value) {
    assert(value.length >= 2, 'Range must have at least 2 values');
    _range = List.from(value);
  }

  @override
  bool get clamp => _clamp;

  @override
  set clamp(bool value) => _clamp = value;

  double _transformPow(double x) {
    return x < 0
        ? -math.pow(-x, _exponent).toDouble()
        : math.pow(x, _exponent).toDouble();
  }

  double _transformPowInverse(double x) {
    return x < 0
        ? -math.pow(-x, 1 / _exponent).toDouble()
        : math.pow(x, 1 / _exponent).toDouble();
  }

  @override
  double call(double value) {
    final d0 = _domain[0];
    final d1 = _domain[1];
    final r0 = _range[0];
    final r1 = _range[1];

    final td0 = _transformPow(d0);
    final td1 = _transformPow(d1);
    final tv = _transformPow(value);

    double t = normalize(tv, td0, td1);

    if (_clamp) {
      t = t.clamp(0.0, 1.0);
    }

    return interpolateNumber(r0, r1)(t).toDouble();
  }

  @override
  double invert(double value) {
    final d0 = _domain[0];
    final d1 = _domain[1];
    final r0 = _range[0];
    final r1 = _range[1];

    double t = normalize(value, r0, r1);

    if (_clamp) {
      t = t.clamp(0.0, 1.0);
    }

    final td0 = _transformPow(d0);
    final td1 = _transformPow(d1);
    final tv = interpolateNumber(td0, td1)(t);

    return _transformPowInverse(tv.toDouble());
  }

  @override
  PowerScale nice([int count = 10]) {
    final d = _domain;
    final start = d.first;
    final stop = d.last;

    final step = tickStep(start, stop, count);
    if (step > 0) {
      _domain[0] = (start / step).floor() * step;
      _domain[_domain.length - 1] = (stop / step).ceil() * step;
    }

    return this;
  }

  @override
  List<double> ticks([int count = 10]) {
    return linearTicks(_domain.first, _domain.last, count);
  }

  @override
  String Function(double) tickFormat([int count = 10, String? specifier]) {
    return linearTickFormat(_domain.first, _domain.last, count, specifier);
  }

  @override
  PowerScale copy() {
    return PowerScale(
      domain: List.from(_domain),
      range: List.from(_range),
      clamp: _clamp,
      exponent: _exponent,
    );
  }
}

/// Creates a square root scale (power scale with exponent 0.5).
PowerScale scaleSqrt({
  List<double>? domain,
  List<double>? range,
  bool clamp = false,
}) {
  return PowerScale(
    domain: domain,
    range: range,
    clamp: clamp,
    exponent: 0.5,
  );
}

/// Creates a power scale.
PowerScale scalePow({
  List<double>? domain,
  List<double>? range,
  bool clamp = false,
  double exponent = 1,
}) {
  return PowerScale(
    domain: domain,
    range: range,
    clamp: clamp,
    exponent: exponent,
  );
}
