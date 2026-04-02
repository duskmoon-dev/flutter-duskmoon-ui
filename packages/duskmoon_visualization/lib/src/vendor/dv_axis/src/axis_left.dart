import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'axis.dart';

/// A vertical axis positioned at the left of a chart.
///
/// AxisLeft renders tick marks pointing leftward, with labels
/// positioned to the left of the tick marks.
///
/// Example usage:
/// ```dart
/// AxisLeft(
///   scale: scaleLinear(domain: [0, 100], range: [300, 0]),
///   length: 300,
///   tickCount: 5,
/// )
/// ```
class AxisLeft<T> extends ChartAxis<T> {
  /// Creates a left axis.
  const AxisLeft({
    super.key,
    required super.scale,
    super.tickValues,
    super.tickCount,
    super.tickFormat,
    super.tickConfig,
    super.lineConfig,
    super.labelStyle,
    required super.length,
    super.labelRotation,
  });

  @override
  AxisOrientation get orientation => AxisOrientation.left;

  @override
  Widget build(BuildContext context) {
    final ticks = generateTicks();
    final effectiveLabelStyle = labelStyle ??
        const TextStyle(
          fontSize: 10,
          color: Color(0xFF000000),
        );

    // Calculate required width based on tick length, padding, and max label width
    final maxLabelWidth = _calculateMaxLabelWidth(ticks, effectiveLabelStyle);
    final width = tickConfig.tickLength +
        tickConfig.tickPadding +
        maxLabelWidth +
        4; // Extra padding

    return SizedBox(
      width: width,
      height: length,
      child: CustomPaint(
        size: Size(width, length),
        painter: _AxisLeftPainter(
          ticks: ticks,
          tickConfig: tickConfig,
          lineConfig: lineConfig,
          labelStyle: effectiveLabelStyle,
          length: length,
          labelRotation: labelRotation * math.pi / 180,
          axisLineX: width, // Paint axis line on the right edge
        ),
      ),
    );
  }

  double _calculateMaxLabelWidth(List<AxisTick<T>> ticks, TextStyle style) {
    double maxWidth = 0;
    for (final tick in ticks) {
      final textPainter = TextPainter(
        text: TextSpan(text: tick.label, style: style),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      if (labelRotation != 0) {
        final radians = labelRotation * math.pi / 180;
        final rotatedWidth = textPainter.width * math.cos(radians).abs() +
            textPainter.height * math.sin(radians).abs();
        maxWidth = math.max(maxWidth, rotatedWidth);
      } else {
        maxWidth = math.max(maxWidth, textPainter.width);
      }
    }
    return maxWidth;
  }
}

class _AxisLeftPainter extends CustomPainter {
  final List<AxisTick> ticks;
  final TickConfig tickConfig;
  final AxisLineConfig lineConfig;
  final TextStyle labelStyle;
  final double length;
  final double labelRotation;
  final double axisLineX;

  _AxisLeftPainter({
    required this.ticks,
    required this.tickConfig,
    required this.lineConfig,
    required this.labelStyle,
    required this.length,
    required this.labelRotation,
    required this.axisLineX,
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

    final x = axisLineX;

    // Draw axis line
    if (lineConfig.visible) {
      canvas.drawLine(Offset(x, 0), Offset(x, length), linePaint);
    }

    // Draw ticks and labels
    for (final tick in ticks) {
      final y = tick.position;

      // Draw tick
      canvas.drawLine(
        Offset(x, y),
        Offset(x - tickConfig.tickLength, y),
        tickPaint,
      );

      // Draw label
      final textSpan = TextSpan(text: tick.label, style: labelStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final labelOffset = Offset(
        x - tickConfig.tickLength - tickConfig.tickPadding - textPainter.width,
        y - textPainter.height / 2,
      );

      if (labelRotation != 0) {
        canvas.save();
        canvas.translate(
          labelOffset.dx + textPainter.width / 2,
          labelOffset.dy + textPainter.height / 2,
        );
        canvas.rotate(labelRotation);
        textPainter.paint(
          canvas,
          Offset(-textPainter.width / 2, -textPainter.height / 2),
        );
        canvas.restore();
      } else {
        textPainter.paint(canvas, labelOffset);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _AxisLeftPainter oldDelegate) {
    return ticks != oldDelegate.ticks ||
        tickConfig != oldDelegate.tickConfig ||
        lineConfig != oldDelegate.lineConfig ||
        labelStyle != oldDelegate.labelStyle ||
        length != oldDelegate.length ||
        labelRotation != oldDelegate.labelRotation ||
        axisLineX != oldDelegate.axisLineX;
  }
}

/// Creates a left axis widget.
Widget axisLeft<T>({
  Key? key,
  required dynamic scale,
  List<T>? tickValues,
  int tickCount = 10,
  String Function(T)? tickFormat,
  TickConfig tickConfig = const TickConfig(),
  AxisLineConfig lineConfig = const AxisLineConfig(),
  TextStyle? labelStyle,
  required double length,
  double labelRotation = 0,
}) {
  return AxisLeft<T>(
    key: key,
    scale: scale,
    tickValues: tickValues,
    tickCount: tickCount,
    tickFormat: tickFormat,
    tickConfig: tickConfig,
    lineConfig: lineConfig,
    labelStyle: labelStyle,
    length: length,
    labelRotation: labelRotation,
  );
}
