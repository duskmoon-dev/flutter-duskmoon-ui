part of 'dm_controller_view.dart';

/// Device finishes intentionally stay independent of the surrounding app theme.
class _ControllerShellPainter extends CustomPainter {
  const _ControllerShellPainter(this.style);
  final DmControllerStyle style;

  Path _body() => switch (style) {
        DmControllerStyle.xbox => Path()
          ..moveTo(128, 91)
          ..cubicTo(166, 74, 207, 87, 246, 91)
          ..quadraticBezierTo(300, 98, 354, 91)
          ..cubicTo(393, 87, 434, 74, 472, 91)
          ..cubicTo(515, 111, 538, 150, 551, 194)
          ..cubicTo(564, 237, 583, 304, 566, 334)
          ..cubicTo(553, 358, 531, 358, 509, 339)
          ..cubicTo(483, 316, 464, 300, 443, 300)
          ..cubicTo(407, 300, 371, 309, 344, 312)
          ..quadraticBezierTo(300, 323, 256, 312)
          ..cubicTo(229, 309, 193, 300, 157, 300)
          ..cubicTo(136, 300, 117, 316, 91, 339)
          ..cubicTo(69, 358, 47, 358, 34, 334)
          ..cubicTo(17, 304, 36, 237, 49, 194)
          ..cubicTo(62, 150, 85, 111, 128, 91)
          ..close(),
        DmControllerStyle.dualSense => Path()
          ..moveTo(130, 89)
          ..cubicTo(168, 73, 209, 87, 251, 91)
          ..quadraticBezierTo(300, 95, 349, 91)
          ..cubicTo(391, 87, 432, 73, 470, 89)
          ..cubicTo(506, 104, 529, 141, 542, 184)
          ..cubicTo(555, 226, 574, 305, 561, 339)
          ..cubicTo(552, 363, 529, 369, 511, 347)
          ..cubicTo(489, 320, 467, 282, 441, 274)
          ..cubicTo(414, 267, 385, 270, 358, 282)
          ..quadraticBezierTo(300, 309, 242, 282)
          ..cubicTo(215, 270, 186, 267, 159, 274)
          ..cubicTo(133, 282, 111, 320, 89, 347)
          ..cubicTo(71, 369, 48, 363, 39, 339)
          ..cubicTo(26, 305, 45, 226, 58, 184)
          ..cubicTo(71, 141, 94, 104, 130, 89)
          ..close(),
        DmControllerStyle.switchPro => Path()
          ..moveTo(132, 90)
          ..cubicTo(163, 75, 201, 86, 239, 92)
          ..quadraticBezierTo(300, 103, 361, 92)
          ..cubicTo(399, 86, 437, 75, 468, 90)
          ..cubicTo(507, 110, 527, 150, 540, 191)
          ..cubicTo(553, 233, 572, 301, 559, 334)
          ..cubicTo(549, 358, 522, 359, 501, 336)
          ..cubicTo(478, 319, 466, 300, 439, 300)
          ..cubicTo(403, 300, 366, 306, 340, 309)
          ..quadraticBezierTo(300, 318, 260, 309)
          ..cubicTo(234, 306, 197, 300, 161, 300)
          ..cubicTo(134, 300, 122, 319, 99, 336)
          ..cubicTo(78, 359, 51, 358, 41, 334)
          ..cubicTo(28, 301, 47, 233, 60, 191)
          ..cubicTo(73, 150, 93, 110, 132, 90)
          ..close(),
      };

  @override
  void paint(Canvas canvas, Size size) {
    final body = _body();
    final isPs = style == DmControllerStyle.dualSense;
    final isSwitch = style == DmControllerStyle.switchPro;
    const bounds = Rect.fromLTWH(25, 80, 550, 280);
    canvas.drawShadow(body, const Color(0x65000000), 7, false);
    canvas.drawPath(
      body,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isPs
              ? const [Color(0xfff5f6f8), Color(0xffd9dde4), Color(0xffbfc5ce)]
              : isSwitch
                  ? const [
                      Color(0xff42494f),
                      Color(0xff30363b),
                      Color(0xff252b30)
                    ]
                  : const [
                      Color(0xff484d54),
                      Color(0xff30353b),
                      Color(0xff22262b)
                    ],
          stops: const [0, .6, 1],
        ).createShader(bounds),
    );
    canvas.save();
    canvas.clipPath(body);

    if (isPs) {
      final core = Path()
        ..moveTo(213, 94)
        ..quadraticBezierTo(300, 109, 387, 94)
        ..cubicTo(381, 142, 407, 168, 425, 197)
        ..cubicTo(444, 229, 430, 251, 395, 268)
        ..quadraticBezierTo(347, 300, 300, 302)
        ..quadraticBezierTo(253, 300, 205, 268)
        ..cubicTo(170, 251, 156, 229, 175, 197)
        ..cubicTo(193, 168, 219, 142, 213, 94)
        ..close();
      canvas.drawPath(
        core,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff242b35), Color(0xff11171e)],
          ).createShader(bounds),
      );
      final light = Paint()
        ..color = const Color(0xff759ce1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawPath(
        Path()
          ..moveTo(210, 99)
          ..cubicTo(218, 142, 195, 174, 180, 198),
        light,
      );
      canvas.drawPath(
        Path()
          ..moveTo(390, 99)
          ..cubicTo(382, 142, 405, 174, 420, 198),
        light,
      );
      final seam = Paint()
        ..color = const Color(0x40717988)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawPath(
        Path()
          ..moveTo(107, 210)
          ..cubicTo(98, 260, 74, 290, 65, 339),
        seam,
      );
      canvas.drawPath(
        Path()
          ..moveTo(493, 210)
          ..cubicTo(502, 260, 526, 290, 535, 339),
        seam,
      );
    } else {
      // Moulded grip sections and fine texture follow each handle's contour.
      final grip = Path()
        ..moveTo(76, 207)
        ..cubicTo(98, 216, 129, 239, 159, 273)
        ..cubicTo(127, 302, 112, 337, 81, 352)
        ..lineTo(28, 349)
        ..lineTo(29, 241)
        ..close();
      canvas.drawPath(
        grip,
        Paint()
          ..color =
              isSwitch ? const Color(0xff2b3136) : const Color(0xff2c3238),
      );
      canvas.save();
      canvas.translate(600, 0);
      canvas.scale(-1, 1);
      canvas.drawPath(
        grip,
        Paint()
          ..color =
              isSwitch ? const Color(0xff2b3136) : const Color(0xff2c3238),
      );
      canvas.restore();
      final seam = Paint()
        ..color = const Color(0x405e6670)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawPath(
        Path()
          ..moveTo(76, 207)
          ..cubicTo(98, 216, 129, 239, 159, 273),
        seam,
      );
      canvas.drawPath(
        Path()
          ..moveTo(524, 207)
          ..cubicTo(502, 216, 471, 239, 441, 273),
        seam,
      );
      final grain = Paint()..color = const Color(0x155e6670);
      for (var y = 241.0; y < 349; y += 6) {
        for (var x = 39.0; x < 120; x += 6) {
          canvas.drawCircle(Offset(x + (y % 12 == 1 ? 3 : 0), y), .65, grain);
          canvas.drawCircle(Offset(600 - x, y), .65, grain);
        }
      }
      if (isSwitch) {
        final seamTop = Path()
          ..moveTo(197, 103)
          ..quadraticBezierTo(300, 127, 403, 103);
        canvas.drawPath(
          seamTop,
          Paint()
            ..color = const Color(0x405e6973)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
        // Small player indicators, as on the front edge of the Pro controller.
        for (var i = 0; i < 4; i++) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(283 + i * 10, 280, 5, 3),
              const Radius.circular(1),
            ),
            Paint()
              ..color =
                  i == 0 ? const Color(0xff8aac73) : const Color(0xff555d62),
          );
        }
      }
    }

    final (left, right, face) = switch (style) {
      DmControllerStyle.xbox => (
          const Offset(160, 164),
          const Offset(387, 245),
          const Offset(447, 163),
        ),
      DmControllerStyle.dualSense => (
          const Offset(235, 235),
          const Offset(365, 235),
          const Offset(447, 171),
        ),
      DmControllerStyle.switchPro => (
          const Offset(160, 162),
          const Offset(388, 244),
          const Offset(447, 161),
        ),
    };
    for (final center in [left, right]) {
      final ring = Rect.fromCircle(center: center, radius: 44);
      canvas.drawCircle(
        center,
        44,
        Paint()
          ..shader = RadialGradient(
            colors: isPs
                ? const [Color(0xff0a1017), Color(0xff343b45)]
                : const [Color(0xff1c2026), Color(0xff444b52)],
            stops: const [.75, 1],
          ).createShader(ring),
      );
      canvas.drawCircle(
        center,
        44,
        Paint()
          ..color = const Color(0x505f6873)
          ..style = PaintingStyle.stroke
          ..strokeWidth = .8,
      );
    }
    canvas.drawCircle(
      face,
      61,
      Paint()
        ..shader = RadialGradient(
          colors: isPs
              ? const [Color(0x007b8795), Color(0x107b8795)]
              : const [Color(0x2020252a), Color(0x004b535c)],
        ).createShader(Rect.fromCircle(center: face, radius: 61)),
    );
    canvas.restore();
    canvas.drawPath(
      body,
      Paint()
        ..color = isPs ? const Color(0xffa4acb7) : const Color(0xff525b64)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3,
    );
  }

  @override
  bool shouldRepaint(_ControllerShellPainter oldDelegate) =>
      oldDelegate.style != style;
}

class _DpadPainter extends CustomPainter {
  const _DpadPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(34, 3)
      ..lineTo(56, 3)
      ..quadraticBezierTo(60, 3, 60, 7)
      ..lineTo(60, 30)
      ..lineTo(83, 30)
      ..quadraticBezierTo(87, 30, 87, 34)
      ..lineTo(87, 56)
      ..quadraticBezierTo(87, 60, 83, 60)
      ..lineTo(60, 60)
      ..lineTo(60, 83)
      ..quadraticBezierTo(60, 87, 56, 87)
      ..lineTo(34, 87)
      ..quadraticBezierTo(30, 87, 30, 83)
      ..lineTo(30, 60)
      ..lineTo(7, 60)
      ..quadraticBezierTo(3, 60, 3, 56)
      ..lineTo(3, 34)
      ..quadraticBezierTo(3, 30, 7, 30)
      ..lineTo(30, 30)
      ..lineTo(30, 7)
      ..quadraticBezierTo(30, 3, 34, 3)
      ..close();
    canvas.drawShadow(path, const Color(0x90000000), 3, false);
    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff383e45), Color(0xff1c2026)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xff575e67)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    canvas.drawCircle(
      const Offset(45, 45),
      7,
      Paint()..color = const Color(0xff2c3238),
    );
  }

  @override
  bool shouldRepaint(_DpadPainter oldDelegate) => false;
}

class _TouchpadPainter extends CustomPainter {
  const _TouchpadPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0x40717c8d);
    for (var y = 6.0; y < size.height - 5; y += 5) {
      for (var x = 8.0; x < size.width - 7; x += 5) {
        canvas.drawCircle(Offset(x, y), .45, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_TouchpadPainter oldDelegate) => false;
}
