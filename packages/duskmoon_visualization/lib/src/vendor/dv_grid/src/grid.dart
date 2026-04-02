import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Configuration for grid lines.
class GridConfig {
  /// The stroke width of grid lines.
  final double strokeWidth;

  /// The color of grid lines.
  final Color color;

  /// The dash pattern for grid lines.
  /// If null, solid lines are drawn.
  /// Example: [5, 3] means 5 pixels on, 3 pixels off.
  final List<double>? dashPattern;

  /// Creates a grid configuration.
  const GridConfig({
    this.strokeWidth = 1,
    this.color = const Color(0xFFE0E0E0),
    this.dashPattern,
  });

  /// Creates a copy with modified values.
  GridConfig copyWith({
    double? strokeWidth,
    Color? color,
    List<double>? dashPattern,
  }) {
    return GridConfig(
      strokeWidth: strokeWidth ?? this.strokeWidth,
      color: color ?? this.color,
      dashPattern: dashPattern ?? this.dashPattern,
    );
  }
}

/// Base class for grid components.
///
/// Grids render lines across a chart area to help readers
/// compare values visually. They work with scales from the
/// dv_scale package to determine line positions.
abstract class Grid extends StatelessWidget {
  /// The scale used to determine grid line positions.
  final dynamic scale;

  /// Custom tick values for grid lines.
  final List? tickValues;

  /// The number of grid lines to generate (if tickValues is not provided).
  final int tickCount;

  /// Configuration for grid lines.
  final GridConfig config;

  /// The width of the grid area.
  final double width;

  /// The height of the grid area.
  final double height;

  /// Creates a grid.
  const Grid({
    super.key,
    required this.scale,
    this.tickValues,
    this.tickCount = 10,
    this.config = const GridConfig(),
    required this.width,
    required this.height,
  });

  /// Returns the positions for grid lines.
  List<double> getPositions() {
    final values = tickValues ?? _getTicksFromScale();
    return values.map((value) => _getPosition(value)).toList();
  }

  List _getTicksFromScale() {
    try {
      final ticks = scale.ticks(tickCount);
      return List.from(ticks);
    } catch (_) {
      try {
        return List.from(scale.domain);
      } catch (_) {
        return [];
      }
    }
  }

  double _getPosition(dynamic value) {
    try {
      final result = scale(value);
      if (result is double) return result;
      if (result is num) return result.toDouble();
      return 0;
    } catch (_) {
      return 0;
    }
  }
}

/// A CustomPainter that draws dashed lines.
class DashedLinePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final Paint linePaint;
  final List<double> dashPattern;

  DashedLinePainter({
    required this.start,
    required this.end,
    required this.linePaint,
    required this.dashPattern,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    final unitDx = dx / distance;
    final unitDy = dy / distance;

    var current = 0.0;
    var dashIndex = 0;
    var isDrawing = true;

    while (current < distance) {
      final dashLength = dashPattern[dashIndex % dashPattern.length];
      final nextCurrent = (current + dashLength).clamp(0.0, distance);

      if (isDrawing) {
        canvas.drawLine(
          Offset(start.dx + unitDx * current, start.dy + unitDy * current),
          Offset(
              start.dx + unitDx * nextCurrent, start.dy + unitDy * nextCurrent),
          linePaint,
        );
      }

      current = nextCurrent;
      dashIndex++;
      isDrawing = !isDrawing;
    }
  }

  @override
  bool shouldRepaint(covariant DashedLinePainter oldDelegate) {
    return start != oldDelegate.start ||
        end != oldDelegate.end ||
        linePaint.color != oldDelegate.linePaint.color ||
        linePaint.strokeWidth != oldDelegate.linePaint.strokeWidth ||
        dashPattern != oldDelegate.dashPattern;
  }
}

/// Helper to draw a line (solid or dashed) on a canvas.
void drawGridLine(
  Canvas canvas,
  Offset start,
  Offset end,
  Paint paint,
  List<double>? dashPattern,
) {
  if (dashPattern == null || dashPattern.isEmpty) {
    canvas.drawLine(start, end, paint);
  } else {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final distance = math.sqrt(dx * dx + dy * dy);

    if (distance == 0) return;

    final unitDx = dx / distance;
    final unitDy = dy / distance;

    var current = 0.0;
    var dashIndex = 0;
    var isDrawing = true;

    while (current < distance) {
      final dashLength = dashPattern[dashIndex % dashPattern.length];
      final nextCurrent = (current + dashLength).clamp(0.0, distance);

      if (isDrawing) {
        canvas.drawLine(
          Offset(start.dx + unitDx * current, start.dy + unitDy * current),
          Offset(
              start.dx + unitDx * nextCurrent, start.dy + unitDy * nextCurrent),
          paint,
        );
      }

      current = nextCurrent;
      dashIndex++;
      isDrawing = !isDrawing;
    }
  }
}
