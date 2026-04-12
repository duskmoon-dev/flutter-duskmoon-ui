import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:duskmoon_ui/duskmoon_ui.dart';

import '../../destination.dart';

class RadialPage extends StatelessWidget {
  static const name = 'Radial & Hierarchy';
  static const path = 'radial';

  const RadialPage({super.key});

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
        title: const Text('Radial Charts'),
        leading: const BackButton(),
        actions: const [PlatformSwitchAction()],
      ),
      appBarBreakpoint: Breakpoints.standard,
      body: (_) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ChartCard(
            title: 'Pie / Donut Chart',
            description: 'Donut chart showing distribution by category',
            height: 300,
            child: CustomPaint(
              size: Size.infinite,
              painter: _DonutChartPainter(colorScheme: colorScheme),
            ),
          ),
          const SizedBox(height: 16),
          _ChartCard(
            title: 'Radar Chart',
            description:
                'Spider/radar chart comparing two entities across 6 dimensions',
            height: 300,
            child: CustomPaint(
              size: Size.infinite,
              painter: _RadarChartPainter(colorScheme: colorScheme),
            ),
          ),
          const SizedBox(height: 16),
          _ChartCard(
            title: 'Radial Bar Chart',
            description: 'Circular bar chart showing weekly activity by day',
            height: 300,
            child: CustomPaint(
              size: Size.infinite,
              painter: _RadialBarChartPainter(colorScheme: colorScheme),
            ),
          ),
          const SizedBox(height: 16),
          _ChartCard(
            title: 'Box Plot',
            description: 'Statistical distribution comparison across groups',
            height: 300,
            child: CustomPaint(
              size: Size.infinite,
              painter: _BoxPlotPainter(colorScheme: colorScheme),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Donut Chart Painter
// ---------------------------------------------------------------------------

class _DonutChartPainter extends CustomPainter {
  const _DonutChartPainter({required this.colorScheme});

  final ColorScheme colorScheme;

  static const _labels = ['Mobile', 'Desktop', 'Tablet', 'Other', 'TV'];
  static const _values = [35.0, 28.0, 18.0, 12.0, 7.0];
  static const _colors = [
    Color(0xFF5C6BC0),
    Color(0xFF26A69A),
    Color(0xFFEF5350),
    Color(0xFFFFA726),
    Color(0xFFAB47BC),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // Layout: chart on left portion, legend on right
    const legendWidth = 120.0;
    final chartArea = Size(size.width - legendWidth, size.height);
    final cx = chartArea.width / 2;
    final cy = chartArea.height / 2;
    final outerRadius = math.min(cx, cy) - 20;
    final innerRadius = outerRadius * 0.5;

    final total = _values.fold<double>(0, (s, v) => s + v);

    double startAngle = -math.pi / 2;
    const labelStyle = TextStyle(
      color: Colors.white,
      fontSize: 11,
      fontWeight: FontWeight.w600,
    );
    final pctStyle = TextStyle(
      color: colorScheme.onSurfaceVariant,
      fontSize: 10,
    );

    for (var i = 0; i < _values.length; i++) {
      final sweep = (_values[i] / total) * 2 * math.pi;

      // Subtract inner circle
      final outerPath = Path()
        ..addArc(
          Rect.fromCircle(center: Offset(cx, cy), radius: outerRadius),
          startAngle,
          sweep,
        );
      outerPath.arcTo(
        Rect.fromCircle(center: Offset(cx, cy), radius: innerRadius),
        startAngle + sweep,
        -sweep,
        false,
      );
      outerPath.close();

      canvas.drawPath(
          outerPath,
          Paint()
            ..color = _colors[i]
            ..style = PaintingStyle.fill);

      // White separator
      final sep = Paint()
        ..color = Colors.white
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(
          cx + innerRadius * math.cos(startAngle),
          cy + innerRadius * math.sin(startAngle),
        ),
        Offset(
          cx + outerRadius * math.cos(startAngle),
          cy + outerRadius * math.sin(startAngle),
        ),
        sep,
      );

      // Percentage label inside segment (if large enough)
      if (sweep > 0.3) {
        final midAngle = startAngle + sweep / 2;
        final midR = (innerRadius + outerRadius) / 2;
        final lx = cx + midR * math.cos(midAngle);
        final ly = cy + midR * math.sin(midAngle);
        _drawText(canvas, '${_values[i].toInt()}%', Offset(lx, ly), labelStyle,
            align: TextAlign.center);
      }

      startAngle += sweep;
    }

    // Close the last separator
    final finalSep = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(cx + innerRadius * math.cos(startAngle),
          cy + innerRadius * math.sin(startAngle)),
      Offset(cx + outerRadius * math.cos(startAngle),
          cy + outerRadius * math.sin(startAngle)),
      finalSep,
    );

    // White center circle
    canvas.drawCircle(
      Offset(cx, cy),
      innerRadius - 2,
      Paint()..color = colorScheme.surface,
    );

    // Center label
    final centerValueStyle = TextStyle(
      color: colorScheme.onSurface,
      fontSize: 13,
      fontWeight: FontWeight.w700,
    );
    final centerLabelStyle = TextStyle(
      color: colorScheme.onSurfaceVariant,
      fontSize: 10,
    );
    _drawText(canvas, 'Total', Offset(cx, cy - 9), centerLabelStyle,
        align: TextAlign.center);
    _drawText(canvas, '100%', Offset(cx, cy + 9), centerValueStyle,
        align: TextAlign.center);

    // Legend on right
    const swatchSize = 10.0;
    const rowHeight = 22.0;
    final legendX = chartArea.width + 8;
    final legendStartY = (size.height - _labels.length * rowHeight) / 2;

    for (var i = 0; i < _labels.length; i++) {
      final rowY = legendStartY + i * rowHeight;
      canvas.drawRect(
        Rect.fromLTWH(legendX, rowY + (rowHeight - swatchSize) / 2, swatchSize,
            swatchSize),
        Paint()..color = _colors[i],
      );
      _drawText(
        canvas,
        _labels[i],
        Offset(legendX + swatchSize + 6, rowY + rowHeight / 2),
        TextStyle(color: colorScheme.onSurface, fontSize: 11),
        align: TextAlign.left,
      );
      _drawText(
        canvas,
        '${_values[i].toInt()}%',
        Offset(legendX + legendWidth - 4, rowY + rowHeight / 2),
        pctStyle,
        align: TextAlign.right,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter old) =>
      old.colorScheme != colorScheme;
}

// ---------------------------------------------------------------------------
// Radar Chart Painter
// ---------------------------------------------------------------------------

class _RadarChartPainter extends CustomPainter {
  const _RadarChartPainter({required this.colorScheme});

  final ColorScheme colorScheme;

  static const _dimensions = [
    'Speed',
    'Power',
    'Defense',
    'Accuracy',
    'Stamina',
    'Agility',
  ];
  static const _playerA = [85.0, 70.0, 65.0, 90.0, 75.0, 80.0];
  static const _playerB = [70.0, 85.0, 80.0, 60.0, 90.0, 65.0];

  static const _colorA = Color(0xFF5C6BC0);
  static const _colorB = Color(0xFF26A69A);

  @override
  void paint(Canvas canvas, Size size) {
    const legendHeight = 32.0;
    const labelPadding = 28.0;
    final cx = size.width / 2;
    final cy = (size.height - legendHeight) / 2;
    final radius = math.min(cx, cy) - labelPadding;
    const n = 6;
    const levels = 5;
    const maxVal = 100.0;

    // Grid circles
    for (var level = 1; level <= levels; level++) {
      final r = radius * level / levels;
      canvas.drawCircle(
        Offset(cx, cy),
        r,
        Paint()
          ..color = colorScheme.outlineVariant
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5,
      );
    }

    // Axis lines and labels
    final axisLabelStyle = TextStyle(
      color: colorScheme.onSurfaceVariant,
      fontSize: 11,
    );
    for (var i = 0; i < n; i++) {
      final angle = -math.pi / 2 + i * 2 * math.pi / n;
      final xEnd = cx + radius * math.cos(angle);
      final yEnd = cy + radius * math.sin(angle);

      canvas.drawLine(
        Offset(cx, cy),
        Offset(xEnd, yEnd),
        Paint()
          ..color = colorScheme.outlineVariant
          ..strokeWidth = 0.5,
      );

      // Labels just outside the radius
      final lx = cx + (radius + labelPadding - 6) * math.cos(angle);
      final ly = cy + (radius + labelPadding - 6) * math.sin(angle);
      _drawText(canvas, _dimensions[i], Offset(lx, ly), axisLabelStyle,
          align: TextAlign.center);
    }

    // Player polygon helper
    void drawPolygon(List<double> values, Color color) {
      final path = Path();
      for (var i = 0; i < n; i++) {
        final angle = -math.pi / 2 + i * 2 * math.pi / n;
        final r = radius * values[i] / maxVal;
        final x = cx + r * math.cos(angle);
        final y = cy + r * math.sin(angle);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();

      canvas.drawPath(
        path,
        Paint()
          ..color = color.withValues(alpha: 0.2)
          ..style = PaintingStyle.fill,
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    drawPolygon(_playerA, _colorA);
    drawPolygon(_playerB, _colorB);

    // Data point dots
    for (var i = 0; i < n; i++) {
      final angle = -math.pi / 2 + i * 2 * math.pi / n;
      for (final entry in [(_playerA, _colorA), (_playerB, _colorB)]) {
        final r = radius * entry.$1[i] / maxVal;
        canvas.drawCircle(
          Offset(cx + r * math.cos(angle), cy + r * math.sin(angle)),
          3.5,
          Paint()..color = entry.$2,
        );
      }
    }

    // Legend at bottom
    const swatchSize = 10.0;
    const spacing = 6.0;
    const itemSpacing = 24.0;
    final legendY = size.height - legendHeight / 2;
    final items = [
      ('Player A', _colorA),
      ('Player B', _colorB),
    ];

    final legendStyle = TextStyle(color: colorScheme.onSurface, fontSize: 11);
    double lx = cx - 80;
    for (final item in items) {
      canvas.drawRect(
        Rect.fromLTWH(lx, legendY - swatchSize / 2, swatchSize, swatchSize),
        Paint()..color = item.$2,
      );
      lx += swatchSize + spacing;
      _drawText(canvas, item.$1, Offset(lx, legendY), legendStyle,
          align: TextAlign.left);
      lx += _measureText(item.$1, legendStyle).width + itemSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter old) =>
      old.colorScheme != colorScheme;
}

// ---------------------------------------------------------------------------
// Radial Bar Chart Painter
// ---------------------------------------------------------------------------

class _RadialBarChartPainter extends CustomPainter {
  const _RadialBarChartPainter({required this.colorScheme});

  final ColorScheme colorScheme;

  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _hours = [6.0, 8.0, 7.0, 9.0, 5.0, 3.0, 4.0];
  static const _maxHours = 10.0;

  static const _arcColors = [
    Color(0xFF5C6BC0),
    Color(0xFF3F51B5),
    Color(0xFF26A69A),
    Color(0xFF00897B),
    Color(0xFFEF5350),
    Color(0xFFAB47BC),
    Color(0xFFFFA726),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    const innerRadius = 42.0;
    final outerMaxRadius = math.min(cx, cy) - 32;
    const n = 7;
    const arcThickness = 14.0;

    final avgHours = _hours.fold<double>(0, (s, v) => s + v) / n;

    for (var i = 0; i < n; i++) {
      final startAngle = -math.pi / 2 + i * 2 * math.pi / n;
      const sweep = 2 * math.pi / n - 0.08; // small gap between arcs

      // Background track
      final trackPaint = Paint()
        ..color = colorScheme.outlineVariant
        ..style = PaintingStyle.stroke
        ..strokeWidth = arcThickness
        ..strokeCap = StrokeCap.round;

      final trackRadius = innerRadius + (outerMaxRadius - innerRadius) / 2;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: trackRadius),
        startAngle,
        sweep,
        false,
        trackPaint,
      );

      // Value arc
      final valueSweep = sweep * (_hours[i] / _maxHours);
      final valuePaint = Paint()
        ..color = _arcColors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = arcThickness
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: trackRadius),
        startAngle,
        valueSweep,
        false,
        valuePaint,
      );

      // Day label outside
      final midAngle = startAngle + sweep / 2;
      final labelR = trackRadius + arcThickness / 2 + 12;
      _drawText(
        canvas,
        _days[i],
        Offset(
            cx + labelR * math.cos(midAngle), cy + labelR * math.sin(midAngle)),
        TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10),
        align: TextAlign.center,
      );

      // Value at arc end
      if (_hours[i] >= 1.0) {
        final valAngle = startAngle + valueSweep;
        final valR = trackRadius;
        _drawText(
          canvas,
          '${_hours[i].toInt()}h',
          Offset(
            cx + valR * math.cos(valAngle),
            cy + valR * math.sin(valAngle),
          ),
          TextStyle(
            color: _arcColors[i],
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
          align: TextAlign.center,
        );
      }
    }

    // Center: average
    final centerValueStyle = TextStyle(
      color: colorScheme.onSurface,
      fontSize: 16,
      fontWeight: FontWeight.w700,
    );
    final centerLabelStyle = TextStyle(
      color: colorScheme.onSurfaceVariant,
      fontSize: 10,
    );
    _drawText(canvas, avgHours.toStringAsFixed(1), Offset(cx, cy - 8),
        centerValueStyle,
        align: TextAlign.center);
    _drawText(canvas, 'avg h/day', Offset(cx, cy + 10), centerLabelStyle,
        align: TextAlign.center);
  }

  @override
  bool shouldRepaint(covariant _RadialBarChartPainter old) =>
      old.colorScheme != colorScheme;
}

// ---------------------------------------------------------------------------
// Box Plot Painter
// ---------------------------------------------------------------------------

class _BoxPlotPainter extends CustomPainter {
  const _BoxPlotPainter({required this.colorScheme});

  final ColorScheme colorScheme;

  static const _groupNames = [
    'Group A',
    'Group B',
    'Group C',
    'Group D',
    'Group E'
  ];

  // Fixed seed data per group: raw sample values
  static final List<List<double>> _rawData = _generateData();

  static List<List<double>> _generateData() {
    final groups = <List<double>>[];
    final seeds = [42, 17, 99, 5, 73];
    for (final seed in seeds) {
      final rng = math.Random(seed);
      final values = List.generate(40, (_) => 20 + rng.nextDouble() * 60);
      groups.add(values);
    }
    return groups;
  }

  static _BoxStats _computeStats(List<double> data) {
    final sorted = List<double>.from(data)..sort();
    final n = sorted.length;
    final q1 = sorted[(n * 0.25).floor()];
    final median = sorted[(n * 0.5).floor()];
    final q3 = sorted[(n * 0.75).floor()];
    final iqr = q3 - q1;
    final lowerFence = q1 - 1.5 * iqr;
    final upperFence = q3 + 1.5 * iqr;
    final whiskerLow = sorted.firstWhere((v) => v >= lowerFence);
    final whiskerHigh = sorted.lastWhere((v) => v <= upperFence);
    final outliers =
        sorted.where((v) => v < lowerFence || v > upperFence).toList();
    return _BoxStats(
      q1: q1,
      median: median,
      q3: q3,
      whiskerLow: whiskerLow,
      whiskerHigh: whiskerHigh,
      outliers: outliers,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    const margin = EdgeInsets.fromLTRB(40, 24, 16, 48);
    final w = size.width - margin.left - margin.right;
    final h = size.height - margin.top - margin.bottom;
    if (w <= 0 || h <= 0) return;

    const yMin = 10.0;
    const yMax = 90.0;
    const yRange = yMax - yMin;

    double toY(double v) => margin.top + h * (1 - (v - yMin) / yRange);

    // Grid
    final gridPaint = Paint()
      ..color = colorScheme.outlineVariant
      ..strokeWidth = 0.5;
    for (var v = 20.0; v <= 80; v += 20) {
      final y = toY(v);
      canvas.drawLine(
        Offset(margin.left, y),
        Offset(margin.left + w, y),
        gridPaint,
      );
      _drawText(
        canvas,
        v.toInt().toString(),
        Offset(margin.left - 4, y),
        TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10),
        align: TextAlign.right,
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

    final n = _groupNames.length;
    final slotW = w / n;
    final boxHalfW = slotW * 0.22;
    final whiskerCapW = slotW * 0.1;

    for (var i = 0; i < n; i++) {
      final stats = _computeStats(_rawData[i]);
      final cx = margin.left + slotW * i + slotW / 2;

      final boxColor = colorScheme.primary;
      final boxPaint = Paint()
        ..color = boxColor.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;
      final strokePaint = Paint()
        ..color = boxColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      final medianPaint = Paint()
        ..color = colorScheme.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      final whiskerPaint = Paint()
        ..color = boxColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      final outlierPaint = Paint()
        ..color = colorScheme.error
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      final q1y = toY(stats.q1);
      final q3y = toY(stats.q3);
      final medY = toY(stats.median);
      final wlY = toY(stats.whiskerLow);
      final whY = toY(stats.whiskerHigh);

      // IQR box
      canvas.drawRect(
        Rect.fromLTRB(cx - boxHalfW, q3y, cx + boxHalfW, q1y),
        boxPaint,
      );
      canvas.drawRect(
        Rect.fromLTRB(cx - boxHalfW, q3y, cx + boxHalfW, q1y),
        strokePaint,
      );

      // Median line
      canvas.drawLine(
        Offset(cx - boxHalfW, medY),
        Offset(cx + boxHalfW, medY),
        medianPaint,
      );

      // Whisker lines (center vertical)
      canvas.drawLine(Offset(cx, q3y), Offset(cx, whY), whiskerPaint);
      canvas.drawLine(Offset(cx, q1y), Offset(cx, wlY), whiskerPaint);

      // Whisker caps
      canvas.drawLine(
        Offset(cx - whiskerCapW, whY),
        Offset(cx + whiskerCapW, whY),
        whiskerPaint,
      );
      canvas.drawLine(
        Offset(cx - whiskerCapW, wlY),
        Offset(cx + whiskerCapW, wlY),
        whiskerPaint,
      );

      // Outliers
      for (final o in stats.outliers) {
        canvas.drawCircle(Offset(cx, toY(o)), 3, outlierPaint);
      }

      // Group label
      _drawText(
        canvas,
        _groupNames[i],
        Offset(cx, margin.top + h + 8),
        TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10),
        align: TextAlign.center,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BoxPlotPainter old) =>
      old.colorScheme != colorScheme;
}

class _BoxStats {
  const _BoxStats({
    required this.q1,
    required this.median,
    required this.q3,
    required this.whiskerLow,
    required this.whiskerHigh,
    required this.outliers,
  });

  final double q1;
  final double median;
  final double q3;
  final double whiskerLow;
  final double whiskerHigh;
  final List<double> outliers;
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

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
