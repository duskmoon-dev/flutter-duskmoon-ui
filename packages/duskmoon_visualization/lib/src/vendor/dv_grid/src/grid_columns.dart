import 'package:flutter/widgets.dart';

import 'grid.dart';

/// Vertical grid lines (columns) spanning the height of a chart.
///
/// GridColumns renders vertical lines at positions determined by
/// a scale. These are typically used with an x-axis scale to show
/// reference lines for values.
///
/// Example usage:
/// ```dart
/// GridColumns(
///   scale: scaleLinear(domain: [0, 100], range: [0, 400]),
///   width: 400,
///   height: 300,
///   tickCount: 5,
/// )
/// ```
class GridColumns extends Grid {
  /// Creates vertical grid columns.
  const GridColumns({
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
        painter: _GridColumnsPainter(
          positions: positions,
          config: config,
          height: height,
        ),
      ),
    );
  }
}

class _GridColumnsPainter extends CustomPainter {
  final List<double> positions;
  final GridConfig config;
  final double height;

  _GridColumnsPainter({
    required this.positions,
    required this.config,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = config.color
      ..strokeWidth = config.strokeWidth
      ..style = PaintingStyle.stroke;

    for (final x in positions) {
      drawGridLine(
        canvas,
        Offset(x, 0),
        Offset(x, height),
        paint,
        config.dashPattern,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GridColumnsPainter oldDelegate) {
    return positions != oldDelegate.positions ||
        config.color != oldDelegate.config.color ||
        config.strokeWidth != oldDelegate.config.strokeWidth ||
        config.dashPattern != oldDelegate.config.dashPattern ||
        height != oldDelegate.height;
  }
}

/// Creates a GridColumns widget.
Widget gridColumns({
  Key? key,
  required dynamic scale,
  List? tickValues,
  int tickCount = 10,
  GridConfig config = const GridConfig(),
  required double width,
  required double height,
}) {
  return GridColumns(
    key: key,
    scale: scale,
    tickValues: tickValues,
    tickCount: tickCount,
    config: config,
    width: width,
    height: height,
  );
}
