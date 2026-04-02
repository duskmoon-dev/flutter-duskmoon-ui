import 'dart:math' as math;

/// An interpolator function type.
typedef Interpolator<T> = T Function(double t);

/// A simple ARGB color representation for pure Dart usage.
class ArgbColor {
  final int alpha;
  final int red;
  final int green;
  final int blue;

  const ArgbColor(this.alpha, this.red, this.green, this.blue);

  /// Creates a color from a 32-bit ARGB value.
  factory ArgbColor.fromARGB(int a, int r, int g, int b) {
    return ArgbColor(a, r, g, b);
  }

  /// Creates a color from a 32-bit integer value (0xAARRGGBB format).
  factory ArgbColor.fromValue(int value) {
    return ArgbColor(
      (value >> 24) & 0xFF,
      (value >> 16) & 0xFF,
      (value >> 8) & 0xFF,
      value & 0xFF,
    );
  }

  /// Returns the color as a 32-bit integer value.
  int get value => (alpha << 24) | (red << 16) | (green << 8) | blue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArgbColor &&
          alpha == other.alpha &&
          red == other.red &&
          green == other.green &&
          blue == other.blue;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() =>
      'ArgbColor(alpha: $alpha, red: $red, green: $green, blue: $blue)';
}

/// Creates a number interpolator between [a] and [b].
Interpolator<num> interpolateNumber(num a, num b) {
  return (double t) => a + (b - a) * t;
}

/// Creates a double interpolator between [a] and [b].
Interpolator<double> interpolateDouble(double a, double b) {
  return (double t) => a + (b - a) * t;
}

/// Creates an integer interpolator between [a] and [b].
/// Rounds the result to the nearest integer.
Interpolator<int> interpolateInt(int a, int b) {
  return (double t) => (a + (b - a) * t).round();
}

/// Creates an RGB color interpolator between [a] and [b].
Interpolator<ArgbColor> interpolateRgb(ArgbColor a, ArgbColor b) {
  final ar = a.red;
  final ag = a.green;
  final ab = a.blue;
  final aa = a.alpha;

  final br = b.red - ar;
  final bg = b.green - ag;
  final bb = b.blue - ab;
  final ba = b.alpha - aa;

  return (double t) => ArgbColor.fromARGB(
        (aa + ba * t).round().clamp(0, 255),
        (ar + br * t).round().clamp(0, 255),
        (ag + bg * t).round().clamp(0, 255),
        (ab + bb * t).round().clamp(0, 255),
      );
}

/// Creates an RGB color interpolator with gamma correction.
Interpolator<ArgbColor> interpolateRgbGamma(ArgbColor a, ArgbColor b,
    {double gamma = 1.0}) {
  final g = gamma;
  final invGamma = 1 / gamma;

  // Apply gamma correction to input colors
  final ar = math.pow(a.red / 255, g);
  final ag = math.pow(a.green / 255, g);
  final ab = math.pow(a.blue / 255, g);
  final aa = a.alpha / 255;

  final br = math.pow(b.red / 255, g) - ar;
  final bg = math.pow(b.green / 255, g) - ag;
  final bb = math.pow(b.blue / 255, g) - ab;
  final ba = b.alpha / 255 - aa;

  return (double t) {
    final r = math.pow(ar + br * t, invGamma);
    final gVal = math.pow(ag + bg * t, invGamma);
    final bVal = math.pow(ab + bb * t, invGamma);
    final aVal = aa + ba * t;

    return ArgbColor.fromARGB(
      (aVal * 255).round().clamp(0, 255),
      (r * 255).round().clamp(0, 255),
      (gVal * 255).round().clamp(0, 255),
      (bVal * 255).round().clamp(0, 255),
    );
  };
}

/// Creates a number array interpolator between [a] and [b].
/// Both arrays must have the same length.
Interpolator<List<num>> interpolateNumberArray(List<num> a, List<num> b) {
  assert(a.length == b.length, 'Arrays must have the same length');

  final n = a.length;
  final result = List<num>.filled(n, 0);

  return (double t) {
    for (int i = 0; i < n; i++) {
      result[i] = a[i] + (b[i] - a[i]) * t;
    }
    return List<num>.from(result);
  };
}

/// Creates a double array interpolator between [a] and [b].
Interpolator<List<double>> interpolateDoubleArray(
    List<double> a, List<double> b) {
  assert(a.length == b.length, 'Arrays must have the same length');

  final n = a.length;

  return (double t) {
    final result = List<double>.filled(n, 0);
    for (int i = 0; i < n; i++) {
      result[i] = a[i] + (b[i] - a[i]) * t;
    }
    return result;
  };
}

/// Creates a string interpolator that interpolates numbers within strings.
Interpolator<String> interpolateString(String a, String b) {
  // Find numeric parts in the strings
  final numPattern = RegExp(r'[-+]?(?:\d+\.?\d*|\.\d+)(?:[eE][-+]?\d+)?');

  final aMatches = numPattern.allMatches(a).toList();
  final bMatches = numPattern.allMatches(b).toList();

  if (aMatches.isEmpty || bMatches.isEmpty) {
    return (double t) => t < 0.5 ? a : b;
  }

  // Extract numbers and create interpolators
  final aNumbers = aMatches.map((m) => double.parse(m.group(0)!)).toList();
  final bNumbers = bMatches.map((m) => double.parse(m.group(0)!)).toList();

  final n = math.min(aNumbers.length, bNumbers.length);
  final interpolators = <Interpolator<double>>[];

  for (int i = 0; i < n; i++) {
    interpolators.add(interpolateDouble(aNumbers[i], bNumbers[i]));
  }

  // Get the template from b
  final parts = <String>[];
  int lastEnd = 0;
  for (final match in bMatches.take(n)) {
    parts.add(b.substring(lastEnd, match.start));
    lastEnd = match.end;
  }
  parts.add(b.substring(lastEnd));

  return (double t) {
    final buffer = StringBuffer();
    for (int i = 0; i < n; i++) {
      buffer.write(parts[i]);
      buffer.write(interpolators[i](t));
    }
    buffer.write(parts.last);
    return buffer.toString();
  };
}

/// Creates a date interpolator between [a] and [b].
Interpolator<DateTime> interpolateDate(DateTime a, DateTime b) {
  final aMs = a.millisecondsSinceEpoch;
  final bMs = b.millisecondsSinceEpoch;

  return (double t) =>
      DateTime.fromMillisecondsSinceEpoch((aMs + (bMs - aMs) * t).round());
}

/// Creates a round interpolator that rounds to the nearest integer.
Interpolator<num> interpolateRound(num a, num b) {
  return (double t) => (a + (b - a) * t).round();
}

/// Creates a discrete interpolator that returns values at specific thresholds.
Interpolator<T> interpolateDiscrete<T>(List<T> values) {
  final n = values.length;
  return (double t) {
    final index = (t * n).floor().clamp(0, n - 1);
    return values[index];
  };
}

/// Creates a hue interpolator for color hue values.
Interpolator<double> interpolateHue(double a, double b) {
  double d = b - a;
  if (d > 180 || d < -180) {
    d -= 360 * (d / 360).round();
  }
  return (double t) => (a + d * t) % 360;
}

/// Creates an exponential interpolator.
Interpolator<double> interpolateExp(double a, double b) {
  if (a <= 0 || b <= 0) {
    return interpolateDouble(a, b);
  }

  final la = math.log(a);
  final lb = math.log(b);

  return (double t) => math.exp(la + (lb - la) * t);
}

/// Clamps the interpolation parameter to [0, 1].
Interpolator<T> clamp<T>(Interpolator<T> interpolator) {
  return (double t) => interpolator(t.clamp(0.0, 1.0));
}

/// Creates a piecewise interpolator from a list of values.
Interpolator<T> piecewise<T>(
  List<T> values,
  Interpolator<T> Function(T, T) interpolate,
) {
  final n = values.length - 1;

  return (double t) {
    if (t <= 0) return values.first;
    if (t >= 1) return values.last;

    final i = (t * n).floor();
    final localT = t * n - i;

    return interpolate(values[i], values[i + 1])(localT);
  };
}

/// Creates a basis spline interpolator.
Interpolator<double> interpolateBasis(List<double> values) {
  final n = values.length - 1;

  double basis(double t1, double v0, double v1, double v2, double v3) {
    final t2 = t1 * t1;
    final t3 = t2 * t1;
    return ((1 - 3 * t1 + 3 * t2 - t3) * v0 +
            (4 - 6 * t2 + 3 * t3) * v1 +
            (1 + 3 * t1 + 3 * t2 - 3 * t3) * v2 +
            t3 * v3) /
        6;
  }

  return (double t) {
    if (t <= 0) return values.first;
    if (t >= 1) return values.last;

    final i = (t * n).floor();
    final localT = t * n - i;

    final v0 = i > 0 ? values[i - 1] : 2 * values[i] - values[i + 1];
    final v1 = values[i];
    final v2 = values[i + 1];
    final v3 = i < n - 1 ? values[i + 2] : 2 * values[i + 1] - values[i];

    return basis(localT, v0, v1, v2, v3);
  };
}

/// Creates a closed basis spline interpolator.
Interpolator<double> interpolateBasisClosed(List<double> values) {
  final n = values.length;

  double basis(double t1, double v0, double v1, double v2, double v3) {
    final t2 = t1 * t1;
    final t3 = t2 * t1;
    return ((1 - 3 * t1 + 3 * t2 - t3) * v0 +
            (4 - 6 * t2 + 3 * t3) * v1 +
            (1 + 3 * t1 + 3 * t2 - 3 * t3) * v2 +
            t3 * v3) /
        6;
  }

  return (double t) {
    final i = ((t % 1) * n).floor();
    final localT = (t * n) % 1;

    final v0 = values[(i - 1 + n) % n];
    final v1 = values[i % n];
    final v2 = values[(i + 1) % n];
    final v3 = values[(i + 2) % n];

    return basis(localT, v0, v1, v2, v3);
  };
}

/// Quantizes an interpolator into discrete steps.
List<T> quantize<T>(Interpolator<T> interpolator, int n) {
  return List<T>.generate(n, (i) => interpolator(i / (n - 1)));
}
