import 'dart:math' as math;

/// Random number generator with various distributions.
class RandomGenerator {
  final math.Random _random;

  /// Creates a random generator with an optional seed.
  RandomGenerator([int? seed]) : _random = math.Random(seed);

  /// Generates a random double between [min] and [max].
  double uniform(double min, double max) {
    return min + _random.nextDouble() * (max - min);
  }

  /// Generates a random integer between [min] (inclusive) and [max] (exclusive).
  int uniformInt(int min, int max) {
    return min + _random.nextInt(max - min);
  }

  /// Generates a random value from a normal (Gaussian) distribution.
  double normal(double mean, double stdDev) {
    // Box-Muller transform
    final u1 = _random.nextDouble();
    final u2 = _random.nextDouble();
    final z = math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2);
    return mean + z * stdDev;
  }

  /// Generates a random value from an exponential distribution.
  double exponential(double lambda) {
    return -math.log(1 - _random.nextDouble()) / lambda;
  }

  /// Generates a random value from a Poisson distribution.
  int poisson(double lambda) {
    final l = math.exp(-lambda);
    int k = 0;
    double p = 1.0;

    do {
      k++;
      p *= _random.nextDouble();
    } while (p > l);

    return k - 1;
  }

  /// Generates a random value from a binomial distribution.
  int binomial(int n, double p) {
    int successes = 0;
    for (int i = 0; i < n; i++) {
      if (_random.nextDouble() < p) {
        successes++;
      }
    }
    return successes;
  }

  /// Generates a random value from a log-normal distribution.
  double logNormal(double mean, double stdDev) {
    return math.exp(normal(mean, stdDev));
  }

  /// Generates a random value from a beta distribution.
  double beta(double alpha, double betaParam) {
    final x = gamma(alpha);
    final y = gamma(betaParam);
    return x / (x + y);
  }

  /// Generates a random value from a gamma distribution.
  double gamma(double shape, [double scale = 1.0]) {
    if (shape < 1) {
      return gamma(shape + 1, scale) *
          math.pow(_random.nextDouble(), 1 / shape);
    }

    final d = shape - 1 / 3;
    final c = 1 / math.sqrt(9 * d);

    while (true) {
      double x, v;
      do {
        x = normal(0, 1);
        v = 1 + c * x;
      } while (v <= 0);

      v = v * v * v;
      final u = _random.nextDouble();

      if (u < 1 - 0.0331 * (x * x) * (x * x)) {
        return d * v * scale;
      }

      if (math.log(u) < 0.5 * x * x + d * (1 - v + math.log(v))) {
        return d * v * scale;
      }
    }
  }

  /// Generates a random value from a Pareto distribution.
  double pareto(double alpha, [double xMin = 1.0]) {
    return xMin / math.pow(_random.nextDouble(), 1 / alpha);
  }

  /// Generates a random value from a Weibull distribution.
  double weibull(double shape, double scale) {
    return scale * math.pow(-math.log(_random.nextDouble()), 1 / shape);
  }

  /// Generates a random value from a triangular distribution.
  double triangular(double min, double max, double mode) {
    final u = _random.nextDouble();
    final fc = (mode - min) / (max - min);

    if (u < fc) {
      return min + math.sqrt(u * (max - min) * (mode - min));
    } else {
      return max - math.sqrt((1 - u) * (max - min) * (max - mode));
    }
  }

  /// Generates a random boolean with the given probability of being true.
  bool boolean([double probability = 0.5]) {
    return _random.nextDouble() < probability;
  }

  /// Selects a random element from a list.
  T choice<T>(List<T> items) {
    return items[_random.nextInt(items.length)];
  }

  /// Selects a random element from a list with weights.
  T weightedChoice<T>(List<T> items, List<double> weights) {
    assert(items.length == weights.length);

    final totalWeight = weights.reduce((a, b) => a + b);
    var random = _random.nextDouble() * totalWeight;

    for (int i = 0; i < items.length; i++) {
      random -= weights[i];
      if (random <= 0) {
        return items[i];
      }
    }

    return items.last;
  }

  /// Shuffles a list in place and returns it.
  List<T> shuffle<T>(List<T> items) {
    for (int i = items.length - 1; i > 0; i--) {
      final j = _random.nextInt(i + 1);
      final temp = items[i];
      items[i] = items[j];
      items[j] = temp;
    }
    return items;
  }

  /// Samples n items from a list without replacement.
  List<T> sample<T>(List<T> items, int n) {
    assert(n <= items.length);

    final shuffled = List<T>.from(items);
    shuffle(shuffled);
    return shuffled.take(n).toList();
  }

  /// Generates a list of random values from a uniform distribution.
  List<double> uniformList(int count, double min, double max) {
    return List.generate(count, (_) => uniform(min, max));
  }

  /// Generates a list of random values from a normal distribution.
  List<double> normalList(int count, double mean, double stdDev) {
    return List.generate(count, (_) => normal(mean, stdDev));
  }

  /// Generates a random walk.
  List<double> randomWalk(int steps, {double start = 0, double stepSize = 1}) {
    final values = <double>[start];
    for (int i = 1; i < steps; i++) {
      final step = normal(0, stepSize);
      values.add(values.last + step);
    }
    return values;
  }

  /// Generates a random walk with drift.
  List<double> randomWalkWithDrift(
    int steps, {
    double start = 0,
    double drift = 0,
    double volatility = 1,
  }) {
    final values = <double>[start];
    for (int i = 1; i < steps; i++) {
      final step = drift + normal(0, volatility);
      values.add(values.last + step);
    }
    return values;
  }

  /// Generates Brownian motion (geometric random walk).
  List<double> brownianMotion(
    int steps, {
    double start = 100,
    double mu = 0.0001,
    double sigma = 0.02,
    double dt = 1,
  }) {
    final values = <double>[start];
    for (int i = 1; i < steps; i++) {
      final drift = (mu - 0.5 * sigma * sigma) * dt;
      final diffusion = sigma * math.sqrt(dt) * normal(0, 1);
      values.add(values.last * math.exp(drift + diffusion));
    }
    return values;
  }

  /// Generates autocorrelated noise.
  List<double> autocorrelatedNoise(int count, double correlation,
      {double stdDev = 1}) {
    final values = <double>[normal(0, stdDev)];
    for (int i = 1; i < count; i++) {
      values.add(
        correlation * values.last +
            math.sqrt(1 - correlation * correlation) * normal(0, stdDev),
      );
    }
    return values;
  }

  /// Generates a random UUID.
  String uuid() {
    final bytes = List.generate(16, (_) => _random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;

    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  /// Generates a random color.
  int randomColor({int? alpha}) {
    final a = alpha ?? _random.nextInt(256);
    final r = _random.nextInt(256);
    final g = _random.nextInt(256);
    final b = _random.nextInt(256);
    return (a << 24) | (r << 16) | (g << 8) | b;
  }
}
