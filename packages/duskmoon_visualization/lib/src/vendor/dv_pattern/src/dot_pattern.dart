import 'package:flutter/widgets.dart';

import 'pattern.dart';

/// A dotted pattern fill.
class DotPattern extends Pattern {
  /// The radius of each dot.
  final double radius;

  /// The horizontal spacing between dots.
  final double spacingX;

  /// The vertical spacing between dots.
  final double spacingY;

  /// Whether to offset alternating rows.
  final bool staggered;

  /// Creates a dot pattern.
  const DotPattern({
    this.radius = 2,
    this.spacingX = 10,
    this.spacingY = 10,
    this.staggered = false,
    super.backgroundColor,
    super.foregroundColor,
  }) : super(
          width: spacingX,
          height: staggered ? spacingY * 2 : spacingY,
        );

  /// Creates a regular grid dot pattern.
  factory DotPattern.grid({
    double radius = 2,
    double spacing = 10,
    Color backgroundColor = const Color(0x00000000),
    Color foregroundColor = const Color(0xFF000000),
  }) {
    return DotPattern(
      radius: radius,
      spacingX: spacing,
      spacingY: spacing,
      staggered: false,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }

  /// Creates a staggered (honeycomb) dot pattern.
  factory DotPattern.staggered({
    double radius = 2,
    double spacing = 10,
    Color backgroundColor = const Color(0x00000000),
    Color foregroundColor = const Color(0xFF000000),
  }) {
    return DotPattern(
      radius: radius,
      spacingX: spacing,
      spacingY: spacing,
      staggered: true,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }

  @override
  void drawPattern(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = foregroundColor
      ..style = PaintingStyle.fill;

    if (staggered) {
      // First row
      canvas.drawCircle(
        Offset(spacingX / 2, spacingY / 2),
        radius,
        paint,
      );
      // Offset row
      canvas.drawCircle(
        Offset(0, spacingY * 1.5),
        radius,
        paint,
      );
      canvas.drawCircle(
        Offset(spacingX, spacingY * 1.5),
        radius,
        paint,
      );
    } else {
      canvas.drawCircle(
        Offset(spacingX / 2, spacingY / 2),
        radius,
        paint,
      );
    }
  }
}

/// A checkerboard pattern.
class CheckerPattern extends Pattern {
  /// The size of each square.
  final double squareSize;

  /// The secondary color (for alternating squares).
  final Color secondaryColor;

  /// Creates a checker pattern.
  const CheckerPattern({
    this.squareSize = 10,
    super.backgroundColor,
    super.foregroundColor,
    this.secondaryColor = const Color(0xFFFFFFFF),
  }) : super(
          width: squareSize * 2,
          height: squareSize * 2,
        );

  @override
  void drawPattern(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = foregroundColor
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill;

    // Top-left
    canvas.drawRect(
      Rect.fromLTWH(0, 0, squareSize, squareSize),
      paint1,
    );
    // Top-right
    canvas.drawRect(
      Rect.fromLTWH(squareSize, 0, squareSize, squareSize),
      paint2,
    );
    // Bottom-left
    canvas.drawRect(
      Rect.fromLTWH(0, squareSize, squareSize, squareSize),
      paint2,
    );
    // Bottom-right
    canvas.drawRect(
      Rect.fromLTWH(squareSize, squareSize, squareSize, squareSize),
      paint1,
    );
  }
}
