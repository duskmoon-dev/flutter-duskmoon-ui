import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// A widget that draws an arc shape for pie/donut chart slices.
class Arc extends StatelessWidget {
  /// The center x coordinate.
  final double centerX;

  /// The center y coordinate.
  final double centerY;

  /// The outer radius.
  final double outerRadius;

  /// The inner radius (0 for pie slice, > 0 for donut slice).
  final double innerRadius;

  /// The start angle in radians.
  final double startAngle;

  /// The end angle in radians.
  final double endAngle;

  /// The fill color.
  final Color color;

  /// Optional stroke color for the outline.
  final Color? strokeColor;

  /// The stroke width for the outline.
  final double strokeWidth;

  /// Optional corner radius for rounded corners.
  final double cornerRadius;

  /// Optional padding angle in radians between slices.
  final double padAngle;

  /// Optional gradient shader.
  final Shader? shader;

  /// Creates an arc widget.
  const Arc({
    super.key,
    this.centerX = 0,
    this.centerY = 0,
    required this.outerRadius,
    this.innerRadius = 0,
    required this.startAngle,
    required this.endAngle,
    this.color = const Color(0xFF000000),
    this.strokeColor,
    this.strokeWidth = 1.0,
    this.cornerRadius = 0,
    this.padAngle = 0,
    this.shader,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ArcPainter(
        centerX: centerX,
        centerY: centerY,
        outerRadius: outerRadius,
        innerRadius: innerRadius,
        startAngle: startAngle,
        endAngle: endAngle,
        color: color,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
        cornerRadius: cornerRadius,
        padAngle: padAngle,
        shader: shader,
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double centerX;
  final double centerY;
  final double outerRadius;
  final double innerRadius;
  final double startAngle;
  final double endAngle;
  final Color color;
  final Color? strokeColor;
  final double strokeWidth;
  final double cornerRadius;
  final double padAngle;
  final Shader? shader;

  _ArcPainter({
    required this.centerX,
    required this.centerY,
    required this.outerRadius,
    required this.innerRadius,
    required this.startAngle,
    required this.endAngle,
    required this.color,
    this.strokeColor,
    required this.strokeWidth,
    required this.cornerRadius,
    required this.padAngle,
    this.shader,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final adjustedStart = startAngle + padAngle / 2;
    final adjustedEnd = endAngle - padAngle / 2;

    if (adjustedStart >= adjustedEnd) return;

    final path = Path();

    if (innerRadius <= 0) {
      // Pie slice - just outer arc and lines to center
      path.moveTo(centerX, centerY);
      path.lineTo(
        centerX + outerRadius * math.cos(adjustedStart),
        centerY + outerRadius * math.sin(adjustedStart),
      );
      path.arcTo(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: outerRadius),
        adjustedStart,
        adjustedEnd - adjustedStart,
        false,
      );
      path.close();
    } else {
      // Donut slice - outer and inner arcs
      // Start at outer arc start
      path.moveTo(
        centerX + outerRadius * math.cos(adjustedStart),
        centerY + outerRadius * math.sin(adjustedStart),
      );

      // Outer arc
      path.arcTo(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: outerRadius),
        adjustedStart,
        adjustedEnd - adjustedStart,
        false,
      );

      // Line to inner arc end
      path.lineTo(
        centerX + innerRadius * math.cos(adjustedEnd),
        centerY + innerRadius * math.sin(adjustedEnd),
      );

      // Inner arc (reverse direction)
      path.arcTo(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: innerRadius),
        adjustedEnd,
        -(adjustedEnd - adjustedStart),
        false,
      );

      path.close();
    }

    // Fill
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    if (shader != null) {
      fillPaint.shader = shader;
    }

    canvas.drawPath(path, fillPaint);

    // Stroke outline if specified
    if (strokeColor != null) {
      final strokePaint = Paint()
        ..style = PaintingStyle.stroke
        ..color = strokeColor!
        ..strokeWidth = strokeWidth;

      canvas.drawPath(path, strokePaint);
    }
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) {
    return centerX != oldDelegate.centerX ||
        centerY != oldDelegate.centerY ||
        outerRadius != oldDelegate.outerRadius ||
        innerRadius != oldDelegate.innerRadius ||
        startAngle != oldDelegate.startAngle ||
        endAngle != oldDelegate.endAngle ||
        color != oldDelegate.color;
  }
}

/// Extension for calculating arc centroid.
extension ArcGeometry on Arc {
  /// Calculates the centroid point of the arc.
  Offset get centroid {
    final midAngle = (startAngle + endAngle) / 2;
    final midRadius = (innerRadius + outerRadius) / 2;
    return Offset(
      centerX + midRadius * math.cos(midAngle),
      centerY + midRadius * math.sin(midAngle),
    );
  }
}
