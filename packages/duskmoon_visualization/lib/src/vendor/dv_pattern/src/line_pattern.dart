import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'pattern.dart';

/// A striped/lined pattern fill.
class LinePattern extends Pattern {
  /// The line stroke width.
  final double strokeWidth;

  /// The spacing between lines.
  final double spacing;

  /// The angle of the lines in radians (0 = horizontal).
  final double angle;

  /// Creates a line pattern.
  const LinePattern({
    this.strokeWidth = 2,
    this.spacing = 8,
    this.angle = 0,
    super.backgroundColor,
    super.foregroundColor,
  }) : super(
          width: spacing + strokeWidth,
          height: spacing + strokeWidth,
        );

  /// Creates a horizontal line pattern.
  factory LinePattern.horizontal({
    double strokeWidth = 2,
    double spacing = 8,
    Color backgroundColor = const Color(0x00000000),
    Color foregroundColor = const Color(0xFF000000),
  }) {
    return LinePattern(
      strokeWidth: strokeWidth,
      spacing: spacing,
      angle: 0,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }

  /// Creates a vertical line pattern.
  factory LinePattern.vertical({
    double strokeWidth = 2,
    double spacing = 8,
    Color backgroundColor = const Color(0x00000000),
    Color foregroundColor = const Color(0xFF000000),
  }) {
    return LinePattern(
      strokeWidth: strokeWidth,
      spacing: spacing,
      angle: math.pi / 2,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }

  /// Creates a diagonal line pattern (45 degrees).
  factory LinePattern.diagonal({
    double strokeWidth = 2,
    double spacing = 8,
    Color backgroundColor = const Color(0x00000000),
    Color foregroundColor = const Color(0xFF000000),
    bool reverse = false,
  }) {
    return LinePattern(
      strokeWidth: strokeWidth,
      spacing: spacing,
      angle: reverse ? -math.pi / 4 : math.pi / 4,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }

  @override
  void drawPattern(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = foregroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.save();

    // Rotate around center
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(angle);
    canvas.translate(-size.width / 2, -size.height / 2);

    // Draw lines to cover the rotated area
    final diagonal =
        math.sqrt(size.width * size.width + size.height * size.height);
    final start = -diagonal;
    final end = diagonal * 2;

    for (double y = start; y < end; y += spacing + strokeWidth) {
      canvas.drawLine(
        Offset(start, y),
        Offset(end, y),
        paint,
      );
    }

    canvas.restore();
  }
}

/// A cross-hatch pattern (two sets of lines).
class CrossHatchPattern extends Pattern {
  /// The line stroke width.
  final double strokeWidth;

  /// The spacing between lines.
  final double spacing;

  /// The angle of the first set of lines.
  final double angle1;

  /// The angle of the second set of lines.
  final double angle2;

  /// Creates a cross-hatch pattern.
  const CrossHatchPattern({
    this.strokeWidth = 1,
    this.spacing = 8,
    this.angle1 = 0.7853981633974483, // 45 degrees
    this.angle2 = -0.7853981633974483, // -45 degrees
    super.backgroundColor,
    super.foregroundColor,
  }) : super(
          width: spacing + strokeWidth,
          height: spacing + strokeWidth,
        );

  @override
  void drawPattern(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = foregroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    void drawLines(double angle) {
      canvas.save();
      canvas.translate(size.width / 2, size.height / 2);
      canvas.rotate(angle);
      canvas.translate(-size.width / 2, -size.height / 2);

      final diagonal =
          math.sqrt(size.width * size.width + size.height * size.height);
      final start = -diagonal;
      final end = diagonal * 2;

      for (double y = start; y < end; y += spacing + strokeWidth) {
        canvas.drawLine(Offset(start, y), Offset(end, y), paint);
      }

      canvas.restore();
    }

    drawLines(angle1);
    drawLines(angle2);
  }
}
