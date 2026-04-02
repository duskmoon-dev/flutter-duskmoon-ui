import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Configuration for label annotations.
class LabelAnnotationConfig {
  /// The background color of the label.
  final Color? backgroundColor;

  /// The background opacity.
  final double backgroundOpacity;

  /// Padding around the text.
  final EdgeInsets padding;

  /// Border radius for the background.
  final double borderRadius;

  /// Whether to show a border.
  final bool showBorder;

  /// The border color.
  final Color borderColor;

  /// The border width.
  final double borderWidth;

  /// Rotation angle in degrees.
  final double rotation;

  /// Creates a label annotation configuration.
  const LabelAnnotationConfig({
    this.backgroundColor,
    this.backgroundOpacity = 0.8,
    this.padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    this.borderRadius = 2,
    this.showBorder = false,
    this.borderColor = const Color(0xFF666666),
    this.borderWidth = 1,
    this.rotation = 0,
  });

  /// Creates a copy with modified values.
  LabelAnnotationConfig copyWith({
    Color? backgroundColor,
    double? backgroundOpacity,
    EdgeInsets? padding,
    double? borderRadius,
    bool? showBorder,
    Color? borderColor,
    double? borderWidth,
    double? rotation,
  }) {
    return LabelAnnotationConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundOpacity: backgroundOpacity ?? this.backgroundOpacity,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      showBorder: showBorder ?? this.showBorder,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      rotation: rotation ?? this.rotation,
    );
  }
}

/// Anchor point for positioning the label relative to its coordinates.
enum LabelAnchor {
  /// Center of the label at the coordinates.
  center,

  /// Top-left corner at the coordinates.
  topLeft,

  /// Top-center at the coordinates.
  topCenter,

  /// Top-right corner at the coordinates.
  topRight,

  /// Middle-left at the coordinates.
  middleLeft,

  /// Middle-right at the coordinates.
  middleRight,

  /// Bottom-left corner at the coordinates.
  bottomLeft,

  /// Bottom-center at the coordinates.
  bottomCenter,

  /// Bottom-right corner at the coordinates.
  bottomRight,
}

/// A text label annotation at a specific position.
///
/// LabelAnnotation places text at specified data coordinates,
/// useful for annotations, callouts, or highlighting specific
/// data points.
///
/// Example usage:
/// ```dart
/// LabelAnnotation(
///   xScale: xScale,
///   yScale: yScale,
///   xValue: 50,
///   yValue: 75,
///   label: 'Peak Value',
///   width: 400,
///   height: 300,
/// )
/// ```
class LabelAnnotation extends StatelessWidget {
  /// The x-scale for positioning.
  final dynamic xScale;

  /// The y-scale for positioning.
  final dynamic yScale;

  /// The x data value.
  final dynamic xValue;

  /// The y data value.
  final dynamic yValue;

  /// The label text.
  final String label;

  /// Text style for the label.
  final TextStyle? labelStyle;

  /// The width of the chart area.
  final double width;

  /// The height of the chart area.
  final double height;

  /// Configuration for the label.
  final LabelAnnotationConfig config;

  /// The anchor point for the label.
  final LabelAnchor anchor;

  /// Additional offset from the anchor position.
  final Offset offset;

  /// Creates a label annotation.
  const LabelAnnotation({
    super.key,
    required this.xScale,
    required this.yScale,
    required this.xValue,
    required this.yValue,
    required this.label,
    this.labelStyle,
    required this.width,
    required this.height,
    this.config = const LabelAnnotationConfig(),
    this.anchor = LabelAnchor.center,
    this.offset = Offset.zero,
  });

  @override
  Widget build(BuildContext context) {
    final xPos = _getPosition(xScale, xValue);
    final yPos = _getPosition(yScale, yValue);

    final effectiveLabelStyle = labelStyle ??
        const TextStyle(
          fontSize: 10,
          color: Color(0xFF000000),
        );

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        size: Size(width, height),
        painter: _LabelAnnotationPainter(
          x: xPos,
          y: yPos,
          label: label,
          labelStyle: effectiveLabelStyle,
          config: config,
          anchor: anchor,
          offset: offset,
        ),
      ),
    );
  }

  double _getPosition(dynamic scale, dynamic value) {
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

class _LabelAnnotationPainter extends CustomPainter {
  final double x;
  final double y;
  final String label;
  final TextStyle labelStyle;
  final LabelAnnotationConfig config;
  final LabelAnchor anchor;
  final Offset offset;

  _LabelAnnotationPainter({
    required this.x,
    required this.y,
    required this.label,
    required this.labelStyle,
    required this.config,
    required this.anchor,
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textSpan = TextSpan(text: label, style: labelStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final textWidth = textPainter.width + config.padding.horizontal;
    final textHeight = textPainter.height + config.padding.vertical;

    // Calculate position based on anchor
    double anchorX = x + offset.dx;
    double anchorY = y + offset.dy;

    switch (anchor) {
      case LabelAnchor.center:
        anchorX -= textWidth / 2;
        anchorY -= textHeight / 2;
        break;
      case LabelAnchor.topLeft:
        // Already at top-left
        break;
      case LabelAnchor.topCenter:
        anchorX -= textWidth / 2;
        break;
      case LabelAnchor.topRight:
        anchorX -= textWidth;
        break;
      case LabelAnchor.middleLeft:
        anchorY -= textHeight / 2;
        break;
      case LabelAnchor.middleRight:
        anchorX -= textWidth;
        anchorY -= textHeight / 2;
        break;
      case LabelAnchor.bottomLeft:
        anchorY -= textHeight;
        break;
      case LabelAnchor.bottomCenter:
        anchorX -= textWidth / 2;
        anchorY -= textHeight;
        break;
      case LabelAnchor.bottomRight:
        anchorX -= textWidth;
        anchorY -= textHeight;
        break;
    }

    final rect = Rect.fromLTWH(anchorX, anchorY, textWidth, textHeight);

    // Apply rotation if specified
    if (config.rotation != 0) {
      canvas.save();
      canvas.translate(x + offset.dx, y + offset.dy);
      canvas.rotate(config.rotation * math.pi / 180);
      canvas.translate(-(x + offset.dx), -(y + offset.dy));
    }

    // Draw background if specified
    if (config.backgroundColor != null) {
      final bgPaint = Paint()
        ..color = config.backgroundColor!
            .withAlpha((config.backgroundOpacity * 255).round())
        ..style = PaintingStyle.fill;

      final rrect = RRect.fromRectAndRadius(
        rect,
        Radius.circular(config.borderRadius),
      );
      canvas.drawRRect(rrect, bgPaint);
    }

    // Draw border if enabled
    if (config.showBorder) {
      final borderPaint = Paint()
        ..color = config.borderColor
        ..strokeWidth = config.borderWidth
        ..style = PaintingStyle.stroke;

      final rrect = RRect.fromRectAndRadius(
        rect,
        Radius.circular(config.borderRadius),
      );
      canvas.drawRRect(rrect, borderPaint);
    }

    // Draw text
    textPainter.paint(
      canvas,
      Offset(
        anchorX + config.padding.left,
        anchorY + config.padding.top,
      ),
    );

    if (config.rotation != 0) {
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _LabelAnnotationPainter oldDelegate) {
    return x != oldDelegate.x ||
        y != oldDelegate.y ||
        label != oldDelegate.label ||
        labelStyle != oldDelegate.labelStyle ||
        config.backgroundColor != oldDelegate.config.backgroundColor ||
        config.backgroundOpacity != oldDelegate.config.backgroundOpacity ||
        config.padding != oldDelegate.config.padding ||
        config.borderRadius != oldDelegate.config.borderRadius ||
        config.showBorder != oldDelegate.config.showBorder ||
        config.borderColor != oldDelegate.config.borderColor ||
        config.borderWidth != oldDelegate.config.borderWidth ||
        config.rotation != oldDelegate.config.rotation ||
        anchor != oldDelegate.anchor ||
        offset != oldDelegate.offset;
  }
}

/// Creates a LabelAnnotation widget.
Widget labelAnnotation({
  Key? key,
  required dynamic xScale,
  required dynamic yScale,
  required dynamic xValue,
  required dynamic yValue,
  required String label,
  TextStyle? labelStyle,
  required double width,
  required double height,
  LabelAnnotationConfig config = const LabelAnnotationConfig(),
  LabelAnchor anchor = LabelAnchor.center,
  Offset offset = Offset.zero,
}) {
  return LabelAnnotation(
    key: key,
    xScale: xScale,
    yScale: yScale,
    xValue: xValue,
    yValue: yValue,
    label: label,
    labelStyle: labelStyle,
    width: width,
    height: height,
    config: config,
    anchor: anchor,
    offset: offset,
  );
}

/// A simple label annotation positioned by pixel coordinates.
///
/// Use this when you want to place a label at a specific pixel
/// position rather than at data coordinates.
class PixelLabelAnnotation extends StatelessWidget {
  /// The x pixel position.
  final double x;

  /// The y pixel position.
  final double y;

  /// The label text.
  final String label;

  /// Text style for the label.
  final TextStyle? labelStyle;

  /// The width of the chart area.
  final double width;

  /// The height of the chart area.
  final double height;

  /// Configuration for the label.
  final LabelAnnotationConfig config;

  /// The anchor point for the label.
  final LabelAnchor anchor;

  /// Creates a pixel-positioned label annotation.
  const PixelLabelAnnotation({
    super.key,
    required this.x,
    required this.y,
    required this.label,
    this.labelStyle,
    required this.width,
    required this.height,
    this.config = const LabelAnnotationConfig(),
    this.anchor = LabelAnchor.center,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveLabelStyle = labelStyle ??
        const TextStyle(
          fontSize: 10,
          color: Color(0xFF000000),
        );

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        size: Size(width, height),
        painter: _LabelAnnotationPainter(
          x: x,
          y: y,
          label: label,
          labelStyle: effectiveLabelStyle,
          config: config,
          anchor: anchor,
          offset: Offset.zero,
        ),
      ),
    );
  }
}
