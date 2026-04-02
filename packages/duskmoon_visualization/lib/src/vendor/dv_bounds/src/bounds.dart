import 'dart:ui';

/// A class representing the bounds (dimensions) of a chart or element.
///
/// [Bounds] encapsulates position and size information, providing
/// convenient methods for working with chart dimensions.
class Bounds {
  /// The x position.
  final double x;

  /// The y position.
  final double y;

  /// The width.
  final double width;

  /// The height.
  final double height;

  /// Creates a Bounds with position and size.
  const Bounds({
    this.x = 0,
    this.y = 0,
    required this.width,
    required this.height,
  });

  /// Creates a Bounds from left, top, right, bottom values.
  factory Bounds.fromLTRB(
      double left, double top, double right, double bottom) {
    return Bounds(
      x: left,
      y: top,
      width: right - left,
      height: bottom - top,
    );
  }

  /// Creates a Bounds from a Rect.
  factory Bounds.fromRect(Rect rect) {
    return Bounds(
      x: rect.left,
      y: rect.top,
      width: rect.width,
      height: rect.height,
    );
  }

  /// Creates a Bounds from a Size at the origin.
  factory Bounds.fromSize(Size size) {
    return Bounds(width: size.width, height: size.height);
  }

  /// Creates a Bounds from center and size.
  factory Bounds.fromCenter({
    required double centerX,
    required double centerY,
    required double width,
    required double height,
  }) {
    return Bounds(
      x: centerX - width / 2,
      y: centerY - height / 2,
      width: width,
      height: height,
    );
  }

  /// Empty bounds.
  static const Bounds empty = Bounds(width: 0, height: 0);

  /// The left edge.
  double get left => x;

  /// The top edge.
  double get top => y;

  /// The right edge.
  double get right => x + width;

  /// The bottom edge.
  double get bottom => y + height;

  /// The center x coordinate.
  double get centerX => x + width / 2;

  /// The center y coordinate.
  double get centerY => y + height / 2;

  /// The center as an Offset.
  Offset get center => Offset(centerX, centerY);

  /// The top-left corner.
  Offset get topLeft => Offset(left, top);

  /// The top-right corner.
  Offset get topRight => Offset(right, top);

  /// The bottom-left corner.
  Offset get bottomLeft => Offset(left, bottom);

  /// The bottom-right corner.
  Offset get bottomRight => Offset(right, bottom);

  /// The size of the bounds.
  Size get size => Size(width, height);

  /// The area of the bounds.
  double get area => width * height;

  /// Whether the bounds are empty.
  bool get isEmpty => width <= 0 || height <= 0;

  /// Whether the bounds are not empty.
  bool get isNotEmpty => !isEmpty;

  /// Converts to a Rect.
  Rect toRect() => Rect.fromLTWH(x, y, width, height);

  /// Whether the bounds contain a point.
  bool contains(Offset point) {
    return point.dx >= left &&
        point.dx <= right &&
        point.dy >= top &&
        point.dy <= bottom;
  }

  /// Whether the bounds contain another bounds.
  bool containsBounds(Bounds other) {
    return other.left >= left &&
        other.right <= right &&
        other.top >= top &&
        other.bottom <= bottom;
  }

  /// Whether the bounds intersect another bounds.
  bool intersects(Bounds other) {
    return left < other.right &&
        right > other.left &&
        top < other.bottom &&
        bottom > other.top;
  }

  /// Returns the intersection with another bounds.
  Bounds? intersection(Bounds other) {
    if (!intersects(other)) return null;

    return Bounds.fromLTRB(
      left > other.left ? left : other.left,
      top > other.top ? top : other.top,
      right < other.right ? right : other.right,
      bottom < other.bottom ? bottom : other.bottom,
    );
  }

  /// Returns the union with another bounds.
  Bounds union(Bounds other) {
    return Bounds.fromLTRB(
      left < other.left ? left : other.left,
      top < other.top ? top : other.top,
      right > other.right ? right : other.right,
      bottom > other.bottom ? bottom : other.bottom,
    );
  }

  /// Expands the bounds by a delta.
  Bounds expand(double delta) {
    return Bounds(
      x: x - delta,
      y: y - delta,
      width: width + delta * 2,
      height: height + delta * 2,
    );
  }

  /// Expands the bounds by different amounts on each side.
  Bounds expandSides({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return Bounds(
      x: x - left,
      y: y - top,
      width: width + left + right,
      height: height + top + bottom,
    );
  }

  /// Contracts the bounds by a delta.
  Bounds contract(double delta) {
    return expand(-delta);
  }

  /// Translates the bounds by an offset.
  Bounds translate(double dx, double dy) {
    return Bounds(
      x: x + dx,
      y: y + dy,
      width: width,
      height: height,
    );
  }

  /// Translates the bounds by an Offset.
  Bounds translateOffset(Offset offset) {
    return translate(offset.dx, offset.dy);
  }

  /// Scales the bounds by a factor.
  Bounds scale(double factor) {
    return Bounds(
      x: x * factor,
      y: y * factor,
      width: width * factor,
      height: height * factor,
    );
  }

  /// Scales the bounds around a center point.
  Bounds scaleFromCenter(double factor) {
    final cx = centerX;
    final cy = centerY;
    final newWidth = width * factor;
    final newHeight = height * factor;
    return Bounds(
      x: cx - newWidth / 2,
      y: cy - newHeight / 2,
      width: newWidth,
      height: newHeight,
    );
  }

  /// Interpolates between this and another bounds.
  Bounds lerp(Bounds other, double t) {
    return Bounds(
      x: x + (other.x - x) * t,
      y: y + (other.y - y) * t,
      width: width + (other.width - width) * t,
      height: height + (other.height - height) * t,
    );
  }

  /// Creates a copy with updated values.
  Bounds copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
  }) {
    return Bounds(
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Bounds &&
        other.x == x &&
        other.y == y &&
        other.width == width &&
        other.height == height;
  }

  @override
  int get hashCode => Object.hash(x, y, width, height);

  @override
  String toString() => 'Bounds(x: $x, y: $y, width: $width, height: $height)';
}

/// Extension to convert Rect to Bounds.
extension RectToBoundsExtension on Rect {
  /// Converts this Rect to Bounds.
  Bounds toBounds() => Bounds.fromRect(this);
}

/// Extension to convert Size to Bounds.
extension SizeToBoundsExtension on Size {
  /// Converts this Size to Bounds at the origin.
  Bounds toBounds() => Bounds.fromSize(this);
}
