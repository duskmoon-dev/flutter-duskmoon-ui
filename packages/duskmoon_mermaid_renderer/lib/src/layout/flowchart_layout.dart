import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../config/layout_config.dart';
import '../error/mermaid_error.dart';
import '../ir/diagram_kind.dart';
import '../ir/direction.dart';
import '../ir/graph.dart';
import 'label_placement.dart';
import 'layout.dart';
import 'layout_types.dart';
import 'ranking.dart';
import 'routing.dart';

MermaidLayout computeMermaidLayout(
  Graph graph,
  MermaidLayoutConfig config,
  MermaidTextMeasurer textMeasurer,
) {
  if (graph.kind != MermaidDiagramKind.flowchart) {
    throw UnsupportedDiagramError(graph.kind);
  }

  final ranks = assignRanks(graph);
  final nodesByRank = <int, List<String>>{};
  for (final entry in ranks.entries) {
    nodesByRank.putIfAbsent(entry.value, () => <String>[]).add(entry.key);
  }
  for (final ids in nodesByRank.values) {
    ids.sort();
  }

  final textStyle = MermaidTextStyle(
    fontSize: config.fontSize,
    lineHeight: config.lineHeight,
  );
  final nodeSizes = <String, Size>{
    for (final entry in graph.nodes.entries)
      entry.key: measureNode(entry.value, config, textMeasurer),
  };

  final horizontal = graph.direction == MermaidDirection.leftRight ||
      graph.direction == MermaidDirection.rightLeft;
  final rankKeys = nodesByRank.keys.toList()..sort();
  if (graph.direction == MermaidDirection.bottomTop ||
      graph.direction == MermaidDirection.rightLeft) {
    rankKeys.sort((a, b) => b.compareTo(a));
  }

  final rankMainSizes = <int, double>{};
  final rankCrossSizes = <int, double>{};
  var maxCross = 0.0;
  for (final rank in rankKeys) {
    final ids = nodesByRank[rank]!;
    final mainSize = ids
        .map((id) => horizontal ? nodeSizes[id]!.width : nodeSizes[id]!.height)
        .fold<double>(0, math.max);
    final crossSize = ids.fold<double>(0, (total, id) {
          final size = nodeSizes[id]!;
          return total + (horizontal ? size.height : size.width);
        }) +
        math.max(0, ids.length - 1) * config.nodeSpacing;
    rankMainSizes[rank] = mainSize;
    rankCrossSizes[rank] = crossSize;
    maxCross = math.max(maxCross, crossSize);
  }

  final nodeLayouts = <String, NodeLayout>{};
  var mainCursor = config.padding;
  for (final rank in rankKeys) {
    final ids = nodesByRank[rank]!;
    final rankMain = rankMainSizes[rank]!;
    var crossCursor = config.padding + (maxCross - rankCrossSizes[rank]!) / 2;

    for (final id in ids) {
      final node = graph.nodes[id]!;
      final size = nodeSizes[id]!;
      final textSize = textMeasurer.measure(node.label, textStyle);
      final rect = horizontal
          ? Rect.fromLTWH(
              mainCursor + (rankMain - size.width) / 2,
              crossCursor,
              size.width,
              size.height,
            )
          : Rect.fromLTWH(
              crossCursor,
              mainCursor + (rankMain - size.height) / 2,
              size.width,
              size.height,
            );
      nodeLayouts[id] = NodeLayout(node: node, rect: rect, labelSize: textSize);
      crossCursor +=
          (horizontal ? size.height : size.width) + config.nodeSpacing;
    }

    mainCursor += rankMain + config.rankSpacing;
  }

  final edgeLayouts = graph.edges.map((edge) {
    final from = nodeLayouts[edge.from]?.rect;
    final to = nodeLayouts[edge.to]?.rect;
    if (from == null || to == null) {
      throw const MermaidRenderError('Missing edge endpoint layout');
    }
    final points = routeEdge(from, to);
    final labelSize = edge.label == null
        ? Size.zero
        : textMeasurer.measure(edge.label!, textStyle);
    return EdgeLayout(
      edge: edge,
      points: points,
      labelBounds: edge.label == null
          ? null
          : edgeLabelBounds(points: points, labelSize: labelSize),
    );
  }).toList();

  final bounds = _layoutBounds(nodeLayouts.values, edgeLayouts, config.padding);
  return MermaidLayout(
    kind: graph.kind,
    width: bounds.width,
    height: bounds.height,
    nodes: nodeLayouts,
    edges: edgeLayouts,
  );
}

Rect _layoutBounds(
  Iterable<NodeLayout> nodes,
  Iterable<EdgeLayout> edges,
  double padding,
) {
  var bounds = Rect.zero;
  var initialized = false;

  void include(Rect rect) {
    bounds = initialized ? bounds.expandToInclude(rect) : rect;
    initialized = true;
  }

  for (final node in nodes) {
    include(node.rect);
  }
  for (final edge in edges) {
    for (final point in edge.points) {
      include(Rect.fromCircle(center: point, radius: 1));
    }
    final labelBounds = edge.labelBounds;
    if (labelBounds != null) include(labelBounds);
  }

  if (!initialized) return Rect.fromLTWH(0, 0, padding * 2, padding * 2);
  return Rect.fromLTRB(
    0,
    0,
    bounds.right + padding,
    bounds.bottom + padding,
  );
}
