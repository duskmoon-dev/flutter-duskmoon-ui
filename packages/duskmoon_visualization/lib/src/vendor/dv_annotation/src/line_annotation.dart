import 'package:flutter/widgets.dart';

import 'annotation.dart';

/// Configuration for line annotations.
class LineAnnotationConfig extends AnnotationConfig {
  /// The orientation of the line.
  final AnnotationOrientation orientation;

  /// Creates a line annotation configuration.
  const LineAnnotationConfig({
    super.color,
    super.strokeWidth,
    super.dashPattern,
    this.orientation = AnnotationOrientation.horizontal,
  });

  @override
  LineAnnotationConfig copyWith({
    Color? color,
    double? strokeWidth,
    List<double>? dashPattern,
    AnnotationOrientation? orientation,
  }) {
    return LineAnnotationConfig(
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      dashPattern: dashPattern ?? this.dashPattern,
      orientation: orientation ?? this.orientation,
    );
  }
}

/// A reference line annotation at a specific data value.
///
/// LineAnnotation draws a single line across the chart at a given
/// data value, useful for showing thresholds, averages, or other
/// reference values.
///
/// Example usage:
/// ```dart
/// LineAnnotation(
///   scale: yScale,
///   value: 50,
///   width: 400,
///   height: 300,
///   config: LineAnnotationConfig(
///     color: Colors.red,
///     dashPattern: [5, 3],
///   ),
/// )
/// ```
class LineAnnotation extends Annotation {
  /// The data value where the line should be drawn.
  final dynamic value;

  /// Configuration for the line.
  final LineAnnotationConfig config;

  /// Optional label to display near the line.
  final String? label;

  /// Text style for the label.
  final TextStyle? labelStyle;

  /// Offset for the label from the line.
  final Offset labelOffset;

  /// Creates a line annotation.
  const LineAnnotation({
    super.key,
    required super.scale,
    required this.value,
    required super.width,
    required super.height,
    this.config = const LineAnnotationConfig(),
    this.label,
    this.labelStyle,
    this.labelOffset = const Offset(4, -4),
  });

  @override
  Widget build(BuildContext context) {
    final position = getPosition(value);
    final effectiveLabelStyle = labelStyle ??
        TextStyle(
          fontSize: 10,
          color: config.color,
        );

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        size: Size(width, height),
        painter: _LineAnnotationPainter(
          position: position,
          config: config,
          width: width,
          height: height,
          label: label,
          labelStyle: effectiveLabelStyle,
          labelOffset: labelOffset,
        ),
      ),
    );
  }
}

class _LineAnnotationPainter extends CustomPainter {
  final double position;
  final LineAnnotationConfig config;
  final double width;
  final double height;
  final String? label;
  final TextStyle labelStyle;
  final Offset labelOffset;

  _LineAnnotationPainter({
    required this.position,
    required this.config,
    required this.width,
    required this.height,
    this.label,
    required this.labelStyle,
    required this.labelOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = config.color
      ..strokeWidth = config.strokeWidth
      ..style = PaintingStyle.stroke;

    Offset start, end;
    if (config.orientation == AnnotationOrientation.horizontal) {
      start = Offset(0, position);
      end = Offset(width, position);
    } else {
      start = Offset(position, 0);
      end = Offset(position, height);
    }

    drawAnnotationLine(canvas, start, end, paint, config.dashPattern);

    // Draw label if provided
    if (label != null) {
      final textSpan = TextSpan(text: label, style: labelStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      Offset labelPos;
      if (config.orientation == AnnotationOrientation.horizontal) {
        labelPos = Offset(
          labelOffset.dx,
          position + labelOffset.dy - textPainter.height,
        );
      } else {
        labelPos = Offset(
          position + labelOffset.dx,
          labelOffset.dy,
        );
      }

      textPainter.paint(canvas, labelPos);
    }
  }

  @override
  bool shouldRepaint(covariant _LineAnnotationPainter oldDelegate) {
    return position != oldDelegate.position ||
        config.color != oldDelegate.config.color ||
        config.strokeWidth != oldDelegate.config.strokeWidth ||
        config.dashPattern != oldDelegate.config.dashPattern ||
        config.orientation != oldDelegate.config.orientation ||
        width != oldDelegate.width ||
        height != oldDelegate.height ||
        label != oldDelegate.label ||
        labelStyle != oldDelegate.labelStyle ||
        labelOffset != oldDelegate.labelOffset;
  }
}

/// Creates a LineAnnotation widget.
Widget lineAnnotation({
  Key? key,
  required dynamic scale,
  required dynamic value,
  required double width,
  required double height,
  LineAnnotationConfig config = const LineAnnotationConfig(),
  String? label,
  TextStyle? labelStyle,
  Offset labelOffset = const Offset(4, -4),
}) {
  return LineAnnotation(
    key: key,
    scale: scale,
    value: value,
    width: width,
    height: height,
    config: config,
    label: label,
    labelStyle: labelStyle,
    labelOffset: labelOffset,
  );
}

/// Creates a horizontal line annotation.
Widget horizontalLineAnnotation({
  Key? key,
  required dynamic scale,
  required dynamic value,
  required double width,
  required double height,
  Color color = const Color(0xFF666666),
  double strokeWidth = 1,
  List<double>? dashPattern,
  String? label,
  TextStyle? labelStyle,
}) {
  return LineAnnotation(
    key: key,
    scale: scale,
    value: value,
    width: width,
    height: height,
    config: LineAnnotationConfig(
      color: color,
      strokeWidth: strokeWidth,
      dashPattern: dashPattern,
      orientation: AnnotationOrientation.horizontal,
    ),
    label: label,
    labelStyle: labelStyle,
  );
}

/// Creates a vertical line annotation.
Widget verticalLineAnnotation({
  Key? key,
  required dynamic scale,
  required dynamic value,
  required double width,
  required double height,
  Color color = const Color(0xFF666666),
  double strokeWidth = 1,
  List<double>? dashPattern,
  String? label,
  TextStyle? labelStyle,
}) {
  return LineAnnotation(
    key: key,
    scale: scale,
    value: value,
    width: width,
    height: height,
    config: LineAnnotationConfig(
      color: color,
      strokeWidth: strokeWidth,
      dashPattern: dashPattern,
      orientation: AnnotationOrientation.vertical,
    ),
    label: label,
    labelStyle: labelStyle,
  );
}
