import 'package:flutter/material.dart';

import 'package:duskmoon_visualization/src/vendor/dv_scale/dv_scale.dart';

/// Data point for XY charts.
class XYDataPoint {
  final dynamic x;
  final double y;
  final Map<String, dynamic>? metadata;

  const XYDataPoint({
    required this.x,
    required this.y,
    this.metadata,
  });
}

/// Configuration for chart margins.
class ChartMargin {
  final double top;
  final double right;
  final double bottom;
  final double left;

  const ChartMargin({
    this.top = 20,
    this.right = 20,
    this.bottom = 40,
    this.left = 50,
  });

  const ChartMargin.all(double value)
      : top = value,
        right = value,
        bottom = value,
        left = value;
}

/// XY Chart widget that combines axes, grid, and series.
class XYChart extends StatefulWidget {
  /// The child series widgets to render.
  final List<Widget> children;

  /// X-axis scale configuration.
  final LinearScale? xScale;

  /// Y-axis scale configuration.
  final LinearScale? yScale;

  /// Chart margins.
  final ChartMargin margin;

  /// Whether to show the X axis.
  final bool showXAxis;

  /// Whether to show the Y axis.
  final bool showYAxis;

  /// Whether to show grid lines.
  final bool showGrid;

  /// X-axis label.
  final String? xAxisLabel;

  /// Y-axis label.
  final String? yAxisLabel;

  /// Background color.
  final Color? backgroundColor;

  /// Grid line color.
  final Color gridColor;

  /// Axis line color.
  final Color axisColor;

  /// Callback when a data point is tapped.
  final void Function(XYDataPoint point)? onPointTap;

  const XYChart({
    super.key,
    required this.children,
    this.xScale,
    this.yScale,
    this.margin = const ChartMargin(),
    this.showXAxis = true,
    this.showYAxis = true,
    this.showGrid = true,
    this.xAxisLabel,
    this.yAxisLabel,
    this.backgroundColor,
    this.gridColor = const Color(0xFFE0E0E0),
    this.axisColor = const Color(0xFF757575),
    this.onPointTap,
  });

  @override
  State<XYChart> createState() => _XYChartState();
}

class _XYChartState extends State<XYChart> {
  late LinearScale _xScale;
  late LinearScale _yScale;

  @override
  void initState() {
    super.initState();
    _xScale = widget.xScale ?? LinearScale(domain: [0, 100], range: [0, 1]);
    _yScale = widget.yScale ?? LinearScale(domain: [0, 100], range: [1, 0]);
  }

  @override
  void didUpdateWidget(XYChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.xScale != null) _xScale = widget.xScale!;
    if (widget.yScale != null) _yScale = widget.yScale!;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final chartWidth = width - widget.margin.left - widget.margin.right;
        final chartHeight = height - widget.margin.top - widget.margin.bottom;

        // Update scale ranges
        _xScale.range = [0, chartWidth];
        _yScale.range = [chartHeight, 0];

        return Container(
          color: widget.backgroundColor,
          child: CustomPaint(
            size: Size(width, height),
            painter: _XYChartPainter(
              margin: widget.margin,
              xScale: _xScale,
              yScale: _yScale,
              showXAxis: widget.showXAxis,
              showYAxis: widget.showYAxis,
              showGrid: widget.showGrid,
              gridColor: widget.gridColor,
              axisColor: widget.axisColor,
              xAxisLabel: widget.xAxisLabel,
              yAxisLabel: widget.yAxisLabel,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: widget.margin.top,
                right: widget.margin.right,
                bottom: widget.margin.bottom,
                left: widget.margin.left,
              ),
              child: ClipRect(
                child: Stack(
                  children: widget.children.map((child) {
                    return XYChartScope(
                      xScale: _xScale,
                      yScale: _yScale,
                      chartWidth: chartWidth,
                      chartHeight: chartHeight,
                      child: child,
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Provides chart scale context to child series.
class XYChartScope extends InheritedWidget {
  final LinearScale xScale;
  final LinearScale yScale;
  final double chartWidth;
  final double chartHeight;

  const XYChartScope({
    super.key,
    required this.xScale,
    required this.yScale,
    required this.chartWidth,
    required this.chartHeight,
    required super.child,
  });

  static XYChartScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<XYChartScope>();
  }

  @override
  bool updateShouldNotify(XYChartScope oldWidget) {
    return xScale != oldWidget.xScale ||
        yScale != oldWidget.yScale ||
        chartWidth != oldWidget.chartWidth ||
        chartHeight != oldWidget.chartHeight;
  }
}

class _XYChartPainter extends CustomPainter {
  final ChartMargin margin;
  final LinearScale xScale;
  final LinearScale yScale;
  final bool showXAxis;
  final bool showYAxis;
  final bool showGrid;
  final Color gridColor;
  final Color axisColor;
  final String? xAxisLabel;
  final String? yAxisLabel;

  _XYChartPainter({
    required this.margin,
    required this.xScale,
    required this.yScale,
    required this.showXAxis,
    required this.showYAxis,
    required this.showGrid,
    required this.gridColor,
    required this.axisColor,
    this.xAxisLabel,
    this.yAxisLabel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final chartWidth = size.width - margin.left - margin.right;
    final chartHeight = size.height - margin.top - margin.bottom;

    canvas.save();
    canvas.translate(margin.left, margin.top);

    // Draw grid
    if (showGrid) {
      _drawGrid(canvas, chartWidth, chartHeight);
    }

    // Draw axes
    if (showXAxis) {
      _drawXAxis(canvas, chartWidth, chartHeight);
    }
    if (showYAxis) {
      _drawYAxis(canvas, chartWidth, chartHeight);
    }

    canvas.restore();
  }

  void _drawGrid(Canvas canvas, double width, double height) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    final xTicks = xScale.ticks(5);
    final yTicks = yScale.ticks(5);

    // Vertical grid lines
    for (final tick in xTicks) {
      final x = xScale(tick);
      canvas.drawLine(Offset(x, 0), Offset(x, height), paint);
    }

    // Horizontal grid lines
    for (final tick in yTicks) {
      final y = yScale(tick);
      canvas.drawLine(Offset(0, y), Offset(width, y), paint);
    }
  }

  void _drawXAxis(Canvas canvas, double width, double height) {
    final paint = Paint()
      ..color = axisColor
      ..strokeWidth = 2;

    // Axis line
    canvas.drawLine(Offset(0, height), Offset(width, height), paint);

    // Ticks and labels
    final ticks = xScale.ticks(5);
    final tickFormat = xScale.tickFormat(5);
    final textStyle = TextStyle(color: axisColor, fontSize: 10);

    for (final tick in ticks) {
      final x = xScale(tick);

      // Tick mark
      canvas.drawLine(
        Offset(x, height),
        Offset(x, height + 5),
        paint..strokeWidth = 1,
      );

      // Label
      final textSpan = TextSpan(text: tickFormat(tick), style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, height + 8),
      );
    }

    // Axis label
    if (xAxisLabel != null) {
      final labelStyle = TextStyle(color: axisColor, fontSize: 12);
      final labelSpan = TextSpan(text: xAxisLabel, style: labelStyle);
      final labelPainter = TextPainter(
        text: labelSpan,
        textDirection: TextDirection.ltr,
      );
      labelPainter.layout();
      labelPainter.paint(
        canvas,
        Offset(width / 2 - labelPainter.width / 2, height + 25),
      );
    }
  }

  void _drawYAxis(Canvas canvas, double width, double height) {
    final paint = Paint()
      ..color = axisColor
      ..strokeWidth = 2;

    // Axis line
    canvas.drawLine(const Offset(0, 0), Offset(0, height), paint);

    // Ticks and labels
    final ticks = yScale.ticks(5);
    final tickFormat = yScale.tickFormat(5);
    final textStyle = TextStyle(color: axisColor, fontSize: 10);

    for (final tick in ticks) {
      final y = yScale(tick);

      // Tick mark
      canvas.drawLine(
        Offset(-5, y),
        Offset(0, y),
        paint..strokeWidth = 1,
      );

      // Label
      final textSpan = TextSpan(text: tickFormat(tick), style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(-textPainter.width - 8, y - textPainter.height / 2),
      );
    }

    // Axis label
    if (yAxisLabel != null) {
      canvas.save();
      canvas.translate(-35, height / 2);
      canvas.rotate(-3.14159 / 2);

      final labelStyle = TextStyle(color: axisColor, fontSize: 12);
      final labelSpan = TextSpan(text: yAxisLabel, style: labelStyle);
      final labelPainter = TextPainter(
        text: labelSpan,
        textDirection: TextDirection.ltr,
      );
      labelPainter.layout();
      labelPainter.paint(canvas, Offset(-labelPainter.width / 2, 0));

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_XYChartPainter oldDelegate) {
    return margin != oldDelegate.margin ||
        showXAxis != oldDelegate.showXAxis ||
        showYAxis != oldDelegate.showYAxis ||
        showGrid != oldDelegate.showGrid ||
        gridColor != oldDelegate.gridColor ||
        axisColor != oldDelegate.axisColor;
  }
}
