import 'package:flutter/material.dart';

import '../ir/style.dart';
import 'scene_label.dart';

class SceneNode {
  const SceneNode({
    required this.id,
    required this.shape,
    required this.bounds,
    required this.fillColor,
    required this.strokeColor,
    required this.label,
  });

  final String id;
  final NodeShape shape;
  final Rect bounds;
  final Color fillColor;
  final Color strokeColor;
  final SceneLabel label;
}
