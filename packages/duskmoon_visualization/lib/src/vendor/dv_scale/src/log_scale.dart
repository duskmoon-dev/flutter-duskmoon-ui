import 'dart:math' as math;

import 'package:duskmoon_visualization/src/vendor/dv_vendor/dv_vendor.dart';

import 'continuous_scale.dart';

/// A logarithmic scale applies a log transform to the domain.
class LogScale implements ContinuousScale<double, double> {
  List<double> _domain;
  List<double> _range;
  bool _clamp;
  double _base;

  /// Creates a log scale with the given parameters.
  LogScale({
    List<double>? domain,
    List<double>? range,
    bool clamp = false,
    double base = 10,
  })  : _domain = domain ?? [1, 10],
        _range = range ?? [0, 1],
        _clamp = clamp,
        _base = base;

  /// The base of the logarithm.
  double get base => _base;
  set base(double value) {
    assert(value > 0 && value != 1, 'Base must be positive and not 1');
    _base = value;
  }

  @override
  List<double> get domain => List.unmodifiable(_domain);

  @override
  set domain(List<double> value) {
    assert(value.length >= 2, 'Domain must have at least 2 values');
    assert(value.every((v) => v > 0), 'Log scale domain must be positive');
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

  double _log(double x) {
    return math.log(x) / math.log(_base);
  }

  double _pow(double x) {
    return math.pow(_base, x).toDouble();
  }

  @override
  double call(double value) {
    if (value <= 0) return _range[0];

    final d0 = _domain[0];
    final d1 = _domain[1];
    final r0 = _range[0];
    final r1 = _range[1];

    final ld0 = _log(d0);
    final ld1 = _log(d1);
    final lv = _log(value);

    double t = normalize(lv, ld0, ld1);

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

    final ld0 = _log(d0);
    final ld1 = _log(d1);
    final lv = interpolateNumber(ld0, ld1)(t);

    return _pow(lv.toDouble());
  }

  @override
  LogScale nice([int count = 10]) {
    final d0 = _domain[0];
    final d1 = _domain[1];

    final l0 = _log(d0);
    final l1 = _log(d1);

    _domain[0] = _pow(l0.floor().toDouble());
    _domain[_domain.length - 1] = _pow(l1.ceil().toDouble());

    return this;
  }

  @override
  List<double> ticks([int count = 10]) {
    final d = _domain;
    var u = d.first;
    var v = d.last;

    final r = v < u;
    if (r) {
      final temp = u;
      u = v;
      v = temp;
    }

    var i = _log(u).floor();
    final j = _log(v).ceil();

    final ticks = <double>[];

    if (_base % 1 == 0) {
      // Integer base
      final k = _base.toInt();
      if (j - i < count) {
        for (; i <= j; ++i) {
          for (int p = 1; p < k; ++p) {
            final t = i < 0 ? p / _pow(-i.toDouble()) : p * _pow(i.toDouble());
            if (t < u) continue;
            if (t > v) break;
            ticks.add(t);
          }
        }
      } else {
        for (; i <= j; ++i) {
          ticks.add(_pow(i.toDouble()));
        }
      }
    } else {
      // Non-integer base
      for (; i <= j; ++i) {
        ticks.add(_pow(i.toDouble()));
      }
    }

    return r ? ticks.reversed.toList() : ticks;
  }

  @override
  String Function(double) tickFormat([int count = 10, String? specifier]) {
    return (double value) {
      if (_base == 10) {
        return value.toStringAsExponential(0);
      }
      return value.toString();
    };
  }

  @override
  LogScale copy() {
    return LogScale(
      domain: List.from(_domain),
      range: List.from(_range),
      clamp: _clamp,
      base: _base,
    );
  }
}

/// Creates a log scale with base 10.
LogScale scaleLog({
  List<double>? domain,
  List<double>? range,
  bool clamp = false,
  double base = 10,
}) {
  return LogScale(
    domain: domain,
    range: range,
    clamp: clamp,
    base: base,
  );
}
