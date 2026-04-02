import 'package:flutter/material.dart';

import 'vendor/dv_network/dv_network.dart';

/// Public data model for a DuskMoon network node.
class DmVizNetworkNode {
  final String id;
  final String? label;
  final String? group;
  final double? x;
  final double? y;
  final bool fixed;
  final double radius;
  final Color? color;
  final Map<String, dynamic>? metadata;

  const DmVizNetworkNode({
    required this.id,
    this.label,
    this.group,
    this.x,
    this.y,
    this.fixed = false,
    this.radius = 10,
    this.color,
    this.metadata,
  });

  NetworkNode toRaw() => NetworkNode(
        id: id,
        label: label,
        group: group,
        x: x,
        y: y,
        fixed: fixed,
        radius: radius,
        color: color,
        metadata: metadata,
      );
}

/// Public data model for a DuskMoon network edge.
class DmVizNetworkEdge {
  final String source;
  final String target;
  final double weight;
  final String? label;
  final Color? color;
  final double width;
  final bool directed;
  final Map<String, dynamic>? metadata;

  const DmVizNetworkEdge({
    required this.source,
    required this.target,
    this.weight = 1,
    this.label,
    this.color,
    this.width = 1,
    this.directed = false,
    this.metadata,
  });

  NetworkLink toRaw() => NetworkLink(
        source: source,
        target: target,
        weight: weight,
        label: label,
        color: color,
        width: width,
        directed: directed,
        metadata: metadata,
      );
}

/// Node shapes for DuskMoon network graphs.
enum DmVizNetworkNodeShape {
  circle,
  square,
  diamond,
  triangle,
  hexagon,
}

extension DmVizNetworkNodeShapeRaw on DmVizNetworkNodeShape {
  NodeShape toRaw() {
    switch (this) {
      case DmVizNetworkNodeShape.circle:
        return NodeShape.circle;
      case DmVizNetworkNodeShape.square:
        return NodeShape.square;
      case DmVizNetworkNodeShape.diamond:
        return NodeShape.diamond;
      case DmVizNetworkNodeShape.triangle:
        return NodeShape.triangle;
      case DmVizNetworkNodeShape.hexagon:
        return NodeShape.hexagon;
    }
  }
}

/// Link styles for DuskMoon network graphs.
enum DmVizNetworkLinkStyle {
  straight,
  curved,
  dashed,
}

extension DmVizNetworkLinkStyleRaw on DmVizNetworkLinkStyle {
  LinkStyle toRaw() {
    switch (this) {
      case DmVizNetworkLinkStyle.straight:
        return LinkStyle.straight;
      case DmVizNetworkLinkStyle.curved:
        return LinkStyle.curved;
      case DmVizNetworkLinkStyle.dashed:
        return LinkStyle.dashed;
    }
  }
}
