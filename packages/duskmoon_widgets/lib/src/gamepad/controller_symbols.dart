part of 'dm_controller_view.dart';

enum _Symbol {
  cross,
  circle,
  square,
  triangle,
  up,
  down,
  left,
  right,
  menu,
  view,
  share,
  home,
  capture,
  xbox,
  minus,
  plus,
}

/// Small controls use paths so model-specific glyphs never depend on font fallback.
class _SymbolPainter extends CustomPainter {
  const _SymbolPainter(this.symbol, this.color);
  final _Symbol symbol;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24, size.height / 24);
    final pen = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    void line(double x1, double y1, double x2, double y2) =>
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), pen);
    switch (symbol) {
      case _Symbol.cross:
        line(5, 5, 19, 19);
        line(19, 5, 5, 19);
      case _Symbol.circle:
        canvas.drawCircle(const Offset(12, 12), 8, pen);
      case _Symbol.square:
        canvas.drawRect(const Rect.fromLTWH(5, 5, 14, 14), pen);
      case _Symbol.triangle:
        canvas.drawPath(
          Path()
            ..moveTo(12, 3)
            ..lineTo(22, 20)
            ..lineTo(2, 20)
            ..close(),
          pen,
        );
      case _Symbol.up:
        canvas.drawPath(
          Path()
            ..moveTo(5, 16)
            ..lineTo(12, 9)
            ..lineTo(19, 16),
          pen,
        );
      case _Symbol.down:
        canvas.drawPath(
          Path()
            ..moveTo(5, 8)
            ..lineTo(12, 15)
            ..lineTo(19, 8),
          pen,
        );
      case _Symbol.left:
        canvas.drawPath(
          Path()
            ..moveTo(16, 5)
            ..lineTo(9, 12)
            ..lineTo(16, 19),
          pen,
        );
      case _Symbol.right:
        canvas.drawPath(
          Path()
            ..moveTo(8, 5)
            ..lineTo(15, 12)
            ..lineTo(8, 19),
          pen,
        );
      case _Symbol.menu:
        line(4, 6, 20, 6);
        line(4, 12, 20, 12);
        line(4, 18, 20, 18);
      case _Symbol.view:
        canvas.drawRect(const Rect.fromLTWH(4, 4, 11, 10), pen);
        canvas.drawRect(const Rect.fromLTWH(9, 10, 11, 10), pen);
      case _Symbol.share:
        canvas.drawPath(
          Path()
            ..moveTo(4, 14)
            ..lineTo(4, 21)
            ..lineTo(20, 21)
            ..lineTo(20, 14),
          pen,
        );
        line(12, 16, 12, 3);
        canvas.drawPath(
          Path()
            ..moveTo(7, 8)
            ..lineTo(12, 3)
            ..lineTo(17, 8),
          pen,
        );
      case _Symbol.home:
        canvas.drawPath(
          Path()
            ..moveTo(3, 11)
            ..lineTo(12, 3)
            ..lineTo(21, 11)
            ..moveTo(6, 9)
            ..lineTo(6, 21)
            ..lineTo(18, 21)
            ..lineTo(18, 9),
          pen,
        );
        canvas.drawRect(const Rect.fromLTWH(10, 14, 4, 7), pen);
      case _Symbol.capture:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(3, 3, 18, 18),
            const Radius.circular(3),
          ),
          pen,
        );
        canvas.drawCircle(const Offset(12, 12), 4, pen);
      case _Symbol.xbox:
        canvas.drawCircle(const Offset(12, 12), 10, Paint()..color = color);
        canvas.drawPath(
          Path()
            ..moveTo(5, 5)
            ..quadraticBezierTo(12, 8, 19, 19)
            ..moveTo(19, 5)
            ..quadraticBezierTo(12, 8, 5, 19),
          Paint()
            ..color = const Color(0xff30353b)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.7
            ..strokeCap = StrokeCap.round,
        );
      case _Symbol.minus:
        line(5, 12, 19, 12);
      case _Symbol.plus:
        line(5, 12, 19, 12);
        line(12, 5, 12, 19);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SymbolPainter oldDelegate) =>
      oldDelegate.symbol != symbol || oldDelegate.color != color;
}
