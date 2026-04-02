/// An ordinal scale maps discrete domain values to discrete range values.
class OrdinalScale<D, R> {
  final Map<D, R> _index = {};
  List<D> _domain = [];
  List<R> _range = [];
  R? _unknown;

  /// Creates an ordinal scale with the given parameters.
  OrdinalScale({
    List<D>? domain,
    List<R>? range,
    R? unknown,
  }) : _unknown = unknown {
    // Range must be set before domain because domain setter calls _getRange
    if (range != null) this.range = range;
    if (domain != null) this.domain = domain;
  }

  /// The discrete domain values.
  List<D> get domain => List.unmodifiable(_domain);
  set domain(List<D> value) {
    _domain = [];
    _index.clear();

    for (final d in value) {
      if (!_index.containsKey(d)) {
        _domain.add(d);
        _index[d] = _getRange(_domain.length - 1);
      }
    }
  }

  /// The discrete range values.
  List<R> get range => List.unmodifiable(_range);
  set range(List<R> value) {
    _range = List.from(value);
    // Rebuild index with new range
    _index.clear();
    for (int i = 0; i < _domain.length; i++) {
      _index[_domain[i]] = _getRange(i);
    }
  }

  /// The value to return for unknown inputs.
  R? get unknown => _unknown;
  set unknown(R? value) => _unknown = value;

  R _getRange(int index) {
    if (_range.isEmpty) {
      throw StateError('Range must not be empty');
    }
    return _range[index % _range.length];
  }

  /// Maps a domain value to a range value.
  R call(D value) {
    if (_index.containsKey(value)) {
      return _index[value]!;
    }

    // If unknown is null and implicit domain, add to domain
    if (_unknown == null) {
      _domain.add(value);
      final r = _getRange(_domain.length - 1);
      _index[value] = r;
      return r;
    }

    return _unknown as R;
  }

  /// Creates a copy of this scale.
  OrdinalScale<D, R> copy() {
    return OrdinalScale<D, R>(
      domain: List.from(_domain),
      range: List.from(_range),
      unknown: _unknown,
    );
  }
}

/// Creates an ordinal scale.
OrdinalScale<D, R> scaleOrdinal<D, R>({
  List<D>? domain,
  List<R>? range,
  R? unknown,
}) {
  return OrdinalScale<D, R>(
    domain: domain,
    range: range,
    unknown: unknown,
  );
}

/// Standard categorical color schemes.
class ColorSchemes {
  ColorSchemes._();

  /// Category10 color scheme (10 colors).
  static const List<String> category10 = [
    '#1f77b4',
    '#ff7f0e',
    '#2ca02c',
    '#d62728',
    '#9467bd',
    '#8c564b',
    '#e377c2',
    '#7f7f7f',
    '#bcbd22',
    '#17becf',
  ];

  /// Accent color scheme (8 colors).
  static const List<String> accent = [
    '#7fc97f',
    '#beaed4',
    '#fdc086',
    '#ffff99',
    '#386cb0',
    '#f0027f',
    '#bf5b17',
    '#666666',
  ];

  /// Dark2 color scheme (8 colors).
  static const List<String> dark2 = [
    '#1b9e77',
    '#d95f02',
    '#7570b3',
    '#e7298a',
    '#66a61e',
    '#e6ab02',
    '#a6761d',
    '#666666',
  ];

  /// Paired color scheme (12 colors).
  static const List<String> paired = [
    '#a6cee3',
    '#1f78b4',
    '#b2df8a',
    '#33a02c',
    '#fb9a99',
    '#e31a1c',
    '#fdbf6f',
    '#ff7f00',
    '#cab2d6',
    '#6a3d9a',
    '#ffff99',
    '#b15928',
  ];

  /// Pastel1 color scheme (9 colors).
  static const List<String> pastel1 = [
    '#fbb4ae',
    '#b3cde3',
    '#ccebc5',
    '#decbe4',
    '#fed9a6',
    '#ffffcc',
    '#e5d8bd',
    '#fddaec',
    '#f2f2f2',
  ];

  /// Pastel2 color scheme (8 colors).
  static const List<String> pastel2 = [
    '#b3e2cd',
    '#fdcdac',
    '#cbd5e8',
    '#f4cae4',
    '#e6f5c9',
    '#fff2ae',
    '#f1e2cc',
    '#cccccc',
  ];

  /// Set1 color scheme (9 colors).
  static const List<String> set1 = [
    '#e41a1c',
    '#377eb8',
    '#4daf4a',
    '#984ea3',
    '#ff7f00',
    '#ffff33',
    '#a65628',
    '#f781bf',
    '#999999',
  ];

  /// Set2 color scheme (8 colors).
  static const List<String> set2 = [
    '#66c2a5',
    '#fc8d62',
    '#8da0cb',
    '#e78ac3',
    '#a6d854',
    '#ffd92f',
    '#e5c494',
    '#b3b3b3',
  ];

  /// Set3 color scheme (12 colors).
  static const List<String> set3 = [
    '#8dd3c7',
    '#ffffb3',
    '#bebada',
    '#fb8072',
    '#80b1d3',
    '#fdb462',
    '#b3de69',
    '#fccde5',
    '#d9d9d9',
    '#bc80bd',
    '#ccebc5',
    '#ffed6f',
  ];

  /// Tableau10 color scheme (10 colors).
  static const List<String> tableau10 = [
    '#4e79a7',
    '#f28e2c',
    '#e15759',
    '#76b7b2',
    '#59a14f',
    '#edc949',
    '#af7aa1',
    '#ff9da7',
    '#9c755f',
    '#bab0ab',
  ];
}
