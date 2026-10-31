// Hide Flutter's InlineSpan to avoid conflict with our InlineSpan from
// highlight_builder.dart.
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart' hide InlineSpan;

import 'highlight_builder.dart';

class LinePainter extends CustomPainter {
  LinePainter({
    required this.spans,
    required this.lineHeight,
    required this.fontFamily,
    required this.fontSize,
    this.fallbackText = '',
    this.defaultStyle,
    this.backgroundColor,
  });

  final List<InlineSpan> spans;
  final double lineHeight;
  final String fontFamily;
  final double fontSize;
  final String fallbackText;
  final TextStyle? defaultStyle;
  final Color? backgroundColor;

  TextPainter? _textPainter;

  /// Creates (or returns the cached) unified [TextPainter] for this line's
  /// entire text.
  TextPainter createTextPainter() {
    if (_textPainter != null) return _textPainter!;

    final baseStyle = (defaultStyle ?? const TextStyle()).copyWith(
      fontFamily: fontFamily,
      fontSize: fontSize,
      height: lineHeight / fontSize,
    );

    final TextSpan rootSpan;
    if (spans.isEmpty) {
      rootSpan = TextSpan(text: fallbackText, style: baseStyle);
    } else {
      rootSpan = TextSpan(
        style: baseStyle,
        children: [
          for (final span in spans)
            TextSpan(
              text: span.text,
              style: (span.style ?? const TextStyle()).copyWith(
                fontFamily: fontFamily,
                fontSize: fontSize,
                height: lineHeight / fontSize,
              ),
            ),
        ],
      );
    }

    final tp = TextPainter(text: rootSpan, textDirection: TextDirection.ltr)
      ..layout();
    _textPainter = tp;
    return tp;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (backgroundColor != null) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = backgroundColor!,
      );
    }
    if (spans.isNotEmpty || fallbackText.isNotEmpty) {
      final tp = createTextPainter();
      tp.paint(canvas, Offset.zero);
    }
  }

  @override
  bool shouldRepaint(LinePainter old) =>
      !listEquals(spans, old.spans) ||
      fallbackText != old.fallbackText ||
      backgroundColor != old.backgroundColor ||
      fontSize != old.fontSize ||
      fontFamily != old.fontFamily ||
      lineHeight != old.lineHeight ||
      defaultStyle != old.defaultStyle;
}
