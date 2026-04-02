import 'package:flutter/widgets.dart';

/// The orientation of an axis.
enum AxisOrientation {
  /// Axis at the bottom of the chart (horizontal, labels below).
  bottom,

  /// Axis at the top of the chart (horizontal, labels above).
  top,

  /// Axis at the left of the chart (vertical, labels to the left).
  left,

  /// Axis at the right of the chart (vertical, labels to the right).
  right,
}

/// Configuration for axis tick marks.
class TickConfig {
  /// The length of tick marks in pixels.
  final double tickLength;

  /// The padding between tick marks and labels.
  final double tickPadding;

  /// The stroke width of tick marks.
  final double tickStrokeWidth;

  /// The color of tick marks.
  final Color tickColor;

  /// Creates a tick configuration.
  const TickConfig({
    this.tickLength = 6,
    this.tickPadding = 3,
    this.tickStrokeWidth = 1,
    this.tickColor = const Color(0xFF000000),
  });

  /// Creates a copy with modified values.
  TickConfig copyWith({
    double? tickLength,
    double? tickPadding,
    double? tickStrokeWidth,
    Color? tickColor,
  }) {
    return TickConfig(
      tickLength: tickLength ?? this.tickLength,
      tickPadding: tickPadding ?? this.tickPadding,
      tickStrokeWidth: tickStrokeWidth ?? this.tickStrokeWidth,
      tickColor: tickColor ?? this.tickColor,
    );
  }
}

/// Configuration for the axis line.
class AxisLineConfig {
  /// Whether to show the axis line.
  final bool visible;

  /// The stroke width of the axis line.
  final double strokeWidth;

  /// The color of the axis line.
  final Color color;

  /// Creates an axis line configuration.
  const AxisLineConfig({
    this.visible = true,
    this.strokeWidth = 1,
    this.color = const Color(0xFF000000),
  });

  /// Creates a copy with modified values.
  AxisLineConfig copyWith({
    bool? visible,
    double? strokeWidth,
    Color? color,
  }) {
    return AxisLineConfig(
      visible: visible ?? this.visible,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      color: color ?? this.color,
    );
  }
}

/// A tick value with its position and label.
class AxisTick<T> {
  /// The domain value for this tick.
  final T value;

  /// The position of this tick in pixels.
  final double position;

  /// The label to display for this tick.
  final String label;

  /// Creates an axis tick.
  const AxisTick({
    required this.value,
    required this.position,
    required this.label,
  });
}

/// Base class for axis components.
///
/// An axis displays tick marks, labels, and an axis line along one edge
/// of a chart area. It works with scales from the dv_scale package to
/// map data values to pixel positions.
abstract class ChartAxis<T> extends StatelessWidget {
  /// The scale used to map values to positions.
  final dynamic scale;

  /// Custom tick values to display.
  final List<T>? tickValues;

  /// The number of ticks to generate (if tickValues is not provided).
  final int tickCount;

  /// Function to format tick values into labels.
  final String Function(T)? tickFormat;

  /// Configuration for tick marks.
  final TickConfig tickConfig;

  /// Configuration for the axis line.
  final AxisLineConfig lineConfig;

  /// Text style for tick labels.
  final TextStyle? labelStyle;

  /// The length of the axis in pixels.
  final double length;

  /// Rotation angle for tick labels in degrees.
  final double labelRotation;

  /// Creates an axis.
  const ChartAxis({
    super.key,
    required this.scale,
    this.tickValues,
    this.tickCount = 10,
    this.tickFormat,
    this.tickConfig = const TickConfig(),
    this.lineConfig = const AxisLineConfig(),
    this.labelStyle,
    required this.length,
    this.labelRotation = 0,
  });

  /// Returns the orientation of this axis.
  AxisOrientation get orientation;

  /// Generates tick data from the scale.
  List<AxisTick<T>> generateTicks() {
    final values = tickValues ?? _getTicksFromScale();
    final format = tickFormat ?? _getDefaultFormat();

    return values.map((value) {
      final position = _getPosition(value);
      final label = format(value);
      return AxisTick<T>(
        value: value,
        position: position,
        label: label,
      );
    }).toList();
  }

  List<T> _getTicksFromScale() {
    // Try to get ticks from the scale if it supports it
    try {
      final ticks = scale.ticks(tickCount);
      return List<T>.from(ticks);
    } catch (_) {
      // Fall back to domain for ordinal/band scales
      try {
        return List<T>.from(scale.domain);
      } catch (_) {
        return [];
      }
    }
  }

  String Function(T) _getDefaultFormat() {
    // Try to get format from the scale
    try {
      return scale.tickFormat(tickCount);
    } catch (_) {
      return (T value) => value.toString();
    }
  }

  double _getPosition(T value) {
    try {
      final result = scale(value);
      if (result is double) return result;
      if (result is num) return result.toDouble();
      return 0;
    } catch (_) {
      return 0;
    }
  }
}

/// CustomPainter for rendering axis components.
class AxisPainter extends CustomPainter {
  /// The orientation of the axis.
  final AxisOrientation orientation;

  /// The ticks to render.
  final List<AxisTick> ticks;

  /// Configuration for tick marks.
  final TickConfig tickConfig;

  /// Configuration for the axis line.
  final AxisLineConfig lineConfig;

  /// Text style for labels.
  final TextStyle labelStyle;

  /// The length of the axis.
  final double length;

  /// Rotation angle for labels in radians.
  final double labelRotation;

  /// Creates an axis painter.
  AxisPainter({
    required this.orientation,
    required this.ticks,
    required this.tickConfig,
    required this.lineConfig,
    required this.labelStyle,
    required this.length,
    this.labelRotation = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final tickPaint = Paint()
      ..color = tickConfig.tickColor
      ..strokeWidth = tickConfig.tickStrokeWidth
      ..style = PaintingStyle.stroke;

    final linePaint = Paint()
      ..color = lineConfig.color
      ..strokeWidth = lineConfig.strokeWidth
      ..style = PaintingStyle.stroke;

    // Draw axis line
    if (lineConfig.visible) {
      _drawAxisLine(canvas, linePaint);
    }

    // Draw ticks and labels
    for (final tick in ticks) {
      _drawTick(canvas, tick, tickPaint);
      _drawLabel(canvas, tick);
    }
  }

  void _drawAxisLine(Canvas canvas, Paint paint) {
    switch (orientation) {
      case AxisOrientation.bottom:
      case AxisOrientation.top:
        canvas.drawLine(Offset.zero, Offset(length, 0), paint);
        break;
      case AxisOrientation.left:
      case AxisOrientation.right:
        canvas.drawLine(Offset.zero, Offset(0, length), paint);
        break;
    }
  }

  void _drawTick(Canvas canvas, AxisTick tick, Paint paint) {
    final pos = tick.position;
    final tickLen = tickConfig.tickLength;

    switch (orientation) {
      case AxisOrientation.bottom:
        canvas.drawLine(Offset(pos, 0), Offset(pos, tickLen), paint);
        break;
      case AxisOrientation.top:
        canvas.drawLine(Offset(pos, 0), Offset(pos, -tickLen), paint);
        break;
      case AxisOrientation.left:
        canvas.drawLine(Offset(0, pos), Offset(-tickLen, pos), paint);
        break;
      case AxisOrientation.right:
        canvas.drawLine(Offset(0, pos), Offset(tickLen, pos), paint);
        break;
    }
  }

  void _drawLabel(Canvas canvas, AxisTick tick) {
    final textSpan = TextSpan(text: tick.label, style: labelStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final pos = tick.position;
    final tickLen = tickConfig.tickLength;
    final padding = tickConfig.tickPadding;
    Offset labelOffset;

    switch (orientation) {
      case AxisOrientation.bottom:
        labelOffset = Offset(
          pos - textPainter.width / 2,
          tickLen + padding,
        );
        break;
      case AxisOrientation.top:
        labelOffset = Offset(
          pos - textPainter.width / 2,
          -tickLen - padding - textPainter.height,
        );
        break;
      case AxisOrientation.left:
        labelOffset = Offset(
          -tickLen - padding - textPainter.width,
          pos - textPainter.height / 2,
        );
        break;
      case AxisOrientation.right:
        labelOffset = Offset(
          tickLen + padding,
          pos - textPainter.height / 2,
        );
        break;
    }

    if (labelRotation != 0) {
      canvas.save();
      canvas.translate(labelOffset.dx + textPainter.width / 2,
          labelOffset.dy + textPainter.height / 2);
      canvas.rotate(labelRotation);
      textPainter.paint(
          canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      canvas.restore();
    } else {
      textPainter.paint(canvas, labelOffset);
    }
  }

  @override
  bool shouldRepaint(covariant AxisPainter oldDelegate) {
    return orientation != oldDelegate.orientation ||
        ticks != oldDelegate.ticks ||
        tickConfig != oldDelegate.tickConfig ||
        lineConfig != oldDelegate.lineConfig ||
        labelStyle != oldDelegate.labelStyle ||
        length != oldDelegate.length ||
        labelRotation != oldDelegate.labelRotation;
  }
}
