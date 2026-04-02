import 'package:duskmoon_visualization/src/vendor/dv_vendor/dv_vendor.dart';

import 'continuous_scale.dart';
import 'ticks.dart';

/// A linear scale maps a continuous domain to a continuous range
/// using linear interpolation.
class LinearScale implements ContinuousScale<double, double> {
  List<double> _domain;
  List<double> _range;
  bool _clamp;

  /// Creates a linear scale with the given domain and range.
  LinearScale({
    List<double>? domain,
    List<double>? range,
    bool clamp = false,
  })  : _domain = domain ?? [0, 1],
        _range = range ?? [0, 1],
        _clamp = clamp;

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

  @override
  double call(double value) {
    // Handle polylinear case with multiple segments
    if (_domain.length > 2) {
      return _polylinear(value, _domain, _range, interpolateNumber);
    }

    final d0 = _domain[0];
    final d1 = _domain[1];
    final r0 = _range[0];
    final r1 = _range[1];

    double t = normalize(value, d0, d1);

    if (_clamp) {
      t = t.clamp(0.0, 1.0);
    }

    return interpolateNumber(r0, r1)(t).toDouble();
  }

  @override
  double invert(double value) {
    // Handle polylinear case
    if (_range.length > 2) {
      return _polylinear(value, _range, _domain, interpolateNumber);
    }

    final d0 = _domain[0];
    final d1 = _domain[1];
    final r0 = _range[0];
    final r1 = _range[1];

    double t = normalize(value, r0, r1);

    if (_clamp) {
      t = t.clamp(0.0, 1.0);
    }

    return interpolateNumber(d0, d1)(t).toDouble();
  }

  double _polylinear(
    double value,
    List<double> fromDomain,
    List<double> toDomain,
    Interpolator<num> Function(num, num) interpolate,
  ) {
    // Find the segment containing the value
    int i =
        bisectRight<num>(fromDomain.sublist(1, fromDomain.length - 1), value);
    i = i.clamp(0, fromDomain.length - 2);

    final d0 = fromDomain[i];
    final d1 = fromDomain[i + 1];
    final r0 = toDomain[i];
    final r1 = toDomain[i + 1];

    double t = normalize(value, d0, d1);

    if (_clamp) {
      t = t.clamp(0.0, 1.0);
    }

    return interpolate(r0, r1)(t).toDouble();
  }

  @override
  LinearScale nice([int count = 10]) {
    final d = _domain;
    const i0 = 0;
    final i1 = d.length - 1;
    var start = d[i0];
    var stop = d[i1];

    if (stop < start) {
      final temp = start;
      start = stop;
      stop = temp;
    }

    final step = tickStep(start, stop, count);
    if (step > 0) {
      start = (start / step).floor() * step;
      stop = (stop / step).ceil() * step;
    } else if (step < 0) {
      start = (start * step).ceil() / step;
      stop = (stop * step).floor() / step;
    }

    if (d[i0] > d[i1]) {
      _domain[i0] = stop;
      _domain[i1] = start;
    } else {
      _domain[i0] = start;
      _domain[i1] = stop;
    }

    return this;
  }

  @override
  List<double> ticks([int count = 10]) {
    final d = _domain;
    return linearTicks(d.first, d.last, count);
  }

  @override
  String Function(double) tickFormat([int count = 10, String? specifier]) {
    final d = _domain;
    return linearTickFormat(d.first, d.last, count, specifier);
  }

  @override
  LinearScale copy() {
    return LinearScale(
      domain: List.from(_domain),
      range: List.from(_range),
      clamp: _clamp,
    );
  }

  /// Creates a linear scale.
  static LinearScale linear() => LinearScale();
}

/// Creates a linear scale with the given domain and range.
LinearScale scaleLinear({
  List<double>? domain,
  List<double>? range,
  bool clamp = false,
}) {
  return LinearScale(domain: domain, range: range, clamp: clamp);
}
