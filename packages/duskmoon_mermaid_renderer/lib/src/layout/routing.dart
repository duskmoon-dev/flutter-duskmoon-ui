import 'package:flutter/material.dart';

List<Offset> routeEdge(Rect from, Rect to) {
  final start = _intersection(from, to.center);
  final end = _intersection(to, from.center);

  if ((start.dx - end.dx).abs() > (start.dy - end.dy).abs()) {
    final midX = (start.dx + end.dx) / 2;
    return <Offset>[start, Offset(midX, start.dy), Offset(midX, end.dy), end];
  }

  final midY = (start.dy + end.dy) / 2;
  return <Offset>[start, Offset(start.dx, midY), Offset(end.dx, midY), end];
}

Offset _intersection(Rect rect, Offset toward) {
  final center = rect.center;
  final dx = toward.dx - center.dx;
  final dy = toward.dy - center.dy;
  if (dx == 0 && dy == 0) return center;

  final scaleX = dx == 0 ? double.infinity : (rect.width / 2) / dx.abs();
  final scaleY = dy == 0 ? double.infinity : (rect.height / 2) / dy.abs();
  final scale = scaleX < scaleY ? scaleX : scaleY;
  return Offset(center.dx + dx * scale, center.dy + dy * scale);
}
