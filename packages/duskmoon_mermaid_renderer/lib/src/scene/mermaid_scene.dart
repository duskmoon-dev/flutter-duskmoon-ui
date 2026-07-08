import 'package:flutter/material.dart';

import '../layout/layout.dart';
import '../theme/theme.dart';
import 'scene_edge.dart';
import 'scene_label.dart';
import 'scene_node.dart';

class MermaidScene {
  const MermaidScene({
    required this.size,
    required this.nodes,
    required this.edges,
    required this.labels,
  });

  final Size size;
  final List<SceneNode> nodes;
  final List<SceneEdge> edges;
  final List<SceneLabel> labels;
}

MermaidScene buildMermaidScene(MermaidLayout layout, MermaidTheme theme) {
  final labels = <SceneLabel>[];
  final nodes = layout.nodes.values.map((nodeLayout) {
    final label = SceneLabel(
      text: nodeLayout.node.label,
      bounds: nodeLayout.rect,
      textColor: theme.textColor,
    );
    labels.add(label);
    return SceneNode(
      id: nodeLayout.node.id,
      shape: nodeLayout.node.shape,
      bounds: nodeLayout.rect,
      fillColor: theme.nodeFill,
      strokeColor: theme.nodeStroke,
      label: label,
    );
  }).toList();

  final edges = layout.edges.map((edgeLayout) {
    SceneLabel? label;
    final labelText = edgeLayout.edge.label;
    final labelBounds = edgeLayout.labelBounds;
    if (labelText != null && labelBounds != null) {
      label = SceneLabel(
        text: labelText,
        bounds: labelBounds,
        textColor: theme.textColor,
        backgroundColor: theme.labelBackground,
      );
      labels.add(label);
    }
    return SceneEdge(
      points: edgeLayout.points,
      style: edgeLayout.edge.style,
      color: theme.edgeStroke,
      arrowStart: edgeLayout.edge.arrowStart,
      arrowEnd: edgeLayout.edge.arrowEnd,
      label: label,
    );
  }).toList();

  return MermaidScene(
    size: Size(layout.width, layout.height),
    nodes: nodes,
    edges: edges,
    labels: labels,
  );
}
