// Hide Flutter's InlineSpan to avoid conflict with our InlineSpan from
// highlight_builder.dart.
import 'package:flutter/material.dart' hide InlineSpan;

import 'highlight_builder.dart';

class LinePainter extends CustomPainter {
  LinePainter({
    required this.spans,
    required this.lineHeight,
    required this.fontFamily,
    required this.fontSize,
    this.backgroundColor,
  });

  final List<InlineSpan> spans;
  final double lineHeight;
  final String fontFamily;
  final double fontSize;
  final Color? backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (backgroundColor != null) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = backgroundColor!,
      );
    }
    var x = 0.0;
    for (final span in spans) {
      final tp = TextPainter(
        text: TextSpan(
          text: span.text,
          style: (span.style ?? const TextStyle()).copyWith(
            fontFamily: fontFamily,
            fontSize: fontSize,
            height: lineHeight / fontSize,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x, 0));
      x += tp.width;
    }
  }

  @override
  bool shouldRepaint(LinePainter old) =>
      spans != old.spans || backgroundColor != old.backgroundColor;
}
