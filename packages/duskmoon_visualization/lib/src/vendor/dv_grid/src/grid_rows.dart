import 'package:flutter/widgets.dart';

import 'grid.dart';

/// Horizontal grid lines (rows) spanning the width of a chart.
///
/// GridRows renders horizontal lines at positions determined by
/// a scale. These are typically used with a y-axis scale to show
/// reference lines for values.
///
/// Example usage:
/// ```dart
/// GridRows(
///   scale: scaleLinear(domain: [0, 100], range: [300, 0]),
///   width: 400,
///   height: 300,
///   tickCount: 5,
/// )
/// ```
class GridRows extends Grid {
  /// Creates horizontal grid rows.
  const GridRows({
    super.key,
    required super.scale,
    super.tickValues,
    super.tickCount,
    super.config,
    required super.width,
    required super.height,
  });

  @override
  Widget build(BuildContext context) {
    final positions = getPositions();

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        size: Size(width, height),
        painter: _GridRowsPainter(
          positions: positions,
          config: config,
          width: width,
        ),
      ),
    );
  }
}

class _GridRowsPainter extends CustomPainter {
  final List<double> positions;
  final GridConfig config;
  final double width;

  _GridRowsPainter({
    required this.positions,
    required this.config,
    required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = config.color
      ..strokeWidth = config.strokeWidth
      ..style = PaintingStyle.stroke;

    for (final y in positions) {
      drawGridLine(
        canvas,
        Offset(0, y),
        Offset(width, y),
        paint,
        config.dashPattern,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GridRowsPainter oldDelegate) {
    return positions != oldDelegate.positions ||
        config.color != oldDelegate.config.color ||
        config.strokeWidth != oldDelegate.config.strokeWidth ||
        config.dashPattern != oldDelegate.config.dashPattern ||
        width != oldDelegate.width;
  }
}

/// Creates a GridRows widget.
Widget gridRows({
  Key? key,
  required dynamic scale,
  List? tickValues,
  int tickCount = 10,
  GridConfig config = const GridConfig(),
  required double width,
  required double height,
}) {
  return GridRows(
    key: key,
    scale: scale,
    tickValues: tickValues,
    tickCount: tickCount,
    config: config,
    width: width,
    height: height,
  );
}
