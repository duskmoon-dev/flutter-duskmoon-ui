/// A point scale maps discrete domain values to points within a continuous range.
/// Similar to band scale but with zero bandwidth.
class PointScale<T> {
  List<T> _domain;
  List<double> _range;
  double _padding;
  double _align;
  bool _round;

  /// Creates a point scale with the given parameters.
  PointScale({
    List<T>? domain,
    List<double>? range,
    double padding = 0,
    double align = 0.5,
    bool round = false,
  })  : _domain = domain ?? [],
        _range = range ?? [0, 1],
        _padding = padding,
        _align = align,
        _round = round;

  /// The discrete domain values.
  List<T> get domain => List.unmodifiable(_domain);
  set domain(List<T> value) => _domain = List.from(value);

  /// The continuous output range.
  List<double> get range => List.unmodifiable(_range);
  set range(List<double> value) {
    assert(value.length >= 2, 'Range must have at least 2 values');
    _range = List.from(value);
  }

  /// The padding on the edges (0 to 1).
  double get padding => _padding;
  set padding(double value) {
    _padding = value.clamp(0.0, 1.0);
  }

  /// The alignment of points within the range (0 to 1).
  double get align => _align;
  set align(double value) {
    _align = value.clamp(0.0, 1.0);
  }

  /// Whether to round output values.
  bool get round => _round;
  set round(bool value) => _round = value;

  /// Returns the position of the point for the given value.
  double call(T value) {
    final index = _domain.indexOf(value);
    if (index < 0) return double.nan;
    return _pointPosition(index);
  }

  double _pointPosition(int index) {
    final n = _domain.length;
    if (n == 0) return double.nan;
    if (n == 1) {
      return (_range[0] + _range[1]) / 2;
    }

    final start = _range[0];
    final stop = _range[1];
    final reverse = stop < start;
    final lo = reverse ? stop : start;
    final hi = reverse ? start : stop;

    final step = _step(n, lo, hi);
    var x = lo + _padding * step + index * step;

    if (reverse) {
      x = hi - _padding * step - (n - 1 - index) * step;
    }

    if (_round) {
      x = x.roundToDouble();
    }

    return x;
  }

  double _step(int n, double lo, double hi) {
    if (n <= 1) return hi - lo;
    final range = hi - lo;
    return range / (n - 1 + 2 * _padding);
  }

  /// Returns the step between points.
  double get step {
    final n = _domain.length;
    if (n <= 1) return 0;

    final start = _range[0];
    final stop = _range[1];
    final lo = stop < start ? stop : start;
    final hi = stop < start ? start : stop;

    return _step(n, lo, hi);
  }

  /// The bandwidth is always 0 for point scales.
  double get bandwidth => 0;

  /// Creates a copy of this scale.
  PointScale<T> copy() {
    return PointScale<T>(
      domain: List.from(_domain),
      range: List.from(_range),
      padding: _padding,
      align: _align,
      round: _round,
    );
  }
}

/// Creates a point scale.
PointScale<T> scalePoint<T>({
  List<T>? domain,
  List<double>? range,
  double padding = 0,
  double align = 0.5,
  bool round = false,
}) {
  return PointScale<T>(
    domain: domain,
    range: range,
    padding: padding,
    align: align,
    round: round,
  );
}
