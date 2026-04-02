import 'package:flutter/widgets.dart';

import 'glyph.dart';

/// A square glyph marker.
class SquareGlyph extends Glyph {
  /// Creates a square glyph.
  const SquareGlyph({
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
    return Path()
      ..addRect(
          Rect.fromCenter(center: Offset.zero, width: size, height: size));
  }

  /// Factory for creating square glyphs.
  static SquareGlyph create({
    required double x,
    required double y,
    double size = 8,
    Color color = const Color(0xFF000000),
    Color? strokeColor,
    double strokeWidth = 1.0,
  }) {
    return SquareGlyph(
      x: x,
      y: y,
      size: size,
      color: color,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
    );
  }
}
