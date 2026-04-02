/// A band scale maps discrete domain values to a continuous range with bands.
class BandScale<T> {
  List<T> _domain;
  List<double> _range;
  double _paddingInner;
  double _paddingOuter;
  double _align;
  bool _round;

  /// Creates a band scale with the given parameters.
  BandScale({
    List<T>? domain,
    List<double>? range,
    double paddingInner = 0,
    double paddingOuter = 0,
    double align = 0.5,
    bool round = false,
  })  : _domain = domain ?? [],
        _range = range ?? [0, 1],
        _paddingInner = paddingInner,
        _paddingOuter = paddingOuter,
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

  /// The inner padding between bands (0 to 1).
  double get paddingInner => _paddingInner;
  set paddingInner(double value) {
    _paddingInner = value.clamp(0.0, 1.0);
  }

  /// The outer padding on the edges (0 to 1).
  double get paddingOuter => _paddingOuter;
  set paddingOuter(double value) {
    _paddingOuter = value.clamp(0.0, 1.0);
  }

  /// Sets both inner and outer padding.
  set padding(double value) {
    paddingInner = value;
    paddingOuter = value;
  }

  /// The alignment of bands within the range (0 to 1).
  double get align => _align;
  set align(double value) {
    _align = value.clamp(0.0, 1.0);
  }

  /// Whether to round output values.
  bool get round => _round;
  set round(bool value) => _round = value;

  /// Returns the start position of the band for the given value.
  double call(T value) {
    final index = _domain.indexOf(value);
    if (index < 0) return double.nan;
    return _bandStart(index);
  }

  double _bandStart(int index) {
    final n = _domain.length;
    if (n == 0) return double.nan;

    final start = _range[0];
    final stop = _range[1];
    final reverse = stop < start;
    final lo = reverse ? stop : start;
    final hi = reverse ? start : stop;

    final step = _step(n, lo, hi);

    var x = lo + _paddingOuter * step + index * step;
    if (reverse) {
      x = hi - _paddingOuter * step - (n - 1 - index) * step;
    }

    if (_round) {
      x = x.roundToDouble();
    }

    return x;
  }

  double _step(int n, double lo, double hi) {
    final range = hi - lo;
    final paddedN = n - _paddingInner + 2 * _paddingOuter;
    return range / paddedN;
  }

  /// Returns the bandwidth (width of each band).
  double get bandwidth {
    final n = _domain.length;
    if (n == 0) return 0;

    final start = _range[0];
    final stop = _range[1];
    final lo = stop < start ? stop : start;
    final hi = stop < start ? start : stop;

    final step = _step(n, lo, hi);
    var bw = step * (1 - _paddingInner);

    if (_round) {
      bw = bw.roundToDouble();
    }

    return bw;
  }

  /// Returns the step between band starts.
  double get step {
    final n = _domain.length;
    if (n == 0) return 0;

    final start = _range[0];
    final stop = _range[1];
    final lo = stop < start ? stop : start;
    final hi = stop < start ? start : stop;

    return _step(n, lo, hi);
  }

  /// Creates a copy of this scale.
  BandScale<T> copy() {
    return BandScale<T>(
      domain: List.from(_domain),
      range: List.from(_range),
      paddingInner: _paddingInner,
      paddingOuter: _paddingOuter,
      align: _align,
      round: _round,
    );
  }
}

/// Creates a band scale.
BandScale<T> scaleBand<T>({
  List<T>? domain,
  List<double>? range,
  double paddingInner = 0,
  double paddingOuter = 0,
  double padding = 0,
  double align = 0.5,
  bool round = false,
}) {
  final scale = BandScale<T>(
    domain: domain,
    range: range,
    paddingInner: padding > 0 ? padding : paddingInner,
    paddingOuter: padding > 0 ? padding : paddingOuter,
    align: align,
    round: round,
  );
  return scale;
}
