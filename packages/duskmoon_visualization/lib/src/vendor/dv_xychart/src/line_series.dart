import 'package:flutter/material.dart';

import 'xy_chart.dart';

/// Line series for XY charts.
class LineSeries extends StatelessWidget {
  /// Data points for the line.
  final List<XYDataPoint> data;

  /// Line color.
  final Color color;

  /// Line stroke width.
  final double strokeWidth;

  /// Whether to show data point markers.
  final bool showMarkers;

  /// Marker radius.
  final double markerRadius;

  /// Marker fill color.
  final Color? markerColor;

  /// Whether to draw a smooth curve.
  final bool smooth;

  /// Curve tension (0-1) for smooth curves.
  final double tension;

  /// Line dash pattern (e.g., [5, 3] for dashed line).
  final List<double>? dashPattern;

  /// Callback when a point is tapped.
  final void Function(XYDataPoint point, int index)? onPointTap;

  const LineSeries({
    super.key,
    required this.data,
    this.color = Colors.blue,
    this.strokeWidth = 2,
    this.showMarkers = false,
    this.markerRadius = 4,
    this.markerColor,
    this.smooth = false,
    this.tension = 0.4,
    this.dashPattern,
    this.onPointTap,
  });

  @override
  Widget build(BuildContext context) {
    final scope = XYChartScope.of(context);
    if (scope == null) {
      return const SizedBox.shrink();
    }

    return CustomPaint(
      size: Size(scope.chartWidth, scope.chartHeight),
      painter: _LineSeriesPainter(
        data: data,
        xScale: scope.xScale,
        yScale: scope.yScale,
        color: color,
        strokeWidth: strokeWidth,
        showMarkers: showMarkers,
        markerRadius: markerRadius,
        markerColor: markerColor ?? color,
        smooth: smooth,
        tension: tension,
        dashPattern: dashPattern,
      ),
    );
  }
}

class _LineSeriesPainter extends CustomPainter {
  final List<XYDataPoint> data;
  final dynamic xScale;
  final dynamic yScale;
  final Color color;
  final double strokeWidth;
  final bool showMarkers;
  final double markerRadius;
  final Color markerColor;
  final bool smooth;
  final double tension;
  final List<double>? dashPattern;

  _LineSeriesPainter({
    required this.data,
    required this.xScale,
    required this.yScale,
    required this.color,
    required this.strokeWidth,
    required this.showMarkers,
    required this.markerRadius,
    required this.markerColor,
    required this.smooth,
    required this.tension,
    this.dashPattern,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final points = _computePoints();
    if (points.isEmpty) return;

    _drawLine(canvas, points);

    if (showMarkers) {
      _drawMarkers(canvas, points);
    }
  }

  List<Offset> _computePoints() {
    return data.map((point) {
      final x = xScale(point.x is num ? point.x.toDouble() : 0.0);
      final y = yScale(point.y);
      return Offset(x, y);
    }).toList();
  }

  void _drawLine(Canvas canvas, List<Offset> points) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    if (smooth && points.length > 2) {
      _drawSmoothLine(path, points);
    } else {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    if (dashPattern != null && dashPattern!.isNotEmpty) {
      canvas.drawPath(_dashPath(path, dashPattern!), paint);
    } else {
      canvas.drawPath(path, paint);
    }
  }

  void _drawSmoothLine(Path path, List<Offset> points) {
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = i > 0 ? points[i - 1] : points[i];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = i < points.length - 2 ? points[i + 2] : p2;

      final cp1x = p1.dx + (p2.dx - p0.dx) * tension / 3;
      final cp1y = p1.dy + (p2.dy - p0.dy) * tension / 3;
      final cp2x = p2.dx - (p3.dx - p1.dx) * tension / 3;
      final cp2y = p2.dy - (p3.dy - p1.dy) * tension / 3;

      path.cubicTo(cp1x, cp1y, cp2x, cp2y, p2.dx, p2.dy);
    }
  }

  Path _dashPath(Path source, List<double> pattern) {
    final result = Path();
    final metrics = source.computeMetrics();

    for (final metric in metrics) {
      double distance = 0;
      int patternIndex = 0;
      bool draw = true;

      while (distance < metric.length) {
        final length = pattern[patternIndex % pattern.length];
        final nextDistance = distance + length;

        if (draw) {
          final extractPath = metric.extractPath(
            distance,
            nextDistance.clamp(0, metric.length),
          );
          result.addPath(extractPath, Offset.zero);
        }

        distance = nextDistance;
        patternIndex++;
        draw = !draw;
      }
    }

    return result;
  }

  void _drawMarkers(Canvas canvas, List<Offset> points) {
    final fillPaint = Paint()
      ..color = markerColor
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    for (final point in points) {
      canvas.drawCircle(point, markerRadius, fillPaint);
      canvas.drawCircle(point, markerRadius, strokePaint);
    }
  }

  @override
  bool shouldRepaint(_LineSeriesPainter oldDelegate) {
    return data != oldDelegate.data ||
        color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth ||
        showMarkers != oldDelegate.showMarkers ||
        markerRadius != oldDelegate.markerRadius ||
        smooth != oldDelegate.smooth;
  }
}
