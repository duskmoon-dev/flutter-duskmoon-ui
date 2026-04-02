import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'axis.dart';

/// A horizontal axis positioned at the top of a chart.
///
/// AxisTop renders tick marks pointing upward, with labels
/// positioned above the tick marks.
///
/// Example usage:
/// ```dart
/// AxisTop(
///   scale: scaleLinear(domain: [0, 100], range: [0, 400]),
///   length: 400,
///   tickCount: 5,
/// )
/// ```
class AxisTop<T> extends ChartAxis<T> {
  /// Creates a top axis.
  const AxisTop({
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
  AxisOrientation get orientation => AxisOrientation.top;

  @override
  Widget build(BuildContext context) {
    final ticks = generateTicks();
    final effectiveLabelStyle = labelStyle ??
        const TextStyle(
          fontSize: 10,
          color: Color(0xFF000000),
        );

    // Calculate required height based on tick length, padding, and label height
    final maxLabelHeight = _calculateMaxLabelHeight(ticks, effectiveLabelStyle);
    final height = tickConfig.tickLength +
        tickConfig.tickPadding +
        maxLabelHeight +
        4; // Extra padding

    return SizedBox(
      width: length,
      height: height,
      child: CustomPaint(
        size: Size(length, height),
        painter: _AxisTopPainter(
          ticks: ticks,
          tickConfig: tickConfig,
          lineConfig: lineConfig,
          labelStyle: effectiveLabelStyle,
          length: length,
          labelRotation: labelRotation * math.pi / 180,
          baselineOffset: height, // Paint from bottom of widget
        ),
      ),
    );
  }

  double _calculateMaxLabelHeight(List<AxisTick<T>> ticks, TextStyle style) {
    double maxHeight = 0;
    for (final tick in ticks) {
      final textPainter = TextPainter(
        text: TextSpan(text: tick.label, style: style),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      if (labelRotation != 0) {
        final radians = labelRotation * math.pi / 180;
        final rotatedHeight = textPainter.width * math.sin(radians).abs() +
            textPainter.height * math.cos(radians).abs();
        maxHeight = math.max(maxHeight, rotatedHeight);
      } else {
        maxHeight = math.max(maxHeight, textPainter.height);
      }
    }
    return maxHeight;
  }
}

class _AxisTopPainter extends CustomPainter {
  final List<AxisTick> ticks;
  final TickConfig tickConfig;
  final AxisLineConfig lineConfig;
  final TextStyle labelStyle;
  final double length;
  final double labelRotation;
  final double baselineOffset;

  _AxisTopPainter({
    required this.ticks,
    required this.tickConfig,
    required this.lineConfig,
    required this.labelStyle,
    required this.length,
    required this.labelRotation,
    required this.baselineOffset,
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

    final y = baselineOffset;

    // Draw axis line
    if (lineConfig.visible) {
      canvas.drawLine(Offset(0, y), Offset(length, y), linePaint);
    }

    // Draw ticks and labels
    for (final tick in ticks) {
      final x = tick.position;

      // Draw tick
      canvas.drawLine(
        Offset(x, y),
        Offset(x, y - tickConfig.tickLength),
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
        x - textPainter.width / 2,
        y - tickConfig.tickLength - tickConfig.tickPadding - textPainter.height,
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
  bool shouldRepaint(covariant _AxisTopPainter oldDelegate) {
    return ticks != oldDelegate.ticks ||
        tickConfig != oldDelegate.tickConfig ||
        lineConfig != oldDelegate.lineConfig ||
        labelStyle != oldDelegate.labelStyle ||
        length != oldDelegate.length ||
        labelRotation != oldDelegate.labelRotation ||
        baselineOffset != oldDelegate.baselineOffset;
  }
}

/// Creates a top axis widget.
Widget axisTop<T>({
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
  return AxisTop<T>(
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
