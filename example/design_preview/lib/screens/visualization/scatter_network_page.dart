import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:duskmoon_visualization/duskmoon_visualization_compat.dart'
    as dv;

import '../../destination.dart';

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------

class ScatterNetworkPage extends StatelessWidget {
  static const name = 'Scatter & Network';
  static const path = 'scatter-network';

  const ScatterNetworkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DmAdaptiveScaffold(
      selectedIndex: Destinations.indexOf(const Key('Visualization')),
      onSelectedIndexChange: (idx) => Destinations.changeHandler(idx, context),
      destinations: Destinations.navs,
      useDrawer: true,
      transitionDuration: Duration.zero,
      appBar: DmAppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Scatter & Network Charts'),
        leading: const BackButton(),
        actions: const [PlatformSwitchAction()],
      ),
      appBarBreakpoint: Breakpoints.standard,
      body: (_) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Scatter, network & relational charts',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'A gallery of advanced chart types built with the DuskMoon compat scale layer and raw CustomPaint.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          const _ChartCard(
            title: 'Scatter Plot',
            description: 'Bubble scatter with two groups and variable radius.',
            height: 280,
            child: _ScatterPlot(),
          ),
          const SizedBox(height: 16),
          const _ChartCard(
            title: 'Activity Heatmap',
            description:
                'Activity intensity matrix using sequential color scale.',
            height: 260,
            child: _ActivityHeatmap(),
          ),
          const SizedBox(height: 16),
          const _ChartCard(
            title: 'Force-Directed Network Graph',
            description: 'Animated force-directed graph with 15 nodes.',
            height: 320,
            child: _ForceGraph(),
          ),
          const SizedBox(height: 16),
          const _ChartCard(
            title: 'Chord Diagram',
            description:
                'Cross-relationship flow diagram between 5 categories.',
            height: 300,
            child: _ChordDiagram(),
          ),
          const SizedBox(height: 16),
          const _ChartCard(
            title: 'Sankey Diagram',
            description: 'Energy flow from sources to consumption end-uses.',
            height: 300,
            child: _SankeyDiagram(),
          ),
          const SizedBox(height: 16),
          const _ChartCard(
            title: 'Delaunay / Voronoi',
            description:
                'Delaunay triangulation and Voronoi diagram of random points.',
            height: 280,
            child: _DelaunayVoronoi(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ChartCard
// ---------------------------------------------------------------------------

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.title,
    required this.description,
    required this.height,
    required this.child,
  });

  final String title;
  final String description;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(description, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            SizedBox(height: height, child: child),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. Scatter Plot
// ---------------------------------------------------------------------------

class _ScatterPlot extends StatelessWidget {
  const _ScatterPlot();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _ScatterPainter(colorScheme: colorScheme),
        );
      },
    );
  }
}

class _ScatterPainter extends CustomPainter {
  const _ScatterPainter({required this.colorScheme});

  final ColorScheme colorScheme;

  // (x, y, radius) triples
  static List<(double, double, double)> _groupA(math.Random rng) {
    return List.generate(30, (_) {
      final x = 20 + rng.nextDouble() * 40;
      final y = 20 + rng.nextDouble() * 60;
      final r = 4 + rng.nextDouble() * 10;
      return (x, y, r);
    });
  }

  static List<(double, double, double)> _groupB(math.Random rng) {
    return List.generate(20, (_) {
      final x = 40 + rng.nextDouble() * 50;
      final y = 30 + rng.nextDouble() * 50;
      final r = 4 + rng.nextDouble() * 10;
      return (x, y, r);
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);
    final groupA = _groupA(rng);
    final groupB = _groupB(rng);

    const margin = EdgeInsets.fromLTRB(48, 16, 16, 40);
    final w = size.width - margin.left - margin.right;
    final h = size.height - margin.top - margin.bottom;

    final xScale = dv.scaleLinear(domain: [0.0, 100.0], range: [0.0, w]);
    final yScale = dv.scaleLinear(domain: [0.0, 100.0], range: [h, 0.0]);

    canvas.save();
    canvas.translate(margin.left, margin.top);

    // Grid
    final gridPaint = Paint()
      ..color = colorScheme.outlineVariant
      ..strokeWidth = 0.5;
    for (var i = 0; i <= 5; i++) {
      final y = yScale(i * 20.0);
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
      final x = xScale(i * 20.0);
      canvas.drawLine(Offset(x, 0), Offset(x, h), gridPaint);
    }

    // Axes
    final axisPaint = Paint()
      ..color = colorScheme.outline
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(0, h), Offset(w, h), axisPaint);
    canvas.drawLine(const Offset(0, 0), Offset(0, h), axisPaint);

    // Axis labels
    final labelStyle = TextStyle(
      color: colorScheme.onSurfaceVariant,
      fontSize: 9,
    );
    for (var i = 0; i <= 5; i++) {
      final val = (i * 20).toStringAsFixed(0);
      _drawText(canvas, val, Offset(-4, yScale(i * 20.0)), labelStyle,
          align: TextAlign.right);
      _drawText(canvas, val, Offset(xScale(i * 20.0), h + 4), labelStyle,
          align: TextAlign.center);
    }

    // Group A circles
    final paintA = Paint()
      ..color = colorScheme.primary.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    for (final (x, y, r) in groupA) {
      canvas.drawCircle(Offset(xScale(x), yScale(y)), r, paintA);
    }

    // Group B circles
    final paintB = Paint()
      ..color = colorScheme.tertiary.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    for (final (x, y, r) in groupB) {
      canvas.drawCircle(Offset(xScale(x), yScale(y)), r, paintB);
    }

    // Legend
    final legendStyle = TextStyle(color: colorScheme.onSurface, fontSize: 10);
    canvas.drawCircle(Offset(w - 80, 8), 5,
        Paint()..color = colorScheme.primary.withValues(alpha: 0.7));
    _drawText(canvas, 'Group A', Offset(w - 72, 8), legendStyle,
        align: TextAlign.left, baseline: true);
    canvas.drawCircle(Offset(w - 80, 22), 5,
        Paint()..color = colorScheme.tertiary.withValues(alpha: 0.7));
    _drawText(canvas, 'Group B', Offset(w - 72, 22), legendStyle,
        align: TextAlign.left, baseline: true);

    canvas.restore();
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset,
    TextStyle style, {
    TextAlign align = TextAlign.left,
    bool baseline = false,
  }) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textAlign: align,
    )..layout(minWidth: 0, maxWidth: 60);
    final dx = align == TextAlign.right
        ? offset.dx - tp.width
        : align == TextAlign.center
            ? offset.dx - tp.width / 2
            : offset.dx;
    final dy = baseline ? offset.dy - tp.height / 2 : offset.dy;
    tp.paint(canvas, Offset(dx, dy));
  }

  @override
  bool shouldRepaint(covariant _ScatterPainter oldDelegate) =>
      oldDelegate.colorScheme != colorScheme;
}

// ---------------------------------------------------------------------------
// 2. Activity Heatmap
// ---------------------------------------------------------------------------

class _ActivityHeatmap extends StatelessWidget {
  const _ActivityHeatmap();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _HeatmapPainter(colorScheme: colorScheme),
        );
      },
    );
  }
}

class _HeatmapPainter extends CustomPainter {
  const _HeatmapPainter({required this.colorScheme});

  final ColorScheme colorScheme;

  static final _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static final _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  Color _heatColor(double v) {
    final t = (v / 100.0).clamp(0.0, 1.0);
    // Interpolate through 5 green shades: shade100 -> shade900
    const shades = [
      Color(0xFFf1f8e9), // green.shade50
      Color(0xFFc8e6c9), // green.shade100
      Color(0xFF81c784), // green.shade300
      Color(0xFF388e3c), // green.shade700
      Color(0xFF1b5e20), // green.shade900
    ];
    final segment = t * (shades.length - 1);
    final i = segment.floor().clamp(0, shades.length - 2);
    final frac = segment - i;
    return Color.lerp(shades[i], shades[i + 1], frac)!;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);
    final data = List.generate(
        7, (_) => List.generate(12, (_) => rng.nextDouble() * 100));

    const margin = EdgeInsets.fromLTRB(36, 8, 8, 28);
    final w = size.width - margin.left - margin.right;
    final h = size.height - margin.top - margin.bottom;
    final cellW = w / 12;
    final cellH = h / 7;

    canvas.save();
    canvas.translate(margin.left, margin.top);

    for (var row = 0; row < 7; row++) {
      for (var col = 0; col < 12; col++) {
        final rect =
            Rect.fromLTWH(col * cellW, row * cellH, cellW - 1, cellH - 1);
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(2)),
          Paint()..color = _heatColor(data[row][col]),
        );
      }
    }

    // Row labels (days)
    final labelStyle = TextStyle(color: colorScheme.onSurface, fontSize: 9);
    for (var row = 0; row < 7; row++) {
      _drawText(
          canvas, _days[row], Offset(-4, row * cellH + cellH / 2), labelStyle,
          baseline: true);
    }

    // Column labels (months)
    for (var col = 0; col < 12; col++) {
      _drawText(canvas, _months[col], Offset(col * cellW + cellW / 2, h + 3),
          labelStyle,
          center: true);
    }

    canvas.restore();
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style,
      {bool baseline = false, bool center = false}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: 40);
    final dx = center ? offset.dx - tp.width / 2 : offset.dx - tp.width;
    final dy = baseline ? offset.dy - tp.height / 2 : offset.dy;
    tp.paint(canvas, Offset(dx, dy));
  }

  @override
  bool shouldRepaint(covariant _HeatmapPainter oldDelegate) =>
      oldDelegate.colorScheme != colorScheme;
}

// ---------------------------------------------------------------------------
// 3. Force-Directed Network Graph
// ---------------------------------------------------------------------------

class _NodeState {
  double x;
  double y;
  double vx = 0;
  double vy = 0;
  int id;
  Color color;

  _NodeState({
    required this.x,
    required this.y,
    required this.id,
    required this.color,
  });
}

class _ForceGraph extends StatefulWidget {
  const _ForceGraph();

  @override
  State<_ForceGraph> createState() => _ForceGraphState();
}

class _ForceGraphState extends State<_ForceGraph>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_NodeState> _nodes;
  late List<(int, int)> _edges;

  static const _nodeColors = [
    Color(0xFF5C6BC0), // indigo
    Color(0xFF26A69A), // teal
    Color(0xFFEF5350), // red
    Color(0xFFFFA726), // orange
    Color(0xFF66BB6A), // green
  ];

  void _initGraph() {
    final rng = math.Random(42);
    _nodes = List.generate(15, (i) {
      return _NodeState(
        id: i,
        x: 40 + rng.nextDouble() * 220,
        y: 40 + rng.nextDouble() * 220,
        color: _nodeColors[i % _nodeColors.length],
      );
    });

    _edges = [];
    final edgeRng = math.Random(42);
    for (var i = 0; i < 15; i++) {
      for (var j = i + 1; j < 15; j++) {
        if (edgeRng.nextDouble() < 0.2) {
          _edges.add((i, j));
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initGraph();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..addListener(_simulate);
    _controller.forward();
  }

  void _simulate() {
    const repulsion = 800.0;
    const attraction = 0.04;
    const gravity = 0.02;
    const damping = 0.85;
    const cx = 150.0;
    const cy = 150.0;

    for (final node in _nodes) {
      double fx = 0;
      double fy = 0;

      // Repulsion between nodes
      for (final other in _nodes) {
        if (other.id == node.id) continue;
        final dx = node.x - other.x;
        final dy = node.y - other.y;
        final dist = math.sqrt(dx * dx + dy * dy).clamp(1.0, double.infinity);
        final force = repulsion / (dist * dist);
        fx += (dx / dist) * force;
        fy += (dy / dist) * force;
      }

      // Attraction along edges
      for (final (a, b) in _edges) {
        if (a == node.id || b == node.id) {
          final other = _nodes[a == node.id ? b : a];
          final dx = other.x - node.x;
          final dy = other.y - node.y;
          fx += dx * attraction;
          fy += dy * attraction;
        }
      }

      // Center gravity
      fx += (cx - node.x) * gravity;
      fy += (cy - node.y) * gravity;

      node.vx = (node.vx + fx) * damping;
      node.vy = (node.vy + fy) * damping;
    }

    for (final node in _nodes) {
      node.x = (node.x + node.vx).clamp(16.0, 284.0);
      node.y = (node.y + node.vy).clamp(16.0, 284.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: TextButton.icon(
            onPressed: () {
              setState(_initGraph);
            },
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Refresh'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ),
        ),
        Expanded(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return CustomPaint(
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                    painter: _ForceGraphPainter(
                      nodes: _nodes,
                      edges: _edges,
                      colorScheme: colorScheme,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ForceGraphPainter extends CustomPainter {
  const _ForceGraphPainter({
    required this.nodes,
    required this.edges,
    required this.colorScheme,
  });

  final List<_NodeState> nodes;
  final List<(int, int)> edges;
  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    // Scale node positions to canvas
    final scaleX = size.width / 300;
    final scaleY = size.height / 300;

    Offset nodeOffset(int id) {
      final n = nodes[id];
      return Offset(n.x * scaleX, n.y * scaleY);
    }

    // Edges
    final edgePaint = Paint()
      ..color = colorScheme.outlineVariant
      ..strokeWidth = 1.2;
    for (final (a, b) in edges) {
      canvas.drawLine(nodeOffset(a), nodeOffset(b), edgePaint);
    }

    // Nodes
    for (final node in nodes) {
      final center = nodeOffset(node.id);
      canvas.drawCircle(
          center, 12, Paint()..color = node.color.withValues(alpha: 0.85));
      canvas.drawCircle(
        center,
        12,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );

      final tp = TextPainter(
        text: TextSpan(
          text: '${node.id + 1}',
          style: const TextStyle(
              color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _ForceGraphPainter oldDelegate) => true;
}

// ---------------------------------------------------------------------------
// 4. Chord Diagram
// ---------------------------------------------------------------------------

class _ChordDiagram extends StatelessWidget {
  const _ChordDiagram();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _ChordPainter(colorScheme: colorScheme),
        );
      },
    );
  }
}

class _ChordPainter extends CustomPainter {
  const _ChordPainter({required this.colorScheme});

  final ColorScheme colorScheme;

  static const _products = [
    'Electronics',
    'Clothing',
    'Food',
    'Books',
    'Sports'
  ];

  // 5x5 symmetric flow matrix
  static const _matrix = [
    [0.0, 28.0, 12.0, 8.0, 15.0],
    [28.0, 0.0, 22.0, 18.0, 10.0],
    [12.0, 22.0, 0.0, 30.0, 5.0],
    [8.0, 18.0, 30.0, 0.0, 20.0],
    [15.0, 10.0, 5.0, 20.0, 0.0],
  ];

  static const _colors = [
    Color(0xFF3949AB), // indigo
    Color(0xFF00897B), // teal
    Color(0xFFEF6C00), // orange
    Color(0xFF6A1B9A), // purple
    Color(0xFFAD1457), // pink
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerRadius = math.min(cx, cy) - 40;
    final innerRadius = outerRadius - 18;

    // Total per group (sum of row)
    final totals = _matrix.map((row) => row.reduce((a, b) => a + b)).toList();
    final grandTotal = totals.reduce((a, b) => a + b);
    final anglePerUnit = (2 * math.pi) / grandTotal;
    const gap = 0.03;

    // Compute start angle for each group
    final startAngles = <double>[];
    var currentAngle = -math.pi / 2;
    for (var i = 0; i < 5; i++) {
      startAngles.add(currentAngle);
      currentAngle += totals[i] * anglePerUnit + gap;
    }

    // Draw chords first (behind arcs)
    for (var i = 0; i < 5; i++) {
      for (var j = i + 1; j < 5; j++) {
        final flow = _matrix[i][j];
        if (flow <= 0) continue;

        final angleI = startAngles[i] + (flow / 2) * anglePerUnit;
        final angleJ = startAngles[j] + (flow / 2) * anglePerUnit;

        final p1 = Offset(cx + innerRadius * math.cos(angleI),
            cy + innerRadius * math.sin(angleI));
        final p2 = Offset(cx + innerRadius * math.cos(angleJ),
            cy + innerRadius * math.sin(angleJ));

        final path = Path()
          ..moveTo(p1.dx, p1.dy)
          ..quadraticBezierTo(cx, cy, p2.dx, p2.dy)
          ..quadraticBezierTo(cx, cy, p1.dx, p1.dy)
          ..close();

        canvas.drawPath(
          path,
          Paint()..color = _colors[i].withValues(alpha: 0.25),
        );
      }
    }

    // Draw outer arcs
    for (var i = 0; i < 5; i++) {
      final startAngle = startAngles[i];
      final sweepAngle = totals[i] * anglePerUnit;

      final arcRect =
          Rect.fromCircle(center: Offset(cx, cy), radius: outerRadius);
      final innerRect =
          Rect.fromCircle(center: Offset(cx, cy), radius: innerRadius);

      final path = Path();
      path.moveTo(
        cx + outerRadius * math.cos(startAngle),
        cy + outerRadius * math.sin(startAngle),
      );
      path.arcTo(arcRect, startAngle, sweepAngle, false);
      path.lineTo(
        cx + innerRadius * math.cos(startAngle + sweepAngle),
        cy + innerRadius * math.sin(startAngle + sweepAngle),
      );
      path.arcTo(innerRect, startAngle + sweepAngle, -sweepAngle, false);
      path.close();

      canvas.drawPath(path, Paint()..color = _colors[i]);

      // Label
      final midAngle = startAngle + sweepAngle / 2;
      final labelRadius = outerRadius + 14;
      final lx = cx + labelRadius * math.cos(midAngle);
      final ly = cy + labelRadius * math.sin(midAngle);

      final tp = TextPainter(
        text: TextSpan(
          text: _products[i],
          style: TextStyle(color: colorScheme.onSurface, fontSize: 9),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(lx - tp.width / 2, ly - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _ChordPainter oldDelegate) =>
      oldDelegate.colorScheme != colorScheme;
}

// ---------------------------------------------------------------------------
// 5. Sankey Diagram
// ---------------------------------------------------------------------------

class _SankeyDiagram extends StatelessWidget {
  const _SankeyDiagram();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _SankeyPainter(colorScheme: colorScheme),
        );
      },
    );
  }
}

class _SankeyNode {
  final String label;
  final double value;
  final Color color;

  const _SankeyNode(this.label, this.value, this.color);
}

class _SankeyFlow {
  final int sourceCol;
  final int sourceIdx;
  final int targetCol;
  final int targetIdx;
  final double value;

  const _SankeyFlow(this.sourceCol, this.sourceIdx, this.targetCol,
      this.targetIdx, this.value);
}

class _SankeyPainter extends CustomPainter {
  const _SankeyPainter({required this.colorScheme});

  final ColorScheme colorScheme;

  static const _columns = [
    // Sources
    [
      _SankeyNode('Solar', 30, Color(0xFFFDD835)),
      _SankeyNode('Wind', 25, Color(0xFF42A5F5)),
      _SankeyNode('Coal', 35, Color(0xFF616161)),
      _SankeyNode('Gas', 20, Color(0xFFEF5350)),
    ],
    // Midpoint
    [
      _SankeyNode('Electric', 65, Color(0xFF5C6BC0)),
      _SankeyNode('Heat', 45, Color(0xFFEF6C00)),
    ],
    // End Uses
    [
      _SankeyNode('Industry', 40, Color(0xFF26A69A)),
      _SankeyNode('Transport', 25, Color(0xFFAB47BC)),
      _SankeyNode('Homes', 30, Color(0xFF66BB6A)),
      _SankeyNode('Office', 15, Color(0xFFFFCA28)),
    ],
  ];

  static const _flows = [
    _SankeyFlow(0, 0, 1, 0, 28), // Solar -> Electric
    _SankeyFlow(0, 1, 1, 0, 22), // Wind -> Electric
    _SankeyFlow(0, 2, 1, 0, 15), // Coal -> Electric
    _SankeyFlow(0, 2, 1, 1, 20), // Coal -> Heat
    _SankeyFlow(0, 3, 1, 1, 18), // Gas -> Heat
    _SankeyFlow(1, 0, 2, 0, 25), // Electric -> Industry
    _SankeyFlow(1, 0, 2, 1, 20), // Electric -> Transport
    _SankeyFlow(1, 0, 2, 3, 12), // Electric -> Office
    _SankeyFlow(1, 1, 2, 2, 28), // Heat -> Homes
    _SankeyFlow(1, 1, 2, 0, 10), // Heat -> Industry
  ];

  @override
  void paint(Canvas canvas, Size size) {
    const margin = EdgeInsets.fromLTRB(8, 8, 8, 8);
    final w = size.width - margin.left - margin.right;
    final h = size.height - margin.top - margin.bottom;

    const nodeWidth = 14.0;
    const nodeGap = 8.0;
    const numCols = 3;

    // Column x positions
    final colX = List.generate(
        numCols, (i) => margin.left + (i * (w - nodeWidth) / (numCols - 1)));

    // Compute node heights (proportional to value, fit in column)
    List<List<Rect>> nodeRects = [];
    for (var col = 0; col < numCols; col++) {
      final nodes = _columns[col];
      final totalValue = nodes.fold(0.0, (sum, n) => sum + n.value);
      final totalGap = nodeGap * (nodes.length - 1);
      final availH = h - totalGap;

      var y = margin.top.toDouble();
      final rects = <Rect>[];
      for (final node in nodes) {
        final nodeH = (node.value / totalValue) * availH;
        rects.add(Rect.fromLTWH(colX[col], y, nodeWidth, nodeH));
        y += nodeH + nodeGap;
      }
      nodeRects.add(rects);
    }

    // Draw flows
    for (final flow in _flows) {
      final srcRect = nodeRects[flow.sourceCol][flow.sourceIdx];
      final dstRect = nodeRects[flow.targetCol][flow.targetIdx];

      final srcNode = _columns[flow.sourceCol][flow.sourceIdx];
      final dstNode = _columns[flow.targetCol][flow.targetIdx];
      final srcTotal = _columns[flow.sourceCol][flow.sourceIdx].value;
      final dstTotal = _columns[flow.targetCol][flow.targetIdx].value;

      // Flow height proportional to value
      final srcFlowH = (flow.value / srcTotal) * srcRect.height;
      final dstFlowH = (flow.value / dstTotal) * dstRect.height;

      final x0 = srcRect.right;
      final y0 = srcRect.top + srcRect.height / 2 - srcFlowH / 2;
      final x1 = dstRect.left;
      final y1 = dstRect.top + dstRect.height / 2 - dstFlowH / 2;

      final path = Path()
        ..moveTo(x0, y0)
        ..cubicTo(
          x0 + (x1 - x0) * 0.5,
          y0,
          x0 + (x1 - x0) * 0.5,
          y1,
          x1,
          y1,
        )
        ..lineTo(x1, y1 + dstFlowH)
        ..cubicTo(
          x0 + (x1 - x0) * 0.5,
          y0 + srcFlowH,
          x0 + (x1 - x0) * 0.5,
          y0 + srcFlowH,
          x0,
          y0 + srcFlowH,
        )
        ..close();

      canvas.drawPath(
        path,
        Paint()
          ..shader = LinearGradient(
            colors: [
              srcNode.color.withValues(alpha: 0.4),
              dstNode.color.withValues(alpha: 0.4),
            ],
          ).createShader(Rect.fromLTRB(x0, y0, x1, y1 + dstFlowH)),
      );
    }

    // Draw nodes
    for (var col = 0; col < numCols; col++) {
      final nodes = _columns[col];
      for (var i = 0; i < nodes.length; i++) {
        final rect = nodeRects[col][i];
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(2)),
          Paint()..color = nodes[i].color,
        );

        // Label
        final labelOnLeft = col == 0;
        final labelOnRight = col == numCols - 1;
        final lx = labelOnLeft
            ? rect.left - 4
            : labelOnRight
                ? rect.right + 4
                : rect.left + rect.width / 2;

        final tp = TextPainter(
          text: TextSpan(
            text: nodes[i].label,
            style: TextStyle(color: colorScheme.onSurface, fontSize: 8),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        double paintX;
        if (labelOnLeft) {
          paintX = lx - tp.width;
        } else if (labelOnRight) {
          paintX = lx;
        } else {
          paintX = lx - tp.width / 2;
        }

        tp.paint(canvas, Offset(paintX, rect.center.dy - tp.height / 2));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SankeyPainter oldDelegate) =>
      oldDelegate.colorScheme != colorScheme;
}

// ---------------------------------------------------------------------------
// 6. Delaunay / Voronoi
// ---------------------------------------------------------------------------

enum _DvMode { voronoi, delaunay, both }

class _DelaunayVoronoi extends StatefulWidget {
  const _DelaunayVoronoi();

  @override
  State<_DelaunayVoronoi> createState() => _DelaunayVoronoiState();
}

class _DelaunayVoronoiState extends State<_DelaunayVoronoi> {
  late List<dv.Point> _points;
  _DvMode _mode = _DvMode.both;

  @override
  void initState() {
    super.initState();
    _regenerate();
  }

  void _regenerate() {
    final rng = math.Random();
    _points = List.generate(
        25,
        (_) => dv.Point(
              0.05 + rng.nextDouble() * 0.9,
              0.05 + rng.nextDouble() * 0.9,
            ));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SegmentedButton<_DvMode>(
                segments: const [
                  ButtonSegment(value: _DvMode.voronoi, label: Text('Voronoi')),
                  ButtonSegment(
                      value: _DvMode.delaunay, label: Text('Delaunay')),
                  ButtonSegment(value: _DvMode.both, label: Text('Both')),
                ],
                selected: {_mode},
                onSelectionChanged: (s) => setState(() => _mode = s.first),
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => setState(_regenerate),
              tooltip: 'Regenerate points',
            ),
          ],
        ),
        const SizedBox(height: 4),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _DvPainter(
                  points: _points,
                  mode: _mode,
                  colorScheme: colorScheme,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DvPainter extends CustomPainter {
  const _DvPainter({
    required this.points,
    required this.mode,
    required this.colorScheme,
  });

  final List<dv.Point> points;
  final _DvMode mode;
  final ColorScheme colorScheme;

  Offset _toCanvas(dv.Point p, Size size) =>
      Offset(p.x * size.width, p.y * size.height);

  /// Returns indices of the k nearest neighbors for point at [idx].
  List<int> _nearestNeighbors(int idx, int k) {
    final src = points[idx];
    final distances = <(double, int)>[];
    for (var i = 0; i < points.length; i++) {
      if (i == idx) continue;
      final dx = points[i].x - src.x;
      final dy = points[i].y - src.y;
      distances.add((dx * dx + dy * dy, i));
    }
    distances.sort((a, b) => a.$1.compareTo(b.$1));
    return distances.take(k).map((e) => e.$2).toList();
  }

  /// Returns the perpendicular bisector segment between points a and b,
  /// clipped to [0,1]x[0,1].
  List<Offset>? _bisectorSegment(dv.Point a, dv.Point b, Size size) {
    final mx = (a.x + b.x) / 2;
    final my = (a.y + b.y) / 2;
    final dx = b.x - a.x;
    final dy = b.y - a.y;

    // Perpendicular direction
    final px = -dy;
    final py = dx;

    if (px.abs() < 1e-10 && py.abs() < 1e-10) return null;

    // Parameterize line: (mx + t*px, my + t*py)
    // Find t range such that both coords stay in [0,1]
    double tMin = -double.infinity;
    double tMax = double.infinity;

    void constrain(double origin, double dir) {
      if (dir.abs() < 1e-10) return;
      final t0 = (0 - origin) / dir;
      final t1 = (1 - origin) / dir;
      if (dir > 0) {
        if (t0 > tMin) tMin = t0;
        if (t1 < tMax) tMax = t1;
      } else {
        if (t1 > tMin) tMin = t1;
        if (t0 < tMax) tMax = t0;
      }
    }

    constrain(mx, px);
    constrain(my, py);

    if (tMin >= tMax) return null;

    // Limit segment length
    final tRange = (tMax - tMin).clamp(0.0, 0.5);
    final tMid = (tMin + tMax) / 2;
    final tA = tMid - tRange / 2;
    final tB = tMid + tRange / 2;

    final p1 = dv.Point(mx + tA * px, my + tA * py);
    final p2 = dv.Point(mx + tB * px, my + tB * py);

    return [
      Offset(p1.x * size.width, p1.y * size.height),
      Offset(p2.x * size.width, p2.y * size.height),
    ];
  }

  @override
  void paint(Canvas canvas, Size size) {
    final delaunayPaint = Paint()
      ..color = colorScheme.primary.withValues(alpha: 0.6)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final voronoiPaint = Paint()
      ..color = colorScheme.tertiary.withValues(alpha: 0.5)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Delaunay: k-nearest-neighbor graph (k=3)
    if (mode == _DvMode.delaunay || mode == _DvMode.both) {
      final drawn = <(int, int)>{};
      for (var i = 0; i < points.length; i++) {
        final neighbors = _nearestNeighbors(i, 3);
        for (final j in neighbors) {
          final key = i < j ? (i, j) : (j, i);
          if (drawn.contains(key)) continue;
          drawn.add(key);
          canvas.drawLine(
            _toCanvas(points[i], size),
            _toCanvas(points[j], size),
            delaunayPaint,
          );
        }
      }
    }

    // Voronoi: perpendicular bisectors between connected pairs
    if (mode == _DvMode.voronoi || mode == _DvMode.both) {
      final connected = <(int, int)>{};
      for (var i = 0; i < points.length; i++) {
        final neighbors = _nearestNeighbors(i, 3);
        for (final j in neighbors) {
          final key = i < j ? (i, j) : (j, i);
          connected.add(key);
        }
      }
      for (final (a, b) in connected) {
        final seg = _bisectorSegment(points[a], points[b], size);
        if (seg != null) {
          canvas.drawLine(seg[0], seg[1], voronoiPaint);
        }
      }
    }

    // Points
    final ptPaint = Paint()..color = colorScheme.secondary;
    for (final p in points) {
      canvas.drawCircle(_toCanvas(p, size), 4, ptPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _DvPainter old) =>
      old.points != points ||
      old.mode != mode ||
      old.colorScheme != colorScheme;
}
