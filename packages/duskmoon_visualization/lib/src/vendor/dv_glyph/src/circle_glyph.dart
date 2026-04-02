import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'glyph.dart';

/// A circular glyph marker.
class CircleGlyph extends Glyph {
  /// Creates a circle glyph.
  const CircleGlyph({
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
    final radius = size / 2;
    return Path()
      ..addOval(Rect.fromCircle(center: Offset.zero, radius: radius));
  }

  /// Factory for creating circle glyphs.
  static CircleGlyph create({
    required double x,
    required double y,
    double size = 8,
    Color color = const Color(0xFF000000),
    Color? strokeColor,
    double strokeWidth = 1.0,
  }) {
    return CircleGlyph(
      x: x,
      y: y,
      size: size,
      color: color,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
    );
  }
}

/// Draws multiple circle glyphs efficiently.
class CircleGlyphs extends StatelessWidget {
  /// The x coordinates.
  final List<double> xValues;

  /// The y coordinates.
  final List<double> yValues;

  /// The sizes (single value or per-point).
  final List<double>? sizes;

  /// Default size if sizes is null.
  final double size;

  /// The fill color.
  final Color color;

  /// Optional stroke color.
  final Color? strokeColor;

  /// The stroke width.
  final double strokeWidth;

  /// Creates multiple circle glyphs.
  const CircleGlyphs({
    super.key,
    required this.xValues,
    required this.yValues,
    this.sizes,
    this.size = 8,
    this.color = const Color(0xFF000000),
    this.strokeColor,
    this.strokeWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CircleGlyphsPainter(
        xValues: xValues,
        yValues: yValues,
        sizes: sizes,
        size: size,
        color: color,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class _CircleGlyphsPainter extends CustomPainter {
  final List<double> xValues;
  final List<double> yValues;
  final List<double>? sizes;
  final double size;
  final Color color;
  final Color? strokeColor;
  final double strokeWidth;

  _CircleGlyphsPainter({
    required this.xValues,
    required this.yValues,
    this.sizes,
    required this.size,
    required this.color,
    this.strokeColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final count = math.min(xValues.length, yValues.length);

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final strokePaint = strokeColor != null
        ? (Paint()
          ..style = PaintingStyle.stroke
          ..color = strokeColor!
          ..strokeWidth = strokeWidth)
        : null;

    for (int i = 0; i < count; i++) {
      final x = xValues[i];
      final y = yValues[i];
      if (!x.isFinite || !y.isFinite) continue;

      final radius =
          (sizes != null && i < sizes!.length ? sizes![i] : size) / 2;
      final center = Offset(x, y);

      canvas.drawCircle(center, radius, fillPaint);
      if (strokePaint != null) {
        canvas.drawCircle(center, radius, strokePaint);
      }
    }
  }

  @override
  bool shouldRepaint(_CircleGlyphsPainter oldDelegate) {
    return xValues != oldDelegate.xValues ||
        yValues != oldDelegate.yValues ||
        color != oldDelegate.color;
  }
}
