import 'package:flutter/material.dart';

import '../dm_chart_palette.dart';
import '../dm_network_models.dart';
import '../vendor/dv_network/dv_network.dart';

class DmVizNetworkGraph extends StatelessWidget {
  final List<DmVizNetworkNode> nodes;
  final List<DmVizNetworkEdge> links;
  final bool enableSimulation;
  final bool showNodeLabels;
  final bool showLinkLabels;
  final bool enableZoomPan;
  final bool draggableNodes;
  final DmVizNetworkNodeShape nodeShape;
  final DmVizNetworkLinkStyle linkStyle;
  final Map<String, Color>? groupColors;
  final DmChartPalette? palette;
  final void Function(DmVizNetworkNode node)? onNodeTap;
  final void Function(DmVizNetworkEdge edge)? onLinkTap;

  const DmVizNetworkGraph({
    super.key,
    required this.nodes,
    required this.links,
    this.enableSimulation = false,
    this.showNodeLabels = true,
    this.showLinkLabels = false,
    this.enableZoomPan = true,
    this.draggableNodes = true,
    this.nodeShape = DmVizNetworkNodeShape.circle,
    this.linkStyle = DmVizNetworkLinkStyle.curved,
    this.groupColors,
    this.palette,
    this.onNodeTap,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedPalette =
        palette ?? DmChartPalette.fromTheme(Theme.of(context));
    final rawNodes = nodes.map((node) => node.toRaw()).toList(growable: false);
    final rawLinks = links.map((edge) => edge.toRaw()).toList(growable: false);

    return ColoredBox(
      color: resolvedPalette.background,
      child: Network(
        nodes: rawNodes,
        links: rawLinks,
        enableSimulation: enableSimulation,
        nodeColor: resolvedPalette.primary,
        nodeBorderColor: resolvedPalette.axis,
        showNodeLabels: showNodeLabels,
        nodeLabelStyle: Theme.of(context).textTheme.labelSmall,
        nodeShape: nodeShape.toRaw(),
        linkColor: resolvedPalette.grid,
        linkStyle: linkStyle.toRaw(),
        showLinkLabels: showLinkLabels,
        linkLabelStyle: Theme.of(context).textTheme.labelSmall,
        groupColors: groupColors,
        draggableNodes: draggableNodes,
        enableZoomPan: enableZoomPan,
        onNodeTap: onNodeTap == null
            ? null
            : (node) {
                this.onNodeTap!(DmVizNetworkNode(
                  id: node.id,
                  label: node.label,
                  group: node.group,
                  x: node.x,
                  y: node.y,
                  fixed: node.fixed,
                  radius: node.radius,
                  color: node.color,
                  metadata: node.metadata,
                ));
              },
        onLinkTap: onLinkTap == null
            ? null
            : (edge) {
                this.onLinkTap!(DmVizNetworkEdge(
                  source: edge.source,
                  target: edge.target,
                  weight: edge.weight,
                  label: edge.label,
                  color: edge.color,
                  width: edge.width,
                  directed: edge.directed,
                  metadata: edge.metadata,
                ));
              },
      ),
    );
  }
}
