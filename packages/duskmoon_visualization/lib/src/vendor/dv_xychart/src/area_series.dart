import 'package:flutter/material.dart';

import 'xy_chart.dart';

/// Area series for XY charts.
class AreaSeries extends StatelessWidget {
  /// Data points for the area.
  final List<XYDataPoint> data;

  /// Fill color.
  final Color color;

  /// Fill opacity (0-1).
  final double opacity;

  /// Whether to show the line on top of the area.
  final bool showLine;

  /// Line color (defaults to area color).
  final Color? lineColor;

  /// Line stroke width.
  final double lineWidth;

  /// Whether to draw a smooth curve.
  final bool smooth;

  /// Curve tension (0-1) for smooth curves.
  final double tension;

  /// Gradient for area fill.
  final Gradient? gradient;

  /// Baseline value (y-axis value where area starts).
  final double baseline;

  const AreaSeries({
    super.key,
    required this.data,
    this.color = Colors.blue,
    this.opacity = 0.3,
    this.showLine = true,
    this.lineColor,
    this.lineWidth = 2,
    this.smooth = false,
    this.tension = 0.4,
    this.gradient,
    this.baseline = 0,
  });

  @override
  Widget build(BuildContext context) {
    final scope = XYChartScope.of(context);
    if (scope == null) {
      return const SizedBox.shrink();
    }

    return CustomPaint(
      size: Size(scope.chartWidth, scope.chartHeight),
      painter: _AreaSeriesPainter(
        data: data,
        xScale: scope.xScale,
        yScale: scope.yScale,
        chartHeight: scope.chartHeight,
        color: color,
        opacity: opacity,
        showLine: showLine,
        lineColor: lineColor ?? color,
        lineWidth: lineWidth,
        smooth: smooth,
        tension: tension,
        gradient: gradient,
        baseline: baseline,
      ),
    );
  }
}

class _AreaSeriesPainter extends CustomPainter {
  final List<XYDataPoint> data;
  final dynamic xScale;
  final dynamic yScale;
  final double chartHeight;
  final Color color;
  final double opacity;
  final bool showLine;
  final Color lineColor;
  final double lineWidth;
  final bool smooth;
  final double tension;
  final Gradient? gradient;
  final double baseline;

  _AreaSeriesPainter({
    required this.data,
    required this.xScale,
    required this.yScale,
    required this.chartHeight,
    required this.color,
    required this.opacity,
    required this.showLine,
    required this.lineColor,
    required this.lineWidth,
    required this.smooth,
    required this.tension,
    this.gradient,
    required this.baseline,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final points = _computePoints();
    if (points.isEmpty) return;

    _drawArea(canvas, size, points);

    if (showLine) {
      _drawLine(canvas, points);
    }
  }

  List<Offset> _computePoints() {
    return data.map((point) {
      final x = xScale(point.x is num ? point.x.toDouble() : 0.0);
      final y = yScale(point.y);
      return Offset(x, y);
    }).toList();
  }

  void _drawArea(Canvas canvas, Size size, List<Offset> points) {
    final baselineY = yScale(baseline);
    final path = Path();

    // Start at baseline
    path.moveTo(points.first.dx, baselineY);

    if (smooth && points.length > 2) {
      // Draw line to first point
      path.lineTo(points.first.dx, points.first.dy);
      _addSmoothCurve(path, points);
    } else {
      for (final point in points) {
        path.lineTo(point.dx, point.dy);
      }
    }

    // Close path back to baseline
    path.lineTo(points.last.dx, baselineY);
    path.close();

    Paint paint;
    if (gradient != null) {
      paint = Paint()
        ..shader =
            gradient!.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill;
    } else {
      paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;
    }

    canvas.drawPath(path, paint);
  }

  void _addSmoothCurve(Path path, List<Offset> points) {
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

  void _drawLine(Canvas canvas, List<Offset> points) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    if (smooth && points.length > 2) {
      path.moveTo(points.first.dx, points.first.dy);
      _addSmoothCurve(path, points);
    } else {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_AreaSeriesPainter oldDelegate) {
    return data != oldDelegate.data ||
        color != oldDelegate.color ||
        opacity != oldDelegate.opacity ||
        showLine != oldDelegate.showLine ||
        smooth != oldDelegate.smooth;
  }
}

/// Stacked area series for multiple data sets.
class StackedAreaSeries extends StatelessWidget {
  /// List of data series.
  final List<List<XYDataPoint>> dataSeries;

  /// Colors for each series.
  final List<Color> colors;

  /// Fill opacity (0-1).
  final double opacity;

  /// Whether to show lines on top of areas.
  final bool showLines;

  /// Line stroke width.
  final double lineWidth;

  /// Whether to draw smooth curves.
  final bool smooth;

  /// Curve tension (0-1) for smooth curves.
  final double tension;

  const StackedAreaSeries({
    super.key,
    required this.dataSeries,
    required this.colors,
    this.opacity = 0.7,
    this.showLines = true,
    this.lineWidth = 2,
    this.smooth = false,
    this.tension = 0.4,
  });

  @override
  Widget build(BuildContext context) {
    final scope = XYChartScope.of(context);
    if (scope == null) {
      return const SizedBox.shrink();
    }

    return CustomPaint(
      size: Size(scope.chartWidth, scope.chartHeight),
      painter: _StackedAreaSeriesPainter(
        dataSeries: dataSeries,
        xScale: scope.xScale,
        yScale: scope.yScale,
        colors: colors,
        opacity: opacity,
        showLines: showLines,
        lineWidth: lineWidth,
        smooth: smooth,
        tension: tension,
      ),
    );
  }
}

class _StackedAreaSeriesPainter extends CustomPainter {
  final List<List<XYDataPoint>> dataSeries;
  final dynamic xScale;
  final dynamic yScale;
  final List<Color> colors;
  final double opacity;
  final bool showLines;
  final double lineWidth;
  final bool smooth;
  final double tension;

  _StackedAreaSeriesPainter({
    required this.dataSeries,
    required this.xScale,
    required this.yScale,
    required this.colors,
    required this.opacity,
    required this.showLines,
    required this.lineWidth,
    required this.smooth,
    required this.tension,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataSeries.isEmpty) return;

    final numPoints = dataSeries.first.length;
    final numSeries = dataSeries.length;

    // Compute stacked values
    final stackedValues = List<List<double>>.generate(
      numSeries,
      (_) => List<double>.filled(numPoints, 0),
    );

    for (int i = 0; i < numPoints; i++) {
      double cumulative = 0;
      for (int s = 0; s < numSeries; s++) {
        cumulative += dataSeries[s][i].y;
        stackedValues[s][i] = cumulative;
      }
    }

    // Draw areas from top to bottom (reverse order for proper layering)
    for (int s = numSeries - 1; s >= 0; s--) {
      final topPoints = <Offset>[];
      final bottomPoints = <Offset>[];

      for (int i = 0; i < numPoints; i++) {
        final x = xScale(dataSeries[s][i].x is num
            ? dataSeries[s][i].x.toDouble()
            : i.toDouble());
        final topY = yScale(stackedValues[s][i]);
        final bottomY = s > 0 ? yScale(stackedValues[s - 1][i]) : yScale(0.0);

        topPoints.add(Offset(x, topY));
        bottomPoints.add(Offset(x, bottomY));
      }

      _drawStackedArea(
          canvas, topPoints, bottomPoints, colors[s % colors.length]);

      if (showLines) {
        _drawLine(canvas, topPoints, colors[s % colors.length]);
      }
    }
  }

  void _drawStackedArea(
    Canvas canvas,
    List<Offset> topPoints,
    List<Offset> bottomPoints,
    Color color,
  ) {
    final path = Path();

    // Draw top edge
    path.moveTo(topPoints.first.dx, topPoints.first.dy);
    for (int i = 1; i < topPoints.length; i++) {
      path.lineTo(topPoints[i].dx, topPoints[i].dy);
    }

    // Draw bottom edge (reversed)
    for (int i = bottomPoints.length - 1; i >= 0; i--) {
      path.lineTo(bottomPoints[i].dx, bottomPoints[i].dy);
    }

    path.close();

    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  void _drawLine(Canvas canvas, List<Offset> points, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_StackedAreaSeriesPainter oldDelegate) {
    return dataSeries != oldDelegate.dataSeries ||
        colors != oldDelegate.colors ||
        opacity != oldDelegate.opacity;
  }
}
