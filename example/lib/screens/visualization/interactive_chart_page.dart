import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:duskmoon_visualization/duskmoon_visualization_compat.dart'
    as dv;

import '../../destination.dart';

class InteractiveChartPage extends StatefulWidget {
  const InteractiveChartPage({super.key});

  @override
  State<InteractiveChartPage> createState() => _InteractiveChartPageState();
}

class _InteractiveChartPageState extends State<InteractiveChartPage> {
  int? _hoveredIndex;
  dv.Point? _tooltipPosition;

  late final List<dv.Point> _data = List.generate(
    20,
    (i) => dv.Point(
      i.toDouble(),
      20 + 50 * math.sin(i * 0.3) + math.Random(i).nextDouble() * 20,
    ),
  );

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
        title: const Text('Interactive Hover Demo'),
        leading: const BackButton(),
      ),
      appBarBreakpoint: Breakpoints.standard,
      body: (_) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Hover for details',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'This screen is adapted from the original interactive showcase demo and uses the migrated scale utilities from the compat layer.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          DmCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const height = 320.0;
                  final chartSize = Size(constraints.maxWidth, height);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Demand signal explorer',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Move your pointer across the chart or tap a marker on touch devices.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: height,
                        child: MouseRegion(
                          onHover: (event) =>
                              _handleProbe(event.localPosition, chartSize),
                          onExit: (_) => _clearSelection(),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTapDown: (details) =>
                                _handleProbe(details.localPosition, chartSize),
                            onPanUpdate: (details) =>
                                _handleProbe(details.localPosition, chartSize),
                            onPanEnd: (_) => _clearSelection(),
                            child: Stack(
                              children: [
                                CustomPaint(
                                  size: Size(chartSize.width, chartSize.height),
                                  painter: _InteractiveChartPainter(
                                    data: _data,
                                    hoveredIndex: _hoveredIndex,
                                    colorScheme: colorScheme,
                                  ),
                                ),
                                if (_hoveredIndex != null &&
                                    _tooltipPosition != null)
                                  dv.ChartTooltip(
                                    targetPosition: Offset(
                                      _tooltipPosition!.x,
                                      _tooltipPosition!.y,
                                    ),
                                    position: dv.TooltipPosition.top,
                                    offset: const Offset(8, 52),
                                    backgroundColor: colorScheme.inverseSurface,
                                    borderRadius: BorderRadius.circular(12),
                                    child: DefaultTextStyle(
                                      style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: colorScheme
                                                    .onInverseSurface,
                                              ) ??
                                          TextStyle(
                                            color: colorScheme.onInverseSurface,
                                          ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Point ${_hoveredIndex! + 1}'),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Value: ${_data[_hoveredIndex!].y.toStringAsFixed(1)}',
                                            style: TextStyle(
                                              color:
                                                  colorScheme.onInverseSurface,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _hoveredIndex == null
                              ? 'Hover or drag across the plot to inspect a point.'
                              : 'Inspecting point ${_hoveredIndex! + 1} with value ${_data[_hoveredIndex!].y.toStringAsFixed(1)}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleProbe(Offset position, Size size) {
    const margin = EdgeInsets.fromLTRB(48, 24, 24, 40);
    final chartWidth = size.width - margin.left - margin.right;
    final chartHeight = size.height - margin.top - margin.bottom;

    if (chartWidth <= 0 || chartHeight <= 0) return;

    final xScale = dv.scaleLinear(
      domain: [0, _data.length - 1],
      range: [margin.left, margin.left + chartWidth],
    );
    final yMax = _data.map((point) => point.y).reduce(math.max);
    final yScale = dv.scaleLinear(
      domain: [0, yMax * 1.1],
      range: [margin.top + chartHeight, margin.top],
    );

    int? closest;
    double minDistance = 24;

    for (var i = 0; i < _data.length; i++) {
      final scaled = dv.Point(xScale(_data[i].x), yScale(_data[i].y));
      final distance = math.sqrt(
        math.pow(position.dx - scaled.x, 2) +
            math.pow(position.dy - scaled.y, 2),
      );
      if (distance < minDistance) {
        closest = i;
        minDistance = distance;
      }
    }

    if (closest == null) {
      if (_hoveredIndex != null) {
        _clearSelection();
      }
      return;
    }

    setState(() {
      _hoveredIndex = closest;
      _tooltipPosition = dv.Point(
        xScale(_data[closest!].x),
        yScale(_data[closest].y),
      );
    });
  }

  void _clearSelection() {
    if (_hoveredIndex == null && _tooltipPosition == null) return;
    setState(() {
      _hoveredIndex = null;
      _tooltipPosition = null;
    });
  }
}

class _InteractiveChartPainter extends CustomPainter {
  const _InteractiveChartPainter({
    required this.data,
    required this.hoveredIndex,
    required this.colorScheme,
  });

  final List<dv.Point> data;
  final int? hoveredIndex;
  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    const margin = EdgeInsets.fromLTRB(48, 24, 24, 40);
    final chartWidth = size.width - margin.left - margin.right;
    final chartHeight = size.height - margin.top - margin.bottom;
    final yMax = data.map((point) => point.y).reduce(math.max);

    final xScale = dv.scaleLinear(
      domain: [0, data.length - 1],
      range: [margin.left, margin.left + chartWidth],
    );
    final yScale = dv.scaleLinear(
      domain: [0, yMax * 1.1],
      range: [margin.top + chartHeight, margin.top],
    );

    final gridPaint = Paint()
      ..color = colorScheme.outlineVariant
      ..strokeWidth = 1;

    for (var step = 0.0; step <= yMax * 1.1; step += 20) {
      final y = yScale(step);
      canvas.drawLine(
        Offset(margin.left, y),
        Offset(margin.left + chartWidth, y),
        gridPaint,
      );
    }

    final areaPath = Path()..moveTo(xScale(0), yScale(0));
    for (final point in data) {
      areaPath.lineTo(xScale(point.x), yScale(point.y));
    }
    areaPath
      ..lineTo(xScale(data.last.x), yScale(0))
      ..close();

    final areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colorScheme.primary.withValues(alpha: 0.25),
          colorScheme.primary.withValues(alpha: 0.04),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawPath(areaPath, areaPaint);

    final linePath = Path();
    for (var i = 0; i < data.length; i++) {
      final point = data[i];
      final offset = Offset(xScale(point.x), yScale(point.y));
      if (i == 0) {
        linePath.moveTo(offset.dx, offset.dy);
      } else {
        linePath.lineTo(offset.dx, offset.dy);
      }
    }

    canvas.drawPath(
      linePath,
      Paint()
        ..color = colorScheme.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    for (var i = 0; i < data.length; i++) {
      final point = data[i];
      final offset = Offset(xScale(point.x), yScale(point.y));
      final isHovered = hoveredIndex == i;
      canvas.drawCircle(
        offset,
        isHovered ? 7 : 5,
        Paint()..color = isHovered ? colorScheme.tertiary : colorScheme.surface,
      );
      canvas.drawCircle(
        offset,
        isHovered ? 7 : 5,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = isHovered ? 3 : 2
          ..color = isHovered ? colorScheme.tertiary : colorScheme.primary,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _InteractiveChartPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.hoveredIndex != hoveredIndex ||
        oldDelegate.colorScheme != colorScheme;
  }
}
