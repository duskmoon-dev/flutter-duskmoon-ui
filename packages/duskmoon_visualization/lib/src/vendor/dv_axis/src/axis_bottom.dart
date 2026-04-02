import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'axis.dart';

/// A horizontal axis positioned at the bottom of a chart.
///
/// AxisBottom renders tick marks pointing downward, with labels
/// positioned below the tick marks.
///
/// Example usage:
/// ```dart
/// AxisBottom(
///   scale: scaleLinear(domain: [0, 100], range: [0, 400]),
///   length: 400,
///   tickCount: 5,
/// )
/// ```
class AxisBottom<T> extends ChartAxis<T> {
  /// Creates a bottom axis.
  const AxisBottom({
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
  AxisOrientation get orientation => AxisOrientation.bottom;

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
        painter: AxisPainter(
          orientation: orientation,
          ticks: ticks,
          tickConfig: tickConfig,
          lineConfig: lineConfig,
          labelStyle: effectiveLabelStyle,
          length: length,
          labelRotation: labelRotation * math.pi / 180,
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
        // Account for rotation
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

/// Creates a bottom axis widget.
Widget axisBottom<T>({
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
  return AxisBottom<T>(
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
