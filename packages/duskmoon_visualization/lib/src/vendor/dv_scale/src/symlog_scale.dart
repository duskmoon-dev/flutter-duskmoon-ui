import 'dart:math' as math;

import 'package:duskmoon_visualization/src/vendor/dv_vendor/dv_vendor.dart';

import 'continuous_scale.dart';
import 'ticks.dart';

/// A symmetric log scale that handles both positive and negative values.
/// Uses the bi-symmetric log transform: sign(x) * log(1 + |x / constant|)
class SymlogScale implements ContinuousScale<double, double> {
  List<double> _domain;
  List<double> _range;
  bool _clamp;
  double _constant;

  /// Creates a symlog scale with the given parameters.
  SymlogScale({
    List<double>? domain,
    List<double>? range,
    bool clamp = false,
    double constant = 1,
  })  : _domain = domain ?? [-1, 1],
        _range = range ?? [0, 1],
        _clamp = clamp,
        _constant = constant;

  /// The constant used in the symlog transform.
  double get constant => _constant;
  set constant(double value) {
    assert(value > 0, 'Constant must be positive');
    _constant = value;
  }

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

  /// Applies the symlog transform.
  double _transform(double x) {
    return x.sign * math.log(1 + (x / _constant).abs());
  }

  /// Applies the inverse symlog transform.
  double _transformInverse(double x) {
    return x.sign * (math.exp(x.abs()) - 1) * _constant;
  }

  @override
  double call(double value) {
    final d0 = _domain[0];
    final d1 = _domain[1];
    final r0 = _range[0];
    final r1 = _range[1];

    final td0 = _transform(d0);
    final td1 = _transform(d1);
    final tv = _transform(value);

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

    final td0 = _transform(d0);
    final td1 = _transform(d1);
    final tv = interpolateNumber(td0, td1)(t);

    return _transformInverse(tv.toDouble());
  }

  @override
  SymlogScale nice([int count = 10]) {
    final step = tickStep(_domain.first, _domain.last, count);
    if (step > 0) {
      _domain[0] = (_domain[0] / step).floor() * step;
      _domain[_domain.length - 1] = (_domain.last / step).ceil() * step;
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
  SymlogScale copy() {
    return SymlogScale(
      domain: List.from(_domain),
      range: List.from(_range),
      clamp: _clamp,
      constant: _constant,
    );
  }
}

/// Creates a symlog scale.
SymlogScale scaleSymlog({
  List<double>? domain,
  List<double>? range,
  bool clamp = false,
  double constant = 1,
}) {
  return SymlogScale(
    domain: domain,
    range: range,
    clamp: clamp,
    constant: constant,
  );
}
