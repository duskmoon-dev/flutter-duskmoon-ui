import 'package:flutter/material.dart';

/// Reference line annotation for charts.
class ReferenceLine extends StatelessWidget {
  /// Start point of the line.
  final Offset start;

  /// End point of the line.
  final Offset end;

  /// Line color.
  final Color color;

  /// Line width.
  final double width;

  /// Line dash pattern (null for solid line).
  final List<double>? dashPattern;

  /// Whether to show markers at endpoints.
  final bool showMarkers;

  /// Marker radius.
  final double markerRadius;

  /// Marker fill color.
  final Color? markerColor;

  /// Whether to show the label.
  final bool showLabel;

  /// Label text.
  final String? label;

  /// Label style.
  final TextStyle? labelStyle;

  /// Label offset from the line.
  final Offset labelOffset;

  /// Callback when line is tapped.
  final VoidCallback? onTap;

  const ReferenceLine({
    super.key,
    required this.start,
    required this.end,
    this.color = Colors.grey,
    this.width = 1,
    this.dashPattern,
    this.showMarkers = false,
    this.markerRadius = 4,
    this.markerColor,
    this.showLabel = false,
    this.label,
    this.labelStyle,
    this.labelOffset = const Offset(0, -10),
    this.onTap,
  });

  /// Creates a horizontal reference line.
  factory ReferenceLine.horizontal({
    required double y,
    required double startX,
    required double endX,
    Color color = Colors.grey,
    double width = 1,
    List<double>? dashPattern,
    bool showLabel = false,
    String? label,
    TextStyle? labelStyle,
  }) {
    return ReferenceLine(
      start: Offset(startX, y),
      end: Offset(endX, y),
      color: color,
      width: width,
      dashPattern: dashPattern,
      showLabel: showLabel,
      label: label,
      labelStyle: labelStyle,
    );
  }

  /// Creates a vertical reference line.
  factory ReferenceLine.vertical({
    required double x,
    required double startY,
    required double endY,
    Color color = Colors.grey,
    double width = 1,
    List<double>? dashPattern,
    bool showLabel = false,
    String? label,
    TextStyle? labelStyle,
  }) {
    return ReferenceLine(
      start: Offset(x, startY),
      end: Offset(x, endY),
      color: color,
      width: width,
      dashPattern: dashPattern,
      showLabel: showLabel,
      label: label,
      labelStyle: labelStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _ReferenceLinePainter(
          start: start,
          end: end,
          color: color,
          width: width,
          dashPattern: dashPattern,
          showMarkers: showMarkers,
          markerRadius: markerRadius,
          markerColor: markerColor ?? color,
          showLabel: showLabel,
          label: label,
          labelStyle: labelStyle ?? TextStyle(fontSize: 10, color: color),
          labelOffset: labelOffset,
        ),
      ),
    );
  }
}

class _ReferenceLinePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final Color color;
  final double width;
  final List<double>? dashPattern;
  final bool showMarkers;
  final double markerRadius;
  final Color markerColor;
  final bool showLabel;
  final String? label;
  final TextStyle labelStyle;
  final Offset labelOffset;

  _ReferenceLinePainter({
    required this.start,
    required this.end,
    required this.color,
    required this.width,
    this.dashPattern,
    required this.showMarkers,
    required this.markerRadius,
    required this.markerColor,
    required this.showLabel,
    this.label,
    required this.labelStyle,
    required this.labelOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (dashPattern != null && dashPattern!.isNotEmpty) {
      _drawDashedLine(canvas, paint);
    } else {
      canvas.drawLine(start, end, paint);
    }

    if (showMarkers) {
      _drawMarkers(canvas);
    }

    if (showLabel && label != null) {
      _drawLabel(canvas);
    }
  }

  void _drawDashedLine(Canvas canvas, Paint paint) {
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
      final segmentLength = dashPattern![patternIndex % dashPattern!.length];
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

  void _drawMarkers(Canvas canvas) {
    final fillPaint = Paint()
      ..color = markerColor
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(start, markerRadius, fillPaint);
    canvas.drawCircle(start, markerRadius, strokePaint);

    canvas.drawCircle(end, markerRadius, fillPaint);
    canvas.drawCircle(end, markerRadius, strokePaint);
  }

  void _drawLabel(Canvas canvas) {
    final textSpan = TextSpan(text: label, style: labelStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Position at midpoint with offset
    final midX =
        (start.dx + end.dx) / 2 + labelOffset.dx - textPainter.width / 2;
    final midY =
        (start.dy + end.dy) / 2 + labelOffset.dy - textPainter.height / 2;

    // Draw background
    final bgRect = Rect.fromLTWH(
      midX - 2,
      midY - 1,
      textPainter.width + 4,
      textPainter.height + 2,
    );
    canvas.drawRect(
        bgRect, Paint()..color = Colors.white.withValues(alpha: 0.8));

    textPainter.paint(canvas, Offset(midX, midY));
  }

  @override
  bool shouldRepaint(_ReferenceLinePainter oldDelegate) {
    return start != oldDelegate.start ||
        end != oldDelegate.end ||
        color != oldDelegate.color ||
        showLabel != oldDelegate.showLabel;
  }
}

/// Multiple reference lines with common styling.
class ReferenceLines extends StatelessWidget {
  /// List of line configurations.
  final List<ReferenceLineConfig> lines;

  /// Default line color.
  final Color color;

  /// Default line width.
  final double width;

  /// Default dash pattern.
  final List<double>? dashPattern;

  /// Default label style.
  final TextStyle? labelStyle;

  const ReferenceLines({
    super.key,
    required this.lines,
    this.color = Colors.grey,
    this.width = 1,
    this.dashPattern,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ReferenceLinesPatiner(
        lines: lines,
        defaultColor: color,
        defaultWidth: width,
        defaultDashPattern: dashPattern,
        defaultLabelStyle: labelStyle ?? TextStyle(fontSize: 10, color: color),
      ),
    );
  }
}

/// Configuration for a single reference line.
class ReferenceLineConfig {
  final Offset start;
  final Offset end;
  final Color? color;
  final double? width;
  final List<double>? dashPattern;
  final String? label;
  final TextStyle? labelStyle;

  const ReferenceLineConfig({
    required this.start,
    required this.end,
    this.color,
    this.width,
    this.dashPattern,
    this.label,
    this.labelStyle,
  });
}

class _ReferenceLinesPatiner extends CustomPainter {
  final List<ReferenceLineConfig> lines;
  final Color defaultColor;
  final double defaultWidth;
  final List<double>? defaultDashPattern;
  final TextStyle defaultLabelStyle;

  _ReferenceLinesPatiner({
    required this.lines,
    required this.defaultColor,
    required this.defaultWidth,
    this.defaultDashPattern,
    required this.defaultLabelStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final line in lines) {
      final color = line.color ?? defaultColor;
      final width = line.width ?? defaultWidth;
      final dashPattern = line.dashPattern ?? defaultDashPattern;

      final paint = Paint()
        ..color = color
        ..strokeWidth = width
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      if (dashPattern != null && dashPattern.isNotEmpty) {
        _drawDashedLine(canvas, line.start, line.end, dashPattern, paint);
      } else {
        canvas.drawLine(line.start, line.end, paint);
      }

      if (line.label != null) {
        _drawLabel(canvas, line, color);
      }
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end,
      List<double> pattern, Paint paint) {
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
      final segmentLength = pattern[patternIndex % pattern.length];
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

  void _drawLabel(Canvas canvas, ReferenceLineConfig line, Color color) {
    final style = line.labelStyle ?? defaultLabelStyle;
    final textSpan = TextSpan(text: line.label, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final midX = (line.start.dx + line.end.dx) / 2 - textPainter.width / 2;
    final midY = (line.start.dy + line.end.dy) / 2 - textPainter.height - 4;

    final bgRect = Rect.fromLTWH(
      midX - 2,
      midY - 1,
      textPainter.width + 4,
      textPainter.height + 2,
    );
    canvas.drawRect(
        bgRect, Paint()..color = Colors.white.withValues(alpha: 0.8));

    textPainter.paint(canvas, Offset(midX, midY));
  }

  @override
  bool shouldRepaint(_ReferenceLinesPatiner oldDelegate) {
    return lines != oldDelegate.lines;
  }
}
