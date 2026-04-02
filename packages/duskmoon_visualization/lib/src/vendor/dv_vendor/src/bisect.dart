/// Returns the insertion index for [value] in [list] to maintain sorted order.
/// Uses the leftmost position for equal values.
int bisectLeft<T extends Comparable<Object>>(
  List<T> list,
  T value, {
  int lo = 0,
  int? hi,
}) {
  var hiValue = hi ?? list.length;

  while (lo < hiValue) {
    final mid = (lo + hiValue) ~/ 2;
    if (list[mid].compareTo(value) < 0) {
      lo = mid + 1;
    } else {
      hiValue = mid;
    }
  }

  return lo;
}

/// Returns the insertion index for [value] in [list] to maintain sorted order.
/// Uses the leftmost position for equal values.
/// Uses an accessor function to extract comparable values.
int bisectLeftBy<T, V extends Comparable<Object>>(
  List<T> list,
  V value,
  V Function(T) accessor, {
  int lo = 0,
  int? hi,
}) {
  var hiValue = hi ?? list.length;

  while (lo < hiValue) {
    final mid = (lo + hiValue) ~/ 2;
    if (accessor(list[mid]).compareTo(value) < 0) {
      lo = mid + 1;
    } else {
      hiValue = mid;
    }
  }

  return lo;
}

/// Returns the insertion index for [value] in [list] to maintain sorted order.
/// Uses the rightmost position for equal values.
int bisectRight<T extends Comparable<Object>>(
  List<T> list,
  T value, {
  int lo = 0,
  int? hi,
}) {
  var hiValue = hi ?? list.length;

  while (lo < hiValue) {
    final mid = (lo + hiValue) ~/ 2;
    if (list[mid].compareTo(value) > 0) {
      hiValue = mid;
    } else {
      lo = mid + 1;
    }
  }

  return lo;
}

/// Returns the insertion index for [value] in [list] to maintain sorted order.
/// Uses the rightmost position for equal values.
/// Uses an accessor function to extract comparable values.
int bisectRightBy<T, V extends Comparable<Object>>(
  List<T> list,
  V value,
  V Function(T) accessor, {
  int lo = 0,
  int? hi,
}) {
  var hiValue = hi ?? list.length;

  while (lo < hiValue) {
    final mid = (lo + hiValue) ~/ 2;
    if (accessor(list[mid]).compareTo(value) > 0) {
      hiValue = mid;
    } else {
      lo = mid + 1;
    }
  }

  return lo;
}

/// Alias for bisectRight.
int bisect<T extends Comparable<Object>>(
  List<T> list,
  T value, {
  int lo = 0,
  int? hi,
}) {
  return bisectRight(list, value, lo: lo, hi: hi);
}

/// Returns the index of the closest element to [value] in [list].
/// Returns -1 if the list is empty.
int bisectCenter<T extends Comparable<Object>>(
  List<T> list,
  T value, {
  int lo = 0,
  int? hi,
}) {
  final hiValue = hi ?? list.length;

  if (lo >= hiValue) return -1;

  final i = bisectLeft(list, value, lo: lo, hi: hiValue);

  if (i == 0) return 0;
  if (i == hiValue) return hiValue - 1;

  // Compare distances to left and right neighbors
  final left = list[i - 1];
  final right = list[i];

  // This is approximate for non-numeric types
  if (value.compareTo(left) == value.compareTo(right)) {
    return i;
  }

  return i - 1;
}

/// Creates a bisector with custom comparison.
class Bisector<T, V extends Comparable<Object>> {
  final V Function(T) accessor;

  const Bisector(this.accessor);

  /// Finds the leftmost insertion point.
  int left(List<T> list, V value, {int lo = 0, int? hi}) {
    return bisectLeftBy(list, value, accessor, lo: lo, hi: hi);
  }

  /// Finds the rightmost insertion point.
  int right(List<T> list, V value, {int lo = 0, int? hi}) {
    return bisectRightBy(list, value, accessor, lo: lo, hi: hi);
  }

  /// Finds the center (closest element).
  int center(List<T> list, V value, {int lo = 0, int? hi}) {
    final hiValue = hi ?? list.length;

    if (lo >= hiValue) return -1;

    final i = left(list, value, lo: lo, hi: hiValue);

    if (i == 0) return 0;
    if (i == hiValue) return hiValue - 1;

    return i - 1;
  }
}

/// Creates a number bisector for common use cases.
Bisector<T, num> bisectorNum<T>(num Function(T) accessor) {
  return Bisector<T, num>(accessor);
}

/// Creates a DateTime bisector for time series data.
Bisector<T, DateTime> bisectorDate<T>(DateTime Function(T) accessor) {
  return Bisector<T, DateTime>(accessor);
}
