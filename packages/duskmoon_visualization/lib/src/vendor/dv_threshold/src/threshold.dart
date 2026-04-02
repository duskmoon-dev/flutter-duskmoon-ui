import 'package:flutter/material.dart';

/// Threshold indicator for chart values.
class Threshold extends StatelessWidget {
  /// The threshold value.
  final double value;

  /// Direction of the threshold line.
  final ThresholdDirection direction;

  /// Line color.
  final Color color;

  /// Line width.
  final double width;

  /// Line dash pattern (null for solid line).
  final List<double>? dashPattern;

  /// Whether to show the label.
  final bool showLabel;

  /// Label text (defaults to threshold value).
  final String? label;

  /// Label position.
  final ThresholdLabelPosition labelPosition;

  /// Label style.
  final TextStyle? labelStyle;

  /// Label background color.
  final Color? labelBackgroundColor;

  /// Label padding.
  final EdgeInsets labelPadding;

  /// Scale function to convert value to position.
  final double Function(double value)? scale;

  const Threshold({
    super.key,
    required this.value,
    this.direction = ThresholdDirection.horizontal,
    this.color = Colors.red,
    this.width = 2,
    this.dashPattern,
    this.showLabel = true,
    this.label,
    this.labelPosition = ThresholdLabelPosition.end,
    this.labelStyle,
    this.labelBackgroundColor,
    this.labelPadding = const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _ThresholdPainter(
            value: value,
            direction: direction,
            color: color,
            width: width,
            dashPattern: dashPattern,
            showLabel: showLabel,
            label: label ?? value.toStringAsFixed(1),
            labelPosition: labelPosition,
            labelStyle: labelStyle ?? TextStyle(fontSize: 10, color: color),
            labelBackgroundColor: labelBackgroundColor,
            labelPadding: labelPadding,
            scale: scale,
          ),
        );
      },
    );
  }
}

/// Direction of the threshold line.
enum ThresholdDirection {
  horizontal,
  vertical,
}

/// Position of the threshold label.
enum ThresholdLabelPosition {
  start,
  center,
  end,
}

class _ThresholdPainter extends CustomPainter {
  final double value;
  final ThresholdDirection direction;
  final Color color;
  final double width;
  final List<double>? dashPattern;
  final bool showLabel;
  final String label;
  final ThresholdLabelPosition labelPosition;
  final TextStyle labelStyle;
  final Color? labelBackgroundColor;
  final EdgeInsets labelPadding;
  final double Function(double value)? scale;

  _ThresholdPainter({
    required this.value,
    required this.direction,
    required this.color,
    required this.width,
    this.dashPattern,
    required this.showLabel,
    required this.label,
    required this.labelPosition,
    required this.labelStyle,
    this.labelBackgroundColor,
    required this.labelPadding,
    this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final position = scale?.call(value) ?? value;

    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset start, end;

    if (direction == ThresholdDirection.horizontal) {
      start = Offset(0, position);
      end = Offset(size.width, position);
    } else {
      start = Offset(position, 0);
      end = Offset(position, size.height);
    }

    if (dashPattern != null && dashPattern!.isNotEmpty) {
      _drawDashedLine(canvas, start, end, paint);
    } else {
      canvas.drawLine(start, end, paint);
    }

    if (showLabel) {
      _drawLabel(canvas, size, position);
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final distance = (dx * dx + dy * dy);
    final sqrtDist = distance > 0 ? _sqrt(distance) : 1.0;
    final unitX = dx / sqrtDist;
    final unitY = dy / sqrtDist;

    double drawn = 0;
    int patternIndex = 0;
    bool draw = true;

    while (drawn < sqrtDist) {
      final segmentLength = dashPattern![patternIndex % dashPattern!.length];
      final nextDrawn = drawn + segmentLength;

      if (draw) {
        canvas.drawLine(
          Offset(start.dx + unitX * drawn, start.dy + unitY * drawn),
          Offset(
            start.dx + unitX * (nextDrawn > sqrtDist ? sqrtDist : nextDrawn),
            start.dy + unitY * (nextDrawn > sqrtDist ? sqrtDist : nextDrawn),
          ),
          paint,
        );
      }

      drawn = nextDrawn;
      patternIndex++;
      draw = !draw;
    }
  }

  double _sqrt(double x) {
    if (x <= 0) return 0;
    double guess = x / 2;
    for (int i = 0; i < 10; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }

  void _drawLabel(Canvas canvas, Size size, double position) {
    final textSpan = TextSpan(text: label, style: labelStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    double x, y;

    if (direction == ThresholdDirection.horizontal) {
      y = position - textPainter.height / 2;

      switch (labelPosition) {
        case ThresholdLabelPosition.start:
          x = labelPadding.left;
          break;
        case ThresholdLabelPosition.center:
          x = size.width / 2 - textPainter.width / 2;
          break;
        case ThresholdLabelPosition.end:
          x = size.width - textPainter.width - labelPadding.right;
          break;
      }
    } else {
      x = position - textPainter.width / 2;

      switch (labelPosition) {
        case ThresholdLabelPosition.start:
          y = labelPadding.top;
          break;
        case ThresholdLabelPosition.center:
          y = size.height / 2 - textPainter.height / 2;
          break;
        case ThresholdLabelPosition.end:
          y = size.height - textPainter.height - labelPadding.bottom;
          break;
      }
    }

    // Draw background
    if (labelBackgroundColor != null) {
      final bgRect = Rect.fromLTWH(
        x - labelPadding.left,
        y - labelPadding.top,
        textPainter.width + labelPadding.horizontal,
        textPainter.height + labelPadding.vertical,
      );
      canvas.drawRect(bgRect, Paint()..color = labelBackgroundColor!);
    }

    textPainter.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(_ThresholdPainter oldDelegate) {
    return value != oldDelegate.value ||
        color != oldDelegate.color ||
        showLabel != oldDelegate.showLabel;
  }
}
