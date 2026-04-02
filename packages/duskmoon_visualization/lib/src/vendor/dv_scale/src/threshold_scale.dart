/// A threshold scale maps values to discrete outputs based on threshold values.
class ThresholdScale<D extends Comparable<D>, R> {
  List<D> _domain;
  List<R> _range;

  /// Creates a threshold scale with the given parameters.
  ThresholdScale({
    required List<D> domain,
    required List<R> range,
  })  : _domain = List.from(domain),
        _range = List.from(range) {
    assert(
      range.length == domain.length + 1,
      'Range must have one more element than domain',
    );
  }

  /// The threshold values.
  List<D> get domain => List.unmodifiable(_domain);
  set domain(List<D> value) {
    _domain = List.from(value);
  }

  /// The discrete output range.
  List<R> get range => List.unmodifiable(_range);
  set range(List<R> value) {
    assert(
      value.length == _domain.length + 1,
      'Range must have one more element than domain',
    );
    _range = List.from(value);
  }

  /// Maps a domain value to a range value.
  R call(D value) {
    int i = 0;
    while (i < _domain.length && value.compareTo(_domain[i]) >= 0) {
      i++;
    }
    return _range[i];
  }

  /// Returns the extent of values in the domain that map to the given range value.
  (D?, D?) invertExtent(R value) {
    final i = _range.indexOf(value);
    if (i < 0) return (null, null);

    final lo = i > 0 ? _domain[i - 1] : null;
    final hi = i < _domain.length ? _domain[i] : null;

    return (lo, hi);
  }

  /// Creates a copy of this scale.
  ThresholdScale<D, R> copy() {
    return ThresholdScale<D, R>(
      domain: List.from(_domain),
      range: List.from(_range),
    );
  }
}

/// Creates a threshold scale.
ThresholdScale<D, R> scaleThreshold<D extends Comparable<D>, R>({
  required List<D> domain,
  required List<R> range,
}) {
  return ThresholdScale<D, R>(
    domain: domain,
    range: range,
  );
}
