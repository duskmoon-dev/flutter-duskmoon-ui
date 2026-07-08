import 'package:flutter/material.dart';

Rect? edgeLabelBounds({
  required List<Offset> points,
  required Size labelSize,
}) {
  if (points.isEmpty || labelSize.isEmpty) return null;
  final midpoint = points[points.length ~/ 2];
  return Rect.fromCenter(
    center: midpoint,
    width: labelSize.width + 12,
    height: labelSize.height + 8,
  );
}
