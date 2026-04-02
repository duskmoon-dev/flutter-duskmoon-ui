import 'package:duskmoon_visualization/src/vendor/dv_vendor/dv_vendor.dart';

import 'continuous_scale.dart';

/// A time scale maps DateTime values to a continuous range.
class TimeScale {
  List<DateTime> _domain;
  List<double> _range;
  bool _clamp;

  /// Creates a time scale with the given parameters.
  TimeScale({
    List<DateTime>? domain,
    List<double>? range,
    bool clamp = false,
  })  : _domain = domain ?? [DateTime(2000), DateTime(2001)],
        _range = range ?? [0, 1],
        _clamp = clamp;

  /// The input domain of DateTime values.
  List<DateTime> get domain => List.unmodifiable(_domain);
  set domain(List<DateTime> value) {
    assert(value.length >= 2, 'Domain must have at least 2 values');
    _domain = List.from(value);
  }

  /// The output range.
  List<double> get range => List.unmodifiable(_range);
  set range(List<double> value) {
    assert(value.length >= 2, 'Range must have at least 2 values');
    _range = List.from(value);
  }

  /// Whether output values are clamped.
  bool get clamp => _clamp;
  set clamp(bool value) => _clamp = value;

  /// Maps a DateTime to a range value.
  double call(DateTime value) {
    final d0 = _domain[0].millisecondsSinceEpoch.toDouble();
    final d1 = _domain[1].millisecondsSinceEpoch.toDouble();
    final r0 = _range[0];
    final r1 = _range[1];
    final v = value.millisecondsSinceEpoch.toDouble();

    double t = normalize(v, d0, d1);

    if (_clamp) {
      t = t.clamp(0.0, 1.0);
    }

    return interpolateNumber(r0, r1)(t).toDouble();
  }

  /// Maps a range value back to a DateTime.
  DateTime invert(double value) {
    final d0 = _domain[0].millisecondsSinceEpoch.toDouble();
    final d1 = _domain[1].millisecondsSinceEpoch.toDouble();
    final r0 = _range[0];
    final r1 = _range[1];

    double t = normalize(value, r0, r1);

    if (_clamp) {
      t = t.clamp(0.0, 1.0);
    }

    final ms = interpolateNumber(d0, d1)(t);
    return DateTime.fromMillisecondsSinceEpoch(ms.round());
  }

  /// Returns tick values as DateTime objects.
  List<DateTime> ticks([int count = 10]) {
    final d0 = _domain[0];
    final d1 = _domain[1];
    final span = d1.difference(d0);

    // Determine appropriate interval
    final interval = _selectInterval(span, count);
    return _generateTicks(d0, d1, interval, count);
  }

  Duration _selectInterval(Duration span, int count) {
    final ms = span.inMilliseconds;
    final step = ms / count;

    // Common time intervals
    const intervals = [
      Duration(milliseconds: 1),
      Duration(milliseconds: 5),
      Duration(milliseconds: 10),
      Duration(milliseconds: 50),
      Duration(milliseconds: 100),
      Duration(milliseconds: 500),
      Duration(seconds: 1),
      Duration(seconds: 5),
      Duration(seconds: 15),
      Duration(seconds: 30),
      Duration(minutes: 1),
      Duration(minutes: 5),
      Duration(minutes: 15),
      Duration(minutes: 30),
      Duration(hours: 1),
      Duration(hours: 3),
      Duration(hours: 6),
      Duration(hours: 12),
      Duration(days: 1),
      Duration(days: 2),
      Duration(days: 7),
      Duration(days: 14),
      Duration(days: 30),
      Duration(days: 90),
      Duration(days: 180),
      Duration(days: 365),
    ];

    for (final interval in intervals) {
      if (interval.inMilliseconds >= step) {
        return interval;
      }
    }

    return const Duration(days: 365);
  }

  List<DateTime> _generateTicks(
    DateTime start,
    DateTime end,
    Duration interval,
    int count,
  ) {
    final ticks = <DateTime>[];

    // Round start to interval
    DateTime current = _floorToInterval(start, interval);

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      if (current.isAfter(start) || current.isAtSameMomentAs(start)) {
        ticks.add(current);
      }
      current = current.add(interval);
    }

    return ticks;
  }

  DateTime _floorToInterval(DateTime date, Duration interval) {
    final ms = date.millisecondsSinceEpoch;
    final intervalMs = interval.inMilliseconds;
    final floored = (ms ~/ intervalMs) * intervalMs;
    return DateTime.fromMillisecondsSinceEpoch(floored);
  }

  /// Returns nicely rounded domain values.
  TimeScale nice([int count = 10]) {
    final span = _domain.last.difference(_domain.first);
    final interval = _selectInterval(span, count);

    _domain[0] = _floorToInterval(_domain[0], interval);
    _domain[_domain.length - 1] = _ceilToInterval(_domain.last, interval);

    return this;
  }

  DateTime _ceilToInterval(DateTime date, Duration interval) {
    final floored = _floorToInterval(date, interval);
    if (floored.isAtSameMomentAs(date)) return date;
    return floored.add(interval);
  }

  /// Returns a tick format function.
  String Function(DateTime) tickFormat([int count = 10]) {
    final span = _domain.last.difference(_domain.first);

    if (span.inDays > 365) {
      return (DateTime d) => '${d.year}';
    } else if (span.inDays > 30) {
      return (DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}';
    } else if (span.inDays > 1) {
      return (DateTime d) => '${d.month}/${d.day}';
    } else if (span.inHours > 1) {
      return (DateTime d) =>
          '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    } else {
      return (DateTime d) =>
          '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}:${d.second.toString().padLeft(2, '0')}';
    }
  }

  /// Creates a copy of this scale.
  TimeScale copy() {
    return TimeScale(
      domain: List.from(_domain),
      range: List.from(_range),
      clamp: _clamp,
    );
  }
}

/// Creates a time scale.
TimeScale scaleTime({
  List<DateTime>? domain,
  List<double>? range,
  bool clamp = false,
}) {
  return TimeScale(
    domain: domain,
    range: range,
    clamp: clamp,
  );
}
