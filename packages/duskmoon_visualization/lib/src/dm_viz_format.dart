import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'dm_viz_series.dart';

bool _locationsReady = false;

tz.Location _location(String name) {
  if (name == 'UTC') return tz.UTC;
  if (!_locationsReady) {
    tzdata.initializeTimeZones();
    _locationsReady = true;
  }
  return tz.getLocation(name);
}

bool validVizFormat(DmVizAxis axis) {
  final format = axis.format;
  if (format == null) return true;
  final validStyle = switch (axis.type) {
    DmVizAxisType.numeric => format.style == DmVizFormatStyle.decimal,
    DmVizAxisType.category => format.style == DmVizFormatStyle.label,
    DmVizAxisType.time => format.style == DmVizFormatStyle.utcIso ||
        format.style == DmVizFormatStyle.dateTime,
  };
  final digits = format.fractionDigits;
  if (!validStyle || (digits != null && (digits < 0 || digits > 12)))
    return false;
  try {
    if (format.locale case final locale?) {
      NumberFormat.decimalPattern(locale);
    }
    if (format.timeZone case final timeZone?) {
      _location(timeZone);
    }
    return true;
  } on ArgumentError {
    return false;
  } on tz.LocationNotFoundException {
    return false;
  }
}

String formatVizValue(
  Object value,
  DmVizAxis axis, {
  Map<String, String> labels = const {},
}) {
  final format = axis.format;
  switch (axis.type) {
    case DmVizAxisType.category:
      return labels[value] ?? value.toString();
    case DmVizAxisType.numeric:
      final number = value as num;
      final label = NumberFormat.decimalPattern(format?.locale ?? 'en-US')
        ..turnOffGrouping()
        ..maximumFractionDigits = format?.fractionDigits ?? 3;
      final result = label.format(number);
      final zero = label.format(0);
      return result == label.symbols.MINUS_SIGN + zero ? zero : result;
    case DmVizAxisType.time:
      final epoch = (value as num).toInt();
      if (format?.style != DmVizFormatStyle.dateTime) {
        return DateTime.fromMillisecondsSinceEpoch(
          epoch,
          isUtc: true,
        ).toIso8601String();
      }
      final time = tz.TZDateTime.fromMillisecondsSinceEpoch(
        _location(format?.timeZone ?? 'UTC'),
        epoch,
      );
      String two(int value) => value.toString().padLeft(2, '0');
      final minutes = time.timeZoneOffset.inMinutes;
      final offset =
          '${minutes < 0 ? '-' : '+'}${two(minutes.abs() ~/ 60)}:${two(minutes.abs() % 60)}';
      final date =
          '${time.year.toString().padLeft(4, '0')}-${two(time.month)}-${two(time.day)}';
      return '$date ${two(time.hour)}:${two(time.minute)}:${two(time.second)} $offset';
  }
}
