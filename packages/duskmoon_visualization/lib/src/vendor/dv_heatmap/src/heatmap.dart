import 'package:flutter/material.dart';

/// Data point for heatmap.
class HeatmapDataPoint {
  final int row;
  final int column;
  final double value;
  final Map<String, dynamic>? metadata;

  const HeatmapDataPoint({
    required this.row,
    required this.column,
    required this.value,
    this.metadata,
  });
}

/// Configuration for heatmap color scale.
class HeatmapColorScale {
  final List<Color> colors;
  final List<double>? stops;
  final double minValue;
  final double maxValue;

  const HeatmapColorScale({
    required this.colors,
    this.stops,
    required this.minValue,
    required this.maxValue,
  });

  /// Default blue to red color scale.
  factory HeatmapColorScale.blueToRed({
    required double minValue,
    required double maxValue,
  }) {
    return HeatmapColorScale(
      colors: const [
        Color(0xFF2166AC),
        Color(0xFF67A9CF),
        Color(0xFFF7F7F7),
        Color(0xFFEF8A62),
        Color(0xFFB2182B),
      ],
      minValue: minValue,
      maxValue: maxValue,
    );
  }

  /// Viridis color scale.
  factory HeatmapColorScale.viridis({
    required double minValue,
    required double maxValue,
  }) {
    return HeatmapColorScale(
      colors: const [
        Color(0xFF440154),
        Color(0xFF3B528B),
        Color(0xFF21918C),
        Color(0xFF5EC962),
        Color(0xFFFDE725),
      ],
      minValue: minValue,
      maxValue: maxValue,
    );
  }

  /// Get color for a value.
  Color getColor(double value) {
    final t = ((value - minValue) / (maxValue - minValue)).clamp(0.0, 1.0);

    if (stops != null && stops!.length == colors.length) {
      for (int i = 0; i < stops!.length - 1; i++) {
        if (t >= stops![i] && t <= stops![i + 1]) {
          final localT = (t - stops![i]) / (stops![i + 1] - stops![i]);
          return Color.lerp(colors[i], colors[i + 1], localT)!;
        }
      }
      return colors.last;
    }

    // Linear interpolation through color stops
    final segmentLength = 1.0 / (colors.length - 1);
    final segmentIndex =
        (t / segmentLength).floor().clamp(0, colors.length - 2);
    final localT = (t - segmentIndex * segmentLength) / segmentLength;

    return Color.lerp(colors[segmentIndex], colors[segmentIndex + 1], localT)!;
  }
}

/// Heatmap widget for visualizing matrix data.
class Heatmap extends StatefulWidget {
  /// Data points for the heatmap.
  final List<HeatmapDataPoint> data;

  /// Number of rows.
  final int rows;

  /// Number of columns.
  final int columns;

  /// Color scale configuration.
  final HeatmapColorScale colorScale;

  /// Row labels.
  final List<String>? rowLabels;

  /// Column labels.
  final List<String>? columnLabels;

  /// Cell padding.
  final double cellPadding;

  /// Cell corner radius.
  final double cellRadius;

  /// Whether to show cell values.
  final bool showValues;

  /// Cell value text style.
  final TextStyle? valueStyle;

  /// Cell border color.
  final Color? borderColor;

  /// Cell border width.
  final double borderWidth;

  /// Callback when a cell is tapped.
  final void Function(HeatmapDataPoint point)? onCellTap;

  /// Callback when a cell is hovered.
  final void Function(HeatmapDataPoint? point)? onCellHover;

  const Heatmap({
    super.key,
    required this.data,
    required this.rows,
    required this.columns,
    required this.colorScale,
    this.rowLabels,
    this.columnLabels,
    this.cellPadding = 1,
    this.cellRadius = 0,
    this.showValues = false,
    this.valueStyle,
    this.borderColor,
    this.borderWidth = 0,
    this.onCellTap,
    this.onCellHover,
  });

  @override
  State<Heatmap> createState() => _HeatmapState();
}

class _HeatmapState extends State<Heatmap> {
  HeatmapDataPoint? _hoveredPoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        // Calculate label space
        final rowLabelWidth = widget.rowLabels != null ? 60.0 : 0.0;
        final columnLabelHeight = widget.columnLabels != null ? 30.0 : 0.0;

        final chartWidth = width - rowLabelWidth;
        final chartHeight = height - columnLabelHeight;

        return Stack(
          children: [
            // Row labels
            if (widget.rowLabels != null)
              Positioned(
                left: 0,
                top: columnLabelHeight,
                width: rowLabelWidth,
                height: chartHeight,
                child: _buildRowLabels(chartHeight),
              ),

            // Column labels
            if (widget.columnLabels != null)
              Positioned(
                left: rowLabelWidth,
                top: 0,
                width: chartWidth,
                height: columnLabelHeight,
                child: _buildColumnLabels(chartWidth),
              ),

            // Heatmap grid
            Positioned(
              left: rowLabelWidth,
              top: columnLabelHeight,
              width: chartWidth,
              height: chartHeight,
              child: GestureDetector(
                onTapUp: (details) =>
                    _handleTap(details, chartWidth, chartHeight),
                child: MouseRegion(
                  onHover: (event) =>
                      _handleHover(event, chartWidth, chartHeight),
                  onExit: (_) => _handleHoverExit(),
                  child: CustomPaint(
                    size: Size(chartWidth, chartHeight),
                    painter: _HeatmapPainter(
                      data: widget.data,
                      rows: widget.rows,
                      columns: widget.columns,
                      colorScale: widget.colorScale,
                      cellPadding: widget.cellPadding,
                      cellRadius: widget.cellRadius,
                      showValues: widget.showValues,
                      valueStyle: widget.valueStyle,
                      borderColor: widget.borderColor,
                      borderWidth: widget.borderWidth,
                      hoveredPoint: _hoveredPoint,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRowLabels(double height) {
    final cellHeight = height / widget.rows;
    return Column(
      children: widget.rowLabels!.map((label) {
        return SizedBox(
          height: cellHeight,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(fontSize: 10),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildColumnLabels(double width) {
    final cellWidth = width / widget.columns;
    return Row(
      children: widget.columnLabels!.map((label) {
        return SizedBox(
          width: cellWidth,
          child: Center(
            child: Transform.rotate(
              angle: -0.5,
              child: Text(
                label,
                style: const TextStyle(fontSize: 10),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _handleTap(TapUpDetails details, double width, double height) {
    final point = _getPointAtPosition(details.localPosition, width, height);
    if (point != null && widget.onCellTap != null) {
      widget.onCellTap!(point);
    }
  }

  void _handleHover(PointerEvent event, double width, double height) {
    final point = _getPointAtPosition(event.localPosition, width, height);
    if (point != _hoveredPoint) {
      setState(() => _hoveredPoint = point);
      widget.onCellHover?.call(point);
    }
  }

  void _handleHoverExit() {
    if (_hoveredPoint != null) {
      setState(() => _hoveredPoint = null);
      widget.onCellHover?.call(null);
    }
  }

  HeatmapDataPoint? _getPointAtPosition(
      Offset position, double width, double height) {
    final cellWidth = width / widget.columns;
    final cellHeight = height / widget.rows;

    final column = (position.dx / cellWidth).floor();
    final row = (position.dy / cellHeight).floor();

    if (row < 0 ||
        row >= widget.rows ||
        column < 0 ||
        column >= widget.columns) {
      return null;
    }

    return widget.data.cast<HeatmapDataPoint?>().firstWhere(
          (p) => p!.row == row && p.column == column,
          orElse: () => null,
        );
  }
}

class _HeatmapPainter extends CustomPainter {
  final List<HeatmapDataPoint> data;
  final int rows;
  final int columns;
  final HeatmapColorScale colorScale;
  final double cellPadding;
  final double cellRadius;
  final bool showValues;
  final TextStyle? valueStyle;
  final Color? borderColor;
  final double borderWidth;
  final HeatmapDataPoint? hoveredPoint;

  _HeatmapPainter({
    required this.data,
    required this.rows,
    required this.columns,
    required this.colorScale,
    required this.cellPadding,
    required this.cellRadius,
    required this.showValues,
    this.valueStyle,
    this.borderColor,
    required this.borderWidth,
    this.hoveredPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / columns;
    final cellHeight = size.height / rows;

    // Create a map for quick lookup
    final dataMap = <String, HeatmapDataPoint>{};
    for (final point in data) {
      dataMap['${point.row},${point.column}'] = point;
    }

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        final point = dataMap['$row,$col'];
        if (point == null) continue;

        final rect = Rect.fromLTWH(
          col * cellWidth + cellPadding,
          row * cellHeight + cellPadding,
          cellWidth - cellPadding * 2,
          cellHeight - cellPadding * 2,
        );

        final color = colorScale.getColor(point.value);
        final isHovered =
            hoveredPoint?.row == row && hoveredPoint?.column == col;

        final fillPaint = Paint()
          ..color = isHovered ? color.withValues(alpha: 0.8) : color
          ..style = PaintingStyle.fill;

        if (cellRadius > 0) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, Radius.circular(cellRadius)),
            fillPaint,
          );
        } else {
          canvas.drawRect(rect, fillPaint);
        }

        // Draw border
        if (borderColor != null && borderWidth > 0) {
          final strokePaint = Paint()
            ..color =
                isHovered ? borderColor!.withValues(alpha: 1.0) : borderColor!
            ..strokeWidth = isHovered ? borderWidth * 2 : borderWidth
            ..style = PaintingStyle.stroke;

          if (cellRadius > 0) {
            canvas.drawRRect(
              RRect.fromRectAndRadius(rect, Radius.circular(cellRadius)),
              strokePaint,
            );
          } else {
            canvas.drawRect(rect, strokePaint);
          }
        }

        // Draw value text
        if (showValues) {
          final style =
              valueStyle ?? const TextStyle(fontSize: 10, color: Colors.black);
          final textSpan = TextSpan(
            text: point.value.toStringAsFixed(1),
            style: style,
          );
          final textPainter = TextPainter(
            text: textSpan,
            textDirection: TextDirection.ltr,
          );
          textPainter.layout();
          textPainter.paint(
            canvas,
            Offset(
              rect.center.dx - textPainter.width / 2,
              rect.center.dy - textPainter.height / 2,
            ),
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_HeatmapPainter oldDelegate) {
    return data != oldDelegate.data ||
        hoveredPoint != oldDelegate.hoveredPoint ||
        showValues != oldDelegate.showValues;
  }
}
