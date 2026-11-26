import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../dm_chart_palette.dart';
import '../dm_geo_models.dart';
import '../dm_network_models.dart';
import '../dm_viz_format.dart';
import '../dm_viz_interaction.dart';
import '../dm_viz_scene.dart';
import '../dm_viz_series.dart';
import 'dm_viz_plot_input.dart';
import 'dm_viz_series_plot.dart';

class DmVizScenePlot extends StatefulWidget {
  final List<DmVizNetworkNode> nodes;
  final List<DmVizNetworkEdge> edges;
  final GeoJsonFeatureCollection? map;
  final Offset? center;
  final double padding;
  final DmChartPalette? palette;
  final DmVizOptions options;
  final DmVizInteraction interaction;
  final double height;

  const DmVizScenePlot({
    super.key,
    this.nodes = const [],
    this.edges = const [],
    this.map,
    this.center,
    this.padding = 0,
    this.palette,
    this.options = const DmVizOptions(),
    this.interaction = const DmVizInteraction(),
    this.height = 300,
  });

  @override
  State<DmVizScenePlot> createState() => _DmVizScenePlotState();
}

class _DmVizScenePlotState extends State<DmVizScenePlot> {
  final _moves = <String, (Offset, Offset)>{};

  @override
  Widget build(BuildContext context) => VizInteractionHost(builder: _build);

  Widget _build(BuildContext context, VizChartController controller) {
    final map = widget.map;
    final network = map == null
        ? vizNetworkScene(widget.nodes, widget.edges)
        : null;
    final geo = map == null
        ? null
        : vizMapScene(map, center: widget.center, padding: widget.padding);
    final bounds = network?.bounds ?? geo?.bounds;
    final initial = network?.viewport ?? geo?.viewport;
    final style = resolveVizChartStyle(context, widget.palette, widget.options);
    final errors = (network?.issues ?? geo!.issues).isNotEmpty;
    final targets = <DmVizTarget>{
      for (final node in widget.nodes) DmVizTarget.node(node.id),
      for (final edge in widget.edges)
        if (edge.id != null) DmVizTarget.edge(edge.id!),
      for (final feature in geo?.features ?? <VizMapFeature>[])
        DmVizTarget.feature(feature.id),
    };
    controller.configure(
      interaction: widget.interaction,
      targets: targets,
      initialViewport: initial,
    );
    final state = controller.state;
    final supplied = state.viewport;
    final viewport =
        supplied?.kind == initial?.kind && (supplied?.valid ?? false)
        ? supplied
        : initial;
    final paintNodes = <String, (DmVizNetworkNode, Offset)>{
      if (network?.bounds != null)
        for (final node in widget.nodes) node.id: (node, _nodePosition(node)),
    };

    Rect plotBounds(Size size) => size.isEmpty ? Rect.zero : Offset.zero & size;
    VizSceneTransform? transform(Rect plot) {
      if (bounds == null || initial == null || viewport == null) return null;
      final fit = fitVizScene(
        bounds,
        initial,
        plot.size,
        padding: widget.padding,
      );
      return fit == null ? null : VizSceneTransform(plot, fit, viewport);
    }

    DmVizTooltipEvent nodeTip(DmVizNetworkNode node, Offset world) =>
        DmVizTooltipEvent(
          target: DmVizTarget.node(node.id),
          raw: {'x': world.dx, 'y': world.dy},
          display: node.label ?? node.id,
        );
    DmVizTooltipEvent edgeTip(DmVizNetworkEdge edge) => DmVizTooltipEvent(
      target: DmVizTarget.edge(edge.id!),
      raw: {'source': edge.source, 'target': edge.target},
      display: edge.label ?? edge.id!,
    );
    DmVizTooltipEvent featureTip(VizMapFeature feature) {
      final value = feature.source.properties['value'];
      final name = feature.source.properties['name'];
      final title = name is String ? name : feature.id;
      return DmVizTooltipEvent(
        target: DmVizTarget.feature(feature.id),
        raw: {if (value is num) 'value': value},
        display: value is num
            ? '$title: ${formatVizValue(value, const DmVizAxis.numeric())}'
            : title,
      );
    }

    List<VizHit> items(Rect plot) {
      final view = transform(plot);
      if (view == null) return [];
      return [
        for (final (node, world) in paintNodes.values)
          (
            tooltip: nodeTip(node, world),
            position: view.forward(world),
            rect: null,
            radius: 11.0,
          ),
        for (final edge in network?.edges ?? [])
          (
            tooltip: edgeTip(edge),
            position: view.forward(
              (paintNodes[edge.source]!.$2 + paintNodes[edge.target]!.$2) / 2,
            ),
            rect: null,
            radius: 7.0,
          ),
        for (final feature in geo?.features ?? <VizMapFeature>[])
          (
            tooltip: featureTip(feature),
            position: view.forward(
              feature.point ?? feature.polygons.first.first.first,
            ),
            rect: null,
            radius: 9.0,
          ),
      ];
    }

    VizHit? hit(Rect plot, Offset point) {
      final view = transform(plot);
      if (view == null) return null;
      if (geo != null) {
        final feature = hitVizMap(geo, view.inverse(point), 9 / view.scale);
        return feature == null
            ? null
            : (
                tooltip: featureTip(feature),
                position: point,
                rect: null,
                radius: 9,
              );
      }
      for (final (node, world) in paintNodes.values.toList().reversed) {
        final position = view.forward(world);
        if ((position - point).distance <= 11) {
          return (
            tooltip: nodeTip(node, world),
            position: position,
            rect: null,
            radius: 11,
          );
        }
      }
      DmVizNetworkEdge? selected;
      double nearest = 7;
      for (final edge in network!.edges) {
        final distance = distanceToVizSegment(
          point,
          view.forward(paintNodes[edge.source]!.$2),
          view.forward(paintNodes[edge.target]!.$2),
        );
        if (distance <= nearest) {
          nearest = distance;
          selected = edge;
        }
      }
      return selected == null
          ? null
          : (
              tooltip: edgeTip(selected),
              position: point,
              rect: null,
              radius: 7,
            );
    }

    DmVizViewport movedViewport(Offset projected, double zoom) {
      if (map == null) return DmVizViewport.network(projected, zoom);
      final point = unprojectVizMercator(projected);
      return DmVizViewport.map(
        Offset(point.dx.clamp(-180, 180), point.dy.clamp(-85, 85)),
        zoom,
      );
    }

    void zoom(Rect plot, double x, double y, double factor) {
      final view = transform(plot);
      if (view == null || viewport == null) return;
      final anchor = Offset(
        plot.left + x * plot.width,
        plot.top + y * plot.height,
      );
      final nextZoom = (viewport.zoom! / factor).clamp(.2, 64.0);
      final scale = view.scale * nextZoom / viewport.zoom!;
      final next = movedViewport(
        view.inverse(anchor) - (anchor - plot.center) / scale,
        nextZoom,
      );
      controller.dispatch(vizAction(VizActionType.zoom, viewport: next));
    }

    void drag(Rect plot, Offset start, Offset end, DmVizTarget? target) {
      final view = transform(plot);
      if (view == null || viewport == null) return;
      if (target?.kind == DmVizTargetKind.node) {
        final id = target!.id;
        final node = network!.nodes[id]!;
        final position = view.inverse(end);
        setState(() => _moves[id] = (Offset(node.x!, node.y!), position));
        controller.dispatch(
          vizAction(VizActionType.dragNode, id: id, position: position),
        );
      } else {
        final center = view.center + (start - end) / view.scale;
        controller.dispatch(
          vizAction(
            VizActionType.pan,
            viewport: movedViewport(center, viewport.zoom!),
          ),
        );
      }
    }

    return VizChartFrame(
      height: widget.height,
      options: widget.options,
      style: style,
      ready: bounds != null,
      error: errors,
      actions: VizChartActions(
        controller: controller,
        zoom: viewport == null
            ? null
            : (factor) {
                final nextZoom = (viewport.zoom! / factor).clamp(.2, 64.0);
                final next = viewport.kind == DmVizViewportKind.network
                    ? DmVizViewport.network(viewport.center!, nextZoom)
                    : DmVizViewport.map(viewport.center!, nextZoom);
                controller.dispatch(
                  vizAction(VizActionType.zoom, viewport: next),
                );
              },
      ),
      data: () => [
        for (final node in widget.nodes)
          (name: node.label ?? node.id, raw: {'x': node.x, 'y': node.y}),
        for (final edge in widget.edges)
          (
            name: edge.label ?? edge.id ?? '',
            raw: {'source': edge.source, 'target': edge.target},
          ),
        for (final feature in geo?.features ?? <VizMapFeature>[])
          (
            name: feature.id,
            raw: {
              'geometry': feature.source.geometry?.type,
              'value': ?feature.source.properties['value'],
            },
          ),
      ],
      painter: _ScenePainter(
        transform: transform,
        style: style,
        direction: Directionality.of(context),
        nodes: paintNodes,
        edges: network?.edges ?? const [],
        features: geo?.features ?? const [],
        selection: state.ids.toSet(),
      ),
      overlay: VizPlotInput(
        bounds: plotBounds,
        items: items,
        controller: controller,
        selectionColor: style.selectionColor,
        tooltipBackground: style.tooltipBackground,
        tooltipText: style.tooltipText,
        zoom: zoom,
        onDrag: drag,
        hitTest: hit,
      ),
    );
  }

  Offset _nodePosition(DmVizNetworkNode node) {
    final original = Offset(node.x!, node.y!);
    final move = _moves[node.id];
    return move?.$1 == original ? move!.$2 : original;
  }
}

class _ScenePainter extends CustomPainter {
  final VizSceneTransform? Function(Rect) transform;
  final VizChartStyle style;
  final TextDirection direction;
  final Map<String, (DmVizNetworkNode, Offset)> nodes;
  final List<DmVizNetworkEdge> edges;
  final List<VizMapFeature> features;
  final Set<DmVizTarget> selection;

  _ScenePainter({
    required this.transform,
    required this.style,
    required this.direction,
    required this.nodes,
    required this.edges,
    required this.features,
    required this.selection,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final plot = Offset.zero & size;
    final view = transform(plot);
    final paint = Paint()..color = style.plot;
    canvas.drawRect(plot, paint);
    if (view == null) return;
    canvas.save();
    canvas.clipRect(plot);
    for (final edge in edges) {
      final from = view.forward(nodes[edge.source]!.$2);
      final to = view.forward(nodes[edge.target]!.$2);
      canvas.drawLine(
        from,
        to,
        paint
          ..color = edge.color ?? style.axis
          ..strokeWidth = selection.contains(DmVizTarget.edge(edge.id!))
              ? 4
              : 1.5,
      );
    }
    for (final (node, world) in nodes.values) {
      final point = view.forward(world);
      if (!plot.inflate(8).contains(point)) continue;
      canvas.drawCircle(
        point,
        6,
        paint..color = node.color ?? style.series.first,
      );
      final label = TextPainter(
        text: TextSpan(text: node.label ?? node.id, style: style.labelStyle),
        textDirection: direction,
        maxLines: 1,
        ellipsis: '…',
      )..layout(maxWidth: math.max(32, size.width / 3));
      label.paint(canvas, point + const Offset(9, -12));
      label.dispose();
    }
    for (final feature in features) {
      for (final polygon in feature.polygons) {
        final path = Path()..fillType = PathFillType.evenOdd;
        for (final ring in polygon) {
          path.addPolygon(ring.map(view.forward).toList(), true);
        }
        canvas.drawPath(
          path,
          paint..color = style.series[3 % style.series.length],
        );
        final selected = selection.contains(DmVizTarget.feature(feature.id));
        canvas.drawPath(
          path,
          Paint()
            ..color = selected ? style.selectionColor : style.axis
            ..style = PaintingStyle.stroke
            ..strokeWidth = selected ? 3 : 1,
        );
      }
    }
    for (final feature in features) {
      if (feature.point case final position?) {
        canvas.drawCircle(
          view.forward(position),
          5,
          paint..color = style.series.first,
        );
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ScenePainter oldDelegate) => true;
}
