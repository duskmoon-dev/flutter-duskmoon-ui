import 'package:flutter/widgets.dart';

/// Base class for data point marker glyphs.
abstract class Glyph extends StatelessWidget {
  /// The x coordinate of the glyph center.
  final double x;

  /// The y coordinate of the glyph center.
  final double y;

  /// The size of the glyph.
  final double size;

  /// The fill color.
  final Color color;

  /// Optional stroke color.
  final Color? strokeColor;

  /// The stroke width.
  final double strokeWidth;

  /// Optional rotation angle in radians.
  final double rotation;

  /// Optional opacity (0.0 - 1.0).
  final double opacity;

  /// Creates a glyph.
  const Glyph({
    super.key,
    required this.x,
    required this.y,
    this.size = 8,
    this.color = const Color(0xFF000000),
    this.strokeColor,
    this.strokeWidth = 1.0,
    this.rotation = 0,
    this.opacity = 1.0,
  });

  /// Returns the path for this glyph shape centered at origin.
  Path createPath();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GlyphPainter(
        glyph: this,
      ),
    );
  }
}

class _GlyphPainter extends CustomPainter {
  final Glyph glyph;

  _GlyphPainter({required this.glyph});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    // Translate to position
    canvas.translate(glyph.x, glyph.y);

    // Apply rotation
    if (glyph.rotation != 0) {
      canvas.rotate(glyph.rotation);
    }

    // Get the path
    final path = glyph.createPath();

    // Apply opacity
    final effectiveOpacity = glyph.opacity.clamp(0.0, 1.0);

    // Fill
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = glyph.color.withValues(alpha: glyph.color.a * effectiveOpacity);
    canvas.drawPath(path, fillPaint);

    // Stroke
    if (glyph.strokeColor != null) {
      final strokePaint = Paint()
        ..style = PaintingStyle.stroke
        ..color = glyph.strokeColor!
            .withValues(alpha: glyph.strokeColor!.a * effectiveOpacity)
        ..strokeWidth = glyph.strokeWidth;
      canvas.drawPath(path, strokePaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_GlyphPainter oldDelegate) {
    return glyph.x != oldDelegate.glyph.x ||
        glyph.y != oldDelegate.glyph.y ||
        glyph.size != oldDelegate.glyph.size ||
        glyph.color != oldDelegate.glyph.color;
  }
}

/// Factory function type for creating glyphs.
typedef GlyphFactory = Glyph Function({
  required double x,
  required double y,
  double size,
  Color color,
  Color? strokeColor,
  double strokeWidth,
});
