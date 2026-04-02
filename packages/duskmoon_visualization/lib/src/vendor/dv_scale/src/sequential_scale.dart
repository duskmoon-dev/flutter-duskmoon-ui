import 'package:duskmoon_visualization/src/vendor/dv_vendor/dv_vendor.dart';

/// A sequential scale maps a continuous domain to a color scheme using an interpolator.
class SequentialScale<R> {
  List<double> _domain;
  Interpolator<R> _interpolator;
  bool _clamp;

  /// Creates a sequential scale with the given parameters.
  SequentialScale({
    List<double>? domain,
    required Interpolator<R> interpolator,
    bool clamp = false,
  })  : _domain = domain ?? [0, 1],
        _interpolator = interpolator,
        _clamp = clamp;

  /// The input domain.
  List<double> get domain => List.unmodifiable(_domain);
  set domain(List<double> value) {
    assert(value.length >= 2, 'Domain must have at least 2 values');
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
    final d1 = _domain[1];

    double t = (value - d0) / (d1 - d0);

    if (_clamp) {
      t = t.clamp(0.0, 1.0);
    }

    return _interpolator(t);
  }

  /// Creates a copy of this scale.
  SequentialScale<R> copy() {
    return SequentialScale<R>(
      domain: List.from(_domain),
      interpolator: _interpolator,
      clamp: _clamp,
    );
  }
}

/// Creates a sequential scale.
SequentialScale<R> scaleSequential<R>({
  List<double>? domain,
  required Interpolator<R> interpolator,
  bool clamp = false,
}) {
  return SequentialScale<R>(
    domain: domain,
    interpolator: interpolator,
    clamp: clamp,
  );
}

/// Sequential scale with log transform.
class SequentialLogScale<R> {
  List<double> _domain;
  Interpolator<R> _interpolator;
  bool _clamp;
  double _base;

  SequentialLogScale({
    List<double>? domain,
    required Interpolator<R> interpolator,
    bool clamp = false,
    double base = 10,
  })  : _domain = domain ?? [1, 10],
        _interpolator = interpolator,
        _clamp = clamp,
        _base = base;

  List<double> get domain => List.unmodifiable(_domain);
  set domain(List<double> value) {
    assert(value.length >= 2, 'Domain must have at least 2 values');
    assert(value.every((v) => v > 0), 'Log scale domain must be positive');
    _domain = List.from(value);
  }

  Interpolator<R> get interpolator => _interpolator;
  set interpolator(Interpolator<R> value) => _interpolator = value;

  bool get clamp => _clamp;
  set clamp(bool value) => _clamp = value;

  double get base => _base;
  set base(double value) => _base = value;

  double _log(double x) => x <= 0 ? 0 : (x.log() / _base.log());

  R call(double value) {
    final ld0 = _log(_domain[0]);
    final ld1 = _log(_domain[1]);
    final lv = _log(value);

    double t = (lv - ld0) / (ld1 - ld0);

    if (_clamp) {
      t = t.clamp(0.0, 1.0);
    }

    return _interpolator(t);
  }

  SequentialLogScale<R> copy() {
    return SequentialLogScale<R>(
      domain: List.from(_domain),
      interpolator: _interpolator,
      clamp: _clamp,
      base: _base,
    );
  }
}

/// Sequential scale with power transform.
class SequentialPowScale<R> {
  List<double> _domain;
  Interpolator<R> _interpolator;
  bool _clamp;
  double _exponent;

  SequentialPowScale({
    List<double>? domain,
    required Interpolator<R> interpolator,
    bool clamp = false,
    double exponent = 1,
  })  : _domain = domain ?? [0, 1],
        _interpolator = interpolator,
        _clamp = clamp,
        _exponent = exponent;

  List<double> get domain => List.unmodifiable(_domain);
  set domain(List<double> value) => _domain = List.from(value);

  Interpolator<R> get interpolator => _interpolator;
  set interpolator(Interpolator<R> value) => _interpolator = value;

  bool get clamp => _clamp;
  set clamp(bool value) => _clamp = value;

  double get exponent => _exponent;
  set exponent(double value) => _exponent = value;

  double _pow(double x) {
    return x < 0 ? -(-x).pow(_exponent) : x.pow(_exponent);
  }

  R call(double value) {
    final pd0 = _pow(_domain[0]);
    final pd1 = _pow(_domain[1]);
    final pv = _pow(value);

    double t = (pv - pd0) / (pd1 - pd0);

    if (_clamp) {
      t = t.clamp(0.0, 1.0);
    }

    return _interpolator(t);
  }

  SequentialPowScale<R> copy() {
    return SequentialPowScale<R>(
      domain: List.from(_domain),
      interpolator: _interpolator,
      clamp: _clamp,
      exponent: _exponent,
    );
  }
}

extension on double {
  double pow(double exponent) {
    return this < 0 ? -(-this).pow(exponent) : this.pow(exponent);
  }

  double log() {
    return this > 0 ? this.log() : 0;
  }
}
