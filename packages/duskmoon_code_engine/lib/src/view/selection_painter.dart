import 'package:flutter/material.dart';

class SelectionPainter extends CustomPainter {
  SelectionPainter({
    required this.selectionRects,
    required this.cursorOffset,
    required this.cursorHeight,
    required this.selectionColor,
    required this.cursorColor,
    required this.cursorWidth,
    required this.showCursor,
  });

  final List<Rect> selectionRects;
  final double? cursorOffset;
  final double cursorHeight;
  final Color selectionColor;
  final Color cursorColor;
  final double cursorWidth;
  final bool showCursor;

  @override
  void paint(Canvas canvas, Size size) {
    final selPaint = Paint()..color = selectionColor;
    for (final rect in selectionRects) {
      canvas.drawRect(rect, selPaint);
    }
    if (showCursor && cursorOffset != null) {
      canvas.drawRect(
        Rect.fromLTWH(cursorOffset!, 0, cursorWidth, cursorHeight),
        Paint()..color = cursorColor,
      );
    }
  }

  @override
  bool shouldRepaint(SelectionPainter old) =>
      cursorOffset != old.cursorOffset ||
      showCursor != old.showCursor ||
      selectionRects != old.selectionRects;
}
