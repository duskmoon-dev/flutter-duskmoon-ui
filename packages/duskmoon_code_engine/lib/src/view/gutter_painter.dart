import 'package:flutter/material.dart';

class GutterPainter extends CustomPainter {
  GutterPainter({
    required this.firstLine,
    required this.lineCount,
    required this.lineHeight,
    required this.activeLine,
    required this.foreground,
    required this.activeForeground,
    required this.background,
    required this.fontFamily,
    required this.fontSize,
    required this.gutterWidth,
  });

  final int firstLine;
  final int lineCount;
  final double lineHeight;
  final int activeLine;
  final Color foreground;
  final Color activeForeground;
  final Color background;
  final String fontFamily;
  final double fontSize;
  final double gutterWidth;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, gutterWidth, size.height),
      Paint()..color = background,
    );
    for (var i = 0; i < lineCount; i++) {
      final lineNum = firstLine + i + 1;
      final isActive = lineNum == activeLine;
      final tp = TextPainter(
        text: TextSpan(
          text: '$lineNum',
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: fontSize,
            color: isActive ? activeForeground : foreground,
            height: lineHeight / fontSize,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
      )..layout(maxWidth: gutterWidth - 8);
      tp.paint(canvas, Offset(gutterWidth - 8 - tp.width, i * lineHeight));
    }
  }

  @override
  bool shouldRepaint(GutterPainter old) =>
      firstLine != old.firstLine ||
      lineCount != old.lineCount ||
      activeLine != old.activeLine;
}
