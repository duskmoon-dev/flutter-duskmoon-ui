/// A quantize scale maps a continuous domain to discrete range values.
class QuantizeScale<R> {
  List<double> _domain;
  List<R> _range;

  /// Creates a quantize scale with the given parameters.
  QuantizeScale({
    List<double>? domain,
    required List<R> range,
  })  : _domain = domain ?? [0, 1],
        _range = range;

  /// The continuous input domain.
  List<double> get domain => List.unmodifiable(_domain);
  set domain(List<double> value) {
    assert(value.length >= 2, 'Domain must have at least 2 values');
    _domain = List.from(value);
  }

  /// The discrete output range.
  List<R> get range => List.unmodifiable(_range);
  set range(List<R> value) {
    assert(value.isNotEmpty, 'Range must not be empty');
    _range = List.from(value);
  }

  /// Maps a domain value to a range value.
  R call(double value) {
    final n = _range.length;
    final d0 = _domain[0];
    final d1 = _domain[1];

    // Normalize value to [0, 1]
    double t = (value - d0) / (d1 - d0);
    t = t.clamp(0.0, 1.0);

    // Find the appropriate bin
    int i = (t * n).floor();
    if (i >= n) i = n - 1;

    return _range[i];
  }

  /// Returns the extent of values in the domain that map to the given range value.
  (double, double) invertExtent(R value) {
    final i = _range.indexOf(value);
    if (i < 0) return (double.nan, double.nan);

    final n = _range.length;
    final d0 = _domain[0];
    final d1 = _domain[1];
    final step = (d1 - d0) / n;

    return (d0 + i * step, d0 + (i + 1) * step);
  }

  /// Returns the thresholds used for binning.
  List<double> get thresholds {
    final n = _range.length;
    final d0 = _domain[0];
    final d1 = _domain[1];
    final step = (d1 - d0) / n;

    return List.generate(n - 1, (i) => d0 + (i + 1) * step);
  }

  /// Creates a copy of this scale.
  QuantizeScale<R> copy() {
    return QuantizeScale<R>(
      domain: List.from(_domain),
      range: List.from(_range),
    );
  }
}

/// Creates a quantize scale.
QuantizeScale<R> scaleQuantize<R>({
  List<double>? domain,
  required List<R> range,
}) {
  return QuantizeScale<R>(
    domain: domain,
    range: range,
  );
}
