import 'dart:math' as math;

/// Result of a linear regression.
class LinearRegressionResult {
  /// The slope of the regression line.
  final double slope;

  /// The y-intercept of the regression line.
  final double intercept;

  /// The coefficient of determination (R-squared).
  final double rSquared;

  const LinearRegressionResult({
    required this.slope,
    required this.intercept,
    required this.rSquared,
  });

  /// Predicts the y value for a given x.
  double predict(double x) => slope * x + intercept;

  @override
  String toString() =>
      'LinearRegressionResult(slope: $slope, intercept: $intercept, r²: $rSquared)';
}

/// Computes simple linear regression for the given data points.
///
/// Returns the slope, intercept, and R-squared value.
/// Throws if there are fewer than 2 points.
LinearRegressionResult linearRegression(
  List<double> x,
  List<double> y,
) {
  if (x.length != y.length) {
    throw ArgumentError('x and y must have the same length');
  }
  if (x.length < 2) {
    throw ArgumentError('At least 2 points are required');
  }

  final n = x.length;

  // Calculate means
  double sumX = 0, sumY = 0;
  for (int i = 0; i < n; i++) {
    sumX += x[i];
    sumY += y[i];
  }
  final meanX = sumX / n;
  final meanY = sumY / n;

  // Calculate slope and intercept
  double ssXY = 0; // Sum of (xi - meanX)(yi - meanY)
  double ssXX = 0; // Sum of (xi - meanX)^2
  double ssYY = 0; // Sum of (yi - meanY)^2

  for (int i = 0; i < n; i++) {
    final dx = x[i] - meanX;
    final dy = y[i] - meanY;
    ssXY += dx * dy;
    ssXX += dx * dx;
    ssYY += dy * dy;
  }

  if (ssXX == 0) {
    // Vertical line - undefined slope
    return LinearRegressionResult(
      slope: double.infinity,
      intercept: double.nan,
      rSquared: 0,
    );
  }

  final slope = ssXY / ssXX;
  final intercept = meanY - slope * meanX;

  // Calculate R-squared
  double rSquared = 0;
  if (ssYY > 0) {
    rSquared = (ssXY * ssXY) / (ssXX * ssYY);
  }

  return LinearRegressionResult(
    slope: slope,
    intercept: intercept,
    rSquared: rSquared,
  );
}

/// Result of an exponential regression.
class ExponentialRegressionResult {
  /// The coefficient 'a' in y = a * e^(b*x).
  final double a;

  /// The exponent coefficient 'b' in y = a * e^(b*x).
  final double b;

  /// The coefficient of determination (R-squared).
  final double rSquared;

  const ExponentialRegressionResult({
    required this.a,
    required this.b,
    required this.rSquared,
  });

  /// Predicts the y value for a given x.
  double predict(double x) => a * math.exp(b * x);

  @override
  String toString() =>
      'ExponentialRegressionResult(a: $a, b: $b, r²: $rSquared)';
}

/// Computes exponential regression for the given data points.
///
/// Fits y = a * e^(b*x) by taking the log of y values and performing
/// linear regression on (x, ln(y)).
///
/// Note: All y values must be positive.
ExponentialRegressionResult exponentialRegression(
  List<double> x,
  List<double> y,
) {
  if (x.length != y.length) {
    throw ArgumentError('x and y must have the same length');
  }
  if (x.length < 2) {
    throw ArgumentError('At least 2 points are required');
  }

  // Filter out non-positive y values
  final validX = <double>[];
  final logY = <double>[];

  for (int i = 0; i < y.length; i++) {
    if (y[i] > 0) {
      validX.add(x[i]);
      logY.add(math.log(y[i]));
    }
  }

  if (validX.length < 2) {
    throw ArgumentError('At least 2 positive y values are required');
  }

  // Perform linear regression on (x, ln(y))
  final result = linearRegression(validX, logY);

  final a = math.exp(result.intercept);
  final b = result.slope;

  // Calculate R-squared for the exponential fit
  final n = validX.length;
  double sumY = 0;
  for (int i = 0; i < validX.length; i++) {
    sumY += y[x.indexOf(validX[i])];
  }
  final meanY = sumY / n;

  double ssTot = 0;
  double ssRes = 0;

  for (int i = 0; i < validX.length; i++) {
    final yi = y[x.indexOf(validX[i])];
    final predicted = a * math.exp(b * validX[i]);
    ssTot += (yi - meanY) * (yi - meanY);
    ssRes += (yi - predicted) * (yi - predicted);
  }

  final rSquared = ssTot > 0 ? 1 - (ssRes / ssTot) : 0.0;

  return ExponentialRegressionResult(
    a: a,
    b: b,
    rSquared: rSquared,
  );
}

/// Computes the simple moving average of a series.
///
/// [data] is the input time series.
/// [window] is the size of the moving window.
/// [center] if true, centers the window around each point (default: false).
///
/// Returns a list of the same length as [data], with null for positions
/// where the window doesn't fit (at the edges).
List<double?> movingAverage(
  List<double> data, {
  required int window,
  bool center = false,
}) {
  if (window < 1) {
    throw ArgumentError('Window size must be at least 1');
  }
  if (data.isEmpty) {
    return [];
  }

  final result = List<double?>.filled(data.length, null);

  if (center) {
    final halfWindow = window ~/ 2;
    for (int i = halfWindow; i < data.length - (window - 1 - halfWindow); i++) {
      double sum = 0;
      for (int j = i - halfWindow; j < i - halfWindow + window; j++) {
        sum += data[j];
      }
      result[i] = sum / window;
    }
  } else {
    // Trailing window
    for (int i = window - 1; i < data.length; i++) {
      double sum = 0;
      for (int j = i - window + 1; j <= i; j++) {
        sum += data[j];
      }
      result[i] = sum / window;
    }
  }

  return result;
}

/// Computes the exponential moving average of a series.
///
/// [data] is the input time series.
/// [alpha] is the smoothing factor (0 < alpha <= 1).
///   Higher alpha gives more weight to recent values.
///
/// Returns a list of the same length as [data].
List<double> exponentialMovingAverage(
  List<double> data, {
  required double alpha,
}) {
  if (alpha <= 0 || alpha > 1) {
    throw ArgumentError('Alpha must be in (0, 1]');
  }
  if (data.isEmpty) {
    return [];
  }

  final result = List<double>.filled(data.length, 0);
  result[0] = data[0];

  for (int i = 1; i < data.length; i++) {
    result[i] = alpha * data[i] + (1 - alpha) * result[i - 1];
  }

  return result;
}

/// Computes the Pearson correlation coefficient between two series.
///
/// Returns a value between -1 and 1, where:
/// - 1 indicates perfect positive correlation
/// - -1 indicates perfect negative correlation
/// - 0 indicates no linear correlation
double correlation(List<double> x, List<double> y) {
  if (x.length != y.length) {
    throw ArgumentError('x and y must have the same length');
  }
  if (x.length < 2) {
    throw ArgumentError('At least 2 points are required');
  }

  final n = x.length;

  // Calculate means
  double sumX = 0, sumY = 0;
  for (int i = 0; i < n; i++) {
    sumX += x[i];
    sumY += y[i];
  }
  final meanX = sumX / n;
  final meanY = sumY / n;

  // Calculate correlation components
  double ssXY = 0;
  double ssXX = 0;
  double ssYY = 0;

  for (int i = 0; i < n; i++) {
    final dx = x[i] - meanX;
    final dy = y[i] - meanY;
    ssXY += dx * dy;
    ssXX += dx * dx;
    ssYY += dy * dy;
  }

  if (ssXX == 0 || ssYY == 0) {
    return 0; // No variance in one or both variables
  }

  return ssXY / math.sqrt(ssXX * ssYY);
}

/// Computes the Spearman rank correlation coefficient.
///
/// This is a non-parametric measure of correlation that assesses
/// monotonic relationships.
double spearmanCorrelation(List<double> x, List<double> y) {
  if (x.length != y.length) {
    throw ArgumentError('x and y must have the same length');
  }
  if (x.length < 2) {
    throw ArgumentError('At least 2 points are required');
  }

  // Convert to ranks
  final rankX = _rank(x);
  final rankY = _rank(y);

  return correlation(rankX, rankY);
}

List<double> _rank(List<double> values) {
  final n = values.length;
  final indexed = List.generate(n, (i) => (i, values[i]));
  indexed.sort((a, b) => a.$2.compareTo(b.$2));

  final ranks = List<double>.filled(n, 0);

  int i = 0;
  while (i < n) {
    int j = i;
    // Find ties
    while (j < n - 1 && indexed[j].$2 == indexed[j + 1].$2) {
      j++;
    }
    // Average rank for ties
    final avgRank = (i + j) / 2 + 1;
    for (int k = i; k <= j; k++) {
      ranks[indexed[k].$1] = avgRank;
    }
    i = j + 1;
  }

  return ranks;
}

/// Kernel types for density estimation.
enum KernelType {
  gaussian,
  epanechnikov,
  triangular,
  uniform,
}

/// Result of kernel density estimation.
class KernelDensityResult {
  /// The x values where density was estimated.
  final List<double> x;

  /// The estimated density values.
  final List<double> density;

  const KernelDensityResult({
    required this.x,
    required this.density,
  });
}

/// Computes kernel density estimation for a set of data points.
///
/// [data] is the input data.
/// [bandwidth] is the kernel bandwidth (smoothing parameter).
///   If not provided, Silverman's rule of thumb is used.
/// [kernel] is the type of kernel to use (default: gaussian).
/// [nPoints] is the number of points to evaluate the density at.
/// [range] is the optional range [min, max] for evaluation.
KernelDensityResult kernelDensityEstimation(
  List<double> data, {
  double? bandwidth,
  KernelType kernel = KernelType.gaussian,
  int nPoints = 100,
  List<double>? range,
}) {
  if (data.isEmpty) {
    return KernelDensityResult(x: [], density: []);
  }

  // Calculate bandwidth using Silverman's rule if not provided
  final h = bandwidth ?? _silvermanBandwidth(data);

  // Determine evaluation range
  double minX, maxX;
  if (range != null && range.length >= 2) {
    minX = range[0];
    maxX = range[1];
  } else {
    minX = data.reduce(math.min) - 3 * h;
    maxX = data.reduce(math.max) + 3 * h;
  }

  // Generate evaluation points
  final xValues = List<double>.generate(
    nPoints,
    (i) => minX + (maxX - minX) * i / (nPoints - 1),
  );

  // Select kernel function
  double Function(double) kernelFn;
  switch (kernel) {
    case KernelType.gaussian:
      kernelFn = _gaussianKernel;
      break;
    case KernelType.epanechnikov:
      kernelFn = _epanechnikovKernel;
      break;
    case KernelType.triangular:
      kernelFn = _triangularKernel;
      break;
    case KernelType.uniform:
      kernelFn = _uniformKernel;
      break;
  }

  // Estimate density at each point
  final n = data.length;
  final density = List<double>.filled(nPoints, 0);

  for (int i = 0; i < nPoints; i++) {
    double sum = 0;
    for (int j = 0; j < n; j++) {
      sum += kernelFn((xValues[i] - data[j]) / h);
    }
    density[i] = sum / (n * h);
  }

  return KernelDensityResult(x: xValues, density: density);
}

double _silvermanBandwidth(List<double> data) {
  final n = data.length;
  if (n == 0) return 1.0;

  // Calculate standard deviation
  double sum = 0;
  for (final x in data) {
    sum += x;
  }
  final mean = sum / n;

  double sumSq = 0;
  for (final x in data) {
    sumSq += (x - mean) * (x - mean);
  }
  final std = math.sqrt(sumSq / n);

  // Calculate IQR
  final sorted = List<double>.from(data)..sort();
  final q1 = sorted[(n * 0.25).floor()];
  final q3 = sorted[(n * 0.75).floor()];
  final iqr = q3 - q1;

  // Silverman's rule of thumb
  final a = math.min(std, iqr / 1.34);
  return 0.9 * a * math.pow(n, -0.2);
}

double _gaussianKernel(double u) {
  return math.exp(-0.5 * u * u) / math.sqrt(2 * math.pi);
}

double _epanechnikovKernel(double u) {
  if (u.abs() > 1) return 0;
  return 0.75 * (1 - u * u);
}

double _triangularKernel(double u) {
  if (u.abs() > 1) return 0;
  return 1 - u.abs();
}

double _uniformKernel(double u) {
  if (u.abs() > 1) return 0;
  return 0.5;
}

/// Result of polynomial regression.
class PolynomialRegressionResult {
  /// Coefficients [a0, a1, a2, ...] for y = a0 + a1*x + a2*x^2 + ...
  final List<double> coefficients;

  /// The coefficient of determination (R-squared).
  final double rSquared;

  const PolynomialRegressionResult({
    required this.coefficients,
    required this.rSquared,
  });

  /// The degree of the polynomial.
  int get degree => coefficients.length - 1;

  /// Predicts the y value for a given x.
  double predict(double x) {
    double result = 0;
    double xPower = 1;
    for (final coef in coefficients) {
      result += coef * xPower;
      xPower *= x;
    }
    return result;
  }
}

/// Computes polynomial regression for the given data points.
///
/// [degree] is the degree of the polynomial to fit.
PolynomialRegressionResult polynomialRegression(
  List<double> x,
  List<double> y, {
  required int degree,
}) {
  if (x.length != y.length) {
    throw ArgumentError('x and y must have the same length');
  }
  if (x.length <= degree) {
    throw ArgumentError('Need more points than the polynomial degree');
  }

  final n = x.length;
  final m = degree + 1;

  // Build the Vandermonde matrix
  final matrix = List.generate(n, (i) {
    return List.generate(m, (j) => math.pow(x[i], j).toDouble());
  });

  // Solve using normal equations: (X^T X) * coeffs = X^T * y
  // Compute X^T X
  final xtx = List.generate(m, (i) {
    return List.generate(m, (j) {
      double sum = 0;
      for (int k = 0; k < n; k++) {
        sum += matrix[k][i] * matrix[k][j];
      }
      return sum;
    });
  });

  // Compute X^T y
  final xty = List.generate(m, (i) {
    double sum = 0;
    for (int k = 0; k < n; k++) {
      sum += matrix[k][i] * y[k];
    }
    return sum;
  });

  // Solve the system using Gaussian elimination
  final coefficients = _solveLinearSystem(xtx, xty);

  // Calculate R-squared
  double sumY = 0;
  for (final yi in y) {
    sumY += yi;
  }
  final meanY = sumY / n;

  double ssTot = 0;
  double ssRes = 0;

  for (int i = 0; i < n; i++) {
    double predicted = 0;
    double xPower = 1;
    for (final coef in coefficients) {
      predicted += coef * xPower;
      xPower *= x[i];
    }
    ssTot += (y[i] - meanY) * (y[i] - meanY);
    ssRes += (y[i] - predicted) * (y[i] - predicted);
  }

  final rSquared = ssTot > 0 ? 1 - (ssRes / ssTot) : 0.0;

  return PolynomialRegressionResult(
    coefficients: coefficients,
    rSquared: rSquared,
  );
}

List<double> _solveLinearSystem(List<List<double>> a, List<double> b) {
  final n = a.length;

  // Create augmented matrix
  final aug = List.generate(n, (i) {
    return List<double>.from(a[i])..add(b[i]);
  });

  // Forward elimination
  for (int i = 0; i < n; i++) {
    // Find pivot
    int maxRow = i;
    for (int k = i + 1; k < n; k++) {
      if (aug[k][i].abs() > aug[maxRow][i].abs()) {
        maxRow = k;
      }
    }

    // Swap rows
    final temp = aug[i];
    aug[i] = aug[maxRow];
    aug[maxRow] = temp;

    // Eliminate column
    for (int k = i + 1; k < n; k++) {
      if (aug[i][i].abs() < 1e-10) continue;
      final factor = aug[k][i] / aug[i][i];
      for (int j = i; j <= n; j++) {
        aug[k][j] -= factor * aug[i][j];
      }
    }
  }

  // Back substitution
  final x = List<double>.filled(n, 0);
  for (int i = n - 1; i >= 0; i--) {
    x[i] = aug[i][n];
    for (int j = i + 1; j < n; j++) {
      x[i] -= aug[i][j] * x[j];
    }
    if (aug[i][i].abs() > 1e-10) {
      x[i] /= aug[i][i];
    }
  }

  return x;
}

/// Result of LOESS (locally weighted scatterplot smoothing).
class LoessResult {
  /// The x values.
  final List<double> x;

  /// The smoothed y values.
  final List<double> y;

  const LoessResult({required this.x, required this.y});
}

/// Computes LOESS smoothing for the given data.
///
/// [span] is the fraction of data to use in each local regression (0 < span <= 1).
/// [degree] is the degree of the local polynomial (1 or 2).
LoessResult loess(
  List<double> x,
  List<double> y, {
  double span = 0.75,
  int degree = 1,
}) {
  if (x.length != y.length) {
    throw ArgumentError('x and y must have the same length');
  }
  if (span <= 0 || span > 1) {
    throw ArgumentError('Span must be in (0, 1]');
  }
  if (degree != 1 && degree != 2) {
    throw ArgumentError('Degree must be 1 or 2');
  }

  final n = x.length;
  if (n == 0) return LoessResult(x: [], y: []);

  // Sort by x
  final indices = List.generate(n, (i) => i);
  indices.sort((a, b) => x[a].compareTo(x[b]));

  final sortedX = indices.map((i) => x[i]).toList();
  final sortedY = indices.map((i) => y[i]).toList();

  final k = (span * n).ceil().clamp(degree + 1, n);
  final smoothedY = List<double>.filled(n, 0);

  for (int i = 0; i < n; i++) {
    final xi = sortedX[i];

    // Find k nearest neighbors
    final distances = List.generate(n, (j) => (sortedX[j] - xi).abs());
    final neighborIndices = List.generate(n, (j) => j);
    neighborIndices.sort((a, b) => distances[a].compareTo(distances[b]));
    final neighbors = neighborIndices.take(k).toList();

    // Calculate weights using tricube function
    final maxDist = distances[neighbors.last];
    final weights = <double>[];
    for (final j in neighbors) {
      final u = maxDist > 0 ? distances[j] / maxDist : 0.0;
      weights.add(_tricube(u));
    }

    // Perform weighted polynomial regression
    if (degree == 1) {
      // Weighted linear regression
      double sumW = 0, sumWx = 0, sumWy = 0, sumWxx = 0, sumWxy = 0;
      for (int j = 0; j < k; j++) {
        final idx = neighbors[j];
        final w = weights[j];
        final xj = sortedX[idx];
        final yj = sortedY[idx];
        sumW += w;
        sumWx += w * xj;
        sumWy += w * yj;
        sumWxx += w * xj * xj;
        sumWxy += w * xj * yj;
      }

      final denom = sumW * sumWxx - sumWx * sumWx;
      if (denom.abs() < 1e-10) {
        smoothedY[i] = sumWy / sumW;
      } else {
        final slope = (sumW * sumWxy - sumWx * sumWy) / denom;
        final intercept = (sumWy - slope * sumWx) / sumW;
        smoothedY[i] = slope * xi + intercept;
      }
    } else {
      // Weighted quadratic regression
      final localX = neighbors.map((j) => sortedX[j]).toList();
      final localY = neighbors.map((j) => sortedY[j]).toList();
      final result = _weightedPolynomialRegression(localX, localY, weights, 2);
      smoothedY[i] = result[0] + result[1] * xi + result[2] * xi * xi;
    }
  }

  return LoessResult(x: sortedX, y: smoothedY);
}

double _tricube(double u) {
  if (u >= 1) return 0;
  final t = 1 - u * u * u;
  return t * t * t;
}

List<double> _weightedPolynomialRegression(
  List<double> x,
  List<double> y,
  List<double> weights,
  int degree,
) {
  final n = x.length;
  final m = degree + 1;

  // Build weighted normal equations
  final xtWx = List.generate(m, (i) {
    return List.generate(m, (j) {
      double sum = 0;
      for (int k = 0; k < n; k++) {
        sum += weights[k] * math.pow(x[k], i + j);
      }
      return sum;
    });
  });

  final xtWy = List.generate(m, (i) {
    double sum = 0;
    for (int k = 0; k < n; k++) {
      sum += weights[k] * math.pow(x[k], i) * y[k];
    }
    return sum;
  });

  return _solveLinearSystem(xtWx, xtWy);
}

/// Computes the covariance between two series.
double covariance(List<double> x, List<double> y) {
  if (x.length != y.length) {
    throw ArgumentError('x and y must have the same length');
  }
  if (x.length < 2) {
    throw ArgumentError('At least 2 points are required');
  }

  final n = x.length;

  double sumX = 0, sumY = 0;
  for (int i = 0; i < n; i++) {
    sumX += x[i];
    sumY += y[i];
  }
  final meanX = sumX / n;
  final meanY = sumY / n;

  double cov = 0;
  for (int i = 0; i < n; i++) {
    cov += (x[i] - meanX) * (y[i] - meanY);
  }

  return cov / (n - 1); // Sample covariance
}

/// Computes the skewness of a distribution.
double? skewness(List<double> data) {
  if (data.length < 3) return null;

  final n = data.length;

  double sum = 0;
  for (final x in data) {
    sum += x;
  }
  final mean = sum / n;

  double m2 = 0, m3 = 0;
  for (final x in data) {
    final d = x - mean;
    m2 += d * d;
    m3 += d * d * d;
  }
  m2 /= n;
  m3 /= n;

  if (m2 == 0) return null;

  return m3 / math.pow(m2, 1.5);
}

/// Computes the kurtosis of a distribution.
double? kurtosis(List<double> data) {
  if (data.length < 4) return null;

  final n = data.length;

  double sum = 0;
  for (final x in data) {
    sum += x;
  }
  final mean = sum / n;

  double m2 = 0, m4 = 0;
  for (final x in data) {
    final d = x - mean;
    final d2 = d * d;
    m2 += d2;
    m4 += d2 * d2;
  }
  m2 /= n;
  m4 /= n;

  if (m2 == 0) return null;

  return m4 / (m2 * m2) - 3; // Excess kurtosis
}

/// Performs a two-sample t-test.
///
/// Returns the t-statistic and p-value (two-tailed).
(double tStatistic, double pValue) tTest(List<double> a, List<double> b) {
  final n1 = a.length;
  final n2 = b.length;

  if (n1 < 2 || n2 < 2) {
    throw ArgumentError('Each sample must have at least 2 observations');
  }

  // Calculate means
  double sum1 = 0, sum2 = 0;
  for (final x in a) {
    sum1 += x;
  }
  for (final x in b) {
    sum2 += x;
  }
  final mean1 = sum1 / n1;
  final mean2 = sum2 / n2;

  // Calculate variances
  double var1 = 0, var2 = 0;
  for (final x in a) {
    var1 += (x - mean1) * (x - mean1);
  }
  for (final x in b) {
    var2 += (x - mean2) * (x - mean2);
  }
  var1 /= (n1 - 1);
  var2 /= (n2 - 1);

  // Calculate t-statistic
  final se = math.sqrt(var1 / n1 + var2 / n2);
  if (se == 0) {
    return (double.infinity, 0);
  }

  final t = (mean1 - mean2) / se;

  // Approximate p-value using normal distribution for large df
  // For more accurate results, use Student's t-distribution
  // Note: Welch-Satterthwaite degrees of freedom could be computed as:
  // df = ((v1 + v2)^2) / ((v1^2)/(n1-1) + (v2^2)/(n2-1))
  // where v1 = var1/n1 and v2 = var2/n2, but we use normal approximation here.
  final pValue = 2 * (1 - _normalCdf(t.abs()));

  return (t, pValue);
}

double _normalCdf(double x) {
  // Approximation of the standard normal CDF
  const a1 = 0.254829592;
  const a2 = -0.284496736;
  const a3 = 1.421413741;
  const a4 = -1.453152027;
  const a5 = 1.061405429;
  const p = 0.3275911;

  final sign = x < 0 ? -1 : 1;
  x = x.abs() / math.sqrt(2);

  final t = 1.0 / (1.0 + p * x);
  final y = 1.0 -
      (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * math.exp(-x * x);

  return 0.5 * (1.0 + sign * y);
}
