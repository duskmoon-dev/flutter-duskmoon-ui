import 'package:flutter/material.dart';

/// Individual cell widget for heatmaps.
class HeatmapCell extends StatefulWidget {
  /// Cell fill color.
  final Color color;

  /// Cell value for display.
  final double? value;

  /// Cell size.
  final double size;

  /// Corner radius.
  final double radius;

  /// Border color.
  final Color? borderColor;

  /// Border width.
  final double borderWidth;

  /// Whether to show the value text.
  final bool showValue;

  /// Value text style.
  final TextStyle? valueStyle;

  /// Value format function.
  final String Function(double value)? valueFormat;

  /// Callback when cell is tapped.
  final VoidCallback? onTap;

  /// Callback when cell is hovered.
  final void Function(bool isHovered)? onHover;

  /// Tooltip content.
  final String? tooltip;

  const HeatmapCell({
    super.key,
    required this.color,
    this.value,
    this.size = 40,
    this.radius = 0,
    this.borderColor,
    this.borderWidth = 0,
    this.showValue = false,
    this.valueStyle,
    this.valueFormat,
    this.onTap,
    this.onHover,
    this.tooltip,
  });

  @override
  State<HeatmapCell> createState() => _HeatmapCellState();
}

class _HeatmapCellState extends State<HeatmapCell> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Widget cell = MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color:
                _isHovered ? widget.color.withValues(alpha: 0.8) : widget.color,
            borderRadius:
                widget.radius > 0 ? BorderRadius.circular(widget.radius) : null,
            border: widget.borderColor != null && widget.borderWidth > 0
                ? Border.all(
                    color: _isHovered
                        ? widget.borderColor!
                        : widget.borderColor!.withValues(alpha: 0.7),
                    width: _isHovered
                        ? widget.borderWidth * 1.5
                        : widget.borderWidth,
                  )
                : null,
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: widget.showValue && widget.value != null
              ? Center(
                  child: Text(
                    widget.valueFormat?.call(widget.value!) ??
                        widget.value!.toStringAsFixed(1),
                    style: widget.valueStyle ??
                        TextStyle(
                          fontSize: widget.size * 0.25,
                          color: _getContrastColor(widget.color),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                )
              : null,
        ),
      ),
    );

    if (widget.tooltip != null) {
      cell = Tooltip(
        message: widget.tooltip!,
        child: cell,
      );
    }

    return cell;
  }

  void _setHovered(bool value) {
    setState(() => _isHovered = value);
    widget.onHover?.call(value);
  }

  Color _getContrastColor(Color color) {
    // Calculate relative luminance
    final r = (color.r * 255.0).round().clamp(0, 255);
    final g = (color.g * 255.0).round().clamp(0, 255);
    final b = (color.b * 255.0).round().clamp(0, 255);
    final luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

/// Grid of heatmap cells with automatic sizing.
class HeatmapGrid extends StatelessWidget {
  /// 2D list of values (rows x columns).
  final List<List<double>> values;

  /// Minimum value for color scale.
  final double minValue;

  /// Maximum value for color scale.
  final double maxValue;

  /// Start color for gradient.
  final Color startColor;

  /// End color for gradient.
  final Color endColor;

  /// Cell corner radius.
  final double cellRadius;

  /// Cell padding.
  final double cellPadding;

  /// Whether to show values in cells.
  final bool showValues;

  /// Value text style.
  final TextStyle? valueStyle;

  /// Callback when a cell is tapped.
  final void Function(int row, int column, double value)? onCellTap;

  const HeatmapGrid({
    super.key,
    required this.values,
    required this.minValue,
    required this.maxValue,
    this.startColor = const Color(0xFF2166AC),
    this.endColor = const Color(0xFFB2182B),
    this.cellRadius = 2,
    this.cellPadding = 1,
    this.showValues = false,
    this.valueStyle,
    this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();

    final rows = values.length;
    final columns = values.first.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth = (constraints.maxWidth - cellPadding * 2) / columns;
        final cellHeight = (constraints.maxHeight - cellPadding * 2) / rows;
        final cellSize = cellWidth < cellHeight ? cellWidth : cellHeight;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(rows, (row) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(columns, (col) {
                final value = values[row][col];
                final t = maxValue != minValue
                    ? (value - minValue) / (maxValue - minValue)
                    : 0.5;
                final color =
                    Color.lerp(startColor, endColor, t.clamp(0.0, 1.0))!;

                return Padding(
                  padding: EdgeInsets.all(cellPadding),
                  child: HeatmapCell(
                    color: color,
                    value: value,
                    size: cellSize - cellPadding * 2,
                    radius: cellRadius,
                    showValue: showValues,
                    valueStyle: valueStyle,
                    tooltip: 'Row $row, Col $col: ${value.toStringAsFixed(2)}',
                    onTap: onCellTap != null
                        ? () => onCellTap!(row, col, value)
                        : null,
                  ),
                );
              }),
            );
          }),
        );
      },
    );
  }
}

/// Calendar heatmap for showing values over time.
class CalendarHeatmap extends StatelessWidget {
  /// Map of date to value.
  final Map<DateTime, double> data;

  /// Start date of the calendar.
  final DateTime startDate;

  /// End date of the calendar.
  final DateTime endDate;

  /// Minimum value for color scale.
  final double minValue;

  /// Maximum value for color scale.
  final double maxValue;

  /// Color for empty cells.
  final Color emptyColor;

  /// Start color for gradient.
  final Color startColor;

  /// End color for gradient.
  final Color endColor;

  /// Cell size.
  final double cellSize;

  /// Cell padding.
  final double cellPadding;

  /// Cell corner radius.
  final double cellRadius;

  /// Whether to show month labels.
  final bool showMonthLabels;

  /// Whether to show day labels.
  final bool showDayLabels;

  /// Callback when a cell is tapped.
  final void Function(DateTime date, double? value)? onCellTap;

  const CalendarHeatmap({
    super.key,
    required this.data,
    required this.startDate,
    required this.endDate,
    required this.minValue,
    required this.maxValue,
    this.emptyColor = const Color(0xFFEBEDF0),
    this.startColor = const Color(0xFF9BE9A8),
    this.endColor = const Color(0xFF216E39),
    this.cellSize = 12,
    this.cellPadding = 2,
    this.cellRadius = 2,
    this.showMonthLabels = true,
    this.showDayLabels = true,
    this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate number of weeks
    final startWeekday = startDate.weekday % 7;
    final adjustedStart = startDate.subtract(Duration(days: startWeekday));
    final totalDays = endDate.difference(adjustedStart).inDays + 1;
    final weeks = (totalDays / 7).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Month labels
        if (showMonthLabels)
          Padding(
            padding: EdgeInsets.only(
              left: showDayLabels ? 20 : 0,
              bottom: 4,
            ),
            child: _buildMonthLabels(weeks),
          ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Day labels
            if (showDayLabels) _buildDayLabels(),

            // Grid
            _buildGrid(adjustedStart, weeks),
          ],
        ),
      ],
    );
  }

  Widget _buildMonthLabels(int weeks) {
    final labels = <Widget>[];
    DateTime? lastMonth;

    for (int week = 0; week < weeks; week++) {
      final weekStart =
          startDate.add(Duration(days: week * 7 - startDate.weekday % 7));

      if (lastMonth == null || weekStart.month != lastMonth.month) {
        final monthNames = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec'
        ];
        labels.add(
          SizedBox(
            width: cellSize + cellPadding * 2,
            child: Text(
              monthNames[weekStart.month - 1],
              style: const TextStyle(fontSize: 10),
            ),
          ),
        );
        lastMonth = weekStart;
      } else {
        labels.add(SizedBox(width: cellSize + cellPadding * 2));
      }
    }

    return Row(children: labels);
  }

  Widget _buildDayLabels() {
    const dayNames = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Column(
      children: List.generate(7, (day) {
        return SizedBox(
          height: cellSize + cellPadding * 2,
          width: 16,
          child: Center(
            child: Text(
              day % 2 == 1 ? dayNames[day] : '',
              style: const TextStyle(fontSize: 9),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildGrid(DateTime adjustedStart, int weeks) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(weeks, (week) {
        return Column(
          children: List.generate(7, (day) {
            final date = adjustedStart.add(Duration(days: week * 7 + day));

            if (date.isBefore(startDate) || date.isAfter(endDate)) {
              return SizedBox(
                width: cellSize + cellPadding * 2,
                height: cellSize + cellPadding * 2,
              );
            }

            final normalizedDate = DateTime(date.year, date.month, date.day);
            final value = data[normalizedDate];
            final color = value != null ? _getColor(value) : emptyColor;

            return Padding(
              padding: EdgeInsets.all(cellPadding),
              child: GestureDetector(
                onTap: onCellTap != null ? () => onCellTap!(date, value) : null,
                child: Tooltip(
                  message:
                      '${date.year}-${date.month}-${date.day}: ${value?.toStringAsFixed(1) ?? "No data"}',
                  child: Container(
                    width: cellSize,
                    height: cellSize,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(cellRadius),
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  Color _getColor(double value) {
    final t =
        maxValue != minValue ? (value - minValue) / (maxValue - minValue) : 0.5;
    return Color.lerp(startColor, endColor, t.clamp(0.0, 1.0))!;
  }
}
