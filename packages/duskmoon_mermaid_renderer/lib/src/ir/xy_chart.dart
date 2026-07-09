enum XyChartOrientation {
  vertical,
  horizontal,
}

enum XyChartSeriesType {
  bar,
  line,
}

class XyChart {
  const XyChart({
    required this.orientation,
    required this.series,
    this.title,
    this.xAxis = const XyChartAxis(),
    this.yAxis = const XyChartAxis(),
  });

  final XyChartOrientation orientation;
  final String? title;
  final XyChartAxis xAxis;
  final XyChartAxis yAxis;
  final List<XyChartSeries> series;
}

class XyChartAxis {
  const XyChartAxis({
    this.title,
    this.categories,
    this.min,
    this.max,
  });

  final String? title;
  final List<String>? categories;
  final double? min;
  final double? max;
}

class XyChartSeries {
  const XyChartSeries({
    required this.type,
    required this.values,
  });

  final XyChartSeriesType type;
  final List<XyChartValue> values;
}

class XyChartValue {
  const XyChartValue({
    required this.value,
    this.label,
  });

  final double value;
  final String? label;
}
