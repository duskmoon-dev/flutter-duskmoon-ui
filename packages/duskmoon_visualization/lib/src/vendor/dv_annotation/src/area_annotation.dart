import 'package:flutter/widgets.dart';

import 'annotation.dart';

/// Configuration for area annotations.
class AreaAnnotationConfig {
  /// The fill color of the area.
  final Color fillColor;

  /// The opacity of the fill (0.0 to 1.0).
  final double fillOpacity;

  /// Whether to show a border.
  final bool showBorder;

  /// The border color.
  final Color borderColor;

  /// The border stroke width.
  final double borderWidth;

  /// The orientation of the area.
  final AnnotationOrientation orientation;

  /// Creates an area annotation configuration.
  const AreaAnnotationConfig({
    this.fillColor = const Color(0xFF666666),
    this.fillOpacity = 0.2,
    this.showBorder = false,
    this.borderColor = const Color(0xFF666666),
    this.borderWidth = 1,
    this.orientation = AnnotationOrientation.horizontal,
  });

  /// Creates a copy with modified values.
  AreaAnnotationConfig copyWith({
    Color? fillColor,
    double? fillOpacity,
    bool? showBorder,
    Color? borderColor,
    double? borderWidth,
    AnnotationOrientation? orientation,
  }) {
    return AreaAnnotationConfig(
      fillColor: fillColor ?? this.fillColor,
      fillOpacity: fillOpacity ?? this.fillOpacity,
      showBorder: showBorder ?? this.showBorder,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      orientation: orientation ?? this.orientation,
    );
  }
}

/// A reference area annotation spanning a range of data values.
///
/// AreaAnnotation draws a filled rectangle between two data values,
/// useful for highlighting ranges, confidence intervals, or zones.
///
/// Example usage:
/// ```dart
/// AreaAnnotation(
///   scale: yScale,
///   startValue: 40,
///   endValue: 60,
///   width: 400,
///   height: 300,
///   config: AreaAnnotationConfig(
///     fillColor: Colors.blue,
///     fillOpacity: 0.2,
///   ),
/// )
/// ```
class AreaAnnotation extends Annotation {
  /// The starting data value for the area.
  final dynamic startValue;

  /// The ending data value for the area.
  final dynamic endValue;

  /// Configuration for the area.
  final AreaAnnotationConfig config;

  /// Optional label to display in the area.
  final String? label;

  /// Text style for the label.
  final TextStyle? labelStyle;

  /// Alignment of the label within the area.
  final Alignment labelAlignment;

  /// Creates an area annotation.
  const AreaAnnotation({
    super.key,
    required super.scale,
    required this.startValue,
    required this.endValue,
    required super.width,
    required super.height,
    this.config = const AreaAnnotationConfig(),
    this.label,
    this.labelStyle,
    this.labelAlignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final startPos = getPosition(startValue);
    final endPos = getPosition(endValue);
    final effectiveLabelStyle = labelStyle ??
        TextStyle(
          fontSize: 10,
          color: config.fillColor,
        );

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        size: Size(width, height),
        painter: _AreaAnnotationPainter(
          startPos: startPos,
          endPos: endPos,
          config: config,
          width: width,
          height: height,
          label: label,
          labelStyle: effectiveLabelStyle,
          labelAlignment: labelAlignment,
        ),
      ),
    );
  }
}

class _AreaAnnotationPainter extends CustomPainter {
  final double startPos;
  final double endPos;
  final AreaAnnotationConfig config;
  final double width;
  final double height;
  final String? label;
  final TextStyle labelStyle;
  final Alignment labelAlignment;

  _AreaAnnotationPainter({
    required this.startPos,
    required this.endPos,
    required this.config,
    required this.width,
    required this.height,
    this.label,
    required this.labelStyle,
    required this.labelAlignment,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect;
    if (config.orientation == AnnotationOrientation.horizontal) {
      final top = startPos < endPos ? startPos : endPos;
      final bottom = startPos < endPos ? endPos : startPos;
      rect = Rect.fromLTRB(0, top, width, bottom);
    } else {
      final left = startPos < endPos ? startPos : endPos;
      final right = startPos < endPos ? endPos : startPos;
      rect = Rect.fromLTRB(left, 0, right, height);
    }

    // Draw fill
    final fillPaint = Paint()
      ..color = config.fillColor.withAlpha((config.fillOpacity * 255).round())
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, fillPaint);

    // Draw border if enabled
    if (config.showBorder) {
      final borderPaint = Paint()
        ..color = config.borderColor
        ..strokeWidth = config.borderWidth
        ..style = PaintingStyle.stroke;
      canvas.drawRect(rect, borderPaint);
    }

    // Draw label if provided
    if (label != null) {
      final textSpan = TextSpan(text: label, style: labelStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      // Calculate label position based on alignment
      final areaWidth = rect.width;
      final areaHeight = rect.height;
      final labelX = rect.left +
          (areaWidth - textPainter.width) * (labelAlignment.x + 1) / 2;
      final labelY = rect.top +
          (areaHeight - textPainter.height) * (labelAlignment.y + 1) / 2;

      textPainter.paint(canvas, Offset(labelX, labelY));
    }
  }

  @override
  bool shouldRepaint(covariant _AreaAnnotationPainter oldDelegate) {
    return startPos != oldDelegate.startPos ||
        endPos != oldDelegate.endPos ||
        config.fillColor != oldDelegate.config.fillColor ||
        config.fillOpacity != oldDelegate.config.fillOpacity ||
        config.showBorder != oldDelegate.config.showBorder ||
        config.borderColor != oldDelegate.config.borderColor ||
        config.borderWidth != oldDelegate.config.borderWidth ||
        config.orientation != oldDelegate.config.orientation ||
        width != oldDelegate.width ||
        height != oldDelegate.height ||
        label != oldDelegate.label ||
        labelStyle != oldDelegate.labelStyle ||
        labelAlignment != oldDelegate.labelAlignment;
  }
}

/// Creates an AreaAnnotation widget.
Widget areaAnnotation({
  Key? key,
  required dynamic scale,
  required dynamic startValue,
  required dynamic endValue,
  required double width,
  required double height,
  AreaAnnotationConfig config = const AreaAnnotationConfig(),
  String? label,
  TextStyle? labelStyle,
  Alignment labelAlignment = Alignment.center,
}) {
  return AreaAnnotation(
    key: key,
    scale: scale,
    startValue: startValue,
    endValue: endValue,
    width: width,
    height: height,
    config: config,
    label: label,
    labelStyle: labelStyle,
    labelAlignment: labelAlignment,
  );
}

/// Creates a horizontal area annotation (band).
Widget horizontalBand({
  Key? key,
  required dynamic scale,
  required dynamic startValue,
  required dynamic endValue,
  required double width,
  required double height,
  Color fillColor = const Color(0xFF666666),
  double fillOpacity = 0.2,
  bool showBorder = false,
  String? label,
  TextStyle? labelStyle,
}) {
  return AreaAnnotation(
    key: key,
    scale: scale,
    startValue: startValue,
    endValue: endValue,
    width: width,
    height: height,
    config: AreaAnnotationConfig(
      fillColor: fillColor,
      fillOpacity: fillOpacity,
      showBorder: showBorder,
      orientation: AnnotationOrientation.horizontal,
    ),
    label: label,
    labelStyle: labelStyle,
  );
}

/// Creates a vertical area annotation (band).
Widget verticalBand({
  Key? key,
  required dynamic scale,
  required dynamic startValue,
  required dynamic endValue,
  required double width,
  required double height,
  Color fillColor = const Color(0xFF666666),
  double fillOpacity = 0.2,
  bool showBorder = false,
  String? label,
  TextStyle? labelStyle,
}) {
  return AreaAnnotation(
    key: key,
    scale: scale,
    startValue: startValue,
    endValue: endValue,
    width: width,
    height: height,
    config: AreaAnnotationConfig(
      fillColor: fillColor,
      fillOpacity: fillOpacity,
      showBorder: showBorder,
      orientation: AnnotationOrientation.vertical,
    ),
    label: label,
    labelStyle: labelStyle,
  );
}
