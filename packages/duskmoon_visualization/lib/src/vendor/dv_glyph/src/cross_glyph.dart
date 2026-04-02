import 'package:flutter/widgets.dart';

import 'glyph.dart';

/// A cross (plus) glyph marker.
class CrossGlyph extends Glyph {
  /// The thickness of the cross arms as a fraction of size.
  final double thickness;

  /// Creates a cross glyph.
  const CrossGlyph({
    super.key,
    required super.x,
    required super.y,
    super.size = 8,
    super.color,
    super.strokeColor,
    super.strokeWidth,
    super.rotation,
    super.opacity,
    this.thickness = 0.3,
  });

  @override
  Path createPath() {
    final half = size / 2;
    final armWidth = size * thickness / 2;

    final path = Path();

    // Horizontal arm
    path.addRect(Rect.fromLTRB(-half, -armWidth, half, armWidth));

    // Vertical arm
    path.addRect(Rect.fromLTRB(-armWidth, -half, armWidth, half));

    return path;
  }

  /// Factory for creating cross glyphs.
  static CrossGlyph create({
    required double x,
    required double y,
    double size = 8,
    Color color = const Color(0xFF000000),
    Color? strokeColor,
    double strokeWidth = 1.0,
    double thickness = 0.3,
  }) {
    return CrossGlyph(
      x: x,
      y: y,
      size: size,
      color: color,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      thickness: thickness,
    );
  }
}

/// An X-shaped glyph marker (rotated cross).
class XGlyph extends Glyph {
  /// The thickness of the X arms as a fraction of size.
  final double thickness;

  /// Creates an X glyph.
  const XGlyph({
    super.key,
    required super.x,
    required super.y,
    super.size = 8,
    super.color,
    super.strokeColor,
    super.strokeWidth,
    super.opacity,
    this.thickness = 0.3,
  }) : super(rotation: 0.7853981633974483); // 45 degrees in radians

  @override
  Path createPath() {
    final half = size / 2;
    final armWidth = size * thickness / 2;

    final path = Path();

    // Horizontal arm (will be rotated 45 degrees)
    path.addRect(Rect.fromLTRB(-half, -armWidth, half, armWidth));

    // Vertical arm (will be rotated 45 degrees)
    path.addRect(Rect.fromLTRB(-armWidth, -half, armWidth, half));

    return path;
  }
}

/// A star glyph marker.
class StarGlyph extends Glyph {
  /// Number of points on the star.
  final int points;

  /// Inner radius as a fraction of outer radius.
  final double innerRadiusFactor;

  /// Creates a star glyph.
  const StarGlyph({
    super.key,
    required super.x,
    required super.y,
    super.size = 8,
    super.color,
    super.strokeColor,
    super.strokeWidth,
    super.rotation,
    super.opacity,
    this.points = 5,
    this.innerRadiusFactor = 0.5,
  });

  @override
  Path createPath() {
    final outerRadius = size / 2;
    final innerRadius = outerRadius * innerRadiusFactor;
    final path = Path();

    final angleStep = 3.141592653589793 / points; // pi / points

    for (int i = 0; i < points * 2; i++) {
      final angle = i * angleStep - 1.5707963267948966; // Start from top
      final radius = i.isEven ? outerRadius : innerRadius;
      final px = radius * _cos(angle);
      final py = radius * _sin(angle);

      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }

    path.close();
    return path;
  }

  double _cos(double x) {
    // Approximate cosine
    return _sin(x + 1.5707963267948966);
  }

  double _sin(double x) {
    // Normalize to -pi to pi
    while (x > 3.141592653589793) {
      x -= 6.283185307179586;
    }
    while (x < -3.141592653589793) {
      x += 6.283185307179586;
    }

    // Taylor series approximation
    double result = x;
    double term = x;
    for (int i = 1; i < 7; i++) {
      term *= -x * x / ((2 * i) * (2 * i + 1));
      result += term;
    }
    return result;
  }
}
