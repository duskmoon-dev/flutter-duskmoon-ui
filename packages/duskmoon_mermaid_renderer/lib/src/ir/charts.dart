class PieChart {
  const PieChart({
    required this.slices,
    this.title,
    this.showData = false,
  });

  final String? title;
  final bool showData;
  final List<PieSlice> slices;
}

class PieSlice {
  const PieSlice({
    required this.label,
    required this.value,
  });

  final String label;
  final double value;
}

class QuadrantChart {
  const QuadrantChart({
    required this.points,
    this.title,
    this.xAxis = const QuadrantAxis(),
    this.yAxis = const QuadrantAxis(),
    this.quadrants = const {},
  });

  final String? title;
  final QuadrantAxis xAxis;
  final QuadrantAxis yAxis;
  final Map<int, String> quadrants;
  final List<QuadrantPoint> points;
}

class QuadrantAxis {
  const QuadrantAxis({
    this.start,
    this.end,
  });

  final String? start;
  final String? end;
}

class QuadrantPoint {
  const QuadrantPoint({
    required this.label,
    required this.x,
    required this.y,
  });

  final String label;
  final double x;
  final double y;
}

class RadarChart {
  const RadarChart({
    required this.axes,
    required this.curves,
    this.title,
    this.min,
    this.max,
    this.ticks = 5,
    this.showLegend = true,
    this.graticule = RadarGraticule.circle,
  });

  final String? title;
  final List<RadarAxis> axes;
  final List<RadarCurve> curves;
  final double? min;
  final double? max;
  final int ticks;
  final bool showLegend;
  final RadarGraticule graticule;
}

class RadarAxis {
  const RadarAxis({
    required this.id,
    required this.label,
  });

  final String id;
  final String label;
}

class RadarCurve {
  const RadarCurve({
    required this.id,
    required this.label,
    required this.values,
  });

  final String id;
  final String label;
  final Map<String, double> values;
}

enum RadarGraticule {
  circle,
  polygon,
}
