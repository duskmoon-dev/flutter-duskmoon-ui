import 'dart:math' as math;

import 'random_generator.dart';

/// Data point for time series.
class TimeSeriesPoint {
  final DateTime timestamp;
  final double value;
  final Map<String, dynamic>? metadata;

  const TimeSeriesPoint({
    required this.timestamp,
    required this.value,
    this.metadata,
  });
}

/// Generator for time series data.
class TimeSeriesGenerator {
  final RandomGenerator _random;

  /// Creates a time series generator with an optional seed.
  TimeSeriesGenerator([int? seed]) : _random = RandomGenerator(seed);

  /// Generates a simple linear trend.
  List<TimeSeriesPoint> linear({
    required DateTime start,
    required DateTime end,
    required Duration interval,
    double startValue = 0,
    double slope = 1,
    double noise = 0,
  }) {
    final points = <TimeSeriesPoint>[];
    var current = start;
    int step = 0;

    while (!current.isAfter(end)) {
      final value = startValue + slope * step + _random.normal(0, noise);
      points.add(TimeSeriesPoint(timestamp: current, value: value));
      current = current.add(interval);
      step++;
    }

    return points;
  }

  /// Generates a sinusoidal pattern.
  List<TimeSeriesPoint> sinusoidal({
    required DateTime start,
    required DateTime end,
    required Duration interval,
    double amplitude = 10,
    double frequency = 1,
    double phase = 0,
    double offset = 50,
    double noise = 0,
  }) {
    final points = <TimeSeriesPoint>[];
    var current = start;
    int step = 0;

    while (!current.isAfter(end)) {
      final t = step * 2 * math.pi * frequency / 100;
      final value =
          offset + amplitude * math.sin(t + phase) + _random.normal(0, noise);
      points.add(TimeSeriesPoint(timestamp: current, value: value));
      current = current.add(interval);
      step++;
    }

    return points;
  }

  /// Generates a random walk time series.
  List<TimeSeriesPoint> randomWalk({
    required DateTime start,
    required DateTime end,
    required Duration interval,
    double startValue = 100,
    double stepSize = 1,
  }) {
    final points = <TimeSeriesPoint>[];
    var current = start;
    var value = startValue;

    while (!current.isAfter(end)) {
      points.add(TimeSeriesPoint(timestamp: current, value: value));
      value += _random.normal(0, stepSize);
      current = current.add(interval);
    }

    return points;
  }

  /// Generates stock-like price data using geometric Brownian motion.
  List<TimeSeriesPoint> stockPrice({
    required DateTime start,
    required DateTime end,
    required Duration interval,
    double startPrice = 100,
    double annualReturn = 0.1,
    double annualVolatility = 0.2,
  }) {
    final points = <TimeSeriesPoint>[];
    var current = start;
    var price = startPrice;

    // Calculate per-interval parameters
    final totalIntervals = end.difference(start).inMinutes / interval.inMinutes;
    final dt = 1 / totalIntervals;
    final mu = annualReturn;
    final sigma = annualVolatility;

    while (!current.isAfter(end)) {
      points.add(TimeSeriesPoint(timestamp: current, value: price));

      final drift = (mu - 0.5 * sigma * sigma) * dt;
      final diffusion = sigma * math.sqrt(dt) * _random.normal(0, 1);
      price = price * math.exp(drift + diffusion);

      current = current.add(interval);
    }

    return points;
  }

  /// Generates data with seasonal patterns.
  List<TimeSeriesPoint> seasonal({
    required DateTime start,
    required DateTime end,
    required Duration interval,
    double baseValue = 100,
    double trend = 0,
    List<double>? dailyPattern,
    List<double>? weeklyPattern,
    List<double>? monthlyPattern,
    double noise = 0,
  }) {
    final points = <TimeSeriesPoint>[];
    var current = start;
    int step = 0;

    // Default patterns
    final daily = dailyPattern ??
        [
          0.8,
          0.7,
          0.6,
          0.5,
          0.5,
          0.6,
          0.8,
          1.0,
          1.2,
          1.3,
          1.2,
          1.1,
          1.2,
          1.3,
          1.2,
          1.1,
          1.0,
          0.9,
          1.0,
          1.1,
          1.0,
          0.9,
          0.9,
          0.8
        ];

    final weekly = weeklyPattern ?? [1.0, 1.1, 1.1, 1.0, 0.9, 0.8, 0.7];

    final monthly = monthlyPattern ??
        [0.9, 0.85, 0.9, 0.95, 1.0, 1.1, 1.15, 1.1, 1.0, 0.95, 1.0, 1.1];

    while (!current.isAfter(end)) {
      final hourFactor = daily[current.hour % 24];
      final dayFactor = weekly[current.weekday - 1];
      final monthFactor = monthly[current.month - 1];

      final value =
          (baseValue + trend * step) * hourFactor * dayFactor * monthFactor +
              _random.normal(0, noise);

      points.add(TimeSeriesPoint(timestamp: current, value: value));
      current = current.add(interval);
      step++;
    }

    return points;
  }

  /// Generates data with step changes (regime shifts).
  List<TimeSeriesPoint> stepChanges({
    required DateTime start,
    required DateTime end,
    required Duration interval,
    required List<DateTime> changePoints,
    required List<double> levels,
    double noise = 0,
  }) {
    assert(changePoints.length == levels.length - 1);

    final points = <TimeSeriesPoint>[];
    var current = start;
    int levelIndex = 0;

    while (!current.isAfter(end)) {
      // Check if we need to change level
      while (levelIndex < changePoints.length &&
          current.isAfter(changePoints[levelIndex])) {
        levelIndex++;
      }

      final value = levels[levelIndex] + _random.normal(0, noise);
      points.add(TimeSeriesPoint(timestamp: current, value: value));
      current = current.add(interval);
    }

    return points;
  }

  /// Generates data with spikes/anomalies.
  List<TimeSeriesPoint> withSpikes({
    required DateTime start,
    required DateTime end,
    required Duration interval,
    double baseValue = 100,
    double spikeProbability = 0.05,
    double spikeMultiplier = 3,
    double noise = 5,
  }) {
    final points = <TimeSeriesPoint>[];
    var current = start;

    while (!current.isAfter(end)) {
      var value = baseValue + _random.normal(0, noise);

      if (_random.boolean(spikeProbability)) {
        value += _random.uniform(1, spikeMultiplier) *
            (_random.boolean() ? 1 : -1) *
            noise *
            3;
      }

      points.add(TimeSeriesPoint(timestamp: current, value: value));
      current = current.add(interval);
    }

    return points;
  }

  /// Generates multiple correlated time series.
  List<List<TimeSeriesPoint>> correlated({
    required DateTime start,
    required DateTime end,
    required Duration interval,
    required int seriesCount,
    double correlation = 0.8,
    double mean = 100,
    double stdDev = 10,
  }) {
    // Generate base series
    final baseSeries = <double>[];
    var current = start;
    while (!current.isAfter(end)) {
      baseSeries.add(_random.normal(0, 1));
      current = current.add(interval);
    }

    // Generate correlated series
    final allSeries = <List<TimeSeriesPoint>>[];
    for (int s = 0; s < seriesCount; s++) {
      final points = <TimeSeriesPoint>[];
      current = start;
      int i = 0;

      while (!current.isAfter(end)) {
        final noise = _random.normal(0, 1);
        final value = mean +
            stdDev *
                (correlation * baseSeries[i] +
                    math.sqrt(1 - correlation * correlation) * noise);

        points.add(TimeSeriesPoint(timestamp: current, value: value));
        current = current.add(interval);
        i++;
      }

      allSeries.add(points);
    }

    return allSeries;
  }

  /// Generates OHLC (Open-High-Low-Close) candlestick data.
  List<OHLCPoint> ohlc({
    required DateTime start,
    required DateTime end,
    required Duration interval,
    double startPrice = 100,
    double volatility = 0.02,
  }) {
    final points = <OHLCPoint>[];
    var current = start;
    var previousClose = startPrice;

    while (!current.isAfter(end)) {
      final open = previousClose * (1 + _random.normal(0, volatility / 2));
      final close = open * (1 + _random.normal(0, volatility));

      final highOffset = _random.exponential(1 / volatility) * 0.5;
      final lowOffset = _random.exponential(1 / volatility) * 0.5;

      final high = math.max(open, close) * (1 + highOffset);
      final low = math.min(open, close) * (1 - lowOffset);

      final volume = _random.exponential(0.0001).toInt() + 1000;

      points.add(OHLCPoint(
        timestamp: current,
        open: open,
        high: high,
        low: low,
        close: close,
        volume: volume,
      ));

      previousClose = close;
      current = current.add(interval);
    }

    return points;
  }

  /// Generates cumulative sum data.
  List<TimeSeriesPoint> cumulative({
    required DateTime start,
    required DateTime end,
    required Duration interval,
    double startValue = 0,
    double incrementMean = 1,
    double incrementStdDev = 0.5,
  }) {
    final points = <TimeSeriesPoint>[];
    var current = start;
    var value = startValue;

    while (!current.isAfter(end)) {
      points.add(TimeSeriesPoint(timestamp: current, value: value));
      value += _random.normal(incrementMean, incrementStdDev).abs();
      current = current.add(interval);
    }

    return points;
  }

  /// Generates mean-reverting time series (Ornstein-Uhlenbeck process).
  List<TimeSeriesPoint> meanReverting({
    required DateTime start,
    required DateTime end,
    required Duration interval,
    double mean = 100,
    double theta = 0.1,
    double sigma = 5,
    double? startValue,
  }) {
    final points = <TimeSeriesPoint>[];
    var current = start;
    var value = startValue ?? mean;

    while (!current.isAfter(end)) {
      points.add(TimeSeriesPoint(timestamp: current, value: value));

      // Ornstein-Uhlenbeck update
      const dt = 1.0;
      value = value +
          theta * (mean - value) * dt +
          sigma * math.sqrt(dt) * _random.normal(0, 1);

      current = current.add(interval);
    }

    return points;
  }
}

/// OHLC (Open-High-Low-Close) data point.
class OHLCPoint {
  final DateTime timestamp;
  final double open;
  final double high;
  final double low;
  final double close;
  final int? volume;

  const OHLCPoint({
    required this.timestamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    this.volume,
  });

  /// Whether this candle is bullish (close > open).
  bool get isBullish => close >= open;

  /// The range (high - low).
  double get range => high - low;

  /// The body size (absolute difference between open and close).
  double get bodySize => (close - open).abs();
}
