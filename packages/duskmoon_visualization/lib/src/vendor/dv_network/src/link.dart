import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'node.dart';

/// Data class representing a link/edge in a network graph.
class NetworkLink {
  /// Source node ID.
  final String source;

  /// Target node ID.
  final String target;

  /// Link weight/strength.
  final double weight;

  /// Link label.
  final String? label;

  /// Link color.
  Color? color;

  /// Link width.
  double width;

  /// Whether the link is directed.
  final bool directed;

  /// Custom metadata.
  final Map<String, dynamic>? metadata;

  NetworkLink({
    required this.source,
    required this.target,
    this.weight = 1,
    this.label,
    this.color,
    this.width = 1,
    this.directed = false,
    this.metadata,
  });

  /// Creates a copy of this link.
  NetworkLink copyWith({
    String? source,
    String? target,
    double? weight,
    String? label,
    Color? color,
    double? width,
    bool? directed,
    Map<String, dynamic>? metadata,
  }) {
    return NetworkLink(
      source: source ?? this.source,
      target: target ?? this.target,
      weight: weight ?? this.weight,
      label: label ?? this.label,
      color: color ?? this.color,
      width: width ?? this.width,
      directed: directed ?? this.directed,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkLink &&
          runtimeType == other.runtimeType &&
          source == other.source &&
          target == other.target;

  @override
  int get hashCode => source.hashCode ^ target.hashCode;
}

/// Widget for rendering a link between two nodes.
class LinkWidget extends StatelessWidget {
  /// The link data.
  final NetworkLink link;

  /// Source node.
  final NetworkNode sourceNode;

  /// Target node.
  final NetworkNode targetNode;

  /// Link color.
  final Color color;

  /// Link width.
  final double width;

  /// Whether to show the label.
  final bool showLabel;

  /// Label text style.
  final TextStyle? labelStyle;

  /// Link style.
  final LinkStyle style;

  /// Arrow size for directed links.
  final double arrowSize;

  /// Whether the link is highlighted.
  final bool highlighted;

  /// Highlight color.
  final Color? highlightColor;

  /// Callback when link is tapped.
  final VoidCallback? onTap;

  const LinkWidget({
    super.key,
    required this.link,
    required this.sourceNode,
    required this.targetNode,
    this.color = Colors.grey,
    this.width = 1,
    this.showLabel = false,
    this.labelStyle,
    this.style = LinkStyle.straight,
    this.arrowSize = 8,
    this.highlighted = false,
    this.highlightColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _LinkPainter(
          sourceX: sourceNode.x,
          sourceY: sourceNode.y,
          targetX: targetNode.x,
          targetY: targetNode.y,
          sourceRadius: sourceNode.radius,
          targetRadius: targetNode.radius,
          color: link.color ?? color,
          width: link.width > 0 ? link.width : width,
          style: style,
          directed: link.directed,
          arrowSize: arrowSize,
          highlighted: highlighted,
          highlightColor:
              highlightColor ?? (link.color ?? color).withValues(alpha: 0.5),
          label: showLabel ? link.label : null,
          labelStyle: labelStyle,
        ),
      ),
    );
  }
}

/// Style of link rendering.
enum LinkStyle {
  straight,
  curved,
  dashed,
}

class _LinkPainter extends CustomPainter {
  final double sourceX;
  final double sourceY;
  final double targetX;
  final double targetY;
  final double sourceRadius;
  final double targetRadius;
  final Color color;
  final double width;
  final LinkStyle style;
  final bool directed;
  final double arrowSize;
  final bool highlighted;
  final Color highlightColor;
  final String? label;
  final TextStyle? labelStyle;

  _LinkPainter({
    required this.sourceX,
    required this.sourceY,
    required this.targetX,
    required this.targetY,
    required this.sourceRadius,
    required this.targetRadius,
    required this.color,
    required this.width,
    required this.style,
    required this.directed,
    required this.arrowSize,
    required this.highlighted,
    required this.highlightColor,
    this.label,
    this.labelStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate direction
    final dx = targetX - sourceX;
    final dy = targetY - sourceY;
    final distance = math.sqrt(dx * dx + dy * dy);

    if (distance == 0) return;

    final unitX = dx / distance;
    final unitY = dy / distance;

    // Calculate start and end points (accounting for node radius)
    final startX = sourceX + unitX * sourceRadius;
    final startY = sourceY + unitY * sourceRadius;
    final endX = targetX - unitX * targetRadius;
    final endY = targetY - unitY * targetRadius;

    // Draw highlight
    if (highlighted) {
      final highlightPaint = Paint()
        ..color = highlightColor
        ..strokeWidth = width + 4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
          Offset(startX, startY), Offset(endX, endY), highlightPaint);
    }

    // Main line paint
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    switch (style) {
      case LinkStyle.straight:
        canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
        break;

      case LinkStyle.curved:
        _drawCurvedLine(canvas, startX, startY, endX, endY, paint);
        break;

      case LinkStyle.dashed:
        _drawDashedLine(canvas, startX, startY, endX, endY, paint);
        break;
    }

    // Draw arrow for directed links
    if (directed) {
      _drawArrow(canvas, endX, endY, unitX, unitY);
    }

    // Draw label
    if (label != null) {
      _drawLabel(canvas, startX, startY, endX, endY);
    }
  }

  void _drawCurvedLine(
      Canvas canvas, double x1, double y1, double x2, double y2, Paint paint) {
    final midX = (x1 + x2) / 2;
    final midY = (y1 + y2) / 2;

    // Calculate perpendicular offset
    final dx = x2 - x1;
    final dy = y2 - y1;
    final perpX = -dy * 0.2;
    final perpY = dx * 0.2;

    final path = Path()
      ..moveTo(x1, y1)
      ..quadraticBezierTo(midX + perpX, midY + perpY, x2, y2);

    canvas.drawPath(path, paint);
  }

  void _drawDashedLine(
      Canvas canvas, double x1, double y1, double x2, double y2, Paint paint) {
    const dashLength = 5.0;
    const gapLength = 3.0;

    final dx = x2 - x1;
    final dy = y2 - y1;
    final distance = math.sqrt(dx * dx + dy * dy);
    final unitX = dx / distance;
    final unitY = dy / distance;

    double drawn = 0;
    bool draw = true;

    while (drawn < distance) {
      final segmentLength = draw ? dashLength : gapLength;
      final end = math.min(drawn + segmentLength, distance);

      if (draw) {
        canvas.drawLine(
          Offset(x1 + unitX * drawn, y1 + unitY * drawn),
          Offset(x1 + unitX * end, y1 + unitY * end),
          paint,
        );
      }

      drawn = end;
      draw = !draw;
    }
  }

  void _drawArrow(
      Canvas canvas, double x, double y, double unitX, double unitY) {
    final arrowPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Calculate arrow points
    final arrowTipX = x;
    final arrowTipY = y;

    // Perpendicular direction
    final perpX = -unitY;
    final perpY = unitX;

    final arrowBaseX = x - unitX * arrowSize;
    final arrowBaseY = y - unitY * arrowSize;

    final path = Path()
      ..moveTo(arrowTipX, arrowTipY)
      ..lineTo(arrowBaseX + perpX * arrowSize / 2,
          arrowBaseY + perpY * arrowSize / 2)
      ..lineTo(arrowBaseX - perpX * arrowSize / 2,
          arrowBaseY - perpY * arrowSize / 2)
      ..close();

    canvas.drawPath(path, arrowPaint);
  }

  void _drawLabel(Canvas canvas, double x1, double y1, double x2, double y2) {
    final midX = (x1 + x2) / 2;
    final midY = (y1 + y2) / 2;

    final style = labelStyle ?? TextStyle(fontSize: 10, color: color);
    final textSpan = TextSpan(text: label, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Draw background
    final bgRect = Rect.fromCenter(
      center: Offset(midX, midY),
      width: textPainter.width + 4,
      height: textPainter.height + 2,
    );
    canvas.drawRect(
      bgRect,
      Paint()..color = Colors.white.withValues(alpha: 0.8),
    );

    textPainter.paint(
      canvas,
      Offset(midX - textPainter.width / 2, midY - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(_LinkPainter oldDelegate) {
    return sourceX != oldDelegate.sourceX ||
        sourceY != oldDelegate.sourceY ||
        targetX != oldDelegate.targetX ||
        targetY != oldDelegate.targetY ||
        color != oldDelegate.color ||
        highlighted != oldDelegate.highlighted;
  }
}
