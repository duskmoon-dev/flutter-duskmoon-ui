import 'package:flutter/material.dart';

import '../ir/style.dart';
import 'scene_label.dart';

class SceneEdge {
  const SceneEdge({
    required this.points,
    required this.style,
    required this.color,
    required this.arrowStart,
    required this.arrowEnd,
    this.label,
  });

  final List<Offset> points;
  final EdgeStyle style;
  final Color color;
  final bool arrowStart;
  final bool arrowEnd;
  final SceneLabel? label;
}
