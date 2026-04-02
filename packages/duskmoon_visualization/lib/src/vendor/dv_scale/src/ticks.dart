import 'dart:math' as math;

/// Calculates the step size for tick generation.
double tickStep(double start, double stop, int count) {
  if (count <= 0) return 0;

  final step0 = (stop - start).abs() / count;
  var step1 = math.pow(10, (math.log(step0) / math.ln10).floor());
  final error = step0 / step1;

  if (error >= _e10) {
    step1 *= 10;
  } else if (error >= _e5) {
    step1 *= 5;
  } else if (error >= _e2) {
    step1 *= 2;
  }

  return stop < start ? -step1.toDouble() : step1.toDouble();
}

const _e10 = math.sqrt2 * math.sqrt2 * math.sqrt2 * math.sqrt2 * math.sqrt2;
const _e5 = math.sqrt2 * math.sqrt2;
const _e2 = math.sqrt2;

/// Generates tick values for a linear scale.
List<double> linearTicks(double start, double stop, [int count = 10]) {
  if (count <= 0) return [];

  final reverse = stop < start;
  if (reverse) {
    final temp = start;
    start = stop;
    stop = temp;
  }

  final step = tickStep(start, stop, count);
  if (step == 0 || !step.isFinite) return [];

  final ticks = <double>[];

  if (step > 0) {
    final r0 = (start / step).ceil();
    final r1 = (stop / step).floor();
    final n = r1 - r0 + 1;

    for (int i = 0; i < n; i++) {
      ticks.add((r0 + i) * step);
    }
  } else {
    final r0 = (start * step).floor();
    final r1 = (stop * step).ceil();
    final n = r0 - r1 + 1;

    for (int i = 0; i < n; i++) {
      ticks.add((r0 - i) / step);
    }
  }

  return reverse ? ticks.reversed.toList() : ticks;
}

/// Creates a tick format function.
String Function(double) linearTickFormat(
  double start,
  double stop,
  int count, [
  String? specifier,
]) {
  final step = tickStep(start, stop, count);

  if (specifier != null) {
    // Handle format specifier if provided
    return (double value) => value.toStringAsFixed(
          _precisionFromStep(step),
        );
  }

  final precision = _precisionFromStep(step);

  return (double value) {
    if (precision <= 0) {
      return value.round().toString();
    }
    return value.toStringAsFixed(precision);
  };
}

int _precisionFromStep(double step) {
  if (step == 0 || !step.isFinite) return 0;

  final absStep = step.abs();
  if (absStep >= 1) return 0;

  final log = -((math.log(absStep) / math.ln10).floor());
  return log.clamp(0, 20);
}

/// Adjusts ticks for nice round values.
List<double> niceTicks(double start, double stop, int count) {
  final step = tickStep(start, stop, count);

  if (step > 0) {
    start = (start / step).floor() * step;
    stop = (stop / step).ceil() * step;
  } else if (step < 0) {
    start = (start * step).ceil() / step;
    stop = (stop * step).floor() / step;
  }

  return linearTicks(start, stop, count);
}

/// Generates tick values for a log scale.
List<double> logTicks(double start, double stop, int count,
    [double base = 10]) {
  final logs = math.log(base);
  var u = start;
  var v = stop;

  final r = v < u;
  if (r) {
    final temp = u;
    u = v;
    v = temp;
  }

  var i = (math.log(u) / logs).floor();
  final j = (math.log(v) / logs).ceil();

  final ticks = <double>[];

  if (base % 1 == 0) {
    final k = base.toInt();
    if (j - i < count) {
      for (; i <= j; ++i) {
        for (int p = 1; p < k; ++p) {
          double t;
          if (i < 0) {
            t = p / math.pow(base, -i);
          } else {
            t = p * math.pow(base, i).toDouble();
          }
          if (t < u) continue;
          if (t > v) break;
          ticks.add(t);
        }
      }
    } else {
      for (; i <= j; ++i) {
        ticks.add(math.pow(base, i).toDouble());
      }
    }
  } else {
    for (; i <= j; ++i) {
      ticks.add(math.pow(base, i).toDouble());
    }
  }

  return r ? ticks.reversed.toList() : ticks;
}

/// Calculates tick increment for integer values.
int tickIncrement(int start, int stop, int count) {
  final step = (stop - start) / count;
  final power = (math.log(step) / math.ln10).floor();
  final error = step / math.pow(10, power);

  int factor;
  if (error >= _e10) {
    factor = 10;
  } else if (error >= _e5) {
    factor = 5;
  } else if (error >= _e2) {
    factor = 2;
  } else {
    factor = 1;
  }

  if (power >= 0) {
    return (factor * math.pow(10, power)).toInt();
  } else {
    return -(math.pow(10, -power) / factor).toInt();
  }
}
