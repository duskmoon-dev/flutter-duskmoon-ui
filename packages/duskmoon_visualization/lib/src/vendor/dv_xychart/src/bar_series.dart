import 'package:flutter/material.dart';

import 'xy_chart.dart';

/// Bar series for XY charts.
class BarSeries extends StatelessWidget {
  /// Data points for the bars.
  final List<XYDataPoint> data;

  /// Bar fill color.
  final Color color;

  /// Bar border color.
  final Color? borderColor;

  /// Bar border width.
  final double borderWidth;

  /// Bar width as a fraction of available space (0-1).
  final double barWidth;

  /// Corner radius for rounded bars.
  final double cornerRadius;

  /// Whether bars are horizontal.
  final bool horizontal;

  /// Callback when a bar is tapped.
  final void Function(XYDataPoint point, int index)? onBarTap;

  const BarSeries({
    super.key,
    required this.data,
    this.color = Colors.blue,
    this.borderColor,
    this.borderWidth = 0,
    this.barWidth = 0.8,
    this.cornerRadius = 0,
    this.horizontal = false,
    this.onBarTap,
  });

  @override
  Widget build(BuildContext context) {
    final scope = XYChartScope.of(context);
    if (scope == null) {
      return const SizedBox.shrink();
    }

    return CustomPaint(
      size: Size(scope.chartWidth, scope.chartHeight),
      painter: _BarSeriesPainter(
        data: data,
        xScale: scope.xScale,
        yScale: scope.yScale,
        chartWidth: scope.chartWidth,
        chartHeight: scope.chartHeight,
        color: color,
        borderColor: borderColor,
        borderWidth: borderWidth,
        barWidth: barWidth,
        cornerRadius: cornerRadius,
        horizontal: horizontal,
      ),
    );
  }
}

class _BarSeriesPainter extends CustomPainter {
  final List<XYDataPoint> data;
  final dynamic xScale;
  final dynamic yScale;
  final double chartWidth;
  final double chartHeight;
  final Color color;
  final Color? borderColor;
  final double borderWidth;
  final double barWidth;
  final double cornerRadius;
  final bool horizontal;

  _BarSeriesPainter({
    required this.data,
    required this.xScale,
    required this.yScale,
    required this.chartWidth,
    required this.chartHeight,
    required this.color,
    this.borderColor,
    required this.borderWidth,
    required this.barWidth,
    required this.cornerRadius,
    required this.horizontal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = borderColor != null
        ? (Paint()
          ..color = borderColor!
          ..strokeWidth = borderWidth
          ..style = PaintingStyle.stroke)
        : null;

    final n = data.length;
    final baselineY = yScale(0.0);

    for (int i = 0; i < n; i++) {
      final point = data[i];

      if (horizontal) {
        _drawHorizontalBar(canvas, point, i, n, fillPaint, strokePaint);
      } else {
        _drawVerticalBar(
            canvas, point, i, n, baselineY, fillPaint, strokePaint);
      }
    }
  }

  void _drawVerticalBar(
    Canvas canvas,
    XYDataPoint point,
    int index,
    int total,
    double baselineY,
    Paint fillPaint,
    Paint? strokePaint,
  ) {
    final x = xScale(point.x is num ? point.x.toDouble() : index.toDouble());
    final y = yScale(point.y);

    // Calculate bar width based on available space
    final availableWidth = chartWidth / total;
    final actualBarWidth = availableWidth * barWidth;
    final barLeft = x - actualBarWidth / 2;

    final rect = Rect.fromLTRB(
      barLeft,
      y < baselineY ? y : baselineY,
      barLeft + actualBarWidth,
      y < baselineY ? baselineY : y,
    );

    if (cornerRadius > 0) {
      final rrect = RRect.fromRectAndRadius(
        rect,
        Radius.circular(cornerRadius),
      );
      canvas.drawRRect(rrect, fillPaint);
      if (strokePaint != null) {
        canvas.drawRRect(rrect, strokePaint);
      }
    } else {
      canvas.drawRect(rect, fillPaint);
      if (strokePaint != null) {
        canvas.drawRect(rect, strokePaint);
      }
    }
  }

  void _drawHorizontalBar(
    Canvas canvas,
    XYDataPoint point,
    int index,
    int total,
    Paint fillPaint,
    Paint? strokePaint,
  ) {
    final baselineX = xScale(0.0);
    final y = yScale(point.x is num ? point.x.toDouble() : index.toDouble());
    final x = xScale(point.y);

    // Calculate bar height based on available space
    final availableHeight = chartHeight / total;
    final actualBarHeight = availableHeight * barWidth;
    final barTop = y - actualBarHeight / 2;

    final rect = Rect.fromLTRB(
      x < baselineX ? x : baselineX,
      barTop,
      x < baselineX ? baselineX : x,
      barTop + actualBarHeight,
    );

    if (cornerRadius > 0) {
      final rrect = RRect.fromRectAndRadius(
        rect,
        Radius.circular(cornerRadius),
      );
      canvas.drawRRect(rrect, fillPaint);
      if (strokePaint != null) {
        canvas.drawRRect(rrect, strokePaint);
      }
    } else {
      canvas.drawRect(rect, fillPaint);
      if (strokePaint != null) {
        canvas.drawRect(rect, strokePaint);
      }
    }
  }

  @override
  bool shouldRepaint(_BarSeriesPainter oldDelegate) {
    return data != oldDelegate.data ||
        color != oldDelegate.color ||
        borderColor != oldDelegate.borderColor ||
        borderWidth != oldDelegate.borderWidth ||
        barWidth != oldDelegate.barWidth ||
        cornerRadius != oldDelegate.cornerRadius ||
        horizontal != oldDelegate.horizontal;
  }
}

/// Grouped bar series for multiple data sets.
class GroupedBarSeries extends StatelessWidget {
  /// List of data series, each with its own color.
  final List<List<XYDataPoint>> dataSeries;

  /// Colors for each series.
  final List<Color> colors;

  /// Bar width as a fraction of available space (0-1).
  final double barWidth;

  /// Gap between bars in a group as a fraction (0-1).
  final double groupGap;

  /// Corner radius for rounded bars.
  final double cornerRadius;

  const GroupedBarSeries({
    super.key,
    required this.dataSeries,
    required this.colors,
    this.barWidth = 0.8,
    this.groupGap = 0.1,
    this.cornerRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    final scope = XYChartScope.of(context);
    if (scope == null) {
      return const SizedBox.shrink();
    }

    return CustomPaint(
      size: Size(scope.chartWidth, scope.chartHeight),
      painter: _GroupedBarSeriesPainter(
        dataSeries: dataSeries,
        xScale: scope.xScale,
        yScale: scope.yScale,
        chartWidth: scope.chartWidth,
        chartHeight: scope.chartHeight,
        colors: colors,
        barWidth: barWidth,
        groupGap: groupGap,
        cornerRadius: cornerRadius,
      ),
    );
  }
}

class _GroupedBarSeriesPainter extends CustomPainter {
  final List<List<XYDataPoint>> dataSeries;
  final dynamic xScale;
  final dynamic yScale;
  final double chartWidth;
  final double chartHeight;
  final List<Color> colors;
  final double barWidth;
  final double groupGap;
  final double cornerRadius;

  _GroupedBarSeriesPainter({
    required this.dataSeries,
    required this.xScale,
    required this.yScale,
    required this.chartWidth,
    required this.chartHeight,
    required this.colors,
    required this.barWidth,
    required this.groupGap,
    required this.cornerRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataSeries.isEmpty) return;

    final numSeries = dataSeries.length;
    final numPoints = dataSeries.first.length;
    final baselineY = yScale(0.0);

    final groupWidth = chartWidth / numPoints * barWidth;
    final individualBarWidth = groupWidth / numSeries * (1 - groupGap);

    for (int s = 0; s < numSeries; s++) {
      final paint = Paint()
        ..color = colors[s % colors.length]
        ..style = PaintingStyle.fill;

      final series = dataSeries[s];
      for (int i = 0; i < series.length; i++) {
        final point = series[i];
        final x = xScale(point.x is num ? point.x.toDouble() : i.toDouble());
        final y = yScale(point.y);

        final groupStart = x - groupWidth / 2;
        final barLeft = groupStart +
            s * (individualBarWidth + groupGap * groupWidth / numSeries);

        final rect = Rect.fromLTRB(
          barLeft,
          y < baselineY ? y : baselineY,
          barLeft + individualBarWidth,
          y < baselineY ? baselineY : y,
        );

        if (cornerRadius > 0) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, Radius.circular(cornerRadius)),
            paint,
          );
        } else {
          canvas.drawRect(rect, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_GroupedBarSeriesPainter oldDelegate) {
    return dataSeries != oldDelegate.dataSeries ||
        colors != oldDelegate.colors ||
        barWidth != oldDelegate.barWidth;
  }
}
