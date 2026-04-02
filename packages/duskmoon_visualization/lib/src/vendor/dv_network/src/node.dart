import 'package:flutter/material.dart';

/// Data class representing a node in a network graph.
class NetworkNode {
  /// Unique identifier for the node.
  final String id;

  /// Display label for the node.
  final String? label;

  /// Node group/category for styling.
  final String? group;

  /// Current x position.
  double x;

  /// Current y position.
  double y;

  /// Velocity x component (for force simulation).
  double vx;

  /// Velocity y component (for force simulation).
  double vy;

  /// Whether the node position is fixed.
  bool fixed;

  /// Node radius.
  double radius;

  /// Node color.
  Color? color;

  /// Custom metadata.
  final Map<String, dynamic>? metadata;

  NetworkNode({
    required this.id,
    this.label,
    this.group,
    double? x,
    double? y,
    this.vx = 0,
    this.vy = 0,
    this.fixed = false,
    this.radius = 10,
    this.color,
    this.metadata,
  })  : x = x ?? 0,
        y = y ?? 0;

  /// Creates a copy of this node.
  NetworkNode copyWith({
    String? id,
    String? label,
    String? group,
    double? x,
    double? y,
    double? vx,
    double? vy,
    bool? fixed,
    double? radius,
    Color? color,
    Map<String, dynamic>? metadata,
  }) {
    return NetworkNode(
      id: id ?? this.id,
      label: label ?? this.label,
      group: group ?? this.group,
      x: x ?? this.x,
      y: y ?? this.y,
      vx: vx ?? this.vx,
      vy: vy ?? this.vy,
      fixed: fixed ?? this.fixed,
      radius: radius ?? this.radius,
      color: color ?? this.color,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkNode &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Widget for rendering a single node.
class NodeWidget extends StatelessWidget {
  /// The node data.
  final NetworkNode node;

  /// Node fill color.
  final Color color;

  /// Node border color.
  final Color? borderColor;

  /// Node border width.
  final double borderWidth;

  /// Whether to show the label.
  final bool showLabel;

  /// Label text style.
  final TextStyle? labelStyle;

  /// Node shape.
  final NodeShape shape;

  /// Whether the node is selected.
  final bool selected;

  /// Selection highlight color.
  final Color? selectionColor;

  /// Callback when node is tapped.
  final VoidCallback? onTap;

  /// Callback when node drag starts.
  final void Function(DragStartDetails)? onDragStart;

  /// Callback when node is dragged.
  final void Function(DragUpdateDetails)? onDragUpdate;

  /// Callback when node drag ends.
  final void Function(DragEndDetails)? onDragEnd;

  const NodeWidget({
    super.key,
    required this.node,
    this.color = Colors.blue,
    this.borderColor,
    this.borderWidth = 2,
    this.showLabel = true,
    this.labelStyle,
    this.shape = NodeShape.circle,
    this.selected = false,
    this.selectionColor,
    this.onTap,
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    final nodeColor = node.color ?? color;
    final size = node.radius * 2;

    Widget nodeWidget = GestureDetector(
      onTap: onTap,
      onPanStart: onDragStart,
      onPanUpdate: onDragUpdate,
      onPanEnd: onDragEnd,
      child: CustomPaint(
        size: Size(size, size),
        painter: _NodePainter(
          color: nodeColor,
          borderColor: borderColor,
          borderWidth: borderWidth,
          shape: shape,
          selected: selected,
          selectionColor: selectionColor ?? nodeColor.withValues(alpha: 0.3),
        ),
      ),
    );

    if (showLabel && node.label != null) {
      nodeWidget = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          nodeWidget,
          const SizedBox(height: 4),
          Text(
            node.label!,
            style: labelStyle ?? const TextStyle(fontSize: 10),
          ),
        ],
      );
    }

    return nodeWidget;
  }
}

/// Shape of a node.
enum NodeShape {
  circle,
  square,
  diamond,
  triangle,
  hexagon,
}

class _NodePainter extends CustomPainter {
  final Color color;
  final Color? borderColor;
  final double borderWidth;
  final NodeShape shape;
  final bool selected;
  final Color selectionColor;

  _NodePainter({
    required this.color,
    this.borderColor,
    required this.borderWidth,
    required this.shape,
    required this.selected,
    required this.selectionColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw selection highlight
    if (selected) {
      final selectionPaint = Paint()
        ..color = selectionColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius + 4, selectionPaint);
    }

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = borderColor != null
        ? (Paint()
          ..color = borderColor!
          ..strokeWidth = borderWidth
          ..style = PaintingStyle.stroke)
        : null;

    switch (shape) {
      case NodeShape.circle:
        canvas.drawCircle(center, radius, fillPaint);
        if (strokePaint != null) canvas.drawCircle(center, radius, strokePaint);
        break;

      case NodeShape.square:
        final rect = Rect.fromCenter(
            center: center, width: radius * 2, height: radius * 2);
        canvas.drawRect(rect, fillPaint);
        if (strokePaint != null) canvas.drawRect(rect, strokePaint);
        break;

      case NodeShape.diamond:
        final path = Path()
          ..moveTo(center.dx, center.dy - radius)
          ..lineTo(center.dx + radius, center.dy)
          ..lineTo(center.dx, center.dy + radius)
          ..lineTo(center.dx - radius, center.dy)
          ..close();
        canvas.drawPath(path, fillPaint);
        if (strokePaint != null) canvas.drawPath(path, strokePaint);
        break;

      case NodeShape.triangle:
        final path = Path()
          ..moveTo(center.dx, center.dy - radius)
          ..lineTo(center.dx + radius * 0.866, center.dy + radius * 0.5)
          ..lineTo(center.dx - radius * 0.866, center.dy + radius * 0.5)
          ..close();
        canvas.drawPath(path, fillPaint);
        if (strokePaint != null) canvas.drawPath(path, strokePaint);
        break;

      case NodeShape.hexagon:
        final path = Path();
        for (int i = 0; i < 6; i++) {
          final angle = i * 3.14159 / 3 - 3.14159 / 6;
          final x = center.dx + radius * cos(angle);
          final y = center.dy + radius * sin(angle);
          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        canvas.drawPath(path, fillPaint);
        if (strokePaint != null) canvas.drawPath(path, strokePaint);
        break;
    }
  }

  double cos(double radians) => 0.0 + 1.0 * _cos(radians);

  double sin(double radians) => 0.0 + 1.0 * _sin(radians);

  double _cos(double x) {
    // Taylor series approximation
    x = x % (2 * 3.14159265359);
    double result = 1.0;
    double term = 1.0;
    for (int n = 1; n <= 10; n++) {
      term *= -x * x / ((2 * n - 1) * (2 * n));
      result += term;
    }
    return result;
  }

  double _sin(double x) {
    x = x % (2 * 3.14159265359);
    double result = x;
    double term = x;
    for (int n = 1; n <= 10; n++) {
      term *= -x * x / ((2 * n) * (2 * n + 1));
      result += term;
    }
    return result;
  }

  @override
  bool shouldRepaint(_NodePainter oldDelegate) {
    return color != oldDelegate.color ||
        borderColor != oldDelegate.borderColor ||
        selected != oldDelegate.selected ||
        shape != oldDelegate.shape;
  }
}
