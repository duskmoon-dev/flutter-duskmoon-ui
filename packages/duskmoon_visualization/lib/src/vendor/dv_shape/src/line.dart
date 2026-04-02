import 'dart:ui' as ui;

import 'package:duskmoon_visualization/src/vendor/dv_curve/dv_curve.dart'
    as dv_curve;
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:flutter/widgets.dart';

/// A widget that draws a line path through data points.
class LinePath extends StatelessWidget {
  /// The data points to draw the line through.
  final List<Point> points;

  /// Optional curve generator for smooth lines.
  final dv_curve.Curve? curve;

  /// The stroke color.
  final Color color;

  /// The stroke width.
  final double strokeWidth;

  /// The stroke cap style.
  final StrokeCap strokeCap;

  /// The stroke join style.
  final StrokeJoin strokeJoin;

  /// Optional dash pattern [dash, gap, dash, gap, ...].
  final List<double>? dashPattern;

  /// Whether the line is defined (drawn) for null/invalid points.
  final bool Function(Point)? defined;

  /// Creates a line path widget.
  const LinePath({
    super.key,
    required this.points,
    this.curve,
    this.color = const Color(0xFF000000),
    this.strokeWidth = 1.0,
    this.strokeCap = StrokeCap.butt,
    this.strokeJoin = StrokeJoin.miter,
    this.dashPattern,
    this.defined,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LinePathPainter(
        points: points,
        curve: curve,
        color: color,
        strokeWidth: strokeWidth,
        strokeCap: strokeCap,
        strokeJoin: strokeJoin,
        dashPattern: dashPattern,
        defined: defined,
      ),
    );
  }
}

class _LinePathPainter extends CustomPainter {
  final List<Point> points;
  final dv_curve.Curve? curve;
  final Color color;
  final double strokeWidth;
  final StrokeCap strokeCap;
  final StrokeJoin strokeJoin;
  final List<double>? dashPattern;
  final bool Function(Point)? defined;

  _LinePathPainter({
    required this.points,
    this.curve,
    required this.color,
    required this.strokeWidth,
    required this.strokeCap,
    required this.strokeJoin,
    this.dashPattern,
    this.defined,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeCap
      ..strokeJoin = strokeJoin
      ..style = PaintingStyle.stroke;

    // Filter points based on defined callback
    final validPoints = defined != null
        ? points.where((p) => p.isFinite && defined!(p)).toList()
        : points.where((p) => p.isFinite).toList();

    if (validPoints.isEmpty) return;

    // Apply curve if provided
    final curvedPoints = curve?.generate(validPoints) ?? validPoints;

    final path = Path();
    path.moveTo(curvedPoints.first.x, curvedPoints.first.y);

    for (int i = 1; i < curvedPoints.length; i++) {
      path.lineTo(curvedPoints[i].x, curvedPoints[i].y);
    }

    // Apply dash pattern if provided
    if (dashPattern != null && dashPattern!.isNotEmpty) {
      final dashedPath = _createDashedPath(path, dashPattern!);
      canvas.drawPath(dashedPath, paint);
    } else {
      canvas.drawPath(path, paint);
    }
  }

  Path _createDashedPath(Path source, List<double> pattern) {
    final result = Path();
    final metrics = source.computeMetrics();

    for (final metric in metrics) {
      double distance = 0;
      int patternIndex = 0;
      bool draw = true;

      while (distance < metric.length) {
        final length = pattern[patternIndex % pattern.length];
        final end = (distance + length).clamp(0, metric.length);

        if (draw) {
          final extracted = metric.extractPath(distance, end.toDouble());
          result.addPath(extracted, ui.Offset.zero);
        }

        distance = end.toDouble();
        patternIndex++;
        draw = !draw;
      }
    }

    return result;
  }

  @override
  bool shouldRepaint(_LinePathPainter oldDelegate) {
    return points != oldDelegate.points ||
        curve != oldDelegate.curve ||
        color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
