import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../ir/style.dart';
import '../scene/scene_node.dart';

class ShapePainter {
  const ShapePainter();

  void paint(Canvas canvas, SceneNode node) {
    final fill = Paint()
      ..color = node.fillColor
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = node.strokeColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    switch (node.shape) {
      case NodeShape.rectangle:
      case NodeShape.text:
      case NodeShape.asymmetric:
        canvas.drawRect(node.bounds, fill);
        canvas.drawRect(node.bounds, stroke);
      case NodeShape.roundRect:
        final rrect = RRect.fromRectAndRadius(
          node.bounds,
          const Radius.circular(8),
        );
        canvas.drawRRect(rrect, fill);
        canvas.drawRRect(rrect, stroke);
      case NodeShape.stadium:
        final rrect = RRect.fromRectAndRadius(
          node.bounds,
          Radius.circular(node.bounds.height / 2),
        );
        canvas.drawRRect(rrect, fill);
        canvas.drawRRect(rrect, stroke);
      case NodeShape.subroutine:
        canvas.drawRect(node.bounds, fill);
        canvas.drawRect(node.bounds, stroke);
        final left = node.bounds.left + 10;
        final right = node.bounds.right - 10;
        canvas.drawLine(
          Offset(left, node.bounds.top),
          Offset(left, node.bounds.bottom),
          stroke,
        );
        canvas.drawLine(
          Offset(right, node.bounds.top),
          Offset(right, node.bounds.bottom),
          stroke,
        );
      case NodeShape.cylinder:
        final path = Path()
          ..moveTo(node.bounds.left, node.bounds.top + 10)
          ..quadraticBezierTo(
            node.bounds.center.dx,
            node.bounds.top - 4,
            node.bounds.right,
            node.bounds.top + 10,
          )
          ..lineTo(node.bounds.right, node.bounds.bottom - 10)
          ..quadraticBezierTo(
            node.bounds.center.dx,
            node.bounds.bottom + 4,
            node.bounds.left,
            node.bounds.bottom - 10,
          )
          ..close();
        canvas.drawPath(path, fill);
        canvas.drawPath(path, stroke);
        canvas.drawArc(
          Rect.fromLTWH(
            node.bounds.left,
            node.bounds.top,
            node.bounds.width,
            20,
          ),
          0,
          math.pi,
          false,
          stroke,
        );
      case NodeShape.circle:
        canvas.drawOval(node.bounds, fill);
        canvas.drawOval(node.bounds, stroke);
      case NodeShape.doubleCircle:
        canvas.drawOval(node.bounds, fill);
        canvas.drawOval(node.bounds, stroke);
        canvas.drawOval(node.bounds.deflate(5), stroke);
      case NodeShape.diamond:
        _paintPath(canvas, _diamond(node.bounds), fill, stroke);
      case NodeShape.hexagon:
        _paintPath(canvas, _hexagon(node.bounds), fill, stroke);
      case NodeShape.parallelogram:
      case NodeShape.parallelogramAlt:
        _paintPath(canvas, _parallelogram(node.bounds), fill, stroke);
      case NodeShape.trapezoid:
      case NodeShape.trapezoidAlt:
        _paintPath(canvas, _trapezoid(node.bounds), fill, stroke);
    }
  }

  void _paintPath(Canvas canvas, Path path, Paint fill, Paint stroke) {
    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
  }

  Path _diamond(Rect rect) {
    return Path()
      ..moveTo(rect.center.dx, rect.top)
      ..lineTo(rect.right, rect.center.dy)
      ..lineTo(rect.center.dx, rect.bottom)
      ..lineTo(rect.left, rect.center.dy)
      ..close();
  }

  Path _hexagon(Rect rect) {
    final inset = rect.width * 0.18;
    return Path()
      ..moveTo(rect.left + inset, rect.top)
      ..lineTo(rect.right - inset, rect.top)
      ..lineTo(rect.right, rect.center.dy)
      ..lineTo(rect.right - inset, rect.bottom)
      ..lineTo(rect.left + inset, rect.bottom)
      ..lineTo(rect.left, rect.center.dy)
      ..close();
  }

  Path _parallelogram(Rect rect) {
    final inset = rect.width * 0.14;
    return Path()
      ..moveTo(rect.left + inset, rect.top)
      ..lineTo(rect.right, rect.top)
      ..lineTo(rect.right - inset, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..close();
  }

  Path _trapezoid(Rect rect) {
    final inset = rect.width * 0.16;
    return Path()
      ..moveTo(rect.left + inset, rect.top)
      ..lineTo(rect.right - inset, rect.top)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..close();
  }
}
