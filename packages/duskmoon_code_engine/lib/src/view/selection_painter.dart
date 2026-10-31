import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';

import 'cursor_blink.dart';

class SelectionPainter extends CustomPainter {
  SelectionPainter({
    super.repaint,
    required this.selectionRects,
    required this.cursorOffset,
    required this.cursorHeight,
    required this.selectionColor,
    required this.cursorColor,
    required this.cursorWidth,
    this.cursorBlink,
    this.showCursor = true,
  });

  final List<Rect> selectionRects;
  final double? cursorOffset;
  final double cursorHeight;
  final Color selectionColor;
  final Color cursorColor;
  final double cursorWidth;
  final CursorBlink? cursorBlink;
  final bool showCursor;

  @override
  void paint(Canvas canvas, Size size) {
    if (selectionRects.isNotEmpty) {
      final selPaint = Paint()..color = selectionColor;
      for (final rect in selectionRects) {
        canvas.drawRect(rect, selPaint);
      }
    }
    final isCursorVisible =
        showCursor && (cursorBlink == null || cursorBlink!.visible);
    if (isCursorVisible && cursorOffset != null) {
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
      cursorBlink != old.cursorBlink ||
      !listEquals(selectionRects, old.selectionRects) ||
      cursorColor != old.cursorColor ||
      selectionColor != old.selectionColor ||
      cursorWidth != old.cursorWidth ||
      cursorHeight != old.cursorHeight;
}
