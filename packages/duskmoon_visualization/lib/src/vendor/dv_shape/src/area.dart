import 'package:duskmoon_visualization/src/vendor/dv_curve/dv_curve.dart'
    as dv_curve;
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:flutter/widgets.dart';

/// A widget that draws a filled area between two lines or from a baseline.
class AreaPath extends StatelessWidget {
  /// The data points for the top line.
  final List<Point> points;

  /// Optional data points for the bottom line. If null, uses baseline.
  final List<Point>? bottomPoints;

  /// The baseline y-value when bottomPoints is null.
  final double baseline;

  /// Optional curve generator for smooth areas.
  final dv_curve.Curve? curve;

  /// The fill color.
  final Color color;

  /// Optional stroke color for the outline.
  final Color? strokeColor;

  /// The stroke width for the outline.
  final double strokeWidth;

  /// Optional gradient shader.
  final Shader? shader;

  /// Whether the line is defined (drawn) for null/invalid points.
  final bool Function(Point)? defined;

  /// Creates an area path widget.
  const AreaPath({
    super.key,
    required this.points,
    this.bottomPoints,
    this.baseline = 0,
    this.curve,
    this.color = const Color(0x80000000),
    this.strokeColor,
    this.strokeWidth = 1.0,
    this.shader,
    this.defined,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _AreaPathPainter(
        points: points,
        bottomPoints: bottomPoints,
        baseline: baseline,
        curve: curve,
        color: color,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
        shader: shader,
        defined: defined,
      ),
    );
  }
}

class _AreaPathPainter extends CustomPainter {
  final List<Point> points;
  final List<Point>? bottomPoints;
  final double baseline;
  final dv_curve.Curve? curve;
  final Color color;
  final Color? strokeColor;
  final double strokeWidth;
  final Shader? shader;
  final bool Function(Point)? defined;

  _AreaPathPainter({
    required this.points,
    this.bottomPoints,
    required this.baseline,
    this.curve,
    required this.color,
    this.strokeColor,
    required this.strokeWidth,
    this.shader,
    this.defined,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    // Filter points based on defined callback
    final validPoints = defined != null
        ? points.where((p) => p.isFinite && defined!(p)).toList()
        : points.where((p) => p.isFinite).toList();

    if (validPoints.isEmpty) return;

    // Apply curve if provided
    final topPoints = curve?.generate(validPoints) ?? validPoints;

    // Build bottom points
    List<Point> bottom;
    if (bottomPoints != null) {
      final validBottom = defined != null
          ? bottomPoints!.where((p) => p.isFinite && defined!(p)).toList()
          : bottomPoints!.where((p) => p.isFinite).toList();
      bottom = curve?.generate(validBottom) ?? validBottom;
    } else {
      bottom = topPoints.map((p) => Point(p.x, baseline)).toList();
    }

    final path = Path();

    // Draw top line
    path.moveTo(topPoints.first.x, topPoints.first.y);
    for (int i = 1; i < topPoints.length; i++) {
      path.lineTo(topPoints[i].x, topPoints[i].y);
    }

    // Draw bottom line (reversed)
    for (int i = bottom.length - 1; i >= 0; i--) {
      path.lineTo(bottom[i].x, bottom[i].y);
    }

    path.close();

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
  bool shouldRepaint(_AreaPathPainter oldDelegate) {
    return points != oldDelegate.points ||
        bottomPoints != oldDelegate.bottomPoints ||
        baseline != oldDelegate.baseline ||
        color != oldDelegate.color;
  }
}
