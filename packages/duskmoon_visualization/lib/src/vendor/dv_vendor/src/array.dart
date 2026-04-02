import 'dart:math' as math;

/// Returns the minimum value in the given [iterable].
/// Returns null if the iterable is empty.
T? min<T extends Comparable<Object>>(Iterable<T> iterable) {
  final iterator = iterable.iterator;
  if (!iterator.moveNext()) return null;

  T minValue = iterator.current;
  while (iterator.moveNext()) {
    if (iterator.current.compareTo(minValue) < 0) {
      minValue = iterator.current;
    }
  }
  return minValue;
}

/// Returns the minimum value using an accessor function.
T? minBy<T, R extends Comparable<Object>>(
  Iterable<T> iterable,
  R Function(T) accessor,
) {
  final iterator = iterable.iterator;
  if (!iterator.moveNext()) return null;

  T minElement = iterator.current;
  R minValue = accessor(minElement);

  while (iterator.moveNext()) {
    final value = accessor(iterator.current);
    if (value.compareTo(minValue) < 0) {
      minElement = iterator.current;
      minValue = value;
    }
  }
  return minElement;
}

/// Returns the maximum value in the given [iterable].
/// Returns null if the iterable is empty.
T? max<T extends Comparable<Object>>(Iterable<T> iterable) {
  final iterator = iterable.iterator;
  if (!iterator.moveNext()) return null;

  T maxValue = iterator.current;
  while (iterator.moveNext()) {
    if (iterator.current.compareTo(maxValue) > 0) {
      maxValue = iterator.current;
    }
  }
  return maxValue;
}

/// Returns the maximum value using an accessor function.
T? maxBy<T, R extends Comparable<Object>>(
  Iterable<T> iterable,
  R Function(T) accessor,
) {
  final iterator = iterable.iterator;
  if (!iterator.moveNext()) return null;

  T maxElement = iterator.current;
  R maxValue = accessor(maxElement);

  while (iterator.moveNext()) {
    final value = accessor(iterator.current);
    if (value.compareTo(maxValue) > 0) {
      maxElement = iterator.current;
      maxValue = value;
    }
  }
  return maxElement;
}

/// Returns the minimum and maximum values as a tuple.
/// Returns null if the iterable is empty.
(T, T)? extent<T extends Comparable<Object>>(Iterable<T> iterable) {
  final iterator = iterable.iterator;
  if (!iterator.moveNext()) return null;

  T minValue = iterator.current;
  T maxValue = iterator.current;

  while (iterator.moveNext()) {
    final current = iterator.current;
    if (current.compareTo(minValue) < 0) {
      minValue = current;
    }
    if (current.compareTo(maxValue) > 0) {
      maxValue = current;
    }
  }
  return (minValue, maxValue);
}

/// Returns the minimum and maximum values using an accessor function.
(R, R)? extentBy<T, R extends Comparable<Object>>(
  Iterable<T> iterable,
  R Function(T) accessor,
) {
  final iterator = iterable.iterator;
  if (!iterator.moveNext()) return null;

  R minValue = accessor(iterator.current);
  R maxValue = minValue;

  while (iterator.moveNext()) {
    final value = accessor(iterator.current);
    if (value.compareTo(minValue) < 0) {
      minValue = value;
    }
    if (value.compareTo(maxValue) > 0) {
      maxValue = value;
    }
  }
  return (minValue, maxValue);
}

/// Returns the sum of the given [iterable] of numbers.
num sum(Iterable<num> iterable) {
  num total = 0;
  for (final value in iterable) {
    total += value;
  }
  return total;
}

/// Returns the sum using an accessor function.
num sumBy<T>(Iterable<T> iterable, num Function(T) accessor) {
  num total = 0;
  for (final item in iterable) {
    total += accessor(item);
  }
  return total;
}

/// Returns the arithmetic mean of the given [iterable].
/// Returns null if the iterable is empty.
double? mean(Iterable<num> iterable) {
  final iterator = iterable.iterator;
  if (!iterator.moveNext()) return null;

  num total = iterator.current;
  int count = 1;

  while (iterator.moveNext()) {
    total += iterator.current;
    count++;
  }

  return total / count;
}

/// Returns the mean using an accessor function.
double? meanBy<T>(Iterable<T> iterable, num Function(T) accessor) {
  final iterator = iterable.iterator;
  if (!iterator.moveNext()) return null;

  num total = accessor(iterator.current);
  int count = 1;

  while (iterator.moveNext()) {
    total += accessor(iterator.current);
    count++;
  }

  return total / count;
}

/// Returns the median of the given [iterable].
/// Returns null if the iterable is empty.
double? median(Iterable<num> iterable) {
  return quantile(iterable, 0.5);
}

/// Returns the p-quantile of the given [iterable], where p is in [0, 1].
/// Uses the R-7 method (linear interpolation of modes).
double? quantile(Iterable<num> iterable, double p) {
  final values = iterable.toList()..sort();
  if (values.isEmpty) return null;
  if (p <= 0) return values.first.toDouble();
  if (p >= 1) return values.last.toDouble();

  final n = values.length;
  final index = (n - 1) * p;
  final lo = index.floor();
  final hi = index.ceil();
  final loValue = values[lo];

  if (lo == hi) return loValue.toDouble();

  return loValue + (values[hi] - loValue) * (index - lo);
}

/// Returns an array of quantiles for the given probabilities.
List<double> quantiles(Iterable<num> iterable, List<double> probabilities) {
  return probabilities.map((p) => quantile(iterable, p) ?? 0).toList();
}

/// Represents a histogram bin.
class Bin<T> {
  /// The lower bound (inclusive) of this bin.
  final num x0;

  /// The upper bound (exclusive) of this bin.
  final num x1;

  /// The values in this bin.
  final List<T> values;

  Bin({
    required this.x0,
    required this.x1,
    required this.values,
  });

  /// The number of values in this bin.
  int get length => values.length;
}

/// Generates a histogram from the given values.
List<Bin<T>> histogram<T>({
  required Iterable<T> data,
  required num Function(T) value,
  int? thresholds,
  List<num>? domain,
}) {
  final values = data.toList();
  if (values.isEmpty) return [];

  // Calculate domain
  num minValue, maxValue;
  if (domain != null && domain.length >= 2) {
    minValue = domain[0];
    maxValue = domain[1];
  } else {
    final ext = extentBy(values, value);
    if (ext == null) return [];
    minValue = ext.$1;
    maxValue = ext.$2;
  }

  // Calculate number of bins using Sturges' formula if not provided
  final binCount = thresholds ??
      math.max(1, (math.log(values.length) / math.ln2).ceil() + 1);

  // Calculate bin width
  final binWidth = (maxValue - minValue) / binCount;
  if (binWidth == 0) {
    return [
      Bin(
        x0: minValue,
        x1: maxValue,
        values: values,
      ),
    ];
  }

  // Create bins
  final bins = List.generate(
    binCount,
    (i) => Bin<T>(
      x0: minValue + i * binWidth,
      x1: minValue + (i + 1) * binWidth,
      values: <T>[],
    ),
  );

  // Distribute values into bins
  for (final item in values) {
    final v = value(item);
    if (v < minValue || v > maxValue) continue;

    int binIndex = ((v - minValue) / binWidth).floor();
    if (binIndex >= binCount) binIndex = binCount - 1;
    bins[binIndex].values.add(item);
  }

  return bins;
}

/// Returns the variance of the given [iterable].
double? variance(Iterable<num> iterable) {
  final values = iterable.toList();
  if (values.isEmpty) return null;

  final m = mean(values);
  if (m == null) return null;

  num sumSquares = 0;
  for (final value in values) {
    final diff = value - m;
    sumSquares += diff * diff;
  }

  return sumSquares / values.length;
}

/// Returns the standard deviation of the given [iterable].
double? deviation(Iterable<num> iterable) {
  final v = variance(iterable);
  if (v == null) return null;
  return math.sqrt(v);
}

/// Generates a range of numbers from [start] to [stop] (exclusive) with [step].
List<num> range(num start, [num? stop, num step = 1]) {
  if (stop == null) {
    stop = start;
    start = 0;
  }

  final result = <num>[];
  if (step > 0) {
    for (num i = start; i < stop; i += step) {
      result.add(i);
    }
  } else if (step < 0) {
    for (num i = start; i > stop; i += step) {
      result.add(i);
    }
  }
  return result;
}

/// Groups elements by a key function.
Map<K, List<T>> group<T, K>(Iterable<T> iterable, K Function(T) key) {
  final map = <K, List<T>>{};
  for (final item in iterable) {
    final k = key(item);
    (map[k] ??= []).add(item);
  }
  return map;
}

/// Rolls up elements by a key function and reduces each group.
Map<K, R> rollup<T, K, R>(
  Iterable<T> iterable,
  K Function(T) key,
  R Function(List<T>) reduce,
) {
  final groups = group(iterable, key);
  return groups.map((k, v) => MapEntry(k, reduce(v)));
}

/// Returns a shuffled copy of the iterable.
List<T> shuffle<T>(Iterable<T> iterable, [math.Random? random]) {
  final list = iterable.toList();
  final rng = random ?? math.Random();

  for (int i = list.length - 1; i > 0; i--) {
    final j = rng.nextInt(i + 1);
    final temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }

  return list;
}

/// Returns the index of the specified value in the sorted list,
/// or -1 if not found.
int indexOf<T extends Comparable<Object>>(List<T> list, T value) {
  int lo = 0;
  int hi = list.length;

  while (lo < hi) {
    final mid = (lo + hi) ~/ 2;
    final cmp = list[mid].compareTo(value);
    if (cmp < 0) {
      lo = mid + 1;
    } else if (cmp > 0) {
      hi = mid;
    } else {
      return mid;
    }
  }

  return -1;
}

/// Permutes the array according to the given indices.
List<T> permute<T>(List<T> array, List<int> indices) {
  return indices.map((i) => array[i]).toList();
}

/// Returns the cross product of two iterables.
List<R> cross<A, B, R>(
  Iterable<A> a,
  Iterable<B> b,
  R Function(A, B) combine,
) {
  final result = <R>[];
  for (final ai in a) {
    for (final bi in b) {
      result.add(combine(ai, bi));
    }
  }
  return result;
}

/// Merges two sorted arrays into a single sorted array.
List<T> merge<T extends Comparable<Object>>(List<T> a, List<T> b) {
  final result = <T>[];
  int i = 0, j = 0;

  while (i < a.length && j < b.length) {
    if (a[i].compareTo(b[j]) <= 0) {
      result.add(a[i++]);
    } else {
      result.add(b[j++]);
    }
  }

  while (i < a.length) {
    result.add(a[i++]);
  }
  while (j < b.length) {
    result.add(b[j++]);
  }

  return result;
}

/// Returns unique values from the iterable.
List<T> distinct<T>(Iterable<T> iterable) {
  return iterable.toSet().toList();
}

/// Returns unique values using a key function.
List<T> distinctBy<T, K>(Iterable<T> iterable, K Function(T) key) {
  final seen = <K>{};
  final result = <T>[];

  for (final item in iterable) {
    final k = key(item);
    if (seen.add(k)) {
      result.add(item);
    }
  }

  return result;
}
