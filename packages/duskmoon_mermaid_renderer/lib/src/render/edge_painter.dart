import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../ir/style.dart';
import '../scene/scene_edge.dart';

class EdgePainter {
  const EdgePainter();

  void paint(Canvas canvas, SceneEdge edge) {
    if (edge.points.length < 2) return;

    final paint = Paint()
      ..color = edge.color
      ..strokeWidth = edge.style == EdgeStyle.thick ? 3 : 1.6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    if (edge.style == EdgeStyle.dotted) {
      _drawDotted(canvas, edge.points, paint);
    } else {
      final path = _pathFromPoints(edge.points);
      canvas.drawPath(path, paint);
    }

    final fill = Paint()
      ..color = edge.color
      ..style = PaintingStyle.fill;
    if (edge.arrowEnd) {
      _drawArrowhead(
          canvas, edge.points[edge.points.length - 2], edge.points.last, fill);
    }
    if (edge.arrowStart) {
      _drawArrowhead(canvas, edge.points[1], edge.points.first, fill);
    }
  }

  Path _pathFromPoints(List<Offset> points) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    return path;
  }

  void _drawDotted(Canvas canvas, List<Offset> points, Paint paint) {
    const dashLength = 5.0;
    const gapLength = 5.0;
    for (var i = 0; i < points.length - 1; i++) {
      final start = points[i];
      final end = points[i + 1];
      final vector = end - start;
      final distance = vector.distance;
      if (distance == 0) continue;
      final direction = vector / distance;
      var cursor = 0.0;
      while (cursor < distance) {
        final dashEnd = math.min(cursor + dashLength, distance);
        canvas.drawLine(
          start + direction * cursor,
          start + direction * dashEnd,
          paint,
        );
        cursor += dashLength + gapLength;
      }
    }
  }

  void _drawArrowhead(Canvas canvas, Offset from, Offset tip, Paint paint) {
    final vector = tip - from;
    if (vector.distance == 0) return;
    final angle = math.atan2(vector.dy, vector.dx);
    const size = 8.0;
    final left = tip -
        Offset(
          math.cos(angle - math.pi / 6) * size,
          math.sin(angle - math.pi / 6) * size,
        );
    final right = tip -
        Offset(
          math.cos(angle + math.pi / 6) * size,
          math.sin(angle + math.pi / 6) * size,
        );
    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(left.dx, left.dy)
      ..lineTo(right.dx, right.dy)
      ..close();
    canvas.drawPath(path, paint);
  }
}
