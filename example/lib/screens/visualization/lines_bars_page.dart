import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:duskmoon_visualization/duskmoon_visualization_compat.dart'
    as dv;

import '../../destination.dart';

class LinesBarsPage extends StatelessWidget {
  const LinesBarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DmAdaptiveScaffold(
      selectedIndex: Destinations.indexOf(const Key('Visualization')),
      onSelectedIndexChange: (idx) => Destinations.changeHandler(idx, context),
      destinations: Destinations.navs,
      useDrawer: true,
      transitionDuration: Duration.zero,
      appBar: DmAppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        title: const Text('Lines & Bars'),
        leading: const BackButton(),
      ),
      appBarBreakpoint: Breakpoints.standard,
      body: (_) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ChartCard(
            title: 'Line Chart',
            description:
                'Multi-series trend lines with Catmull-Rom curve interpolation',
            height: 280,
            child: CustomPaint(
              size: Size.infinite,
              painter: _LineChartPainter(colorScheme: colorScheme),
            ),
          ),
          const SizedBox(height: 16),
          _ChartCard(
            title: 'Area Chart',
            description:
                'Stacked area chart with gradient fill using basis curve',
            height: 280,
            child: CustomPaint(
              size: Size.infinite,
              painter: _AreaChartPainter(colorScheme: colorScheme),
            ),
          ),
          const SizedBox(height: 16),
          _ChartCard(
            title: 'Bar Chart',
            description: 'Grouped vertical bars with band scale',
            height: 260,
            child: CustomPaint(
              size: Size.infinite,
              painter: _BarChartPainter(colorScheme: colorScheme),
            ),
          ),
          const SizedBox(height: 16),
          _ChartCard(
            title: 'Stacked Bar Chart',
            description:
                'Stacked vertical bars showing composition by category',
            height: 260,
            child: CustomPaint(
              size: Size.infinite,
              painter: _StackedBarChartPainter(colorScheme: colorScheme),
            ),
          ),
          const SizedBox(height: 16),
          _ChartCard(
            title: 'Horizontal Bar Chart',
            description: 'Horizontal bars ranked by value',
            height: 260,
            child: CustomPaint(
              size: Size.infinite,
              painter: _HorizontalBarChartPainter(colorScheme: colorScheme),
            ),
          ),
          const SizedBox(height: 16),
          _ChartCard(
            title: 'Streamgraph',
            description:
                'Stacked area chart with silhouette baseline for organic flow',
            height: 260,
            child: CustomPaint(
              size: Size.infinite,
              painter: _StreamgraphPainter(colorScheme: colorScheme),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Line Chart Painter
// ---------------------------------------------------------------------------

class _LineChartPainter extends CustomPainter {
  const _LineChartPainter({required this.colorScheme});

  final ColorScheme colorScheme;

  static final List<List<double>> _series1 = List.generate(
    12,
    (i) => [i.toDouble(), 50 + 30 * math.sin(i * 0.5)],
  );

  static final List<List<double>> _series2 = List.generate(
    12,
    (i) => [i.toDouble(), 50 + 30 * math.cos(i * 0.5)],
  );

  @override
  void paint(Canvas canvas, Size size) {
    const margin = EdgeInsets.fromLTRB(48, 24, 24, 56);
    final w = size.width - margin.left - margin.right;
    final h = size.height - margin.top - margin.bottom;
    if (w <= 0 || h <= 0) return;

    final xScale = dv.scaleLinear(domain: [0, 11], range: [0, w]);
    final yScale = dv.scaleLinear(domain: [0, 100], range: [h, 0]);

    final gridPaint = Paint()
      ..color = colorScheme.outlineVariant
      ..strokeWidth = 0.5;
    for (var v = 0.0; v <= 100; v += 25) {
      final y = margin.top + yScale(v);
      canvas.drawLine(
        Offset(margin.left, y),
        Offset(margin.left + w, y),
        gridPaint,
      );
    }

    // Axes
    final axisPaint = Paint()
      ..color = colorScheme.outline
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(margin.left, margin.top),
      Offset(margin.left, margin.top + h),
      axisPaint,
    );
    canvas.drawLine(
      Offset(margin.left, margin.top + h),
      Offset(margin.left + w, margin.top + h),
      axisPaint,
    );

    // Axis labels
    final labelStyle = TextStyle(
      color: colorScheme.onSurfaceVariant,
      fontSize: 10,
    );
    for (var i = 0; i <= 4; i++) {
      final v = i * 25.0;
      final y = margin.top + yScale(v);
      _drawText(
        canvas,
        v.toInt().toString(),
        Offset(margin.left - 4, y),
        labelStyle,
        align: TextAlign.right,
      );
    }
    for (var i = 0; i <= 11; i += 2) {
      final x = margin.left + xScale(i.toDouble());
      _drawText(
        canvas,
        'M${i + 1}',
        Offset(x, margin.top + h + 6),
        labelStyle,
        align: TextAlign.center,
      );
    }

    // Draw interpolated lines
    _drawLine(canvas, _series1, xScale.call, yScale.call, margin,
        const Color(0xFF3F51B5)); // indigo
    _drawLine(canvas, _series2, xScale.call, yScale.call, margin,
        const Color(0xFF009688)); // teal

    // Data points
    _drawPoints(canvas, _series1, xScale.call, yScale.call, margin,
        const Color(0xFF3F51B5));
    _drawPoints(canvas, _series2, xScale.call, yScale.call, margin,
        const Color(0xFF009688));

    // Legend
    _drawLegend(canvas, size, margin, const [
      _LegendItem('Series A', Color(0xFF3F51B5)),
      _LegendItem('Series B', Color(0xFF009688)),
    ]);
  }

  void _drawLine(
    Canvas canvas,
    List<List<double>> series,
    double Function(double) xScale,
    double Function(double) yScale,
    EdgeInsets margin,
    Color color,
  ) {
    final points = series
        .map((p) => dv.Point(xScale(p[0]), yScale(p[1])))
        .toList(growable: false);

    final curve = dv.curveCatmullRom();
    final smoothed = curve.generate(points);

    if (smoothed.isEmpty) return;

    final path = Path()
      ..moveTo(
        margin.left + smoothed.first.x,
        margin.top + smoothed.first.y,
      );
    for (final pt in smoothed.skip(1)) {
      path.lineTo(margin.left + pt.x, margin.top + pt.y);
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _drawPoints(
    Canvas canvas,
    List<List<double>> series,
    double Function(double) xScale,
    double Function(double) yScale,
    EdgeInsets margin,
    Color color,
  ) {
    for (final p in series) {
      final cx = margin.left + xScale(p[0]);
      final cy = margin.top + yScale(p[1]);
      canvas.drawCircle(Offset(cx, cy), 3.5, Paint()..color = color);
      canvas.drawCircle(
        Offset(cx, cy),
        3.5,
        Paint()
          ..color = colorScheme.surface
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  void _drawLegend(
    Canvas canvas,
    Size size,
    EdgeInsets margin,
    List<_LegendItem> items,
  ) {
    const swatchSize = 12.0;
    const spacing = 8.0;
    const itemSpacing = 24.0;

    final style = TextStyle(
      color: colorScheme.onSurface,
      fontSize: 11,
    );

    double x = margin.left;
    final y = size.height - 16;

    for (final item in items) {
      canvas.drawRect(
        Rect.fromLTWH(x, y - swatchSize / 2, swatchSize, swatchSize),
        Paint()..color = item.color,
      );
      x += swatchSize + spacing;
      _drawText(canvas, item.label, Offset(x, y), style, align: TextAlign.left);
      x += _measureText(item.label, style).width + itemSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter old) =>
      old.colorScheme != colorScheme;
}

// ---------------------------------------------------------------------------
// Area Chart Painter
// ---------------------------------------------------------------------------

class _AreaChartPainter extends CustomPainter {
  const _AreaChartPainter({required this.colorScheme});

  final ColorScheme colorScheme;

  static final List<List<double>> _raw = List.generate(
    10,
    (i) => [
      i.toDouble(),
      10 + 8 * math.sin(i * 0.7),
      8 + 6 * math.cos(i * 0.5 + 1),
      12 + 5 * math.sin(i * 0.9 + 2),
    ],
  );

  static const List<Color> _colors = [
    Color(0xFF5C6BC0),
    Color(0xFF26A69A),
    Color(0xFFEF5350),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    const margin = EdgeInsets.fromLTRB(48, 24, 24, 40);
    final w = size.width - margin.left - margin.right;
    final h = size.height - margin.top - margin.bottom;
    if (w <= 0 || h <= 0) return;

    // Compute stacked totals
    final maxTotal =
        _raw.map((row) => row[1] + row[2] + row[3]).reduce(math.max);

    final xScale = dv.scaleLinear(domain: [0, 9], range: [0, w]);
    final yScale = dv.scaleLinear(domain: [0, maxTotal * 1.05], range: [h, 0]);

    // Draw each area layer (from top stack to bottom for painter's algorithm)
    for (var s = 2; s >= 0; s--) {
      final bottomPts = <dv.Point>[];
      final topPts = <dv.Point>[];

      for (var i = 0; i < _raw.length; i++) {
        final row = _raw[i];
        double bottom = 0;
        for (var k = 0; k < s; k++) {
          bottom += row[k + 1];
        }
        final top = bottom + row[s + 1];

        bottomPts.add(dv.Point(xScale(row[0]), yScale(bottom)));
        topPts.add(dv.Point(xScale(row[0]), yScale(top)));
      }

      final curve = dv.curveBasis();
      final smoothedTop = curve.generate(topPts);
      final smoothedBottom = curve.generate(bottomPts);

      if (smoothedTop.isEmpty || smoothedBottom.isEmpty) continue;

      final areaPath = Path()
        ..moveTo(margin.left + smoothedTop.first.x,
            margin.top + smoothedTop.first.y);
      for (final pt in smoothedTop.skip(1)) {
        areaPath.lineTo(margin.left + pt.x, margin.top + pt.y);
      }
      for (final pt in smoothedBottom.reversed) {
        areaPath.lineTo(margin.left + pt.x, margin.top + pt.y);
      }
      areaPath.close();

      canvas.drawPath(
        areaPath,
        Paint()
          ..color = _colors[s].withValues(alpha: 0.45)
          ..style = PaintingStyle.fill,
      );

      // Stroke the top edge
      final strokePath = Path()
        ..moveTo(margin.left + smoothedTop.first.x,
            margin.top + smoothedTop.first.y);
      for (final pt in smoothedTop.skip(1)) {
        strokePath.lineTo(margin.left + pt.x, margin.top + pt.y);
      }
      canvas.drawPath(
        strokePath,
        Paint()
          ..color = _colors[s]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    // Axes
    final axisPaint = Paint()
      ..color = colorScheme.outline
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(margin.left, margin.top),
      Offset(margin.left, margin.top + h),
      axisPaint,
    );
    canvas.drawLine(
      Offset(margin.left, margin.top + h),
      Offset(margin.left + w, margin.top + h),
      axisPaint,
    );

    final labelStyle =
        TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10);
    for (var i = 0; i < _raw.length; i += 2) {
      final x = margin.left + xScale(_raw[i][0]);
      _drawText(
        canvas,
        'T${i + 1}',
        Offset(x, margin.top + h + 6),
        labelStyle,
        align: TextAlign.center,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AreaChartPainter old) =>
      old.colorScheme != colorScheme;
}

// ---------------------------------------------------------------------------
// Bar Chart Painter (Grouped)
// ---------------------------------------------------------------------------

class _BarChartPainter extends CustomPainter {
  const _BarChartPainter({required this.colorScheme});

  final ColorScheme colorScheme;

  static const _categories = ['Q1', 'Q2', 'Q3', 'Q4'];
  static const _seriesA = [42.0, 58.0, 73.0, 65.0];
  static const _seriesB = [35.0, 47.0, 61.0, 79.0];
  static const _seriesColors = [Color(0xFF3F51B5), Color(0xFF26A69A)];

  @override
  void paint(Canvas canvas, Size size) {
    const margin = EdgeInsets.fromLTRB(48, 24, 24, 48);
    final w = size.width - margin.left - margin.right;
    final h = size.height - margin.top - margin.bottom;
    if (w <= 0 || h <= 0) return;

    final xBand = dv.scaleBand<String>(
      domain: _categories,
      range: [0, w],
      paddingInner: 0.25,
      paddingOuter: 0.1,
    );
    final yScale = dv.scaleLinear(domain: [0, 100], range: [h, 0]);

    // Grid
    final gridPaint = Paint()
      ..color = colorScheme.outlineVariant
      ..strokeWidth = 0.5;
    for (var v = 0.0; v <= 100; v += 25) {
      final y = margin.top + yScale(v);
      canvas.drawLine(
        Offset(margin.left, y),
        Offset(margin.left + w, y),
        gridPaint,
      );
    }

    // Axes
    canvas.drawLine(
      Offset(margin.left, margin.top + h),
      Offset(margin.left + w, margin.top + h),
      Paint()
        ..color = colorScheme.outline
        ..strokeWidth = 1,
    );

    final bw = xBand.bandwidth;
    final subBw = bw / 2 - 2;
    final labelStyle =
        TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10);

    for (var i = 0; i < _categories.length; i++) {
      final cat = _categories[i];
      final bandX = margin.left + xBand(cat);

      // Series A bar
      final aLeft = bandX + 1;
      final aTop = margin.top + yScale(_seriesA[i]);
      final aBottom = margin.top + h;
      canvas.drawRect(
        Rect.fromLTRB(aLeft, aTop, aLeft + subBw, aBottom),
        Paint()..color = _seriesColors[0],
      );

      // Series B bar
      final bLeft = bandX + bw / 2 + 1;
      final bTop = margin.top + yScale(_seriesB[i]);
      canvas.drawRect(
        Rect.fromLTRB(bLeft, bTop, bLeft + subBw, aBottom),
        Paint()..color = _seriesColors[1],
      );

      // Category label
      _drawText(
        canvas,
        cat,
        Offset(bandX + bw / 2, margin.top + h + 6),
        labelStyle,
        align: TextAlign.center,
      );
    }

    // Y-axis labels
    for (var v = 0.0; v <= 100; v += 25) {
      _drawText(
        canvas,
        v.toInt().toString(),
        Offset(margin.left - 4, margin.top + yScale(v)),
        labelStyle,
        align: TextAlign.right,
      );
    }

    // Legend
    _drawInlineLegend(canvas, size, margin, [
      _LegendItem('Series A', _seriesColors[0]),
      _LegendItem('Series B', _seriesColors[1]),
    ]);
  }

  void _drawInlineLegend(
    Canvas canvas,
    Size size,
    EdgeInsets margin,
    List<_LegendItem> items,
  ) {
    const swatchSize = 10.0;
    const spacing = 6.0;
    const itemSpacing = 20.0;
    final style = TextStyle(color: colorScheme.onSurface, fontSize: 10);

    double x = margin.left;
    final y = size.height - 14;
    for (final item in items) {
      canvas.drawRect(
        Rect.fromLTWH(x, y - swatchSize / 2, swatchSize, swatchSize),
        Paint()..color = item.color,
      );
      x += swatchSize + spacing;
      _drawText(canvas, item.label, Offset(x, y), style, align: TextAlign.left);
      x += _measureText(item.label, style).width + itemSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter old) =>
      old.colorScheme != colorScheme;
}

// ---------------------------------------------------------------------------
// Stacked Bar Chart Painter
// ---------------------------------------------------------------------------

class _StackedBarChartPainter extends CustomPainter {
  const _StackedBarChartPainter({required this.colorScheme});

  final ColorScheme colorScheme;

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May'];
  static const _data = [
    [30.0, 25.0, 20.0],
    [35.0, 20.0, 28.0],
    [28.0, 32.0, 22.0],
    [40.0, 18.0, 30.0],
    [33.0, 27.0, 25.0],
  ];
  static const _stackColors = [
    Color(0xFF5C6BC0),
    Color(0xFF26A69A),
    Color(0xFFEF5350),
  ];
  static const _stackLabels = ['Product A', 'Product B', 'Product C'];

  @override
  void paint(Canvas canvas, Size size) {
    const margin = EdgeInsets.fromLTRB(48, 24, 24, 48);
    final w = size.width - margin.left - margin.right;
    final h = size.height - margin.top - margin.bottom;
    if (w <= 0 || h <= 0) return;

    const maxValue = 100.0;
    final barWidth = w / _months.length;
    final barPadding = barWidth * 0.2;

    // Grid
    final gridPaint = Paint()
      ..color = colorScheme.outlineVariant
      ..strokeWidth = 0.5;
    for (var v = 0.0; v <= maxValue; v += 25) {
      final y = margin.top + h * (1 - v / maxValue);
      canvas.drawLine(
        Offset(margin.left, y),
        Offset(margin.left + w, y),
        gridPaint,
      );
    }

    for (var m = 0; m < _months.length; m++) {
      final barLeft = margin.left + m * barWidth + barPadding;
      final barRight = margin.left + (m + 1) * barWidth - barPadding;
      double cumulative = 0;

      for (var s = 0; s < _data[m].length; s++) {
        final value = _data[m][s];
        final bottom = margin.top + h * (1 - cumulative / maxValue);
        final top = margin.top + h * (1 - (cumulative + value) / maxValue);
        canvas.drawRect(
          Rect.fromLTRB(barLeft, top, barRight, bottom),
          Paint()..color = _stackColors[s],
        );
        cumulative += value;
      }

      // Month label
      _drawText(
        canvas,
        _months[m],
        Offset(margin.left + m * barWidth + barWidth / 2, margin.top + h + 6),
        TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10),
        align: TextAlign.center,
      );
    }

    // Y-axis
    canvas.drawLine(
      Offset(margin.left, margin.top),
      Offset(margin.left, margin.top + h),
      Paint()
        ..color = colorScheme.outline
        ..strokeWidth = 1,
    );
    canvas.drawLine(
      Offset(margin.left, margin.top + h),
      Offset(margin.left + w, margin.top + h),
      Paint()
        ..color = colorScheme.outline
        ..strokeWidth = 1,
    );

    final labelStyle =
        TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10);
    for (var v = 0.0; v <= maxValue; v += 25) {
      final y = margin.top + h * (1 - v / maxValue);
      _drawText(
        canvas,
        v.toInt().toString(),
        Offset(margin.left - 4, y),
        labelStyle,
        align: TextAlign.right,
      );
    }

    // Legend
    const swatchSize = 10.0;
    const spacing = 6.0;
    double lx = margin.left;
    final ly = size.height - 14;
    final lstyle = TextStyle(color: colorScheme.onSurface, fontSize: 10);
    for (var i = 0; i < _stackLabels.length; i++) {
      canvas.drawRect(
        Rect.fromLTWH(lx, ly - swatchSize / 2, swatchSize, swatchSize),
        Paint()..color = _stackColors[i],
      );
      lx += swatchSize + spacing;
      _drawText(canvas, _stackLabels[i], Offset(lx, ly), lstyle,
          align: TextAlign.left);
      lx += _measureText(_stackLabels[i], lstyle).width + 16;
    }
  }

  @override
  bool shouldRepaint(covariant _StackedBarChartPainter old) =>
      old.colorScheme != colorScheme;
}

// ---------------------------------------------------------------------------
// Horizontal Bar Chart Painter
// ---------------------------------------------------------------------------

class _HorizontalBarChartPainter extends CustomPainter {
  const _HorizontalBarChartPainter({required this.colorScheme});

  final ColorScheme colorScheme;

  static const _items = [
    'Python',
    'JavaScript',
    'TypeScript',
    'Rust',
    'Go',
    'Kotlin',
    'Dart',
  ];
  static const _values = [82.0, 78.0, 71.0, 65.0, 61.0, 55.0, 48.0];

  @override
  void paint(Canvas canvas, Size size) {
    const margin = EdgeInsets.fromLTRB(88, 16, 40, 32);
    final w = size.width - margin.left - margin.right;
    final h = size.height - margin.top - margin.bottom;
    if (w <= 0 || h <= 0) return;

    final xScale = dv.scaleLinear(domain: [0, 100], range: [0, w]);
    final yBand = dv.scaleBand<String>(
      domain: _items,
      range: [0, h],
      paddingInner: 0.3,
      paddingOuter: 0.1,
    );

    // Grid
    final gridPaint = Paint()
      ..color = colorScheme.outlineVariant
      ..strokeWidth = 0.5;
    for (var v = 0.0; v <= 100; v += 25) {
      final x = margin.left + xScale(v);
      canvas.drawLine(
        Offset(x, margin.top),
        Offset(x, margin.top + h),
        gridPaint,
      );
    }

    // Axes
    canvas.drawLine(
      Offset(margin.left, margin.top),
      Offset(margin.left, margin.top + h),
      Paint()
        ..color = colorScheme.outline
        ..strokeWidth = 1,
    );
    canvas.drawLine(
      Offset(margin.left, margin.top + h),
      Offset(margin.left + w, margin.top + h),
      Paint()
        ..color = colorScheme.outline
        ..strokeWidth = 1,
    );

    final bw = yBand.bandwidth;
    final labelStyle =
        TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10);

    for (var i = 0; i < _items.length; i++) {
      final item = _items[i];
      final barTop = margin.top + yBand(item);
      final barWidth = xScale(_values[i]);

      canvas.drawRect(
        Rect.fromLTWH(margin.left, barTop, barWidth, bw),
        Paint()..color = colorScheme.primary.withValues(alpha: 0.8),
      );

      // Value label
      _drawText(
        canvas,
        '${_values[i].toInt()}',
        Offset(margin.left + barWidth + 4, barTop + bw / 2),
        labelStyle,
        align: TextAlign.left,
      );

      // Item label on left
      _drawText(
        canvas,
        item,
        Offset(margin.left - 4, barTop + bw / 2),
        labelStyle,
        align: TextAlign.right,
      );
    }

    // X-axis labels
    for (var v = 0.0; v <= 100; v += 25) {
      final x = margin.left + xScale(v);
      _drawText(
        canvas,
        v.toInt().toString(),
        Offset(x, margin.top + h + 6),
        labelStyle,
        align: TextAlign.center,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HorizontalBarChartPainter old) =>
      old.colorScheme != colorScheme;
}

// ---------------------------------------------------------------------------
// Streamgraph Painter
// ---------------------------------------------------------------------------

class _StreamgraphPainter extends CustomPainter {
  const _StreamgraphPainter({required this.colorScheme});

  final ColorScheme colorScheme;

  static const _layerColors = [
    Color(0xFF5C6BC0),
    Color(0xFF26A69A),
    Color(0xFFEF5350),
    Color(0xFFFFA726),
    Color(0xFFAB47BC),
  ];

  static const _numLayers = 5;
  static const _numPoints = 20;

  List<List<double>> _buildData() {
    return List.generate(_numLayers, (layer) {
      return List.generate(_numPoints, (i) {
        return 5 +
            15 * math.sin(i * 0.4 + layer * 1.3).abs() +
            8 * math.cos(i * 0.7 + layer * 0.8).abs();
      });
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    const margin = EdgeInsets.fromLTRB(16, 16, 16, 16);
    final w = size.width - margin.left - margin.right;
    final h = size.height - margin.top - margin.bottom;
    if (w <= 0 || h <= 0) return;

    final data = _buildData();

    // Compute totals per time point
    final totals = List.generate(_numPoints, (i) {
      return data.fold<double>(0, (sum, layer) => sum + layer[i]);
    });

    // Silhouette centering: shift baseline so center of stream is at h/2
    final baselines = List.generate(_numPoints, (i) => -totals[i] / 2);

    final xScale = dv.scaleLinear(domain: [0, _numPoints - 1], range: [0, w]);
    final maxTotal = totals.reduce(math.max);
    final yScale =
        dv.scaleLinear(domain: [-maxTotal / 2, maxTotal / 2], range: [h, 0]);

    for (var layer = _numLayers - 1; layer >= 0; layer--) {
      final topPts = <Offset>[];
      final bottomPts = <Offset>[];

      for (var i = 0; i < _numPoints; i++) {
        double cumBelow = baselines[i];
        for (var k = 0; k < layer; k++) {
          cumBelow += data[k][i];
        }
        final top = cumBelow + data[layer][i];

        topPts.add(Offset(
          margin.left + xScale(i.toDouble()),
          margin.top + yScale(top),
        ));
        bottomPts.add(Offset(
          margin.left + xScale(i.toDouble()),
          margin.top + yScale(cumBelow),
        ));
      }

      // Build smooth path using quadratic beziers
      final path = _smoothArea(topPts, bottomPts);
      canvas.drawPath(
        path,
        Paint()
          ..color = _layerColors[layer].withValues(alpha: 0.72)
          ..style = PaintingStyle.fill,
      );
      canvas.drawPath(
        _smoothLine(topPts),
        Paint()
          ..color = _layerColors[layer]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  Path _smoothLine(List<Offset> pts) {
    if (pts.isEmpty) return Path();
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length; i++) {
      final cp = Offset(
        (pts[i - 1].dx + pts[i].dx) / 2,
        (pts[i - 1].dy + pts[i].dy) / 2,
      );
      path.quadraticBezierTo(pts[i - 1].dx, pts[i - 1].dy, cp.dx, cp.dy);
    }
    if (pts.length > 1) path.lineTo(pts.last.dx, pts.last.dy);
    return path;
  }

  Path _smoothArea(List<Offset> top, List<Offset> bottom) {
    final path = _smoothLine(top);
    for (var i = bottom.length - 1; i >= 0; i--) {
      path.lineTo(bottom[i].dx, bottom[i].dy);
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant _StreamgraphPainter old) =>
      old.colorScheme != colorScheme;
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

class _LegendItem {
  const _LegendItem(this.label, this.color);
  final String label;
  final Color color;
}

Size _measureText(String text, TextStyle style) {
  final tp = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
  )..layout();
  return tp.size;
}

void _drawText(
  Canvas canvas,
  String text,
  Offset position,
  TextStyle style, {
  TextAlign align = TextAlign.left,
}) {
  final tp = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    textAlign: align,
  )..layout();

  double dx = position.dx;
  if (align == TextAlign.center) {
    dx -= tp.width / 2;
  } else if (align == TextAlign.right) {
    dx -= tp.width;
  }
  tp.paint(canvas, Offset(dx, position.dy - tp.height / 2));
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
            Text(title, style: Theme.of(context).textTheme.titleLarge),
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
