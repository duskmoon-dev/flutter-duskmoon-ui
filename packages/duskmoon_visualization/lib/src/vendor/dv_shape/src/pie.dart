import 'dart:math' as math;

/// A pie/donut layout generator that computes arc angles from data values.
class PieLayout<T> {
  /// Function to extract the value from a data item.
  final double Function(T) value;

  /// The start angle in radians (default: -pi/2, 12 o'clock position).
  final double startAngle;

  /// The end angle in radians (default: 3*pi/2, full circle).
  final double endAngle;

  /// Padding angle between slices in radians.
  final double padAngle;

  /// Optional sort comparator for data items.
  final int Function(T a, T b)? sort;

  /// Whether to sort by value descending.
  final bool sortByValueDescending;

  /// Creates a pie layout generator.
  PieLayout({
    required this.value,
    this.startAngle = -math.pi / 2,
    this.endAngle = 3 * math.pi / 2,
    this.padAngle = 0,
    this.sort,
    this.sortByValueDescending = false,
  });

  /// Generates pie arcs from the given data.
  List<PieArc<T>> generate(List<T> data) {
    if (data.isEmpty) return [];

    // Sort data if needed
    final sortedData = List<T>.from(data);
    if (sort != null) {
      sortedData.sort(sort);
    } else if (sortByValueDescending) {
      sortedData.sort((a, b) => value(b).compareTo(value(a)));
    }

    // Calculate total value
    double total = 0;
    for (final item in sortedData) {
      final v = value(item);
      if (v > 0) total += v;
    }

    if (total <= 0) return [];

    // Calculate angles
    final angleRange = endAngle - startAngle;
    final totalPadding = padAngle * sortedData.length;
    final availableAngle = angleRange - totalPadding;

    final arcs = <PieArc<T>>[];
    double currentAngle = startAngle;

    for (int i = 0; i < sortedData.length; i++) {
      final item = sortedData[i];
      final v = value(item);

      if (v <= 0) continue;

      final arcAngle = (v / total) * availableAngle;
      final arcStartAngle = currentAngle;
      final arcEndAngle = currentAngle + arcAngle;

      arcs.add(PieArc<T>(
        data: item,
        value: v,
        index: i,
        startAngle: arcStartAngle,
        endAngle: arcEndAngle,
        padAngle: padAngle,
      ));

      currentAngle = arcEndAngle + padAngle;
    }

    return arcs;
  }
}

/// Represents a single arc in a pie/donut chart.
class PieArc<T> {
  /// The original data item.
  final T data;

  /// The numeric value.
  final double value;

  /// The index in the sorted data array.
  final int index;

  /// The start angle in radians.
  final double startAngle;

  /// The end angle in radians.
  final double endAngle;

  /// The padding angle in radians.
  final double padAngle;

  /// Creates a pie arc.
  const PieArc({
    required this.data,
    required this.value,
    required this.index,
    required this.startAngle,
    required this.endAngle,
    required this.padAngle,
  });

  /// The mid angle of the arc.
  double get midAngle => (startAngle + endAngle) / 2;

  /// The angular span of the arc.
  double get angle => endAngle - startAngle;

  /// Calculates the centroid of this arc for the given radii.
  ({double x, double y}) centroid(double innerRadius, double outerRadius) {
    final r = (innerRadius + outerRadius) / 2;
    final a = midAngle;
    return (x: r * math.cos(a), y: r * math.sin(a));
  }

  @override
  String toString() =>
      'PieArc(value: $value, start: $startAngle, end: $endAngle)';
}
