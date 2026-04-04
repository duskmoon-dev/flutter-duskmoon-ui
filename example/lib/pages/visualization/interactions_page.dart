import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:duskmoon_visualization/duskmoon_visualization_compat.dart'
    as dv;

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------

class InteractionsPage extends StatelessWidget {
  const InteractionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chart Interactions')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Interactive chart demonstrations',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Hover, brush, zoom, scale comparisons, and a word-cloud built with the DuskMoon compat layer.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          const _ChartCard(
            title: 'Interactive Hover Chart',
            description: 'Hover/tap to inspect individual data points.',
            height: 300,
            child: _HoverChart(),
          ),
          const SizedBox(height: 16),
          const _ChartCard(
            title: 'Brush Selection',
            description: 'Drag to select a region of data points.',
            height: 300,
            child: _BrushChart(),
          ),
          const SizedBox(height: 16),
          const _ChartCard(
            title: 'Zoom & Pan',
            description: 'Pinch to zoom and drag to pan the chart view.',
            height: 300,
            child: _ZoomPanChart(),
          ),
          const SizedBox(height: 16),
          const _ChartCard(
            title: 'Scale Types',
            description:
                'Demonstration of linear, log, power, and band scales.',
            height: 320,
            child: _ScaleTypesChart(),
          ),
          const SizedBox(height: 16),
          const _ChartCard(
            title: 'Word Cloud',
            description: 'Tag cloud with spiral placement algorithm.',
            height: 300,
            child: _WordCloud(),
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
// 1. Interactive Hover Chart
// ---------------------------------------------------------------------------

class _HoverChart extends StatefulWidget {
  const _HoverChart();

  @override
  State<_HoverChart> createState() => _HoverChartState();
}

class _HoverChartState extends State<_HoverChart> {
  static const _margin = EdgeInsets.fromLTRB(48, 20, 20, 36);

  int? _hoveredIndex;
  dv.Point? _tooltipPos;

  final List<dv.Point> _data = List.generate(15, (i) {
    final rng = math.Random(i + 7);
    return dv.Point(
      i.toDouble(),
      30 + 40 * math.sin(i * 0.45) + rng.nextDouble() * 15,
    );
  });

  void _handleProbe(Offset pos, Size size) {
    final cw = size.width - _margin.left - _margin.right;
    final ch = size.height - _margin.top - _margin.bottom - 44;
    if (cw <= 0 || ch <= 0) return;

    final yMax = _data.map((p) => p.y).reduce(math.max);
    final xScale = dv.scaleLinear(
      domain: [0.0, (_data.length - 1).toDouble()],
      range: [_margin.left, _margin.left + cw],
    );
    final yScale = dv.scaleLinear(
      domain: [0.0, yMax * 1.15],
      range: [_margin.top + ch, _margin.top],
    );

    int? closest;
    var minDist = 28.0;
    for (var i = 0; i < _data.length; i++) {
      final ox = xScale(_data[i].x);
      final oy = yScale(_data[i].y);
      final d = math.sqrt(math.pow(pos.dx - ox, 2) + math.pow(pos.dy - oy, 2));
      if (d < minDist) {
        minDist = d;
        closest = i;
      }
    }

    setState(() {
      _hoveredIndex = closest;
      _tooltipPos = closest == null
          ? null
          : dv.Point(xScale(_data[closest].x), yScale(_data[closest].y));
    });
  }

  void _clearHover() {
    if (_hoveredIndex == null) return;
    setState(() {
      _hoveredIndex = null;
      _tooltipPos = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusText = _hoveredIndex == null
        ? 'Hover or tap a point to inspect its value.'
        : 'Point ${_hoveredIndex! + 1}: y = ${_data[_hoveredIndex!].y.toStringAsFixed(1)}';

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final chartSize =
                  Size(constraints.maxWidth, constraints.maxHeight);
              return MouseRegion(
                onHover: (e) => _handleProbe(e.localPosition, chartSize),
                onExit: (_) => _clearHover(),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (d) => _handleProbe(d.localPosition, chartSize),
                  onPanUpdate: (d) => _handleProbe(d.localPosition, chartSize),
                  onPanEnd: (_) => _clearHover(),
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: chartSize,
                        painter: _HoverChartPainter(
                          data: _data,
                          hoveredIndex: _hoveredIndex,
                          colorScheme: colorScheme,
                        ),
                      ),
                      if (_hoveredIndex != null && _tooltipPos != null)
                        Positioned(
                          left: (_tooltipPos!.x - 44)
                              .clamp(0.0, chartSize.width - 90),
                          top:
                              (_tooltipPos!.y - 52).clamp(0.0, double.infinity),
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.inverseSurface,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Point ${_hoveredIndex! + 1}',
                                    style: TextStyle(
                                      color: colorScheme.onInverseSurface,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    _data[_hoveredIndex!].y.toStringAsFixed(1),
                                    style: TextStyle(
                                      color: colorScheme.onInverseSurface,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            statusText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
          ),
        ),
      ],
    );
  }
}

class _HoverChartPainter extends CustomPainter {
  const _HoverChartPainter({
    required this.data,
    required this.hoveredIndex,
    required this.colorScheme,
  });

  final List<dv.Point> data;
  final int? hoveredIndex;
  final ColorScheme colorScheme;

  static const _margin = EdgeInsets.fromLTRB(48, 20, 20, 36);

  @override
  void paint(Canvas canvas, Size size) {
    final cw = size.width - _margin.left - _margin.right;
    final ch = size.height - _margin.top - _margin.bottom - 44;
    if (cw <= 0 || ch <= 0) return;

    final yMax = data.map((p) => p.y).reduce(math.max);
    final xScale = dv.scaleLinear(
      domain: [0.0, (data.length - 1).toDouble()],
      range: [_margin.left, _margin.left + cw],
    );
    final yScale = dv.scaleLinear(
      domain: [0.0, yMax * 1.15],
      range: [_margin.top + ch, _margin.top],
    );

    // Grid
    final gridPaint = Paint()
      ..color = colorScheme.outlineVariant
      ..strokeWidth = 0.5;
    for (var i = 0; i <= 4; i++) {
      final y = yScale(yMax * 1.15 * i / 4);
      canvas.drawLine(
          Offset(_margin.left, y), Offset(_margin.left + cw, y), gridPaint);
    }

    // Area fill
    final areaPath = Path()..moveTo(xScale(0), yScale(0));
    for (final pt in data) {
      areaPath.lineTo(xScale(pt.x), yScale(pt.y));
    }
    areaPath
      ..lineTo(xScale(data.last.x), yScale(0))
      ..close();
    canvas.drawPath(
      areaPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.primary.withValues(alpha: 0.3),
            colorScheme.primary.withValues(alpha: 0.02),
          ],
        ).createShader(
          Rect.fromLTWH(_margin.left, _margin.top, cw, ch),
        ),
    );

    // Line
    final linePath = Path();
    for (var i = 0; i < data.length; i++) {
      final o = Offset(xScale(data[i].x), yScale(data[i].y));
      if (i == 0) {
        linePath.moveTo(o.dx, o.dy);
      } else {
        linePath.lineTo(o.dx, o.dy);
      }
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = colorScheme.primary
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Points
    for (var i = 0; i < data.length; i++) {
      final o = Offset(xScale(data[i].x), yScale(data[i].y));
      final isHovered = i == hoveredIndex;
      final radius = isHovered ? 7.0 : 4.5;
      canvas.drawCircle(o, radius, Paint()..color = colorScheme.surface);
      canvas.drawCircle(
        o,
        radius,
        Paint()
          ..color = isHovered ? colorScheme.tertiary : colorScheme.primary
          ..style = PaintingStyle.stroke
          ..strokeWidth = isHovered ? 2.5 : 1.8,
      );
      if (isHovered) {
        canvas.drawCircle(o, 3, Paint()..color = colorScheme.tertiary);
      }
    }

    // Y axis labels
    final axisStyle = TextStyle(
      color: colorScheme.onSurfaceVariant,
      fontSize: 9,
    );
    for (var i = 0; i <= 4; i++) {
      final val = (yMax * 1.15 * i / 4).toStringAsFixed(0);
      final y = yScale(yMax * 1.15 * i / 4);
      _paintText(canvas, val, Offset(_margin.left - 4, y), axisStyle,
          rightAlign: true);
    }

    // X axis labels
    for (var i = 0; i < data.length; i += 3) {
      final x = xScale(data[i].x);
      _paintText(canvas, '${i + 1}', Offset(x, _margin.top + ch + 4), axisStyle,
          centerAlign: true);
    }
  }

  void _paintText(Canvas canvas, String text, Offset o, TextStyle style,
      {bool rightAlign = false, bool centerAlign = false}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: 60);
    double dx;
    if (rightAlign) {
      dx = o.dx - tp.width;
    } else if (centerAlign) {
      dx = o.dx - tp.width / 2;
    } else {
      dx = o.dx;
    }
    tp.paint(canvas, Offset(dx, o.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _HoverChartPainter old) =>
      old.hoveredIndex != hoveredIndex || old.colorScheme != colorScheme;
}

// ---------------------------------------------------------------------------
// 2. Brush Selection
// ---------------------------------------------------------------------------

class _BrushChart extends StatefulWidget {
  const _BrushChart();

  @override
  State<_BrushChart> createState() => _BrushChartState();
}

class _BrushChartState extends State<_BrushChart> {
  static const _margin = EdgeInsets.fromLTRB(12, 12, 12, 12);

  final List<dv.Point> _points = List.generate(80, (i) {
    final rng = math.Random(i + 99);
    return dv.Point(rng.nextDouble(), rng.nextDouble());
  });

  Offset? _brushStart;
  Offset? _brushEnd;
  Size _canvasSize = Size.zero;

  Rect? get _brushRect {
    if (_brushStart == null || _brushEnd == null) return null;
    return Rect.fromPoints(_brushStart!, _brushEnd!);
  }

  bool _inBrush(dv.Point p) {
    final rect = _brushRect;
    if (rect == null || _canvasSize == Size.zero) return false;
    final xScale = dv.scaleLinear(
      domain: [0.0, 1.0],
      range: [_margin.left, _canvasSize.width - _margin.right],
    );
    final yScale = dv.scaleLinear(
      domain: [0.0, 1.0],
      range: [_canvasSize.height - _margin.bottom, _margin.top],
    );
    return rect.contains(Offset(xScale(p.x), yScale(p.y)));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedCount = _points.where(_inBrush).length;

    return Column(
      children: [
        Row(
          children: [
            Text(
              _brushRect == null
                  ? 'Drag to select points'
                  : '$selectedCount of ${_points.length} selected',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Spacer(),
            if (_brushRect != null)
              TextButton(
                onPressed: () => setState(() {
                  _brushStart = null;
                  _brushEnd = null;
                }),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Clear'),
              ),
          ],
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              _canvasSize = Size(constraints.maxWidth, constraints.maxHeight);
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanStart: (d) => setState(() {
                  _brushStart = d.localPosition;
                  _brushEnd = d.localPosition;
                }),
                onPanUpdate: (d) => setState(() => _brushEnd = d.localPosition),
                onPanEnd: (_) {},
                child: CustomPaint(
                  size: _canvasSize,
                  painter: _BrushPainter(
                    points: _points,
                    brushRect: _brushRect,
                    colorScheme: colorScheme,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BrushPainter extends CustomPainter {
  const _BrushPainter({
    required this.points,
    required this.brushRect,
    required this.colorScheme,
  });

  final List<dv.Point> points;
  final Rect? brushRect;
  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    const m = EdgeInsets.fromLTRB(12, 12, 12, 12);
    final xScale = dv.scaleLinear(
      domain: [0.0, 1.0],
      range: [m.left, size.width - m.right],
    );
    final yScale = dv.scaleLinear(
      domain: [0.0, 1.0],
      range: [size.height - m.bottom, m.top],
    );

    // Background
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = colorScheme.surfaceContainerLowest,
    );

    for (final p in points) {
      final ox = xScale(p.x);
      final oy = yScale(p.y);
      final inside = brushRect != null && brushRect!.contains(Offset(ox, oy));

      canvas.drawCircle(
        Offset(ox, oy),
        inside ? 5.5 : 3.5,
        Paint()
          ..color = inside
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
      );
    }

    if (brushRect != null) {
      canvas.drawRect(
        brushRect!,
        Paint()
          ..color = colorScheme.primary.withValues(alpha: 0.15)
          ..style = PaintingStyle.fill,
      );
      canvas.drawRect(
        brushRect!,
        Paint()
          ..color = colorScheme.primary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BrushPainter old) =>
      old.brushRect != brushRect || old.colorScheme != colorScheme;
}

// ---------------------------------------------------------------------------
// 3. Zoom & Pan
// ---------------------------------------------------------------------------

class _ZoomPanChart extends StatefulWidget {
  const _ZoomPanChart();

  @override
  State<_ZoomPanChart> createState() => _ZoomPanChartState();
}

class _ZoomPanChartState extends State<_ZoomPanChart> {
  static const _margin = EdgeInsets.fromLTRB(8, 8, 8, 8);

  double _scale = 1.0;
  Offset _translate = Offset.zero;
  Offset? _lastPanPos;

  final List<dv.Point> _points = List.generate(50, (i) {
    final rng = math.Random(i + 200);
    return dv.Point(rng.nextDouble() * 100, rng.nextDouble() * 100);
  });

  void _zoom(double factor, Size size) {
    setState(() {
      _scale = (_scale * factor).clamp(0.5, 6.0);
    });
  }

  void _reset() {
    setState(() {
      _scale = 1.0;
      _translate = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.zoom_in),
              onPressed: () => _zoom(1.3, const Size(300, 200)),
              tooltip: 'Zoom In',
              iconSize: 20,
            ),
            IconButton(
              icon: const Icon(Icons.zoom_out),
              onPressed: () => _zoom(1 / 1.3, const Size(300, 200)),
              tooltip: 'Zoom Out',
              iconSize: 20,
            ),
            IconButton(
              icon: const Icon(Icons.fit_screen),
              onPressed: _reset,
              tooltip: 'Reset',
              iconSize: 20,
            ),
            const Spacer(),
            Text(
              '${(_scale * 100).toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = Size(constraints.maxWidth, constraints.maxHeight);
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanStart: (d) => _lastPanPos = d.localPosition,
                onPanUpdate: (d) {
                  setState(() {
                    if (_lastPanPos != null) {
                      _translate += d.localPosition - _lastPanPos!;
                    }
                    _lastPanPos = d.localPosition;
                  });
                },
                onPanEnd: (_) => _lastPanPos = null,
                onScaleUpdate: (d) {
                  if (d.scale != 1.0) {
                    setState(() {
                      _scale = (_scale * d.scale).clamp(0.5, 6.0);
                    });
                  }
                },
                child: CustomPaint(
                  size: size,
                  painter: _ZoomPanPainter(
                    points: _points,
                    scale: _scale,
                    translate: _translate,
                    margin: _margin,
                    colorScheme: colorScheme,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ZoomPanPainter extends CustomPainter {
  const _ZoomPanPainter({
    required this.points,
    required this.scale,
    required this.translate,
    required this.margin,
    required this.colorScheme,
  });

  final List<dv.Point> points;
  final double scale;
  final Offset translate;
  final EdgeInsets margin;
  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    final cw = size.width - margin.left - margin.right;
    final ch = size.height - margin.top - margin.bottom;

    // Clip to chart area
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(margin.left, margin.top, cw, ch));

    // Background
    canvas.drawRect(
      Rect.fromLTWH(margin.left, margin.top, cw, ch),
      Paint()..color = colorScheme.surfaceContainerLowest,
    );

    // Zoomed/panned coordinate system
    final cx = margin.left + cw / 2 + translate.dx;
    final cy = margin.top + ch / 2 + translate.dy;
    final xScale = dv.scaleLinear(
      domain: [0.0, 100.0],
      range: [cx - (cw / 2) * scale, cx + (cw / 2) * scale],
    );
    final yScale = dv.scaleLinear(
      domain: [0.0, 100.0],
      range: [cy + (ch / 2) * scale, cy - (ch / 2) * scale],
    );

    // Grid
    final gridPaint = Paint()
      ..color = colorScheme.outlineVariant
      ..strokeWidth = 0.5;
    for (var i = 0; i <= 10; i++) {
      final x = xScale(i * 10.0);
      if (x >= margin.left && x <= margin.left + cw) {
        canvas.drawLine(
          Offset(x, margin.top),
          Offset(x, margin.top + ch),
          gridPaint,
        );
      }
      final y = yScale(i * 10.0);
      if (y >= margin.top && y <= margin.top + ch) {
        canvas.drawLine(
          Offset(margin.left, y),
          Offset(margin.left + cw, y),
          gridPaint,
        );
      }
    }

    // Points
    for (final p in points) {
      final ox = xScale(p.x);
      final oy = yScale(p.y);
      canvas.drawCircle(
        Offset(ox, oy),
        4,
        Paint()..color = colorScheme.primary.withValues(alpha: 0.75),
      );
    }

    canvas.restore();

    // Minimap (top-right corner)
    const minimapSize = Size(60, 48);
    final minimapLeft = size.width - minimapSize.width - 8;
    const minimapTop = 8.0;
    final minimapRect = Rect.fromLTWH(
        minimapLeft, minimapTop, minimapSize.width, minimapSize.height);

    canvas.drawRect(
      minimapRect,
      Paint()..color = colorScheme.surfaceContainer.withValues(alpha: 0.9),
    );
    canvas.drawRect(
      minimapRect,
      Paint()
        ..color = colorScheme.outline
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    final miniXScale = dv.scaleLinear(
        domain: [0.0, 100.0],
        range: [minimapLeft + 2, minimapLeft + minimapSize.width - 2]);
    final miniYScale = dv.scaleLinear(
        domain: [0.0, 100.0],
        range: [minimapTop + minimapSize.height - 2, minimapTop + 2]);

    for (final p in points) {
      canvas.drawCircle(
        Offset(miniXScale(p.x), miniYScale(p.y)),
        1,
        Paint()..color = colorScheme.primary.withValues(alpha: 0.6),
      );
    }

    // Viewport indicator in minimap
    final vpW = minimapSize.width / scale;
    final vpH = minimapSize.height / scale;
    final vpLeft = minimapLeft +
        (minimapSize.width - vpW) / 2 -
        translate.dx * minimapSize.width / cw / scale;
    final vpTop = minimapTop +
        (minimapSize.height - vpH) / 2 -
        translate.dy * minimapSize.height / ch / scale;

    canvas.drawRect(
      Rect.fromLTWH(
        vpLeft.clamp(minimapLeft, minimapLeft + minimapSize.width - vpW),
        vpTop.clamp(minimapTop, minimapTop + minimapSize.height - vpH),
        vpW.clamp(2, minimapSize.width),
        vpH.clamp(2, minimapSize.height),
      ),
      Paint()
        ..color = colorScheme.tertiary.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(covariant _ZoomPanPainter old) =>
      old.scale != scale ||
      old.translate != translate ||
      old.colorScheme != colorScheme;
}

// ---------------------------------------------------------------------------
// 4. Scale Types
// ---------------------------------------------------------------------------

class _ScaleTypesChart extends StatelessWidget {
  const _ScaleTypesChart();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final cellW = w / 2;
        final cellH = h / 2;

        return Stack(
          children: [
            // Linear
            Positioned(
              left: 0,
              top: 0,
              width: cellW,
              height: cellH,
              child: _ScaleSubChart(
                label: 'Linear',
                colorScheme: colorScheme,
                painter: _LinearSubPainter(colorScheme: colorScheme),
              ),
            ),
            // Log
            Positioned(
              left: cellW,
              top: 0,
              width: cellW,
              height: cellH,
              child: _ScaleSubChart(
                label: 'Logarithmic',
                colorScheme: colorScheme,
                painter: _LogSubPainter(colorScheme: colorScheme),
              ),
            ),
            // Power
            Positioned(
              left: 0,
              top: cellH,
              width: cellW,
              height: cellH,
              child: _ScaleSubChart(
                label: 'Power (x²)',
                colorScheme: colorScheme,
                painter: _PowerSubPainter(colorScheme: colorScheme),
              ),
            ),
            // Band
            Positioned(
              left: cellW,
              top: cellH,
              width: cellW,
              height: cellH,
              child: _ScaleSubChart(
                label: 'Band',
                colorScheme: colorScheme,
                painter: _BandSubPainter(colorScheme: colorScheme),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ScaleSubChart extends StatelessWidget {
  const _ScaleSubChart({
    required this.label,
    required this.colorScheme,
    required this.painter,
  });

  final String label;
  final ColorScheme colorScheme;
  final CustomPainter painter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: painter,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LinearSubPainter extends CustomPainter {
  const _LinearSubPainter({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    const m = EdgeInsets.fromLTRB(24, 4, 8, 20);
    final w = size.width - m.left - m.right;
    final h = size.height - m.top - m.bottom;

    final xScale =
        dv.scaleLinear(domain: [0.0, 100.0], range: [m.left, m.left + w]);
    final yScale =
        dv.scaleLinear(domain: [0.0, 100.0], range: [m.top + h, m.top]);

    _drawAxes(canvas, size, m, colorScheme);

    final path = Path()..moveTo(xScale(0), yScale(0));
    for (var i = 1; i <= 100; i++) {
      path.lineTo(xScale(i.toDouble()), yScale(i.toDouble()));
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = colorScheme.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    // Labels
    final style = TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 8);
    for (var i = 0; i <= 2; i++) {
      final v = i * 50.0;
      _paintLabel(
          canvas, v.toStringAsFixed(0), Offset(m.left - 2, yScale(v)), style,
          rightAlign: true);
      _paintLabel(
          canvas, v.toStringAsFixed(0), Offset(xScale(v), m.top + h + 2), style,
          centerAlign: true);
    }
  }

  @override
  bool shouldRepaint(covariant _LinearSubPainter old) =>
      old.colorScheme != colorScheme;
}

class _LogSubPainter extends CustomPainter {
  const _LogSubPainter({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    const m = EdgeInsets.fromLTRB(24, 4, 8, 20);
    final w = size.width - m.left - m.right;
    final h = size.height - m.top - m.bottom;

    final xScale =
        dv.scaleLinear(domain: [1.0, 100.0], range: [m.left, m.left + w]);
    final yMax = math.log(100) / math.ln10;
    final yScale =
        dv.scaleLinear(domain: [0.0, yMax], range: [m.top + h, m.top]);

    _drawAxes(canvas, size, m, colorScheme);

    final path = Path();
    var first = true;
    for (var i = 1; i <= 100; i++) {
      final y = math.log(i.toDouble()) / math.ln10;
      final o = Offset(xScale(i.toDouble()), yScale(y));
      if (first) {
        path.moveTo(o.dx, o.dy);
        first = false;
      } else {
        path.lineTo(o.dx, o.dy);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = colorScheme.secondary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    final style = TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 8);
    for (final v in [1, 10, 100]) {
      _paintLabel(
          canvas,
          'e${v == 1 ? '0' : v == 10 ? '1' : '2'}',
          Offset(m.left - 2, yScale(math.log(v.toDouble()) / math.ln10)),
          style,
          rightAlign: true);
      _paintLabel(
          canvas, '$v', Offset(xScale(v.toDouble()), m.top + h + 2), style,
          centerAlign: true);
    }
  }

  @override
  bool shouldRepaint(covariant _LogSubPainter old) =>
      old.colorScheme != colorScheme;
}

class _PowerSubPainter extends CustomPainter {
  const _PowerSubPainter({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    const m = EdgeInsets.fromLTRB(28, 4, 8, 20);
    final w = size.width - m.left - m.right;
    final h = size.height - m.top - m.bottom;

    final xScale =
        dv.scaleLinear(domain: [0.0, 10.0], range: [m.left, m.left + w]);
    final yScale =
        dv.scaleLinear(domain: [0.0, 100.0], range: [m.top + h, m.top]);

    _drawAxes(canvas, size, m, colorScheme);

    final path = Path();
    for (var i = 0; i <= 100; i++) {
      final x = i / 10.0;
      final y = x * x;
      final o = Offset(xScale(x), yScale(y));
      if (i == 0) {
        path.moveTo(o.dx, o.dy);
      } else {
        path.lineTo(o.dx, o.dy);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = colorScheme.tertiary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    final style = TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 8);
    for (final v in [0, 50, 100]) {
      _paintLabel(canvas, '$v', Offset(m.left - 2, yScale(v.toDouble())), style,
          rightAlign: true);
    }
    for (final v in [0, 5, 10]) {
      _paintLabel(
          canvas, '$v', Offset(xScale(v.toDouble()), m.top + h + 2), style,
          centerAlign: true);
    }
  }

  @override
  bool shouldRepaint(covariant _PowerSubPainter old) =>
      old.colorScheme != colorScheme;
}

class _BandSubPainter extends CustomPainter {
  const _BandSubPainter({required this.colorScheme});

  final ColorScheme colorScheme;

  static const _cats = ['A', 'B', 'C', 'D', 'E', 'F'];
  static const _vals = [42.0, 68.0, 35.0, 80.0, 55.0, 63.0];

  @override
  void paint(Canvas canvas, Size size) {
    const m = EdgeInsets.fromLTRB(28, 4, 8, 20);
    final w = size.width - m.left - m.right;
    final h = size.height - m.top - m.bottom;

    final xScale = dv.scaleBand<String>(
      domain: _cats,
      range: [m.left, m.left + w],
      paddingInner: 0.2,
      paddingOuter: 0.1,
    );
    final yScale =
        dv.scaleLinear(domain: [0.0, 100.0], range: [m.top + h, m.top]);

    _drawAxes(canvas, size, m, colorScheme);

    for (var i = 0; i < _cats.length; i++) {
      final x = xScale(_cats[i]);
      final y = yScale(_vals[i]);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, xScale.bandwidth, m.top + h - y),
          const Radius.circular(2),
        ),
        Paint()..color = colorScheme.primary.withValues(alpha: 0.75),
      );
      final style = TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 8);
      _paintLabel(canvas, _cats[i],
          Offset(x + xScale.bandwidth / 2, m.top + h + 2), style,
          centerAlign: true);
    }

    final style = TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 8);
    for (final v in [0, 50, 100]) {
      _paintLabel(canvas, '$v', Offset(m.left - 2, yScale(v.toDouble())), style,
          rightAlign: true);
    }
  }

  @override
  bool shouldRepaint(covariant _BandSubPainter old) =>
      old.colorScheme != colorScheme;
}

void _drawAxes(
    Canvas canvas, Size size, EdgeInsets m, ColorScheme colorScheme) {
  final axisPaint = Paint()
    ..color = colorScheme.outline
    ..strokeWidth = 1;
  final h = size.height - m.top - m.bottom;
  final w = size.width - m.left - m.right;
  canvas.drawLine(Offset(m.left, m.top), Offset(m.left, m.top + h), axisPaint);
  canvas.drawLine(
      Offset(m.left, m.top + h), Offset(m.left + w, m.top + h), axisPaint);
}

void _paintLabel(Canvas canvas, String text, Offset o, TextStyle style,
    {bool rightAlign = false, bool centerAlign = false}) {
  final tp = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: 50);
  double dx;
  if (rightAlign) {
    dx = o.dx - tp.width;
  } else if (centerAlign) {
    dx = o.dx - tp.width / 2;
  } else {
    dx = o.dx;
  }
  tp.paint(canvas, Offset(dx, o.dy - tp.height / 2));
}

// ---------------------------------------------------------------------------
// 5. Word Cloud
// ---------------------------------------------------------------------------

class _WordCloud extends StatelessWidget {
  const _WordCloud();

  static const _words = [
    ('Flutter', 100.0),
    ('Dart', 90.0),
    ('Widget', 85.0),
    ('State', 80.0),
    ('BLoC', 75.0),
    ('Provider', 70.0),
    ('Animation', 65.0),
    ('Navigation', 60.0),
    ('Theme', 55.0),
    ('Material', 50.0),
    ('Cupertino', 45.0),
    ('Scaffold', 40.0),
    ('Stream', 38.0),
    ('Future', 36.0),
    ('BuildContext', 34.0),
    ('StatefulWidget', 32.0),
    ('InheritedWidget', 30.0),
    ('Key', 28.0),
    ('Riverpod', 26.0),
    ('GetIt', 24.0),
    ('Navigator', 22.0),
    ('Route', 20.0),
    ('ListView', 18.0),
    ('Column', 16.0),
  ];

  static const _palette = [
    Color(0xFF3949AB),
    Color(0xFF00897B),
    Color(0xFFEF5350),
    Color(0xFFFFA726),
    Color(0xFF66BB6A),
    Color(0xFF5C6BC0),
    Color(0xFFAB47BC),
    Color(0xFF26A69A),
    Color(0xFFEF6C00),
    Color(0xFF42A5F5),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: const _WordCloudPainter(
            words: _words,
            palette: _palette,
          ),
        );
      },
    );
  }
}

class _WordCloudPainter extends CustomPainter {
  const _WordCloudPainter({
    required this.words,
    required this.palette,
  });

  final List<(String, double)> words;
  final List<Color> palette;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Sort by frequency desc
    final sorted = [...words]..sort((a, b) => b.$2.compareTo(a.$2));
    final maxFreq = sorted.first.$2;
    final minFreq = sorted.last.$2;

    // Placed word rects (in canvas coords)
    final placed = <Rect>[];
    final rng = math.Random(13);

    for (var idx = 0; idx < sorted.length; idx++) {
      final (word, freq) = sorted[idx];
      final t =
          (freq - minFreq) / (maxFreq - minFreq).clamp(1, double.infinity);
      final fontSize = 12.0 + t * 28.0;
      final color = palette[idx % palette.length];

      final tp = TextPainter(
        text: TextSpan(
          text: word,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final ww = tp.width;
      final wh = tp.height;

      // Archimedean spiral search
      const step = 0.15;
      double angle = rng.nextDouble() * 2 * math.pi;
      double radius = 0;
      bool foundSpot = false;

      for (var attempt = 0; attempt < 600; attempt++) {
        radius = step * angle / (2 * math.pi) * 12;
        final x = cx + radius * math.cos(angle) - ww / 2;
        final y = cy + radius * math.sin(angle) - wh / 2;
        angle += step;

        // Bounds check
        if (x < 4 ||
            y < 4 ||
            x + ww > size.width - 4 ||
            y + wh > size.height - 4) {
          continue;
        }

        final candidate = Rect.fromLTWH(x - 2, y - 2, ww + 4, wh + 4);

        // Overlap check
        final overlaps = placed.any((r) => r.overlaps(candidate));
        if (!overlaps) {
          tp.paint(canvas, Offset(x, y));
          placed.add(candidate);
          foundSpot = true;
          break;
        }
      }

      if (!foundSpot) {
        // Fallback: place at a random location without overlap check
        final x = rng.nextDouble() * (size.width - ww - 8) + 4;
        final y = rng.nextDouble() * (size.height - wh - 8) + 4;
        tp.paint(canvas, Offset(x, y));
        placed.add(Rect.fromLTWH(x - 2, y - 2, ww + 4, wh + 4));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WordCloudPainter old) => false;
}
