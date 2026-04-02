import 'package:flutter/material.dart';

import 'node.dart';
import 'link.dart';
import 'force_simulation.dart';

/// Network graph visualization widget.
class Network extends StatefulWidget {
  /// Nodes in the network.
  final List<NetworkNode> nodes;

  /// Links between nodes.
  final List<NetworkLink> links;

  /// Width of the visualization.
  final double? width;

  /// Height of the visualization.
  final double? height;

  /// Whether to run force simulation.
  final bool enableSimulation;

  /// Force simulation configuration.
  final ForceSimulation? simulation;

  /// Default node color.
  final Color nodeColor;

  /// Default node border color.
  final Color? nodeBorderColor;

  /// Default node border width.
  final double nodeBorderWidth;

  /// Whether to show node labels.
  final bool showNodeLabels;

  /// Node label style.
  final TextStyle? nodeLabelStyle;

  /// Default node shape.
  final NodeShape nodeShape;

  /// Default link color.
  final Color linkColor;

  /// Default link width.
  final double linkWidth;

  /// Default link style.
  final LinkStyle linkStyle;

  /// Whether to show link labels.
  final bool showLinkLabels;

  /// Link label style.
  final TextStyle? linkLabelStyle;

  /// Color mapping for node groups.
  final Map<String, Color>? groupColors;

  /// Whether nodes are draggable.
  final bool draggableNodes;

  /// Whether to enable zoom and pan.
  final bool enableZoomPan;

  /// Minimum zoom level.
  final double minZoom;

  /// Maximum zoom level.
  final double maxZoom;

  /// Callback when a node is tapped.
  final void Function(NetworkNode node)? onNodeTap;

  /// Callback when a link is tapped.
  final void Function(NetworkLink link)? onLinkTap;

  /// Callback when a node is dragged.
  final void Function(NetworkNode node)? onNodeDrag;

  /// Callback when simulation state changes.
  final void Function(bool running)? onSimulationStateChange;

  const Network({
    super.key,
    required this.nodes,
    required this.links,
    this.width,
    this.height,
    this.enableSimulation = true,
    this.simulation,
    this.nodeColor = Colors.blue,
    this.nodeBorderColor,
    this.nodeBorderWidth = 2,
    this.showNodeLabels = true,
    this.nodeLabelStyle,
    this.nodeShape = NodeShape.circle,
    this.linkColor = Colors.grey,
    this.linkWidth = 1,
    this.linkStyle = LinkStyle.straight,
    this.showLinkLabels = false,
    this.linkLabelStyle,
    this.groupColors,
    this.draggableNodes = true,
    this.enableZoomPan = true,
    this.minZoom = 0.1,
    this.maxZoom = 4.0,
    this.onNodeTap,
    this.onLinkTap,
    this.onNodeDrag,
    this.onSimulationStateChange,
  });

  @override
  State<Network> createState() => _NetworkState();
}

class _NetworkState extends State<Network> {
  late ForceSimulation _simulation;
  NetworkNode? _selectedNode;
  NetworkNode? _draggedNode;

  // Transform for zoom/pan
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  Offset? _lastFocalPoint;

  @override
  void initState() {
    super.initState();
    _initSimulation();
  }

  void _initSimulation() {
    if (widget.simulation != null) {
      _simulation = widget.simulation!;
    } else {
      _simulation = ForceSimulation.withDefaults(
        nodes: widget.nodes,
        links: widget.links,
        onTick: () => setState(() {}),
        onEnd: () => widget.onSimulationStateChange?.call(false),
      );
    }

    if (widget.enableSimulation) {
      _simulation.start();
      widget.onSimulationStateChange?.call(true);
    }
  }

  @override
  void didUpdateWidget(Network oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.nodes != oldWidget.nodes || widget.links != oldWidget.links) {
      _simulation.stop();
      _initSimulation();
    }
  }

  @override
  void dispose() {
    _simulation.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = widget.width ?? constraints.maxWidth;
        final height = widget.height ?? constraints.maxHeight;

        return GestureDetector(
          onScaleStart: widget.enableZoomPan ? _onScaleStart : null,
          onScaleUpdate: widget.enableZoomPan ? _onScaleUpdate : null,
          child: ClipRect(
            child: CustomPaint(
              size: Size(width, height),
              painter: _NetworkPainter(
                nodes: widget.nodes,
                links: widget.links,
                nodeMap: {for (final n in widget.nodes) n.id: n},
                nodeColor: widget.nodeColor,
                nodeBorderColor: widget.nodeBorderColor,
                nodeBorderWidth: widget.nodeBorderWidth,
                showNodeLabels: widget.showNodeLabels,
                nodeLabelStyle: widget.nodeLabelStyle,
                nodeShape: widget.nodeShape,
                linkColor: widget.linkColor,
                linkWidth: widget.linkWidth,
                linkStyle: widget.linkStyle,
                showLinkLabels: widget.showLinkLabels,
                linkLabelStyle: widget.linkLabelStyle,
                groupColors: widget.groupColors,
                selectedNode: _selectedNode,
                draggedNode: _draggedNode,
                scale: _scale,
                offset: _offset,
                centerX: width / 2,
                centerY: height / 2,
              ),
              child: widget.draggableNodes || widget.onNodeTap != null
                  ? _buildInteractiveLayer(width, height)
                  : null,
            ),
          ),
        );
      },
    );
  }

  Widget _buildInteractiveLayer(double width, double height) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapUp: (details) => _handleTap(details, width, height),
      onPanStart: widget.draggableNodes
          ? (details) => _handleDragStart(details, width, height)
          : null,
      onPanUpdate: widget.draggableNodes ? _handleDragUpdate : null,
      onPanEnd: widget.draggableNodes ? _handleDragEnd : null,
    );
  }

  void _onScaleStart(ScaleStartDetails details) {
    _lastFocalPoint = details.focalPoint;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      // Update scale
      final newScale =
          (_scale * details.scale).clamp(widget.minZoom, widget.maxZoom);

      // Update offset for panning
      if (_lastFocalPoint != null) {
        _offset += details.focalPoint - _lastFocalPoint!;
      }

      _scale = newScale;
      _lastFocalPoint = details.focalPoint;
    });
  }

  void _handleTap(TapUpDetails details, double width, double height) {
    final node = _findNodeAtPosition(details.localPosition, width, height);
    if (node != null) {
      setState(() => _selectedNode = node);
      widget.onNodeTap?.call(node);
    } else {
      setState(() => _selectedNode = null);
    }
  }

  void _handleDragStart(DragStartDetails details, double width, double height) {
    final node = _findNodeAtPosition(details.localPosition, width, height);
    if (node != null) {
      setState(() {
        _draggedNode = node;
        node.fixed = true;
      });
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_draggedNode != null) {
      setState(() {
        _draggedNode!.x += details.delta.dx / _scale;
        _draggedNode!.y += details.delta.dy / _scale;
      });
      widget.onNodeDrag?.call(_draggedNode!);
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_draggedNode != null) {
      setState(() {
        _draggedNode!.fixed = false;
        _draggedNode = null;
      });

      // Reheat simulation
      if (widget.enableSimulation) {
        _simulation.restart();
        widget.onSimulationStateChange?.call(true);
      }
    }
  }

  NetworkNode? _findNodeAtPosition(
      Offset position, double width, double height) {
    final centerX = width / 2;
    final centerY = height / 2;

    // Transform position to simulation coordinates
    final x = (position.dx - centerX - _offset.dx) / _scale;
    final y = (position.dy - centerY - _offset.dy) / _scale;

    return _simulation.findNode(x, y, radius: 20 / _scale);
  }
}

class _NetworkPainter extends CustomPainter {
  final List<NetworkNode> nodes;
  final List<NetworkLink> links;
  final Map<String, NetworkNode> nodeMap;
  final Color nodeColor;
  final Color? nodeBorderColor;
  final double nodeBorderWidth;
  final bool showNodeLabels;
  final TextStyle? nodeLabelStyle;
  final NodeShape nodeShape;
  final Color linkColor;
  final double linkWidth;
  final LinkStyle linkStyle;
  final bool showLinkLabels;
  final TextStyle? linkLabelStyle;
  final Map<String, Color>? groupColors;
  final NetworkNode? selectedNode;
  final NetworkNode? draggedNode;
  final double scale;
  final Offset offset;
  final double centerX;
  final double centerY;

  _NetworkPainter({
    required this.nodes,
    required this.links,
    required this.nodeMap,
    required this.nodeColor,
    this.nodeBorderColor,
    required this.nodeBorderWidth,
    required this.showNodeLabels,
    this.nodeLabelStyle,
    required this.nodeShape,
    required this.linkColor,
    required this.linkWidth,
    required this.linkStyle,
    required this.showLinkLabels,
    this.linkLabelStyle,
    this.groupColors,
    this.selectedNode,
    this.draggedNode,
    required this.scale,
    required this.offset,
    required this.centerX,
    required this.centerY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    // Apply transform
    canvas.translate(centerX + offset.dx, centerY + offset.dy);
    canvas.scale(scale);

    // Draw links first (behind nodes)
    for (final link in links) {
      final source = nodeMap[link.source];
      final target = nodeMap[link.target];
      if (source == null || target == null) continue;

      _drawLink(canvas, link, source, target);
    }

    // Draw nodes
    for (final node in nodes) {
      _drawNode(canvas, node);
    }

    canvas.restore();
  }

  void _drawLink(
      Canvas canvas, NetworkLink link, NetworkNode source, NetworkNode target) {
    final color = link.color ?? linkColor;
    final width = link.width > 0 ? link.width : linkWidth;

    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Calculate points
    final dx = target.x - source.x;
    final dy = target.y - source.y;
    final dist = (dx * dx + dy * dy).abs();
    final distance = dist > 0 ? dist.toDouble() : 1.0;
    final sqrtDist = _sqrt(distance);

    final unitX = dx / sqrtDist;
    final unitY = dy / sqrtDist;

    final startX = source.x + unitX * source.radius;
    final startY = source.y + unitY * source.radius;
    final endX = target.x - unitX * target.radius;
    final endY = target.y - unitY * target.radius;

    canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);

    // Draw arrow for directed links
    if (link.directed) {
      _drawArrow(canvas, endX, endY, unitX, unitY, color, 8);
    }
  }

  double _sqrt(double x) {
    if (x <= 0) return 0;
    double guess = x / 2;
    for (int i = 0; i < 10; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }

  void _drawArrow(Canvas canvas, double x, double y, double ux, double uy,
      Color color, double size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final perpX = -uy;
    final perpY = ux;

    final path = Path()
      ..moveTo(x, y)
      ..lineTo(
          x - ux * size + perpX * size / 2, y - uy * size + perpY * size / 2)
      ..lineTo(
          x - ux * size - perpX * size / 2, y - uy * size - perpY * size / 2)
      ..close();

    canvas.drawPath(path, paint);
  }

  void _drawNode(Canvas canvas, NetworkNode node) {
    final isSelected = node == selectedNode;
    final isDragged = node == draggedNode;

    final color = node.color ?? groupColors?[node.group] ?? nodeColor;
    final radius = node.radius;

    // Draw selection highlight
    if (isSelected || isDragged) {
      final highlightPaint = Paint()
        ..color = color.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(node.x, node.y), radius + 4, highlightPaint);
    }

    // Draw node
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(node.x, node.y), radius, fillPaint);

    // Draw border
    if (nodeBorderColor != null) {
      final strokePaint = Paint()
        ..color = nodeBorderColor!
        ..strokeWidth = nodeBorderWidth
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(Offset(node.x, node.y), radius, strokePaint);
    }

    // Draw label
    if (showNodeLabels && node.label != null) {
      final style =
          nodeLabelStyle ?? const TextStyle(fontSize: 10, color: Colors.black);
      final textSpan = TextSpan(text: node.label, style: style);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(node.x - textPainter.width / 2, node.y + radius + 4),
      );
    }
  }

  @override
  bool shouldRepaint(_NetworkPainter oldDelegate) {
    return nodes != oldDelegate.nodes ||
        links != oldDelegate.links ||
        selectedNode != oldDelegate.selectedNode ||
        scale != oldDelegate.scale ||
        offset != oldDelegate.offset;
  }
}
