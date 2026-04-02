import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'xy_chart.dart';

/// Marker shape for scatter plots.
enum MarkerShape {
  circle,
  square,
  triangle,
  diamond,
  cross,
  plus,
  star,
}

/// Scatter series for XY charts.
class ScatterSeries extends StatelessWidget {
  /// Data points for the scatter plot.
  final List<XYDataPoint> data;

  /// Marker fill color.
  final Color color;

  /// Marker border color.
  final Color? borderColor;

  /// Marker border width.
  final double borderWidth;

  /// Marker radius.
  final double radius;

  /// Marker shape.
  final MarkerShape shape;

  /// Opacity (0-1).
  final double opacity;

  /// Function to compute radius from data point.
  final double Function(XYDataPoint point)? radiusAccessor;

  /// Function to compute color from data point.
  final Color Function(XYDataPoint point)? colorAccessor;

  /// Callback when a point is tapped.
  final void Function(XYDataPoint point, int index)? onPointTap;

  const ScatterSeries({
    super.key,
    required this.data,
    this.color = Colors.blue,
    this.borderColor,
    this.borderWidth = 1,
    this.radius = 5,
    this.shape = MarkerShape.circle,
    this.opacity = 1.0,
    this.radiusAccessor,
    this.colorAccessor,
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
      painter: _ScatterSeriesPainter(
        data: data,
        xScale: scope.xScale,
        yScale: scope.yScale,
        color: color,
        borderColor: borderColor,
        borderWidth: borderWidth,
        radius: radius,
        shape: shape,
        opacity: opacity,
        radiusAccessor: radiusAccessor,
        colorAccessor: colorAccessor,
      ),
    );
  }
}

class _ScatterSeriesPainter extends CustomPainter {
  final List<XYDataPoint> data;
  final dynamic xScale;
  final dynamic yScale;
  final Color color;
  final Color? borderColor;
  final double borderWidth;
  final double radius;
  final MarkerShape shape;
  final double opacity;
  final double Function(XYDataPoint point)? radiusAccessor;
  final Color Function(XYDataPoint point)? colorAccessor;

  _ScatterSeriesPainter({
    required this.data,
    required this.xScale,
    required this.yScale,
    required this.color,
    this.borderColor,
    required this.borderWidth,
    required this.radius,
    required this.shape,
    required this.opacity,
    this.radiusAccessor,
    this.colorAccessor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    for (final point in data) {
      final x = xScale(point.x is num ? point.x.toDouble() : 0.0);
      final y = yScale(point.y);
      final center = Offset(x, y);

      final pointRadius = radiusAccessor?.call(point) ?? radius;
      final pointColor = colorAccessor?.call(point) ?? color;

      _drawMarker(canvas, center, pointRadius, pointColor);
    }
  }

  void _drawMarker(Canvas canvas, Offset center, double r, Color c) {
    final fillPaint = Paint()
      ..color = c.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    final strokePaint = borderColor != null
        ? (Paint()
          ..color = borderColor!
          ..strokeWidth = borderWidth
          ..style = PaintingStyle.stroke)
        : null;

    switch (shape) {
      case MarkerShape.circle:
        canvas.drawCircle(center, r, fillPaint);
        if (strokePaint != null) canvas.drawCircle(center, r, strokePaint);
        break;

      case MarkerShape.square:
        final rect =
            Rect.fromCenter(center: center, width: r * 2, height: r * 2);
        canvas.drawRect(rect, fillPaint);
        if (strokePaint != null) canvas.drawRect(rect, strokePaint);
        break;

      case MarkerShape.triangle:
        final path = _trianglePath(center, r);
        canvas.drawPath(path, fillPaint);
        if (strokePaint != null) canvas.drawPath(path, strokePaint);
        break;

      case MarkerShape.diamond:
        final path = _diamondPath(center, r);
        canvas.drawPath(path, fillPaint);
        if (strokePaint != null) canvas.drawPath(path, strokePaint);
        break;

      case MarkerShape.cross:
        _drawCross(canvas, center, r, fillPaint, strokePaint);
        break;

      case MarkerShape.plus:
        _drawPlus(canvas, center, r, fillPaint, strokePaint);
        break;

      case MarkerShape.star:
        final path = _starPath(center, r);
        canvas.drawPath(path, fillPaint);
        if (strokePaint != null) canvas.drawPath(path, strokePaint);
        break;
    }
  }

  Path _trianglePath(Offset center, double r) {
    final path = Path();
    final h = r * math.sqrt(3);
    path.moveTo(center.dx, center.dy - r);
    path.lineTo(center.dx - h / 2, center.dy + r / 2);
    path.lineTo(center.dx + h / 2, center.dy + r / 2);
    path.close();
    return path;
  }

  Path _diamondPath(Offset center, double r) {
    final path = Path();
    path.moveTo(center.dx, center.dy - r);
    path.lineTo(center.dx + r, center.dy);
    path.lineTo(center.dx, center.dy + r);
    path.lineTo(center.dx - r, center.dy);
    path.close();
    return path;
  }

  void _drawCross(
      Canvas canvas, Offset center, double r, Paint fill, Paint? stroke) {
    final paint = stroke ?? fill;
    paint.strokeWidth = r / 2;
    paint.style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(center.dx - r, center.dy - r),
      Offset(center.dx + r, center.dy + r),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + r, center.dy - r),
      Offset(center.dx - r, center.dy + r),
      paint,
    );
  }

  void _drawPlus(
      Canvas canvas, Offset center, double r, Paint fill, Paint? stroke) {
    final paint = stroke ?? fill;
    paint.strokeWidth = r / 2;
    paint.style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(center.dx - r, center.dy),
      Offset(center.dx + r, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - r),
      Offset(center.dx, center.dy + r),
      paint,
    );
  }

  Path _starPath(Offset center, double r) {
    final path = Path();
    const points = 5;
    final innerRadius = r * 0.4;

    for (int i = 0; i < points * 2; i++) {
      final angle = (i * math.pi / points) - math.pi / 2;
      final radius = i.isEven ? r : innerRadius;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(_ScatterSeriesPainter oldDelegate) {
    return data != oldDelegate.data ||
        color != oldDelegate.color ||
        radius != oldDelegate.radius ||
        shape != oldDelegate.shape ||
        opacity != oldDelegate.opacity;
  }
}

/// Bubble chart series (scatter with variable radius).
class BubbleSeries extends StatelessWidget {
  /// Data points with size values.
  final List<BubbleDataPoint> data;

  /// Bubble fill color.
  final Color color;

  /// Bubble border color.
  final Color? borderColor;

  /// Bubble border width.
  final double borderWidth;

  /// Minimum bubble radius.
  final double minRadius;

  /// Maximum bubble radius.
  final double maxRadius;

  /// Opacity (0-1).
  final double opacity;

  /// Function to compute color from data point.
  final Color Function(BubbleDataPoint point)? colorAccessor;

  const BubbleSeries({
    super.key,
    required this.data,
    this.color = Colors.blue,
    this.borderColor,
    this.borderWidth = 1,
    this.minRadius = 5,
    this.maxRadius = 30,
    this.opacity = 0.6,
    this.colorAccessor,
  });

  @override
  Widget build(BuildContext context) {
    final scope = XYChartScope.of(context);
    if (scope == null) {
      return const SizedBox.shrink();
    }

    return CustomPaint(
      size: Size(scope.chartWidth, scope.chartHeight),
      painter: _BubbleSeriesPainter(
        data: data,
        xScale: scope.xScale,
        yScale: scope.yScale,
        color: color,
        borderColor: borderColor,
        borderWidth: borderWidth,
        minRadius: minRadius,
        maxRadius: maxRadius,
        opacity: opacity,
        colorAccessor: colorAccessor,
      ),
    );
  }
}

/// Data point for bubble charts with a size value.
class BubbleDataPoint extends XYDataPoint {
  final double size;

  const BubbleDataPoint({
    required super.x,
    required super.y,
    required this.size,
    super.metadata,
  });
}

class _BubbleSeriesPainter extends CustomPainter {
  final List<BubbleDataPoint> data;
  final dynamic xScale;
  final dynamic yScale;
  final Color color;
  final Color? borderColor;
  final double borderWidth;
  final double minRadius;
  final double maxRadius;
  final double opacity;
  final Color Function(BubbleDataPoint point)? colorAccessor;

  _BubbleSeriesPainter({
    required this.data,
    required this.xScale,
    required this.yScale,
    required this.color,
    this.borderColor,
    required this.borderWidth,
    required this.minRadius,
    required this.maxRadius,
    required this.opacity,
    this.colorAccessor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // Find min/max size values for scaling
    double minSize = double.infinity;
    double maxSize = double.negativeInfinity;
    for (final point in data) {
      if (point.size < minSize) minSize = point.size;
      if (point.size > maxSize) maxSize = point.size;
    }

    final sizeRange = maxSize - minSize;

    // Sort by size descending so smaller bubbles are drawn on top
    final sortedData = List<BubbleDataPoint>.from(data)
      ..sort((a, b) => b.size.compareTo(a.size));

    for (final point in sortedData) {
      final x = xScale(point.x is num ? point.x.toDouble() : 0.0);
      final y = yScale(point.y);
      final center = Offset(x, y);

      // Scale size to radius
      final normalizedSize =
          sizeRange > 0 ? (point.size - minSize) / sizeRange : 0.5;
      final radius = minRadius + (maxRadius - minRadius) * normalizedSize;

      final pointColor = colorAccessor?.call(point) ?? color;

      final fillPaint = Paint()
        ..color = pointColor.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, radius, fillPaint);

      if (borderColor != null) {
        final strokePaint = Paint()
          ..color = borderColor!
          ..strokeWidth = borderWidth
          ..style = PaintingStyle.stroke;
        canvas.drawCircle(center, radius, strokePaint);
      }
    }
  }

  @override
  bool shouldRepaint(_BubbleSeriesPainter oldDelegate) {
    return data != oldDelegate.data ||
        color != oldDelegate.color ||
        minRadius != oldDelegate.minRadius ||
        maxRadius != oldDelegate.maxRadius ||
        opacity != oldDelegate.opacity;
  }
}
