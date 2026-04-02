import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'glyph.dart';

/// A triangle glyph marker.
class TriangleGlyph extends Glyph {
  /// Whether the triangle points upward (true) or downward (false).
  final bool pointUp;

  /// Creates a triangle glyph.
  const TriangleGlyph({
    super.key,
    required super.x,
    required super.y,
    super.size = 8,
    super.color,
    super.strokeColor,
    super.strokeWidth,
    super.rotation,
    super.opacity,
    this.pointUp = true,
  });

  @override
  Path createPath() {
    final half = size / 2;
    // Equilateral triangle inscribed in circle
    final height = size * math.sqrt(3) / 2;
    final topY = pointUp ? -height * 2 / 3 : height * 2 / 3;
    final baseY = pointUp ? height / 3 : -height / 3;

    final path = Path();
    path.moveTo(0, topY);
    path.lineTo(-half, baseY);
    path.lineTo(half, baseY);
    path.close();

    return path;
  }

  /// Factory for creating triangle glyphs.
  static TriangleGlyph create({
    required double x,
    required double y,
    double size = 8,
    Color color = const Color(0xFF000000),
    Color? strokeColor,
    double strokeWidth = 1.0,
    bool pointUp = true,
  }) {
    return TriangleGlyph(
      x: x,
      y: y,
      size: size,
      color: color,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      pointUp: pointUp,
    );
  }
}

/// A downward-pointing triangle glyph marker.
class TriangleDownGlyph extends TriangleGlyph {
  /// Creates a downward-pointing triangle glyph.
  const TriangleDownGlyph({
    super.key,
    required super.x,
    required super.y,
    super.size = 8,
    super.color,
    super.strokeColor,
    super.strokeWidth,
    super.rotation,
    super.opacity,
  }) : super(pointUp: false);
}
