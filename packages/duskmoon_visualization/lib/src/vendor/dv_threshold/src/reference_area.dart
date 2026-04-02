import 'package:flutter/material.dart';

/// Reference area annotation for charts.
class ReferenceArea extends StatelessWidget {
  /// Top-left corner of the area.
  final Offset topLeft;

  /// Bottom-right corner of the area.
  final Offset bottomRight;

  /// Fill color.
  final Color color;

  /// Fill opacity.
  final double opacity;

  /// Border color.
  final Color? borderColor;

  /// Border width.
  final double borderWidth;

  /// Border dash pattern (null for solid border).
  final List<double>? borderDashPattern;

  /// Corner radius.
  final double cornerRadius;

  /// Whether to show the label.
  final bool showLabel;

  /// Label text.
  final String? label;

  /// Label style.
  final TextStyle? labelStyle;

  /// Label position within the area.
  final ReferenceAreaLabelPosition labelPosition;

  /// Gradient fill (overrides color if provided).
  final Gradient? gradient;

  /// Callback when area is tapped.
  final VoidCallback? onTap;

  const ReferenceArea({
    super.key,
    required this.topLeft,
    required this.bottomRight,
    this.color = Colors.blue,
    this.opacity = 0.2,
    this.borderColor,
    this.borderWidth = 1,
    this.borderDashPattern,
    this.cornerRadius = 0,
    this.showLabel = false,
    this.label,
    this.labelStyle,
    this.labelPosition = ReferenceAreaLabelPosition.topLeft,
    this.gradient,
    this.onTap,
  });

  /// Creates a horizontal band area.
  factory ReferenceArea.horizontalBand({
    required double yMin,
    required double yMax,
    required double xStart,
    required double xEnd,
    Color color = Colors.blue,
    double opacity = 0.2,
    Color? borderColor,
    double borderWidth = 1,
    String? label,
    TextStyle? labelStyle,
  }) {
    return ReferenceArea(
      topLeft: Offset(xStart, yMin),
      bottomRight: Offset(xEnd, yMax),
      color: color,
      opacity: opacity,
      borderColor: borderColor,
      borderWidth: borderWidth,
      showLabel: label != null,
      label: label,
      labelStyle: labelStyle,
    );
  }

  /// Creates a vertical band area.
  factory ReferenceArea.verticalBand({
    required double xMin,
    required double xMax,
    required double yStart,
    required double yEnd,
    Color color = Colors.blue,
    double opacity = 0.2,
    Color? borderColor,
    double borderWidth = 1,
    String? label,
    TextStyle? labelStyle,
  }) {
    return ReferenceArea(
      topLeft: Offset(xMin, yStart),
      bottomRight: Offset(xMax, yEnd),
      color: color,
      opacity: opacity,
      borderColor: borderColor,
      borderWidth: borderWidth,
      showLabel: label != null,
      label: label,
      labelStyle: labelStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _ReferenceAreaPainter(
          topLeft: topLeft,
          bottomRight: bottomRight,
          color: color,
          opacity: opacity,
          borderColor: borderColor,
          borderWidth: borderWidth,
          borderDashPattern: borderDashPattern,
          cornerRadius: cornerRadius,
          showLabel: showLabel,
          label: label,
          labelStyle: labelStyle ?? TextStyle(fontSize: 10, color: color),
          labelPosition: labelPosition,
          gradient: gradient,
        ),
      ),
    );
  }
}

/// Position of the label within a reference area.
enum ReferenceAreaLabelPosition {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

class _ReferenceAreaPainter extends CustomPainter {
  final Offset topLeft;
  final Offset bottomRight;
  final Color color;
  final double opacity;
  final Color? borderColor;
  final double borderWidth;
  final List<double>? borderDashPattern;
  final double cornerRadius;
  final bool showLabel;
  final String? label;
  final TextStyle labelStyle;
  final ReferenceAreaLabelPosition labelPosition;
  final Gradient? gradient;

  _ReferenceAreaPainter({
    required this.topLeft,
    required this.bottomRight,
    required this.color,
    required this.opacity,
    this.borderColor,
    required this.borderWidth,
    this.borderDashPattern,
    required this.cornerRadius,
    required this.showLabel,
    this.label,
    required this.labelStyle,
    required this.labelPosition,
    this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromPoints(topLeft, bottomRight);

    // Draw fill
    Paint fillPaint;
    if (gradient != null) {
      fillPaint = Paint()
        ..shader = gradient!.createShader(rect)
        ..style = PaintingStyle.fill;
    } else {
      fillPaint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;
    }

    if (cornerRadius > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(cornerRadius)),
        fillPaint,
      );
    } else {
      canvas.drawRect(rect, fillPaint);
    }

    // Draw border
    if (borderColor != null && borderWidth > 0) {
      final strokePaint = Paint()
        ..color = borderColor!
        ..strokeWidth = borderWidth
        ..style = PaintingStyle.stroke;

      if (borderDashPattern != null && borderDashPattern!.isNotEmpty) {
        _drawDashedRect(canvas, rect, strokePaint);
      } else if (cornerRadius > 0) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(cornerRadius)),
          strokePaint,
        );
      } else {
        canvas.drawRect(rect, strokePaint);
      }
    }

    // Draw label
    if (showLabel && label != null) {
      _drawLabel(canvas, rect);
    }
  }

  void _drawDashedRect(Canvas canvas, Rect rect, Paint paint) {
    // Draw each edge as a dashed line
    _drawDashedLine(canvas, rect.topLeft, rect.topRight, paint);
    _drawDashedLine(canvas, rect.topRight, rect.bottomRight, paint);
    _drawDashedLine(canvas, rect.bottomRight, rect.bottomLeft, paint);
    _drawDashedLine(canvas, rect.bottomLeft, rect.topLeft, paint);
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final distance = _sqrt(dx * dx + dy * dy);
    if (distance == 0) return;

    final unitX = dx / distance;
    final unitY = dy / distance;

    double drawn = 0;
    int patternIndex = 0;
    bool draw = true;

    while (drawn < distance) {
      final segmentLength =
          borderDashPattern![patternIndex % borderDashPattern!.length];
      final nextDrawn = drawn + segmentLength;

      if (draw) {
        canvas.drawLine(
          Offset(start.dx + unitX * drawn, start.dy + unitY * drawn),
          Offset(
            start.dx + unitX * (nextDrawn > distance ? distance : nextDrawn),
            start.dy + unitY * (nextDrawn > distance ? distance : nextDrawn),
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

  void _drawLabel(Canvas canvas, Rect rect) {
    final textSpan = TextSpan(text: label, style: labelStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    double x, y;
    const padding = 4.0;

    switch (labelPosition) {
      case ReferenceAreaLabelPosition.topLeft:
        x = rect.left + padding;
        y = rect.top + padding;
        break;
      case ReferenceAreaLabelPosition.topCenter:
        x = rect.center.dx - textPainter.width / 2;
        y = rect.top + padding;
        break;
      case ReferenceAreaLabelPosition.topRight:
        x = rect.right - textPainter.width - padding;
        y = rect.top + padding;
        break;
      case ReferenceAreaLabelPosition.centerLeft:
        x = rect.left + padding;
        y = rect.center.dy - textPainter.height / 2;
        break;
      case ReferenceAreaLabelPosition.center:
        x = rect.center.dx - textPainter.width / 2;
        y = rect.center.dy - textPainter.height / 2;
        break;
      case ReferenceAreaLabelPosition.centerRight:
        x = rect.right - textPainter.width - padding;
        y = rect.center.dy - textPainter.height / 2;
        break;
      case ReferenceAreaLabelPosition.bottomLeft:
        x = rect.left + padding;
        y = rect.bottom - textPainter.height - padding;
        break;
      case ReferenceAreaLabelPosition.bottomCenter:
        x = rect.center.dx - textPainter.width / 2;
        y = rect.bottom - textPainter.height - padding;
        break;
      case ReferenceAreaLabelPosition.bottomRight:
        x = rect.right - textPainter.width - padding;
        y = rect.bottom - textPainter.height - padding;
        break;
    }

    // Draw background
    final bgRect = Rect.fromLTWH(
      x - 2,
      y - 1,
      textPainter.width + 4,
      textPainter.height + 2,
    );
    canvas.drawRect(
        bgRect, Paint()..color = Colors.white.withValues(alpha: 0.8));

    textPainter.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(_ReferenceAreaPainter oldDelegate) {
    return topLeft != oldDelegate.topLeft ||
        bottomRight != oldDelegate.bottomRight ||
        color != oldDelegate.color ||
        opacity != oldDelegate.opacity ||
        showLabel != oldDelegate.showLabel;
  }
}

/// Multiple reference areas with common styling.
class ReferenceAreas extends StatelessWidget {
  /// List of area configurations.
  final List<ReferenceAreaConfig> areas;

  /// Default fill color.
  final Color color;

  /// Default fill opacity.
  final double opacity;

  /// Default border color.
  final Color? borderColor;

  /// Default border width.
  final double borderWidth;

  /// Default label style.
  final TextStyle? labelStyle;

  const ReferenceAreas({
    super.key,
    required this.areas,
    this.color = Colors.blue,
    this.opacity = 0.2,
    this.borderColor,
    this.borderWidth = 1,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ReferenceAreasPainter(
        areas: areas,
        defaultColor: color,
        defaultOpacity: opacity,
        defaultBorderColor: borderColor,
        defaultBorderWidth: borderWidth,
        defaultLabelStyle: labelStyle ?? TextStyle(fontSize: 10, color: color),
      ),
    );
  }
}

/// Configuration for a single reference area.
class ReferenceAreaConfig {
  final Offset topLeft;
  final Offset bottomRight;
  final Color? color;
  final double? opacity;
  final Color? borderColor;
  final double? borderWidth;
  final String? label;
  final TextStyle? labelStyle;
  final ReferenceAreaLabelPosition labelPosition;

  const ReferenceAreaConfig({
    required this.topLeft,
    required this.bottomRight,
    this.color,
    this.opacity,
    this.borderColor,
    this.borderWidth,
    this.label,
    this.labelStyle,
    this.labelPosition = ReferenceAreaLabelPosition.topLeft,
  });
}

class _ReferenceAreasPainter extends CustomPainter {
  final List<ReferenceAreaConfig> areas;
  final Color defaultColor;
  final double defaultOpacity;
  final Color? defaultBorderColor;
  final double defaultBorderWidth;
  final TextStyle defaultLabelStyle;

  _ReferenceAreasPainter({
    required this.areas,
    required this.defaultColor,
    required this.defaultOpacity,
    this.defaultBorderColor,
    required this.defaultBorderWidth,
    required this.defaultLabelStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final area in areas) {
      final color = area.color ?? defaultColor;
      final opacity = area.opacity ?? defaultOpacity;
      final borderColor = area.borderColor ?? defaultBorderColor;
      final borderWidth = area.borderWidth ?? defaultBorderWidth;

      final rect = Rect.fromPoints(area.topLeft, area.bottomRight);

      // Draw fill
      final fillPaint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;
      canvas.drawRect(rect, fillPaint);

      // Draw border
      if (borderColor != null && borderWidth > 0) {
        final strokePaint = Paint()
          ..color = borderColor
          ..strokeWidth = borderWidth
          ..style = PaintingStyle.stroke;
        canvas.drawRect(rect, strokePaint);
      }

      // Draw label
      if (area.label != null) {
        _drawLabel(canvas, rect, area);
      }
    }
  }

  void _drawLabel(Canvas canvas, Rect rect, ReferenceAreaConfig area) {
    final style = area.labelStyle ?? defaultLabelStyle;
    final textSpan = TextSpan(text: area.label, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    double x, y;
    const padding = 4.0;

    switch (area.labelPosition) {
      case ReferenceAreaLabelPosition.topLeft:
        x = rect.left + padding;
        y = rect.top + padding;
        break;
      case ReferenceAreaLabelPosition.topCenter:
        x = rect.center.dx - textPainter.width / 2;
        y = rect.top + padding;
        break;
      case ReferenceAreaLabelPosition.topRight:
        x = rect.right - textPainter.width - padding;
        y = rect.top + padding;
        break;
      case ReferenceAreaLabelPosition.centerLeft:
        x = rect.left + padding;
        y = rect.center.dy - textPainter.height / 2;
        break;
      case ReferenceAreaLabelPosition.center:
        x = rect.center.dx - textPainter.width / 2;
        y = rect.center.dy - textPainter.height / 2;
        break;
      case ReferenceAreaLabelPosition.centerRight:
        x = rect.right - textPainter.width - padding;
        y = rect.center.dy - textPainter.height / 2;
        break;
      case ReferenceAreaLabelPosition.bottomLeft:
        x = rect.left + padding;
        y = rect.bottom - textPainter.height - padding;
        break;
      case ReferenceAreaLabelPosition.bottomCenter:
        x = rect.center.dx - textPainter.width / 2;
        y = rect.bottom - textPainter.height - padding;
        break;
      case ReferenceAreaLabelPosition.bottomRight:
        x = rect.right - textPainter.width - padding;
        y = rect.bottom - textPainter.height - padding;
        break;
    }

    final bgRect = Rect.fromLTWH(
      x - 2,
      y - 1,
      textPainter.width + 4,
      textPainter.height + 2,
    );
    canvas.drawRect(
        bgRect, Paint()..color = Colors.white.withValues(alpha: 0.8));

    textPainter.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(_ReferenceAreasPainter oldDelegate) {
    return areas != oldDelegate.areas;
  }
}
