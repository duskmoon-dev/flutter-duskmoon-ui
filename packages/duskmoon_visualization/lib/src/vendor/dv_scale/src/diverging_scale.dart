import 'dart:math' as math;

import 'package:duskmoon_visualization/src/vendor/dv_vendor/dv_vendor.dart';

/// A diverging scale maps a continuous domain with a midpoint to an interpolator.
class DivergingScale<R> {
  List<double> _domain;
  Interpolator<R> _interpolator;
  bool _clamp;

  /// Creates a diverging scale with the given parameters.
  /// Domain should have 3 values: [min, mid, max]
  DivergingScale({
    List<double>? domain,
    required Interpolator<R> interpolator,
    bool clamp = false,
  })  : _domain = domain ?? [0, 0.5, 1],
        _interpolator = interpolator,
        _clamp = clamp {
    assert(_domain.length == 3,
        'Diverging scale requires exactly 3 domain values');
  }

  /// The input domain [min, mid, max].
  List<double> get domain => List.unmodifiable(_domain);
  set domain(List<double> value) {
    assert(
        value.length == 3, 'Diverging scale requires exactly 3 domain values');
    _domain = List.from(value);
  }

  /// The interpolator function.
  Interpolator<R> get interpolator => _interpolator;
  set interpolator(Interpolator<R> value) => _interpolator = value;

  /// Whether to clamp output values.
  bool get clamp => _clamp;
  set clamp(bool value) => _clamp = value;

  /// Maps a domain value to a range value.
  R call(double value) {
    final d0 = _domain[0];
    final d1 = _domain[1]; // midpoint
    final d2 = _domain[2];

    double t;
    if (value < d1) {
      t = 0.5 * (value - d0) / (d1 - d0);
    } else {
      t = 0.5 + 0.5 * (value - d1) / (d2 - d1);
    }

    if (_clamp) {
      t = t.clamp(0.0, 1.0);
    }

    return _interpolator(t);
  }

  /// Creates a copy of this scale.
  DivergingScale<R> copy() {
    return DivergingScale<R>(
      domain: List.from(_domain),
      interpolator: _interpolator,
      clamp: _clamp,
    );
  }
}

/// Creates a diverging scale.
DivergingScale<R> scaleDiverging<R>({
  List<double>? domain,
  required Interpolator<R> interpolator,
  bool clamp = false,
}) {
  return DivergingScale<R>(
    domain: domain,
    interpolator: interpolator,
    clamp: clamp,
  );
}

/// Diverging scale with log transform.
class DivergingLogScale<R> {
  List<double> _domain;
  Interpolator<R> _interpolator;
  bool _clamp;
  double _base;

  DivergingLogScale({
    List<double>? domain,
    required Interpolator<R> interpolator,
    bool clamp = false,
    double base = 10,
  })  : _domain = domain ?? [0.1, 1, 10],
        _interpolator = interpolator,
        _clamp = clamp,
        _base = base {
    assert(_domain.length == 3,
        'Diverging scale requires exactly 3 domain values');
  }

  List<double> get domain => List.unmodifiable(_domain);
  set domain(List<double> value) {
    assert(
        value.length == 3, 'Diverging scale requires exactly 3 domain values');
    _domain = List.from(value);
  }

  Interpolator<R> get interpolator => _interpolator;
  set interpolator(Interpolator<R> value) => _interpolator = value;

  bool get clamp => _clamp;
  set clamp(bool value) => _clamp = value;

  double get base => _base;
  set base(double value) => _base = value;

  double _log(double x) => math.log(x.abs()) / math.log(_base);

  R call(double value) {
    final ld0 = _log(_domain[0]);
    final ld1 = _log(_domain[1]);
    final ld2 = _log(_domain[2]);
    final lv = _log(value.abs());

    double t;
    if (lv < ld1) {
      t = 0.5 * (lv - ld0) / (ld1 - ld0);
    } else {
      t = 0.5 + 0.5 * (lv - ld1) / (ld2 - ld1);
    }

    if (_clamp) {
      t = t.clamp(0.0, 1.0);
    }

    return _interpolator(t);
  }

  DivergingLogScale<R> copy() {
    return DivergingLogScale<R>(
      domain: List.from(_domain),
      interpolator: _interpolator,
      clamp: _clamp,
      base: _base,
    );
  }
}

/// Diverging scale with power transform.
class DivergingPowScale<R> {
  List<double> _domain;
  Interpolator<R> _interpolator;
  bool _clamp;
  double _exponent;

  DivergingPowScale({
    List<double>? domain,
    required Interpolator<R> interpolator,
    bool clamp = false,
    double exponent = 1,
  })  : _domain = domain ?? [-1, 0, 1],
        _interpolator = interpolator,
        _clamp = clamp,
        _exponent = exponent {
    assert(_domain.length == 3,
        'Diverging scale requires exactly 3 domain values');
  }

  List<double> get domain => List.unmodifiable(_domain);
  set domain(List<double> value) {
    assert(
        value.length == 3, 'Diverging scale requires exactly 3 domain values');
    _domain = List.from(value);
  }

  Interpolator<R> get interpolator => _interpolator;
  set interpolator(Interpolator<R> value) => _interpolator = value;

  bool get clamp => _clamp;
  set clamp(bool value) => _clamp = value;

  double get exponent => _exponent;
  set exponent(double value) => _exponent = value;

  double _pow(double x) {
    return x < 0
        ? -math.pow(-x, _exponent).toDouble()
        : math.pow(x, _exponent).toDouble();
  }

  R call(double value) {
    final pd0 = _pow(_domain[0]);
    final pd1 = _pow(_domain[1]);
    final pd2 = _pow(_domain[2]);
    final pv = _pow(value);

    double t;
    if (pv < pd1) {
      t = 0.5 * (pv - pd0) / (pd1 - pd0);
    } else {
      t = 0.5 + 0.5 * (pv - pd1) / (pd2 - pd1);
    }

    if (_clamp) {
      t = t.clamp(0.0, 1.0);
    }

    return _interpolator(t);
  }

  DivergingPowScale<R> copy() {
    return DivergingPowScale<R>(
      domain: List.from(_domain),
      interpolator: _interpolator,
      clamp: _clamp,
      exponent: _exponent,
    );
  }
}
