import 'package:duskmoon_visualization/src/vendor/dv_vendor/dv_vendor.dart'
    as vendor;

/// A quantile scale maps a sampled domain to discrete range values based on quantiles.
class QuantileScale<R> {
  List<double> _domain = [];
  List<R> _range = [];
  List<double> _thresholds = [];

  /// Creates a quantile scale with the given parameters.
  QuantileScale({
    List<double>? domain,
    required List<R> range,
  }) {
    _range = List.from(range);
    if (domain != null) {
      this.domain = domain;
    }
  }

  /// The input domain (sample values).
  List<double> get domain => List.unmodifiable(_domain);
  set domain(List<double> value) {
    _domain = value.where((v) => v.isFinite).toList()..sort();
    _rescale();
  }

  /// The discrete output range.
  List<R> get range => List.unmodifiable(_range);
  set range(List<R> value) {
    assert(value.isNotEmpty, 'Range must not be empty');
    _range = List.from(value);
    _rescale();
  }

  void _rescale() {
    if (_domain.isEmpty || _range.isEmpty) {
      _thresholds = [];
      return;
    }

    final n = _range.length;
    _thresholds = List.generate(
      n - 1,
      (i) => vendor.quantile(_domain, (i + 1) / n) ?? 0,
    );
  }

  /// Maps a domain value to a range value.
  R call(double value) {
    if (_thresholds.isEmpty) {
      return _range.first;
    }

    int i = 0;
    while (i < _thresholds.length && value > _thresholds[i]) {
      i++;
    }

    return _range[i];
  }

  /// Returns the extent of values in the domain that map to the given range value.
  (double, double) invertExtent(R value) {
    final i = _range.indexOf(value);
    if (i < 0) return (double.nan, double.nan);

    final lo = i > 0 ? _thresholds[i - 1] : _domain.first;
    final hi = i < _thresholds.length ? _thresholds[i] : _domain.last;

    return (lo, hi);
  }

  /// Returns the quantile thresholds.
  List<double> get thresholds => List.unmodifiable(_thresholds);

  /// Returns the quantile values (probabilities).
  List<double> get quantiles {
    final n = _range.length;
    return List.generate(n - 1, (i) => (i + 1) / n);
  }

  /// Creates a copy of this scale.
  QuantileScale<R> copy() {
    return QuantileScale<R>(
      domain: List.from(_domain),
      range: List.from(_range),
    );
  }
}

/// Creates a quantile scale.
QuantileScale<R> scaleQuantile<R>({
  List<double>? domain,
  required List<R> range,
}) {
  return QuantileScale<R>(
    domain: domain,
    range: range,
  );
}
