import 'dart:math' as math;

import 'random_generator.dart';
import 'time_series_generator.dart';

/// Mock data generator for various chart types.
class MockData {
  final RandomGenerator _random;
  final TimeSeriesGenerator _timeSeries;

  /// Creates a mock data generator with an optional seed.
  MockData([int? seed])
      : _random = RandomGenerator(seed),
        _timeSeries = TimeSeriesGenerator(seed);

  /// Access to the random generator.
  RandomGenerator get random => _random;

  /// Access to the time series generator.
  TimeSeriesGenerator get timeSeries => _timeSeries;

  // ==================== XY Data ====================

  /// Generates scatter plot data points.
  List<Map<String, double>> scatterData({
    int count = 50,
    double xMin = 0,
    double xMax = 100,
    double yMin = 0,
    double yMax = 100,
    double? correlation,
  }) {
    if (correlation != null) {
      return _correlatedScatter(count, xMin, xMax, yMin, yMax, correlation);
    }

    return List.generate(
        count,
        (_) => {
              'x': _random.uniform(xMin, xMax),
              'y': _random.uniform(yMin, yMax),
            });
  }

  List<Map<String, double>> _correlatedScatter(
    int count,
    double xMin,
    double xMax,
    double yMin,
    double yMax,
    double correlation,
  ) {
    final xMean = (xMin + xMax) / 2;
    final yMean = (yMin + yMax) / 2;
    final xStd = (xMax - xMin) / 4;
    final yStd = (yMax - yMin) / 4;

    return List.generate(count, (_) {
      final x = _random.normal(xMean, xStd);
      final y = yMean +
          correlation * (x - xMean) * yStd / xStd +
          math.sqrt(1 - correlation * correlation) * _random.normal(0, yStd);
      return {'x': x.clamp(xMin, xMax), 'y': y.clamp(yMin, yMax)};
    });
  }

  /// Generates line chart data.
  List<Map<String, dynamic>> lineData({
    int points = 20,
    double startValue = 50,
    double volatility = 5,
    String xKey = 'x',
    String yKey = 'y',
  }) {
    final values =
        _random.randomWalk(points, start: startValue, stepSize: volatility);
    return List.generate(points, (i) => {xKey: i, yKey: values[i]});
  }

  /// Generates bar chart data.
  List<Map<String, dynamic>> barData({
    int bars = 10,
    double minValue = 10,
    double maxValue = 100,
    List<String>? categories,
  }) {
    return List.generate(bars, (i) {
      return {
        'category': categories?[i] ?? 'Category ${i + 1}',
        'value': _random.uniform(minValue, maxValue),
      };
    });
  }

  /// Generates grouped bar chart data.
  List<Map<String, dynamic>> groupedBarData({
    int groups = 5,
    List<String>? groupNames,
    List<String>? seriesNames,
    int seriesCount = 3,
    double minValue = 10,
    double maxValue = 100,
  }) {
    final series =
        seriesNames ?? List.generate(seriesCount, (i) => 'Series ${i + 1}');
    final groups_ =
        groupNames ?? List.generate(groups, (i) => 'Group ${i + 1}');

    return groups_.map((group) {
      final Map<String, dynamic> data = {'group': group};
      for (final s in series) {
        data[s] = _random.uniform(minValue, maxValue);
      }
      return data;
    }).toList();
  }

  /// Generates stacked data.
  List<Map<String, dynamic>> stackedData({
    int categories = 10,
    List<String>? categoryNames,
    List<String>? seriesNames,
    int seriesCount = 4,
    double minValue = 10,
    double maxValue = 50,
  }) {
    final series =
        seriesNames ?? List.generate(seriesCount, (i) => 'Series ${i + 1}');
    final categories_ =
        categoryNames ?? List.generate(categories, (i) => 'Cat ${i + 1}');

    return categories_.map((category) {
      final Map<String, dynamic> data = {'category': category};
      for (final s in series) {
        data[s] = _random.uniform(minValue, maxValue);
      }
      return data;
    }).toList();
  }

  // ==================== Hierarchical Data ====================

  /// Generates pie/donut chart data.
  List<Map<String, dynamic>> pieData({
    int slices = 5,
    List<String>? labels,
    bool sorted = true,
  }) {
    final values = List.generate(slices, (_) => _random.uniform(10, 100));
    final total = values.reduce((a, b) => a + b);

    final data = List.generate(
        slices,
        (i) => {
              'label': labels?[i] ?? 'Slice ${i + 1}',
              'value': values[i],
              'percentage': values[i] / total * 100,
            });

    if (sorted) {
      data.sort(
          (a, b) => (b['value'] as double).compareTo(a['value'] as double));
    }

    return data;
  }

  /// Generates treemap data.
  Map<String, dynamic> treemapData({
    int depth = 2,
    int minChildren = 2,
    int maxChildren = 5,
    double minValue = 10,
    double maxValue = 100,
    String name = 'Root',
  }) {
    return _generateTreeNode(
        name, depth, minChildren, maxChildren, minValue, maxValue);
  }

  Map<String, dynamic> _generateTreeNode(
    String name,
    int depth,
    int minChildren,
    int maxChildren,
    double minValue,
    double maxValue,
  ) {
    if (depth <= 0) {
      return {
        'name': name,
        'value': _random.uniform(minValue, maxValue),
      };
    }

    final childCount = _random.uniformInt(minChildren, maxChildren + 1);
    final children = List.generate(
      childCount,
      (i) => _generateTreeNode(
        '$name.${i + 1}',
        depth - 1,
        minChildren,
        maxChildren,
        minValue,
        maxValue,
      ),
    );

    return {
      'name': name,
      'children': children,
    };
  }

  /// Generates sunburst data.
  Map<String, dynamic> sunburstData({
    int depth = 3,
    int minChildren = 2,
    int maxChildren = 4,
  }) {
    return treemapData(
      depth: depth,
      minChildren: minChildren,
      maxChildren: maxChildren,
    );
  }

  // ==================== Network Data ====================

  /// Generates network graph data.
  Map<String, dynamic> networkData({
    int nodeCount = 20,
    double linkProbability = 0.1,
    int? groupCount,
  }) {
    final groups = groupCount ?? (nodeCount / 5).ceil();

    final nodes = List.generate(
        nodeCount,
        (i) => {
              'id': 'node_$i',
              'label': 'Node $i',
              'group': 'Group ${i % groups}',
              'value': _random.uniform(5, 20),
            });

    final links = <Map<String, dynamic>>[];
    for (int i = 0; i < nodeCount; i++) {
      for (int j = i + 1; j < nodeCount; j++) {
        if (_random.boolean(linkProbability)) {
          links.add({
            'source': 'node_$i',
            'target': 'node_$j',
            'weight': _random.uniform(1, 5),
          });
        }
      }
    }

    return {
      'nodes': nodes,
      'links': links,
    };
  }

  /// Generates tree structure data.
  Map<String, dynamic> treeData({
    int depth = 3,
    int minChildren = 1,
    int maxChildren = 4,
  }) {
    return _generateTree('root', depth, minChildren, maxChildren, 0);
  }

  Map<String, dynamic> _generateTree(
    String id,
    int depth,
    int minChildren,
    int maxChildren,
    int level,
  ) {
    final node = <String, dynamic>{
      'id': id,
      'name': id
          .replaceAll('_', ' ')
          .split(' ')
          .map((s) => s[0].toUpperCase() + s.substring(1))
          .join(' '),
      'level': level,
    };

    if (depth > 0) {
      final childCount = _random.uniformInt(minChildren, maxChildren + 1);
      node['children'] = List.generate(
        childCount,
        (i) => _generateTree(
            '${id}_$i', depth - 1, minChildren, maxChildren, level + 1),
      );
    }

    return node;
  }

  // ==================== Heatmap Data ====================

  /// Generates heatmap data.
  List<List<double>> heatmapData({
    int rows = 10,
    int columns = 10,
    double minValue = 0,
    double maxValue = 100,
  }) {
    return List.generate(
      rows,
      (_) => List.generate(columns, (_) => _random.uniform(minValue, maxValue)),
    );
  }

  /// Generates correlated heatmap data (like a correlation matrix).
  List<List<double>> correlationMatrix({int size = 10}) {
    final matrix = List.generate(
      size,
      (_) => List.filled(size, 0.0),
    );

    for (int i = 0; i < size; i++) {
      matrix[i][i] = 1.0;
      for (int j = i + 1; j < size; j++) {
        final value = _random.uniform(-1, 1);
        matrix[i][j] = value;
        matrix[j][i] = value;
      }
    }

    return matrix;
  }

  /// Generates calendar heatmap data.
  Map<DateTime, double> calendarHeatmapData({
    required DateTime start,
    required DateTime end,
    double minValue = 0,
    double maxValue = 10,
    double emptyProbability = 0.2,
  }) {
    final data = <DateTime, double>{};
    var current = start;

    while (!current.isAfter(end)) {
      if (!_random.boolean(emptyProbability)) {
        data[DateTime(current.year, current.month, current.day)] =
            _random.uniform(minValue, maxValue);
      }
      current = current.add(const Duration(days: 1));
    }

    return data;
  }

  // ==================== Geographic Data ====================

  /// Generates random geographic points.
  List<Map<String, double>> geoPoints({
    int count = 50,
    double latMin = -90,
    double latMax = 90,
    double lonMin = -180,
    double lonMax = 180,
  }) {
    return List.generate(
        count,
        (_) => {
              'latitude': _random.uniform(latMin, latMax),
              'longitude': _random.uniform(lonMin, lonMax),
              'value': _random.uniform(0, 100),
            });
  }

  /// Generates clustered geographic points.
  List<Map<String, double>> geoPointsClustered({
    int clusterCount = 5,
    int pointsPerCluster = 20,
    double clusterRadius = 5,
  }) {
    final points = <Map<String, double>>[];

    for (int c = 0; c < clusterCount; c++) {
      final centerLat = _random.uniform(-60, 60);
      final centerLon = _random.uniform(-150, 150);

      for (int p = 0; p < pointsPerCluster; p++) {
        points.add({
          'latitude': centerLat + _random.normal(0, clusterRadius),
          'longitude': centerLon + _random.normal(0, clusterRadius),
          'cluster': c.toDouble(),
          'value': _random.uniform(0, 100),
        });
      }
    }

    return points;
  }

  // ==================== Statistical Data ====================

  /// Generates box plot data.
  List<Map<String, dynamic>> boxPlotData({
    int groups = 5,
    List<String>? groupNames,
    int samplesPerGroup = 100,
  }) {
    return List.generate(groups, (i) {
      final samples = _random.normalList(
          samplesPerGroup, _random.uniform(30, 70), _random.uniform(5, 15));
      samples.sort();

      final q1Index = (samplesPerGroup * 0.25).floor();
      final medianIndex = (samplesPerGroup * 0.5).floor();
      final q3Index = (samplesPerGroup * 0.75).floor();

      final iqr = samples[q3Index] - samples[q1Index];
      final lowerFence = samples[q1Index] - 1.5 * iqr;
      final upperFence = samples[q3Index] + 1.5 * iqr;

      final outliers =
          samples.where((v) => v < lowerFence || v > upperFence).toList();

      return {
        'group': groupNames?[i] ?? 'Group ${i + 1}',
        'min': samples.where((v) => v >= lowerFence).first,
        'q1': samples[q1Index],
        'median': samples[medianIndex],
        'q3': samples[q3Index],
        'max': samples.where((v) => v <= upperFence).last,
        'outliers': outliers,
        'samples': samples,
      };
    });
  }

  /// Generates histogram data.
  Map<String, dynamic> histogramData({
    int sampleCount = 1000,
    int binCount = 20,
    double mean = 50,
    double stdDev = 15,
  }) {
    final samples = _random.normalList(sampleCount, mean, stdDev);
    final min = samples.reduce((a, b) => a < b ? a : b);
    final max = samples.reduce((a, b) => a > b ? a : b);
    final binWidth = (max - min) / binCount;

    final bins = List.filled(binCount, 0);
    for (final sample in samples) {
      final binIndex =
          ((sample - min) / binWidth).floor().clamp(0, binCount - 1);
      bins[binIndex]++;
    }

    return {
      'bins': List.generate(
          binCount,
          (i) => {
                'x0': min + i * binWidth,
                'x1': min + (i + 1) * binWidth,
                'count': bins[i],
                'frequency': bins[i] / sampleCount,
              }),
      'samples': samples,
      'mean': mean,
      'stdDev': stdDev,
    };
  }

  /// Generates violin plot data.
  List<Map<String, dynamic>> violinData({
    int groups = 4,
    List<String>? groupNames,
    int samplesPerGroup = 200,
  }) {
    return List.generate(groups, (i) {
      final mean = _random.uniform(30, 70);
      final stdDev = _random.uniform(5, 15);
      final samples = _random.normalList(samplesPerGroup, mean, stdDev);

      return {
        'group': groupNames?[i] ?? 'Group ${i + 1}',
        'samples': samples,
        'mean': mean,
        'stdDev': stdDev,
      };
    });
  }
}
