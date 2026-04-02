import 'package:flutter/widgets.dart';

import 'glyph.dart';

/// A diamond (rotated square) glyph marker.
class DiamondGlyph extends Glyph {
  /// Creates a diamond glyph.
  const DiamondGlyph({
    super.key,
    required super.x,
    required super.y,
    super.size = 8,
    super.color,
    super.strokeColor,
    super.strokeWidth,
    super.rotation,
    super.opacity,
  });

  @override
  Path createPath() {
    final half = size / 2;

    final path = Path();
    path.moveTo(0, -half); // Top
    path.lineTo(half, 0); // Right
    path.lineTo(0, half); // Bottom
    path.lineTo(-half, 0); // Left
    path.close();

    return path;
  }

  /// Factory for creating diamond glyphs.
  static DiamondGlyph create({
    required double x,
    required double y,
    double size = 8,
    Color color = const Color(0xFF000000),
    Color? strokeColor,
    double strokeWidth = 1.0,
  }) {
    return DiamondGlyph(
      x: x,
      y: y,
      size: size,
      color: color,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
    );
  }
}
