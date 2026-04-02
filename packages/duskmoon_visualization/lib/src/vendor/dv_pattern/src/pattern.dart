import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

/// Base class for pattern fills.
abstract class Pattern {
  /// The pattern width.
  final double width;

  /// The pattern height.
  final double height;

  /// The background color.
  final Color backgroundColor;

  /// The foreground/pattern color.
  final Color foregroundColor;

  /// Creates a pattern.
  const Pattern({
    required this.width,
    required this.height,
    this.backgroundColor = const Color(0x00000000),
    this.foregroundColor = const Color(0xFF000000),
  });

  /// Draws the pattern once at origin.
  void drawPattern(Canvas canvas, Size size);

  /// Creates a shader that tiles this pattern.
  Shader createShader(Rect bounds) {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = Size(width, height);

    // Draw background
    if (backgroundColor.a > 0) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, width, height),
        Paint()..color = backgroundColor,
      );
    }

    // Draw pattern
    drawPattern(canvas, size);

    final picture = recorder.endRecording();
    final image = picture.toImageSync(width.ceil(), height.ceil());

    return ImageShader(
      image,
      TileMode.repeated,
      TileMode.repeated,
      Matrix4.identity().storage,
    );
  }
}

/// Widget that paints a pattern fill.
class PatternPaint extends StatelessWidget {
  /// The pattern to paint.
  final Pattern pattern;

  /// Child widget to apply the pattern to.
  final Widget? child;

  /// Creates a pattern paint widget.
  const PatternPaint({
    super.key,
    required this.pattern,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PatternPainter(pattern: pattern),
      child: child,
    );
  }
}

class _PatternPainter extends CustomPainter {
  final Pattern pattern;

  _PatternPainter({required this.pattern});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..shader = pattern.createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(_PatternPainter oldDelegate) {
    return pattern != oldDelegate.pattern;
  }
}
