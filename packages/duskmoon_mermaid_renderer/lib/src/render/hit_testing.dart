import 'package:flutter/material.dart';

import '../scene/mermaid_scene.dart';

String? hitTestNode(MermaidScene scene, Offset position) {
  for (final node in scene.nodes.reversed) {
    if (node.bounds.contains(position)) return node.id;
  }
  return null;
}
