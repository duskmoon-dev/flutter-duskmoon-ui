import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../dm_chart_models.dart';
import '../dm_chart_palette.dart';
import '../dm_viz_format.dart';
import '../dm_viz_interaction.dart';
import '../dm_viz_layout.dart';
import '../dm_viz_series.dart';
import 'dm_viz_plot_input.dart';

class DmVizSeriesPlot extends StatelessWidget {
  final DmVizChartKind kind;
  final List<DmVizSeries> series;
  final DmVizAxis xAxis;
  final DmVizAxis yAxis;
  final List<DmVizCategory> categories;
  final DmVizOptions options;
  final DmVizInteraction interaction;
  final DmChartPalette? palette;
  final DmVizMarker marker;
  final bool connectMissing;
  final bool sortX;
  final DmVizBarOrientation orientation;
  final double height;

  const DmVizSeriesPlot({
    super.key,
    required this.kind,
    required this.series,
    required this.xAxis,
    required this.yAxis,
    this.categories = const [],
    this.options = const DmVizOptions(),
    this.interaction = const DmVizInteraction(),
    this.palette,
    this.marker = const DmVizMarker(),
    this.connectMissing = false,
    this.sortX = false,
    this.orientation = DmVizBarOrientation.vertical,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) => VizInteractionHost(builder: _build);

  Widget _build(BuildContext context, VizChartController controller) {
    final style = resolveVizChartStyle(context, palette, options);
    VizXYLayout layoutFor(DmVizAxis x, DmVizAxis y, Set<String>? hidden) =>
        layoutVizXY(
          kind: kind,
          series: series,
          xAxis: x,
          yAxis: y,
          palette: style.series,
          options: options,
          connectMissing: connectMissing,
          sortX: sortX,
          orientation: orientation,
          hiddenSeriesIds: hidden,
        );
    DmVizViewport? viewportFor(VizXYLayout layout) {
      final dx = layout.xDomain;
      final dy = layout.yDomain;
      if (dx is! VizDomain || dy == null) return null;
      return switch (kind) {
        DmVizChartKind.line => DmVizViewport.line(dx),
        DmVizChartKind.scatter => DmVizViewport.scatter(dx, dy),
        DmVizChartKind.bar => null,
      };
    }

    final initial = layoutFor(xAxis, yAxis, null);
    controller.configure(
      interaction: interaction,
      series: series.map((series) => series.id).toList(),
      targets: {
        for (final s in series)
          for (final datum in s.data) DmVizTarget.datum(s.id, datum.id),
      },
      initialHidden: options.hiddenSeriesIds,
      initialViewport: viewportFor(initial),
    );
    final state = controller.state;
    final zoomed = controller.hasViewport &&
            state.viewport?.kind == viewportFor(initial)?.kind
        ? state.viewport
        : null;
    final activeX = _axisRange(xAxis, zoomed?.x);
    final activeY = _axisRange(yAxis, zoomed?.y);
    final layout = layoutFor(activeX, activeY, state.hidden);
    final viewport = zoomed ?? viewportFor(layout);
    final horizontal = orientation == DmVizBarOrientation.horizontal;
    final labels = {
      for (final category in categories) category.id: category.label,
    };
    final line = viewport?.kind == DmVizViewportKind.line ? viewport?.x : null;
    final textStyle = style.labelStyle;
    final direction = Directionality.of(context);
    final ready = layout.series.any((series) => series.points.isNotEmpty);
    return VizChartFrame(
      height: height,
      options: options,
      style: style,
      ready: ready,
      error: layout.issues.any((issue) => !issue.warning),
      legend: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final series in layout.series)
            VizActionButton(
              series.source.name,
              selected: series.visible,
              onPressed: () => controller.dispatch(
                vizAction(VizActionType.toggleSeries, id: series.source.id),
              ),
              swatch: DecoratedBox(
                decoration: BoxDecoration(color: series.color),
                child: const SizedBox.square(dimension: 10),
              ),
            ),
        ],
      ),
      actions: VizChartActions(
        controller: controller,
        zoom: viewport == null
            ? null
            : (factor) {
                final x = zoomVizDomain(
                  viewport.x!,
                  .5,
                  factor,
                  integer: xAxis.type == DmVizAxisType.time,
                );
                final next = viewport.y == null
                    ? DmVizViewport.line(x)
                    : DmVizViewport.scatter(
                        x,
                        zoomVizDomain(viewport.y!, .5, factor),
                      );
                controller.dispatch(
                  vizAction(VizActionType.zoom, viewport: next),
                );
              },
      ),
      data: () => [
        for (final source in series)
          for (final point in source.data)
            (
              name: '${source.name} · ${point.id}',
              raw: {'x': point.x, 'y': point.y},
            ),
      ],
      overlay: VizPlotInput(
        bounds: (size) =>
            _xyBounds(size, horizontal, horizontal ? yAxis : xAxis),
        controller: controller,
        selectionColor: style.selectionColor,
        tooltipBackground: style.tooltipBackground,
        tooltipText: style.tooltipText,
        items: (bounds) => [
          for (final series in layout.series)
            for (final point in series.points)
              if (point.position.dx >= 0 &&
                  point.position.dx <= 1 &&
                  point.position.dy >= 0 &&
                  point.position.dy <= 1)
                (
                  tooltip: DmVizTooltipEvent(
                    target: DmVizTarget.datum(series.source.id, point.datum.id),
                    raw: {
                      'x': point.datum.x is DateTime
                          ? (point.datum.x as DateTime).millisecondsSinceEpoch
                          : point.datum.x,
                      'y': point.datum.y,
                    },
                    display:
                        formatVizValue(point.datum.y!, yAxis, labels: labels) +
                            (yAxis.unit == null ? '' : ' ${yAxis.unit}'),
                    unit: yAxis.unit,
                  ),
                  position: _absolutePosition(point.position, bounds),
                  rect: point.rect == null
                      ? null
                      : _absoluteRect(point.rect!, bounds),
                  radius: math.max(12, marker.radius),
                ),
        ],
        zoom: viewport == null
            ? null
            : (_, x, y, factor) {
                final domain = zoomVizDomain(
                  viewport.x!,
                  x,
                  factor,
                  integer: xAxis.type == DmVizAxisType.time,
                );
                final next = viewport.y == null
                    ? DmVizViewport.line(domain)
                    : DmVizViewport.scatter(
                        domain,
                        zoomVizDomain(viewport.y!, 1 - y, factor),
                      );
                controller.dispatch(
                  vizAction(VizActionType.zoom, viewport: next),
                );
              },
        brush: line == null
            ? null
            : (start, end) {
                double position(double fraction) {
                  final value = line.$1 * (1 - fraction) + line.$2 * fraction;
                  return xAxis.type == DmVizAxisType.time
                      ? value.roundToDouble()
                      : value;
                }

                controller.dispatch(
                  vizAction(
                    VizActionType.brush,
                    range: (
                      position(math.min(start, end)),
                      position(math.max(start, end)),
                    ),
                  ),
                );
              },
        brushPixels: line == null || state.brush == null
            ? null
            : (
                vizPosition(state.brush!.$1, line),
                vizPosition(state.brush!.$2, line),
              ),
      ),
      painter: _XYPainter(
        layout: layout,
        xAxis: activeX,
        yAxis: activeY,
        categories: categories,
        kind: kind,
        marker: marker,
        horizontal: orientation == DmVizBarOrientation.horizontal,
        style: style,
        textStyle: textStyle,
        direction: direction,
      ),
    );
  }
}

class DmVizHeatmapPlot extends StatelessWidget {
  final List<DmVizCategory> rows;
  final List<DmVizCategory> columns;
  final List<DmVizHeatmapDatum> data;
  final (double, double)? valueDomain;
  final bool showValues;
  final DmVizOptions options;
  final DmVizInteraction interaction;
  final DmChartPalette? palette;
  final double height;

  const DmVizHeatmapPlot({
    super.key,
    required this.rows,
    required this.columns,
    required this.data,
    this.valueDomain,
    this.showValues = false,
    this.options = const DmVizOptions(),
    this.interaction = const DmVizInteraction(),
    this.palette,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) => VizInteractionHost(builder: _build);

  Widget _build(BuildContext context, VizChartController controller) {
    controller.configure(
      interaction: interaction,
      targets: {for (final cell in data) DmVizTarget.cell(cell.id)},
    );
    final style = resolveVizChartStyle(context, palette, options);
    final layout = layoutVizHeatmap(
      rows: rows,
      columns: columns,
      data: data,
      colors: style.heatmap,
      missing: style.missing,
      explicitDomain: valueDomain,
    );
    final label = style.labelStyle;
    final domain = layout.domain;
    return VizChartFrame(
      options: options,
      style: style,
      height: height,
      ready: data.any((cell) => cell.value != null),
      error: layout.issues.isNotEmpty,
      legend: domain == null
          ? null
          : Semantics(
              label: 'Heatmap color scale',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_decimal(domain.$1), style: label),
                  const SizedBox(width: 8),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: style.heatmap),
                    ),
                    child: const SizedBox(width: 100, height: 8),
                  ),
                  const SizedBox(width: 8),
                  Text(_decimal(domain.$2), style: label),
                ],
              ),
            ),
      actions: VizChartActions(controller: controller),
      data: () => [
        for (final cell in data)
          (
            name: cell.id,
            raw: {
              'row': cell.rowId,
              'column': cell.columnId,
              'value': cell.value,
            },
          ),
      ],
      overlay: VizPlotInput(
        bounds: _heatmapBounds,
        controller: controller,
        selectionColor: style.selectionColor,
        tooltipBackground: style.tooltipBackground,
        tooltipText: style.tooltipText,
        items: (bounds) => [
          for (final entry in layout.cells)
            if (entry.cell case final cell?)
              (
                tooltip: DmVizTooltipEvent(
                  target: DmVizTarget.cell(cell.id),
                  raw: {'value': cell.value},
                  display: cell.value == null
                      ? 'Missing value'
                      : _decimal(cell.value!),
                ),
                position: _absoluteRect(entry.rect, bounds).center,
                rect: _absoluteRect(entry.rect, bounds),
                radius: 0.0,
              ),
        ],
      ),
      painter: _HeatmapPainter(
        layout,
        rows,
        columns,
        showValues,
        label,
        Directionality.of(context),
      ),
    );
  }
}

class VizChartFrame extends StatelessWidget {
  final double height;
  final DmVizOptions options;
  final VizChartStyle style;
  final bool ready;
  final bool error;
  final CustomPainter painter;
  final Widget? legend;
  final Widget? actions;
  final Widget? overlay;
  final List<VizDataRow> Function()? data;

  const VizChartFrame({
    super.key,
    required this.height,
    required this.options,
    required this.style,
    required this.ready,
    required this.error,
    required this.painter,
    this.legend,
    this.actions,
    this.overlay,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    final message = options.loading
        ? 'Loading chart…'
        : error
            ? 'Unable to display chart'
            : !ready
                ? 'No data to display'
                : null;
    return LayoutBuilder(
      builder: (context, constraints) {
        final plot = SizedBox(
          height: constraints.hasBoundedHeight
              ? math.min(height, constraints.maxHeight * .65)
              : height,
          child: message == null
              ? CustomPaint(
                  painter: painter,
                  child: SizedBox.expand(child: overlay),
                )
              : Center(
                  child: Semantics(liveRegion: true, child: Text(message)),
                ),
        );
        final content = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Semantics(
                header: true,
                child: Text(options.title ?? 'Chart', style: style.titleStyle),
              ),
            ),
            if (options.description case final description?)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(description),
              ),
            plot,
            if (legend case final legend?)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: legend,
              ),
            if (actions case final actions?) actions,
            if (data case final data?) _VizDataOutlet(data: data, style: style),
            if (options.summary case final summary?)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(summary),
              ),
          ],
        );
        return ColoredBox(
          color: style.background,
          child: DefaultTextStyle.merge(
            style: style.bodyStyle.copyWith(color: style.text),
            child: constraints.hasBoundedHeight
                ? SingleChildScrollView(child: content)
                : content,
          ),
        );
      },
    );
  }
}

String _decimal(double value) =>
    formatVizValue(value, const DmVizAxis.numeric());

void _label(
  Canvas canvas,
  String value,
  Offset origin,
  double width,
  TextStyle style,
  TextDirection direction, {
  TextAlign align = TextAlign.start,
}) {
  if (width <= 0) return;
  final painter = TextPainter(
    text: TextSpan(text: value, style: style),
    textDirection: direction,
    textAlign: align,
    maxLines: 1,
    ellipsis: '…',
  )..layout(minWidth: width, maxWidth: width);
  painter.paint(canvas, origin);
  painter.dispose();
}

class VizInteractionHost extends StatefulWidget {
  final Widget Function(BuildContext, VizChartController) builder;
  const VizInteractionHost({super.key, required this.builder});

  @override
  State<VizInteractionHost> createState() => _VizInteractionHostState();
}

class _VizInteractionHostState extends State<VizInteractionHost> {
  final _controller = VizChartController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: _controller,
        builder: (context, _) => widget.builder(context, _controller),
      );
}

class VizChartActions extends StatelessWidget {
  final VizChartController controller;

  final ValueChanged<double>? zoom;
  const VizChartActions({super.key, required this.controller, this.zoom});

  @override
  Widget build(BuildContext context) => Wrap(
        children: [
          if (zoom case final apply?) ...[
            VizActionButton('Zoom in', onPressed: () => apply(1 / 1.2)),
            VizActionButton('Zoom out', onPressed: () => apply(1.2)),
          ],
          VizActionButton(
            'Clear selection',
            onPressed: () =>
                controller.dispatch(vizAction(VizActionType.clearSelection)),
          ),
          if (controller.state.brush != null)
            VizActionButton(
              'Clear range',
              onPressed: () =>
                  controller.dispatch(vizAction(VizActionType.clearBrush)),
            ),
          VizActionButton(
            'Reset chart',
            onPressed: () =>
                controller.dispatch(vizAction(VizActionType.reset)),
          ),
        ],
      );
}

DmVizAxis _axisRange(DmVizAxis axis, VizDomain? range) {
  if (range == null) return axis;
  final domain = [range.$1, range.$2];
  return axis.type == DmVizAxisType.time
      ? DmVizAxis.time(
          domain: domain,
          tickValues: axis.tickValues,
          label: axis.label,
          unit: axis.unit,
          format: axis.format,
        )
      : DmVizAxis.numeric(
          domain: domain,
          tickValues: axis.tickValues?.cast<num>(),
          label: axis.label,
          unit: axis.unit,
          format: axis.format,
        );
}

Rect _xyBounds(Size size, bool horizontal, DmVizAxis bottomAxis) {
  final bottomPadding = bottomAxis.label == null ? 28.0 : 44.0;
  final paddingScale = math.min(1.0, size.height / (bottomPadding + 48));
  final rect = Rect.fromLTRB(
    math.min(size.width / 3, horizontal ? 140 : 100),
    16 * paddingScale,
    size.width - 16,
    size.height - bottomPadding * paddingScale,
  );
  return rect.isEmpty ? Rect.zero : rect;
}

Rect _heatmapBounds(Size size) {
  final rect = Rect.fromLTRB(
    math.min(110, size.width / 3),
    26,
    size.width - 16,
    size.height - 16,
  );
  return rect.isEmpty ? Rect.zero : rect;
}

Offset _absolutePosition(Offset position, Rect plot) => Offset(
      plot.left + position.dx * plot.width,
      plot.top + position.dy * plot.height,
    );

Rect _absoluteRect(Rect rect, Rect plot) => Rect.fromLTWH(
      plot.left + rect.left * plot.width,
      plot.top + rect.top * plot.height,
      rect.width * plot.width,
      rect.height * plot.height,
    );

class _XYPainter extends CustomPainter {
  final VizXYLayout layout;
  final DmVizAxis xAxis;
  final DmVizAxis yAxis;
  final List<DmVizCategory> categories;
  final DmVizChartKind kind;
  final DmVizMarker marker;
  final bool horizontal;
  final VizChartStyle style;
  final TextStyle textStyle;
  final TextDirection direction;

  _XYPainter({
    required this.layout,
    required this.xAxis,
    required this.yAxis,
    required this.categories,
    required this.kind,
    required this.marker,
    required this.horizontal,
    required this.style,
    required this.textStyle,
    required this.direction,
  });

  List<(double, String)> _ticks(
    DmVizAxis axis,
    Object domain,
    List<Object> ticks,
  ) {
    if (domain is List<String>) {
      final index = {for (final (index, id) in domain.indexed) id: index};
      final labels = {
        for (final category in categories) category.id: category.label,
      };
      return [
        for (final value in ticks.whereType<String>())
          if (index.containsKey(value))
            ((index[value]! + 0.5) / domain.length, labels[value] ?? value),
      ];
    }
    final range = domain as VizDomain;
    final values = axis.tickValues != null
        ? ticks
        : List.generate(
            5,
            (index) => range.$1 * (1 - index / 4) + range.$2 * (index / 4),
          );
    return [
      for (final value in values
          .map((value) => normalizeVizAxisValue(value, axis))
          .whereType<double>())
        if (value >= range.$1 && value <= range.$2)
          (vizPosition(value, range), formatVizValue(value, axis)),
    ];
  }

  @override
  void paint(Canvas canvas, Size size) {
    final xDomain = layout.xDomain;
    final yDomain = layout.yDomain;
    if (xDomain == null || yDomain == null) return;
    final bottomAxis = horizontal ? yAxis : xAxis;
    final leftAxis = horizontal ? xAxis : yAxis;
    final plot = _xyBounds(size, horizontal, bottomAxis);
    if (plot.isEmpty) return;
    final paint = Paint();
    canvas.drawRect(plot, paint..color = style.plot);
    final xTicks = _ticks(xAxis, xDomain, layout.xTicks);
    final yTicks = _ticks(yAxis, yDomain, layout.yTicks);
    final bottomTicks = horizontal ? yTicks : xTicks;
    final leftTicks =
        horizontal ? xTicks : yTicks.map((tick) => (1 - tick.$1, tick.$2));
    for (final (fraction, text) in leftTicks) {
      final y = plot.top + fraction * plot.height;
      canvas.drawLine(
        Offset(plot.left, y),
        Offset(plot.right, y),
        paint..color = style.grid,
      );
      final reserved = leftAxis.label == null ? 0.0 : 16.0;
      _label(
        canvas,
        text,
        Offset(reserved, y - 8),
        plot.left - 8 - reserved,
        textStyle,
        direction,
        align: TextAlign.right,
      );
    }
    for (final (fraction, text) in bottomTicks) {
      final x = plot.left + fraction * plot.width;
      canvas.drawLine(
        Offset(x, plot.top),
        Offset(x, plot.bottom),
        paint..color = style.grid,
      );
      final width = math.min(plot.width / bottomTicks.length, 150.0);
      _label(
        canvas,
        text,
        Offset((x - width / 2).clamp(0.0, size.width - width), plot.bottom + 6),
        width,
        textStyle,
        direction,
        align: TextAlign.center,
      );
    }
    if (bottomAxis.label case final label?) {
      _label(
        canvas,
        label,
        Offset(plot.left, plot.bottom + 24),
        plot.width,
        textStyle,
        direction,
        align: TextAlign.center,
      );
    }
    if (leftAxis.label case final label?) {
      canvas.save();
      canvas.translate(0, plot.bottom);
      canvas.rotate(-math.pi / 2);
      _label(
        canvas,
        label,
        Offset.zero,
        plot.height,
        textStyle,
        direction,
        align: TextAlign.center,
      );
      canvas.restore();
    }
    canvas.drawLine(plot.topLeft, plot.bottomLeft, paint..color = style.axis);
    canvas.drawLine(plot.bottomLeft, plot.bottomRight, paint);
    if (layout.baseline case final baseline?) {
      if (horizontal) {
        final x = plot.left + baseline * plot.width;
        canvas.drawLine(Offset(x, plot.top), Offset(x, plot.bottom), paint);
      } else {
        final y = plot.top + baseline * plot.height;
        canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), paint);
      }
    }

    Offset absolute(Offset offset) => Offset(
          plot.left + offset.dx * plot.width,
          plot.top + offset.dy * plot.height,
        );
    canvas.save();
    canvas.clipRect(plot);
    final outline = Paint()
      ..color = style.axis.withValues(alpha: .72)
      ..strokeWidth = .7
      ..style = PaintingStyle.stroke;
    for (final series in layout.series.where((series) => series.visible)) {
      for (final segment in series.segments) {
        final path = Path();
        for (final (index, point) in segment.indexed) {
          final position = absolute(point.position);
          if (index == 0) {
            path.moveTo(position.dx, position.dy);
          } else {
            path.lineTo(position.dx, position.dy);
          }
        }
        canvas.drawPath(path, outline..strokeWidth = 3.5);
        canvas.drawPath(
          path,
          Paint()
            ..color = series.color
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke,
        );
      }
      for (final point in series.points) {
        if (point.rect case final rect?) {
          canvas.drawRect(
            _absoluteRect(rect, plot),
            paint..color = point.color,
          );
          canvas.drawRect(
            _absoluteRect(rect, plot),
            outline..strokeWidth = .65,
          );
        } else if (marker.visible ?? (kind == DmVizChartKind.scatter)) {
          final position = absolute(point.position);
          if (position.dx >= plot.left &&
              position.dx <= plot.right &&
              position.dy >= plot.top &&
              position.dy <= plot.bottom) {
            _drawMarker(
              canvas,
              position,
              point.color,
              marker,
              outline..strokeWidth = .85,
            );
          }
        }
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _XYPainter oldDelegate) => true;
}

void _drawMarker(
  Canvas canvas,
  Offset point,
  Color color,
  DmVizMarker marker,
  Paint outline,
) {
  final radius = marker.radius;
  final paint = Paint()..color = color;
  switch (marker.shape) {
    case DmVizMarkerShape.circle:
      canvas.drawCircle(point, radius, paint);
      canvas.drawCircle(point, radius, outline);
    case DmVizMarkerShape.square:
      canvas.drawRect(Rect.fromCircle(center: point, radius: radius), paint);
      canvas.drawRect(Rect.fromCircle(center: point, radius: radius), outline);
    case DmVizMarkerShape.cross || DmVizMarkerShape.plus:
      canvas.save();
      canvas.translate(point.dx, point.dy);
      if (marker.shape == DmVizMarkerShape.cross) canvas.rotate(math.pi / 4);
      canvas.drawLine(
        Offset(-radius, 0),
        Offset(radius, 0),
        paint..strokeWidth = 2,
      );
      canvas.drawLine(Offset(0, -radius), Offset(0, radius), paint);
      canvas.restore();
    case DmVizMarkerShape.diamond ||
          DmVizMarkerShape.triangle ||
          DmVizMarkerShape.star:
      final count = marker.shape == DmVizMarkerShape.triangle
          ? 3
          : marker.shape == DmVizMarkerShape.diamond
              ? 4
              : 10;
      final path = Path();
      for (var index = 0; index < count; index++) {
        final angle = index * 2 * math.pi / count - math.pi / 2;
        final distance = count == 10 && index.isOdd ? radius * .45 : radius;
        final vertex = point +
            Offset(math.cos(angle) * distance, math.sin(angle) * distance);
        if (index == 0) {
          path.moveTo(vertex.dx, vertex.dy);
        } else {
          path.lineTo(vertex.dx, vertex.dy);
        }
      }
      canvas.drawPath(path..close(), paint);
      canvas.drawPath(path, outline);
  }
}

class _HeatmapPainter extends CustomPainter {
  final VizHeatmapLayout layout;
  final List<DmVizCategory> rows;
  final List<DmVizCategory> columns;
  final bool showValues;
  final TextStyle style;
  final TextDirection direction;

  _HeatmapPainter(
    this.layout,
    this.rows,
    this.columns,
    this.showValues,
    this.style,
    this.direction,
  );

  @override
  void paint(Canvas canvas, Size size) {
    if (rows.isEmpty || columns.isEmpty) return;
    final plot = _heatmapBounds(size);
    if (plot.isEmpty) return;
    final columnWidth = plot.width / columns.length;
    final rowHeight = plot.height / rows.length;
    for (final (index, row) in rows.indexed) {
      _label(
        canvas,
        row.label,
        Offset(0, plot.top + (index + 0.5) * rowHeight - 8),
        plot.left - 8,
        style,
        direction,
        align: TextAlign.right,
      );
    }
    for (final (index, column) in columns.indexed) {
      _label(
        canvas,
        column.label,
        Offset(plot.left + index * columnWidth, 6),
        columnWidth,
        style,
        direction,
        align: TextAlign.center,
      );
    }
    final paint = Paint();
    for (final cell in layout.cells) {
      final rect = _absoluteRect(cell.rect, plot);
      canvas.drawRect(rect, paint..color = cell.color);
      if (cell.cell?.value case final value? when showValues) {
        _label(
          canvas,
          _decimal(value),
          Offset(rect.left, rect.center.dy - 8),
          rect.width,
          style,
          direction,
          align: TextAlign.center,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HeatmapPainter oldDelegate) => true;
}

typedef VizDataRow = ({String name, Map<String, Object?> raw});

class _VizDataOutlet extends StatelessWidget {
  final List<VizDataRow> Function() data;
  final VizChartStyle style;

  const _VizDataOutlet({required this.data, required this.style});

  @override
  Widget build(BuildContext context) => VizActionButton(
        'Show chart data',
        onPressed: () {
          final rows = data();
          var page = 0;
          final last = math.max(0, (rows.length - 1) ~/ 100);
          showGeneralDialog<void>(
            context: context,
            barrierDismissible: true,
            barrierLabel: 'Close chart data',
            pageBuilder: (context, _, _) => Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: 480, maxHeight: 360),
                child: ColoredBox(
                  color: style.background,
                  child: DefaultTextStyle(
                    style: style.labelStyle.copyWith(color: style.text),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: StatefulBuilder(
                        builder: (context, redraw) {
                          final displayed =
                              rows.skip(page * 100).take(100).toList();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Semantics(
                                header: true,
                                child: Text(
                                  'Chart data (${rows.length})',
                                  style: style.titleStyle,
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: displayed.length,
                                  itemBuilder: (context, index) {
                                    final row = displayed[index];
                                    final text = row.raw.entries
                                        .map(
                                          (entry) =>
                                              '${entry.key}: ${entry.value ?? "missing"}',
                                        )
                                        .join(', ');
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 3,
                                      ),
                                      child: Text('${row.name}: $text'),
                                    );
                                  },
                                ),
                              ),
                              Wrap(
                                children: [
                                  if (page > 0)
                                    VizActionButton(
                                      'Previous data page',
                                      onPressed: () => redraw(() => page--),
                                    ),
                                  if (page < last)
                                    VizActionButton(
                                      'Next data page',
                                      onPressed: () => redraw(() => page++),
                                    ),
                                  VizActionButton(
                                    'Close',
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
}
