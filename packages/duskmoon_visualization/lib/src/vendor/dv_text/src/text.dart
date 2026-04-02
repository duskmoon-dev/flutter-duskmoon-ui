import 'package:flutter/widgets.dart';

/// A text widget optimized for chart labels and annotations.
class ChartText extends StatelessWidget {
  /// The text to display.
  final String text;

  /// The x position.
  final double x;

  /// The y position.
  final double y;

  /// The text style.
  final TextStyle? style;

  /// Horizontal anchor point.
  final TextAnchor anchor;

  /// Vertical alignment.
  final TextBaseline baseline;

  /// Rotation angle in radians.
  final double rotation;

  /// Optional max width for wrapping.
  final double? maxWidth;

  /// Creates a chart text widget.
  const ChartText({
    super.key,
    required this.text,
    this.x = 0,
    this.y = 0,
    this.style,
    this.anchor = TextAnchor.start,
    this.baseline = TextBaseline.alphabetic,
    this.rotation = 0,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ChartTextPainter(
        text: text,
        x: x,
        y: y,
        style: style ?? const TextStyle(color: Color(0xFF000000), fontSize: 12),
        anchor: anchor,
        baseline: baseline,
        rotation: rotation,
        maxWidth: maxWidth,
      ),
    );
  }
}

/// Text anchor point options.
enum TextAnchor {
  /// Align text start to position.
  start,

  /// Center text on position.
  middle,

  /// Align text end to position.
  end,
}

class _ChartTextPainter extends CustomPainter {
  final String text;
  final double x;
  final double y;
  final TextStyle style;
  final TextAnchor anchor;
  final TextBaseline baseline;
  final double rotation;
  final double? maxWidth;

  _ChartTextPainter({
    required this.text,
    required this.x,
    required this.y,
    required this.style,
    required this.anchor,
    required this.baseline,
    required this.rotation,
    this.maxWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: maxWidth != null ? null : 1,
    );

    textPainter.layout(maxWidth: maxWidth ?? double.infinity);

    // Calculate offset based on anchor
    double offsetX = 0;
    switch (anchor) {
      case TextAnchor.start:
        offsetX = 0;
        break;
      case TextAnchor.middle:
        offsetX = -textPainter.width / 2;
        break;
      case TextAnchor.end:
        offsetX = -textPainter.width;
        break;
    }

    // Calculate vertical offset based on baseline
    double offsetY = 0;
    switch (baseline) {
      case TextBaseline.alphabetic:
        offsetY = -textPainter.height * 0.8;
        break;
      case TextBaseline.ideographic:
        offsetY = -textPainter.height;
        break;
    }

    canvas.save();
    canvas.translate(x, y);

    if (rotation != 0) {
      canvas.rotate(rotation);
    }

    textPainter.paint(canvas, Offset(offsetX, offsetY));

    canvas.restore();
  }

  @override
  bool shouldRepaint(_ChartTextPainter oldDelegate) {
    return text != oldDelegate.text ||
        x != oldDelegate.x ||
        y != oldDelegate.y ||
        style != oldDelegate.style ||
        anchor != oldDelegate.anchor ||
        rotation != oldDelegate.rotation;
  }
}

/// Widget for rendering multiple text labels efficiently.
class ChartTextLabels extends StatelessWidget {
  /// The labels to render.
  final List<TextLabel> labels;

  /// Default text style for all labels.
  final TextStyle? defaultStyle;

  /// Creates a chart text labels widget.
  const ChartTextLabels({
    super.key,
    required this.labels,
    this.defaultStyle,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ChartTextLabelsPainter(
        labels: labels,
        defaultStyle: defaultStyle ??
            const TextStyle(color: Color(0xFF000000), fontSize: 12),
      ),
    );
  }
}

/// A single text label definition.
class TextLabel {
  /// The text content.
  final String text;

  /// The x position.
  final double x;

  /// The y position.
  final double y;

  /// Optional text style override.
  final TextStyle? style;

  /// Horizontal anchor point.
  final TextAnchor anchor;

  /// Rotation angle in radians.
  final double rotation;

  /// Creates a text label.
  const TextLabel({
    required this.text,
    required this.x,
    required this.y,
    this.style,
    this.anchor = TextAnchor.start,
    this.rotation = 0,
  });
}

class _ChartTextLabelsPainter extends CustomPainter {
  final List<TextLabel> labels;
  final TextStyle defaultStyle;

  _ChartTextLabelsPainter({
    required this.labels,
    required this.defaultStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final label in labels) {
      final style = label.style ?? defaultStyle;
      final textSpan = TextSpan(text: label.text, style: style);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        maxLines: 1,
      );

      textPainter.layout();

      double offsetX = 0;
      switch (label.anchor) {
        case TextAnchor.start:
          offsetX = 0;
          break;
        case TextAnchor.middle:
          offsetX = -textPainter.width / 2;
          break;
        case TextAnchor.end:
          offsetX = -textPainter.width;
          break;
      }

      canvas.save();
      canvas.translate(label.x, label.y);

      if (label.rotation != 0) {
        canvas.rotate(label.rotation);
      }

      textPainter.paint(canvas, Offset(offsetX, -textPainter.height * 0.8));

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ChartTextLabelsPainter oldDelegate) {
    return labels != oldDelegate.labels ||
        defaultStyle != oldDelegate.defaultStyle;
  }
}
