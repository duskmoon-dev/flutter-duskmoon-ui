import 'package:flutter/widgets.dart';

import 'bounds.dart';

/// A class representing margins around a chart area.
///
/// [Margin] encapsulates spacing values for all four sides,
/// commonly used for chart padding and margins.
class Margin {
  /// The top margin.
  final double top;

  /// The right margin.
  final double right;

  /// The bottom margin.
  final double bottom;

  /// The left margin.
  final double left;

  /// Creates a Margin with individual values for each side.
  const Margin({
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.left = 0,
  });

  /// Creates a Margin with the same value on all sides.
  const Margin.all(double value)
      : top = value,
        right = value,
        bottom = value,
        left = value;

  /// Creates a Margin with symmetric horizontal and vertical values.
  const Margin.symmetric({
    double vertical = 0,
    double horizontal = 0,
  })  : top = vertical,
        bottom = vertical,
        left = horizontal,
        right = horizontal;

  /// Creates a Margin with only the specified sides.
  const Margin.only({
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.left = 0,
  });

  /// Creates a Margin from EdgeInsets.
  factory Margin.fromEdgeInsets(EdgeInsets insets) {
    return Margin(
      top: insets.top,
      right: insets.right,
      bottom: insets.bottom,
      left: insets.left,
    );
  }

  /// Zero margin.
  static const Margin zero = Margin();

  /// Default chart margin.
  static const Margin defaultChart = Margin(
    top: 20,
    right: 20,
    bottom: 40,
    left: 50,
  );

  /// The horizontal margin (left + right).
  double get horizontal => left + right;

  /// The vertical margin (top + bottom).
  double get vertical => top + bottom;

  /// The total width consumed by margins.
  double get totalWidth => horizontal;

  /// The total height consumed by margins.
  double get totalHeight => vertical;

  /// Whether all margins are zero.
  bool get isZero => top == 0 && right == 0 && bottom == 0 && left == 0;

  /// Converts to EdgeInsets.
  EdgeInsets toEdgeInsets() {
    return EdgeInsets.fromLTRB(left, top, right, bottom);
  }

  /// Applies this margin to a Size, returning the inner size.
  Size applyToSize(Size outer) {
    return Size(
      outer.width - horizontal,
      outer.height - vertical,
    );
  }

  /// Applies this margin to Bounds, returning the inner bounds.
  Bounds applyToBounds(Bounds outer) {
    return Bounds(
      x: outer.x + left,
      y: outer.y + top,
      width: outer.width - horizontal,
      height: outer.height - vertical,
    );
  }

  /// Expands a Size by this margin.
  Size expandSize(Size inner) {
    return Size(
      inner.width + horizontal,
      inner.height + vertical,
    );
  }

  /// Expands Bounds by this margin.
  Bounds expandBounds(Bounds inner) {
    return Bounds(
      x: inner.x - left,
      y: inner.y - top,
      width: inner.width + horizontal,
      height: inner.height + vertical,
    );
  }

  /// Returns the offset for positioning content within the margin.
  Offset get offset => Offset(left, top);

  /// Adds another margin to this one.
  Margin operator +(Margin other) {
    return Margin(
      top: top + other.top,
      right: right + other.right,
      bottom: bottom + other.bottom,
      left: left + other.left,
    );
  }

  /// Subtracts another margin from this one.
  Margin operator -(Margin other) {
    return Margin(
      top: top - other.top,
      right: right - other.right,
      bottom: bottom - other.bottom,
      left: left - other.left,
    );
  }

  /// Multiplies this margin by a scalar.
  Margin operator *(double scalar) {
    return Margin(
      top: top * scalar,
      right: right * scalar,
      bottom: bottom * scalar,
      left: left * scalar,
    );
  }

  /// Divides this margin by a scalar.
  Margin operator /(double scalar) {
    return Margin(
      top: top / scalar,
      right: right / scalar,
      bottom: bottom / scalar,
      left: left / scalar,
    );
  }

  /// Interpolates between this margin and another.
  Margin lerp(Margin other, double t) {
    return Margin(
      top: top + (other.top - top) * t,
      right: right + (other.right - right) * t,
      bottom: bottom + (other.bottom - bottom) * t,
      left: left + (other.left - left) * t,
    );
  }

  /// Creates a copy with updated values.
  Margin copyWith({
    double? top,
    double? right,
    double? bottom,
    double? left,
  }) {
    return Margin(
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Margin &&
        other.top == top &&
        other.right == right &&
        other.bottom == bottom &&
        other.left == left;
  }

  @override
  int get hashCode => Object.hash(top, right, bottom, left);

  @override
  String toString() =>
      'Margin(top: $top, right: $right, bottom: $bottom, left: $left)';
}

/// Extension methods for applying margins.
extension MarginExtensions on Size {
  /// Applies a margin to this size, returning the inner size.
  Size applyMargin(Margin margin) => margin.applyToSize(this);

  /// Expands this size by a margin.
  Size expandByMargin(Margin margin) => margin.expandSize(this);
}

/// Extension methods for applying margins to Bounds.
extension MarginBoundsExtensions on Bounds {
  /// Applies a margin to this bounds, returning the inner bounds.
  Bounds applyMargin(Margin margin) => margin.applyToBounds(this);

  /// Expands this bounds by a margin.
  Bounds expandByMargin(Margin margin) => margin.expandBounds(this);
}
