import 'dart:convert';
import 'dart:io';

import 'package:duskmoon_visualization/duskmoon_visualization.dart';
import 'package:duskmoon_visualization/src/dm_viz_interaction.dart'
    show VizActionType, transitionViz, vizAction, vizInitial;
import 'package:duskmoon_visualization/src/dm_viz_scene.dart'
    show VizSceneTransform, fitVizScene, hitVizMap, projectVizMercator;
import 'package:duskmoon_visualization/src/widgets/dm_viz_plot_input.dart'
    show VizPlotInput;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

typedef Json = Map<String, dynamic>;

Json _read(String path) {
  var root = Directory.current;
  while (!Directory('${root.path}/specs/visualization/v1').existsSync()) {
    if (root.parent.path == root.path)
      throw StateError('Missing contract snapshot');
    root = root.parent;
  }
  return jsonDecode(
    File('${root.path}/specs/visualization/v1/$path').readAsStringSync(),
  ) as Json;
}

List<DmVizNetworkNode> _nodes(Json chart) => [
      for (final node in (chart['nodes'] as List).cast<Json>())
        DmVizNetworkNode(
          id: node['id'] as String,
          x: (node['x'] as num).toDouble(),
          y: (node['y'] as num).toDouble(),
        ),
    ];
List<DmVizNetworkEdge> _edges(Json chart) => [
      for (final edge in (chart['edges'] as List).cast<Json>())
        DmVizNetworkEdge(
          id: edge['id'] as String,
          source: edge['source'] as String,
          target: edge['target'] as String,
        ),
    ];

Offset _point(Object? raw) {
  final values = (raw as List).cast<num>();
  return Offset(values[0].toDouble(), values[1].toDouble());
}

void _near(Offset point, Object? expected, double tolerance) {
  final pair = _point(expected);
  expect(point.dx, closeTo(pair.dx, tolerance));
  expect(point.dy, closeTo(pair.dy, tolerance));
}

void main() {
  final scenes = _read('fixtures/scenes.json');
  final results = _read('expected/scenes.json');
  for (final MapEntry(key: id, value: data) in scenes.entries) {
    test(id, () {
      final fixture = data as Json;
      final chart = fixture['chart'] as Json;
      final expected = results[id] as Json;
      final geometry = expected['geometry'] as Json;
      final tolerance = geometry['tolerance'] as double;
      final sizePoint = _point(fixture['plotSize']);
      final size = Size(sizePoint.dx, sizePoint.dy);
      final plot = Offset.zero & size;
      Offset normalized(Offset point) =>
          Offset(point.dx / size.width, point.dy / size.height);
      if (chart['kind'] == 'network') {
        final scene = vizNetworkScene(_nodes(chart), _edges(chart));
        expect(scene.issues, isEmpty);
        expect(scene.viewport!.toJson(), expected['viewport']);
        final view = VizSceneTransform(
          plot,
          fitVizScene(scene.bounds!, scene.viewport!, size)!,
          scene.viewport!,
        );
        Offset screen(String name) {
          final node = scene.nodes[name]!;
          return normalized(view.forward(Offset(node.x!, node.y!)));
        }

        for (final MapEntry(key: key, value: point)
            in (geometry['nodes'] as Json).entries) {
          _near(screen(key), point, tolerance);
        }
        for (final edge in scene.edges) {
          final points = (geometry['edges'] as Json)[edge.id] as List;
          _near(screen(edge.source), points[0], tolerance);
          _near(screen(edge.target), points[1], tolerance);
        }
      } else {
        final padding =
            ((chart['options'] as Json)['padding'] as num).toDouble();
        final scene = vizMapScene(
          GeoJsonFeatureCollection.fromJson(chart['geoJson'] as Json),
          padding: padding,
        );
        expect(scene.issues, isEmpty);
        final viewport = scene.viewport!;
        _near(
          viewport.center!,
          (expected['viewport'] as Json)['center'],
          tolerance,
        );
        expect(viewport.zoom, (expected['viewport'] as Json)['zoom']);
        final view = VizSceneTransform(
          plot,
          fitVizScene(scene.bounds!, viewport, size, padding: padding)!,
          viewport,
        );
        for (final MapEntry(key: key, value: value)
            in (geometry['points'] as Json).entries) {
          final point =
              scene.features.firstWhere((feature) => feature.id == key).point!;
          _near(normalized(view.forward(point)), value, tolerance);
        }
        final ring = scene.features
            .firstWhere((feature) => feature.id == 'region')
            .polygons
            .first
            .first;
        final y = ring
            .map((position) => normalized(view.forward(position)).dy)
            .toList()
          ..sort();
        expect(y.first, closeTo(geometry['outerTop'] as num, tolerance));
        expect(y.last, closeTo(geometry['outerBottom'] as num, tolerance));
        expect(
          (fixture['hitLocations'] as List).map((position) {
            final projected = projectVizMercator(_point(position));
            return hitVizMap(
              scene,
              view.inverse(view.forward(projected)),
              5 / view.scale,
            )?.id;
          }).toList(),
          expected['hitIds'],
        );
      }
    });
  }

  final invalid = _read('fixtures/validation.json');
  final invalidResults = _read('expected/validation.json');
  for (final (id, _) in [
    ('unknown-node', 0),
    ('invalid-latitude', 1),
    ('date-line-crossing', 2),
  ]) {
    test(id, () {
      final input = invalid[id] as Json;
      final chart = input['chart'] as Json;
      final mutation = (input['mutations'] as List).single as Json;
      final keys = (mutation['path'] as String).split('/').skip(1).toList();
      Object item = chart;
      for (final part in keys.take(keys.length - 1)) {
        item = (item is List ? item[int.parse(part)] : (item as Json)[part])
            as Object;
      }
      if (item is List) {
        item[int.parse(keys.last)] = mutation['value'];
      } else {
        (item as Json)[keys.last] = mutation['value'];
      }
      final issues = chart['kind'] == 'network'
          ? vizNetworkScene(_nodes(chart), _edges(chart)).issues
          : vizMapScene(
              GeoJsonFeatureCollection.fromJson(chart['geoJson'] as Json),
            ).issues;
      expect(
        issues
            .map(
              (issue) => {
                'code': issue.code,
                'path': issue.path,
                'severity': issue.warning ? 'warning' : 'error',
              },
            )
            .toList(),
        (invalidResults[id] as Json)['issues'],
      );
    });
  }

  test('post-zoom node drag fixture', () {
    const id = 'network-zoom-drag-and-cancel';
    final input = _read('fixtures/interaction.json')[id] as Json;
    final expected = _read('expected/interaction.json')[id] as Json;
    final chart = input['chart'] as Json;
    final scene = vizNetworkScene(_nodes(chart), _edges(chart));
    final plotSize = _point(input['plotSize']);
    final size = Size(plotSize.dx, plotSize.dy);
    final actions = (input['actions'] as List).cast<Json>();
    final zoom = actions[0]['viewport'] as Json;
    final viewport = DmVizViewport.network(
      _point(zoom['center']),
      (zoom['zoom'] as num).toDouble(),
    );
    final initial = vizInitial(viewport: scene.viewport);
    final first = transitionViz(
      initial,
      vizAction(VizActionType.zoom, viewport: viewport),
      initial: initial,
    );
    final view = VizSceneTransform(
      Offset.zero & size,
      fitVizScene(scene.bounds!, scene.viewport!, size)!,
      viewport,
    );
    final point = _point(actions[1]['plotPosition']);
    final second = transitionViz(
      first.state,
      vizAction(
        VizActionType.dragNode,
        id: actions[1]['id'] as String,
        position: view.inverse(
          Offset(point.dx * size.width, point.dy * size.height),
        ),
      ),
      initial: initial,
    );
    final cancel = transitionViz(
      second.state,
      vizAction(VizActionType.cancel),
      initial: initial,
    );
    expect(
      [
        ...first.events,
        ...second.events,
        ...cancel.events,
      ].map((event) => event.toJson()).toList(),
      expected['events'],
    );
  });

  test('map viewport and selection reset fixture', () {
    const id = 'map-viewport-and-point-selection';
    final input = _read('fixtures/interaction.json')[id] as Json;
    final expected = _read('expected/interaction.json')[id] as Json;
    final chart = input['chart'] as Json;
    final scene = vizMapScene(
      GeoJsonFeatureCollection.fromJson(chart['geoJson'] as Json),
      padding: 0,
    );
    final initial = vizInitial(viewport: scene.viewport);
    var state = initial;
    final events = <DmVizEvent>[];
    for (final action in (input['actions'] as List).cast<Json>()) {
      final next = switch (action['type']) {
        'zoom' => vizAction(
            VizActionType.zoom,
            viewport: DmVizViewport.map(
              _point((action['viewport'] as Json)['center']),
              ((action['viewport'] as Json)['zoom'] as num).toDouble(),
            ),
          ),
        'activate' => vizAction(
            VizActionType.activate,
            target: DmVizTarget.feature(
              (action['target'] as Json)['id'] as String,
            ),
          ),
        'reset' => vizAction(VizActionType.reset),
        _ => throw StateError('Unexpected map fixture action'),
      };
      final result = transitionViz(state, next, initial: initial);
      state = result.state;
      events.addAll(result.events);
    }
    expect(events.map((event) => event.toJson()).toList(), expected['events']);
  });

  testWidgets('map distinguishes a hole and a feature from touch input', (
    tester,
  ) async {
    final fixture = scenes['mercator-fit-holes-and-points'] as Json;
    final chart = fixture['chart'] as Json;
    final geo = GeoJsonFeatureCollection.fromJson(chart['geoJson'] as Json);
    final scene = vizMapScene(geo, padding: 0);
    final events = <DmVizEvent>[];
    await tester.pumpWidget(
      WidgetsApp(
        color: const Color(0xff112233),
        builder: (_, _) => Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 320,
            child: DmVizMapChart.mercator(
              geoJson: geo,
              padding: 0,
              height: 220,
              interaction: DmVizInteraction(onEvent: events.add),
            ),
          ),
        ),
      ),
    );
    final plot = find.byType(VizPlotInput);
    final size = tester.getSize(plot);
    final origin = tester.getTopLeft(plot);
    final view = VizSceneTransform(
      Offset.zero & size,
      fitVizScene(scene.bounds!, scene.viewport!, size)!,
      scene.viewport!,
    );
    await tester.tapAt(origin + view.forward(projectVizMercator(Offset.zero)));
    await tester.pump();
    expect(events, isEmpty);
    await tester.tapAt(
      origin + view.forward(projectVizMercator(const Offset(5, 0))),
    );
    await tester.pump();
    expect(events.whereType<DmVizSelectionEvent>().single.ids, [
      const DmVizTarget.feature('marker'),
    ]);
    expect(
      events.whereType<DmVizTooltipEvent>().single.target,
      const DmVizTarget.feature('marker'),
    );
  });

  testWidgets('network drag commits layout coordinates after zoom', (
    tester,
  ) async {
    final fixture = scenes['network-fixed'] as Json;
    final chart = fixture['chart'] as Json;
    final nodes = _nodes(chart);
    final edges = _edges(chart);
    final scene = vizNetworkScene(nodes, edges);
    const viewport = DmVizViewport.network(Offset(5, 5), .75);
    final events = <DmVizEvent>[];
    await tester.pumpWidget(
      WidgetsApp(
        color: const Color(0xff112233),
        builder: (_, _) => Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 320,
            child: DmVizNetworkGraph.fixed(
              nodes: nodes,
              edges: edges,
              height: 220,
              interaction: DmVizInteraction(
                viewport: viewport,
                onEvent: events.add,
              ),
            ),
          ),
        ),
      ),
    );
    final plot = find.byType(VizPlotInput);
    final size = tester.getSize(plot);
    final origin = tester.getTopLeft(plot);
    final view = VizSceneTransform(
      Offset.zero & size,
      fitVizScene(scene.bounds!, scene.viewport!, size)!,
      viewport,
    );
    final start = view.forward(Offset.zero);
    final touch = await tester.startGesture(origin + start);
    await touch.moveBy(const Offset(28, 14));
    await touch.moveBy(const Offset(17, 12));
    await touch.up();
    await tester.pump();
    final result = events.whereType<DmVizNodeMoveEvent>().single;
    expect(result.id, 'west');
    final expected = view.inverse(start + const Offset(45, 26));
    _near(result.position, [expected.dx, expected.dy], 1e-9);
    expect(events.whereType<DmVizSelectionEvent>(), isEmpty);
  });
}
