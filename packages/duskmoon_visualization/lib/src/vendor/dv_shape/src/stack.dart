/// Stack layout generator for stacked area/bar charts.
class StackLayout<T> {
  /// Keys to stack (series names).
  final List<String> keys;

  /// Function to extract a value for a given key from a data item.
  final double Function(T data, String key) value;

  /// The stack order strategy.
  final StackOrder order;

  /// The stack offset strategy.
  final StackOffset offset;

  /// Creates a stack layout generator.
  StackLayout({
    required this.keys,
    required this.value,
    this.order = StackOrder.none,
    this.offset = StackOffset.none,
  });

  /// Generates stacked series from the given data.
  List<StackSeries<T>> generate(List<T> data) {
    if (data.isEmpty || keys.isEmpty) return [];

    // Order keys
    final orderedKeys = _orderKeys(data);

    // Calculate raw stacks
    final series = <StackSeries<T>>[];

    for (final key in orderedKeys) {
      final points = <StackPoint<T>>[];

      for (int i = 0; i < data.length; i++) {
        final v = value(data[i], key);
        points.add(StackPoint<T>(
          data: data[i],
          index: i,
          value: v,
          y0: 0,
          y1: v,
        ));
      }

      series.add(StackSeries<T>(
        key: key,
        points: points,
      ));
    }

    // Stack the values
    for (int i = 0; i < data.length; i++) {
      double y0 = 0;
      for (final s in series) {
        final point = s.points[i];
        final v = point.value;
        s.points[i] = StackPoint<T>(
          data: point.data,
          index: point.index,
          value: v,
          y0: y0,
          y1: y0 + v,
        );
        y0 += v;
      }
    }

    // Apply offset
    _applyOffset(series, data.length);

    return series;
  }

  List<String> _orderKeys(List<T> data) {
    switch (order) {
      case StackOrder.none:
        return keys;

      case StackOrder.ascending:
        final sums = <String, double>{};
        for (final key in keys) {
          double sum = 0;
          for (final item in data) {
            sum += value(item, key);
          }
          sums[key] = sum;
        }
        final sorted = List<String>.from(keys);
        sorted.sort((a, b) => sums[a]!.compareTo(sums[b]!));
        return sorted;

      case StackOrder.descending:
        final sums = <String, double>{};
        for (final key in keys) {
          double sum = 0;
          for (final item in data) {
            sum += value(item, key);
          }
          sums[key] = sum;
        }
        final sorted = List<String>.from(keys);
        sorted.sort((a, b) => sums[b]!.compareTo(sums[a]!));
        return sorted;

      case StackOrder.reverse:
        return keys.reversed.toList();
    }
  }

  void _applyOffset(List<StackSeries<T>> series, int dataLength) {
    if (series.isEmpty) return;

    switch (offset) {
      case StackOffset.none:
        // No adjustment needed
        break;

      case StackOffset.expand:
        // Normalize to 0-1 range
        for (int i = 0; i < dataLength; i++) {
          final total = series.last.points[i].y1;
          if (total == 0) continue;

          for (final s in series) {
            final point = s.points[i];
            s.points[i] = StackPoint<T>(
              data: point.data,
              index: point.index,
              value: point.value,
              y0: point.y0 / total,
              y1: point.y1 / total,
            );
          }
        }
        break;

      case StackOffset.silhouette:
        // Center the stream
        for (int i = 0; i < dataLength; i++) {
          final total = series.last.points[i].y1;
          final shift = total / 2;

          for (final s in series) {
            final point = s.points[i];
            s.points[i] = StackPoint<T>(
              data: point.data,
              index: point.index,
              value: point.value,
              y0: point.y0 - shift,
              y1: point.y1 - shift,
            );
          }
        }
        break;

      case StackOffset.wiggle:
        // Minimize weighted wiggle (streamgraph)
        for (int i = 0; i < dataLength; i++) {
          double y0 = 0;
          double total = 0;

          for (int j = 0; j < series.length; j++) {
            total += series[j].points[i].value;
            if (j > 0) {
              y0 += (series.length - j) * series[j].points[i].value;
            }
          }

          if (total > 0) {
            y0 = -y0 / total;
          }

          for (final s in series) {
            final point = s.points[i];
            final height = point.y1 - point.y0;
            s.points[i] = StackPoint<T>(
              data: point.data,
              index: point.index,
              value: point.value,
              y0: y0,
              y1: y0 + height,
            );
            y0 += height;
          }
        }
        break;
    }
  }
}

/// Stack ordering strategies.
enum StackOrder {
  /// Keep original order.
  none,

  /// Sort by sum ascending.
  ascending,

  /// Sort by sum descending.
  descending,

  /// Reverse the order.
  reverse,
}

/// Stack offset strategies.
enum StackOffset {
  /// No offset, baseline at zero.
  none,

  /// Normalize to 0-1 range (100% stacked).
  expand,

  /// Center the stack (silhouette).
  silhouette,

  /// Minimize weighted wiggle (streamgraph).
  wiggle,
}

/// A stacked series containing points for one key.
class StackSeries<T> {
  /// The series key.
  final String key;

  /// The stacked points.
  final List<StackPoint<T>> points;

  /// Creates a stack series.
  StackSeries({
    required this.key,
    required this.points,
  });

  @override
  String toString() => 'StackSeries(key: $key, points: ${points.length})';
}

/// A single point in a stacked series.
class StackPoint<T> {
  /// The original data item.
  final T data;

  /// The index in the data array.
  final int index;

  /// The raw value.
  final double value;

  /// The lower y bound after stacking.
  final double y0;

  /// The upper y bound after stacking.
  final double y1;

  /// Creates a stack point.
  const StackPoint({
    required this.data,
    required this.index,
    required this.value,
    required this.y0,
    required this.y1,
  });

  /// The height of this segment.
  double get height => y1 - y0;

  @override
  String toString() => 'StackPoint(value: $value, y0: $y0, y1: $y1)';
}
