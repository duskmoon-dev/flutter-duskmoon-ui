import 'dart:math' as math;

/// A 2D point class for coordinate operations.
class Point {
  /// The x coordinate.
  final double x;

  /// The y coordinate.
  final double y;

  /// Creates a point with the given [x] and [y] coordinates.
  const Point(this.x, this.y);

  /// Creates a point at the origin (0, 0).
  static const Point zero = Point(0, 0);

  /// Creates a point from polar coordinates.
  factory Point.fromPolar(double radius, double angle) {
    return Point(
      radius * math.cos(angle),
      radius * math.sin(angle),
    );
  }

  /// Creates a point from a Map with 'x' and 'y' keys.
  factory Point.fromMap(Map<String, dynamic> map) {
    return Point(
      (map['x'] as num).toDouble(),
      (map['y'] as num).toDouble(),
    );
  }

  /// Creates a point from a List [x, y].
  factory Point.fromList(List<num> list) {
    assert(list.length >= 2, 'List must have at least 2 elements');
    return Point(list[0].toDouble(), list[1].toDouble());
  }

  /// Adds two points.
  Point operator +(Point other) {
    return Point(x + other.x, y + other.y);
  }

  /// Subtracts two points.
  Point operator -(Point other) {
    return Point(x - other.x, y - other.y);
  }

  /// Multiplies the point by a scalar.
  Point operator *(double scalar) {
    return Point(x * scalar, y * scalar);
  }

  /// Divides the point by a scalar.
  Point operator /(double scalar) {
    return Point(x / scalar, y / scalar);
  }

  /// Negates the point.
  Point operator -() {
    return Point(-x, -y);
  }

  /// Returns the Euclidean distance to another point.
  double distanceTo(Point other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return math.sqrt(dx * dx + dy * dy);
  }

  /// Returns the squared distance to another point.
  /// More efficient than [distanceTo] when comparing distances.
  double squaredDistanceTo(Point other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return dx * dx + dy * dy;
  }

  /// Returns the Manhattan distance to another point.
  double manhattanDistanceTo(Point other) {
    return (x - other.x).abs() + (y - other.y).abs();
  }

  /// Returns the magnitude (length) of this point as a vector.
  double get magnitude => math.sqrt(x * x + y * y);

  /// Returns the squared magnitude of this point as a vector.
  double get squaredMagnitude => x * x + y * y;

  /// Returns the angle of this point relative to the origin.
  double get angle => math.atan2(y, x);

  /// Returns a normalized version of this point (unit vector).
  Point get normalized {
    final m = magnitude;
    if (m == 0) return Point.zero;
    return Point(x / m, y / m);
  }

  /// Returns the dot product with another point.
  double dot(Point other) {
    return x * other.x + y * other.y;
  }

  /// Returns the cross product (z-component) with another point.
  double cross(Point other) {
    return x * other.y - y * other.x;
  }

  /// Linearly interpolates between this point and another.
  Point lerp(Point other, double t) {
    return Point(
      x + (other.x - x) * t,
      y + (other.y - y) * t,
    );
  }

  /// Returns a rotated version of this point around the origin.
  Point rotate(double angle) {
    final cos = math.cos(angle);
    final sin = math.sin(angle);
    return Point(
      x * cos - y * sin,
      x * sin + y * cos,
    );
  }

  /// Returns a rotated version around a center point.
  Point rotateAround(Point center, double angle) {
    final translated = this - center;
    final rotated = translated.rotate(angle);
    return rotated + center;
  }

  /// Returns the midpoint between this point and another.
  Point midpointTo(Point other) {
    return Point(
      (x + other.x) / 2,
      (y + other.y) / 2,
    );
  }

  /// Clamps this point to the given bounds.
  Point clamp({
    double? minX,
    double? maxX,
    double? minY,
    double? maxY,
  }) {
    return Point(
      x.clamp(minX ?? double.negativeInfinity, maxX ?? double.infinity),
      y.clamp(minY ?? double.negativeInfinity, maxY ?? double.infinity),
    );
  }

  /// Returns a copy with updated values.
  Point copyWith({double? x, double? y}) {
    return Point(x ?? this.x, y ?? this.y);
  }

  /// Converts to a Map.
  Map<String, double> toMap() {
    return {'x': x, 'y': y};
  }

  /// Converts to a List [x, y].
  List<double> toList() {
    return [x, y];
  }

  /// Returns true if this point is finite.
  bool get isFinite => x.isFinite && y.isFinite;

  /// Returns true if this point has NaN values.
  bool get hasNaN => x.isNaN || y.isNaN;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Point && other.x == x && other.y == y;
  }

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Point($x, $y)';
}

/// Extension methods for lists of points.
extension PointListExtensions on List<Point> {
  /// Returns the centroid (center of mass) of the points.
  Point get centroid {
    if (isEmpty) return Point.zero;

    double sumX = 0;
    double sumY = 0;

    for (final point in this) {
      sumX += point.x;
      sumY += point.y;
    }

    return Point(sumX / length, sumY / length);
  }

  /// Returns the bounding box as (minPoint, maxPoint).
  (Point, Point)? get bounds {
    if (isEmpty) return null;

    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final point in this) {
      if (point.x < minX) minX = point.x;
      if (point.x > maxX) maxX = point.x;
      if (point.y < minY) minY = point.y;
      if (point.y > maxY) maxY = point.y;
    }

    return (Point(minX, minY), Point(maxX, maxY));
  }

  /// Returns the total length of the polyline defined by these points.
  double get polylineLength {
    if (length < 2) return 0;

    double total = 0;
    for (int i = 1; i < length; i++) {
      total += this[i - 1].distanceTo(this[i]);
    }
    return total;
  }

  /// Returns the area of the polygon defined by these points.
  /// Uses the shoelace formula. Positive for counterclockwise, negative for clockwise.
  double get polygonArea {
    if (length < 3) return 0;

    double area = 0;
    for (int i = 0; i < length; i++) {
      final j = (i + 1) % length;
      area += this[i].x * this[j].y;
      area -= this[j].x * this[i].y;
    }
    return area / 2;
  }

  /// Returns true if the polygon is clockwise.
  bool get isClockwise => polygonArea < 0;

  /// Returns the perimeter of the polygon.
  double get polygonPerimeter {
    if (length < 2) return 0;

    double perimeter = 0;
    for (int i = 0; i < length; i++) {
      final j = (i + 1) % length;
      perimeter += this[i].distanceTo(this[j]);
    }
    return perimeter;
  }
}

/// Helper functions for working with points.

/// Calculates the distance between two points.
double distance(Point a, Point b) => a.distanceTo(b);

/// Calculates the angle between two points.
double angleBetween(Point from, Point to) {
  return math.atan2(to.y - from.y, to.x - from.x);
}

/// Returns the point at a given distance and angle from an origin.
Point pointAt(Point origin, double distance, double angle) {
  return Point(
    origin.x + distance * math.cos(angle),
    origin.y + distance * math.sin(angle),
  );
}

/// Checks if three points are collinear.
bool areCollinear(Point a, Point b, Point c, {double tolerance = 1e-10}) {
  return ((b - a).cross(c - a)).abs() < tolerance;
}

/// Returns the orientation of three points.
/// 0: collinear, positive: counterclockwise, negative: clockwise.
double orientation(Point a, Point b, Point c) {
  return (b - a).cross(c - a);
}
