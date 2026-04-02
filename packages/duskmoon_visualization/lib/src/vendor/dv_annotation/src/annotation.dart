import 'dart:math' as math;
import 'package:flutter/widgets.dart';

/// The orientation of an annotation.
enum AnnotationOrientation {
  /// Horizontal annotation (spans width).
  horizontal,

  /// Vertical annotation (spans height).
  vertical,
}

/// Base configuration for annotations.
class AnnotationConfig {
  /// The color of the annotation.
  final Color color;

  /// The stroke width for line annotations.
  final double strokeWidth;

  /// The dash pattern for line annotations.
  /// If null, solid lines are drawn.
  final List<double>? dashPattern;

  /// Creates an annotation configuration.
  const AnnotationConfig({
    this.color = const Color(0xFF666666),
    this.strokeWidth = 1,
    this.dashPattern,
  });

  /// Creates a copy with modified values.
  AnnotationConfig copyWith({
    Color? color,
    double? strokeWidth,
    List<double>? dashPattern,
  }) {
    return AnnotationConfig(
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      dashPattern: dashPattern ?? this.dashPattern,
    );
  }
}

/// Base class for chart annotations.
///
/// Annotations are visual overlays that highlight specific values,
/// ranges, or add reference information to a chart. They work with
/// scales to position themselves based on data values.
abstract class Annotation extends StatelessWidget {
  /// The scale used to position the annotation.
  final dynamic scale;

  /// The width of the chart area.
  final double width;

  /// The height of the chart area.
  final double height;

  /// Creates an annotation.
  const Annotation({
    super.key,
    required this.scale,
    required this.width,
    required this.height,
  });

  /// Converts a data value to a pixel position using the scale.
  double getPosition(dynamic value) {
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

/// Helper to draw a dashed line on a canvas.
void drawAnnotationLine(
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
