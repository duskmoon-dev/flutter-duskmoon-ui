import 'dart:convert';
import 'dart:io';

import 'package:duskmoon_visualization/duskmoon_visualization.dart';
import 'package:duskmoon_visualization/src/dm_viz_format.dart';
import 'package:duskmoon_visualization/src/dm_viz_interaction.dart'
    show
        VizActionType,
        VizInteractionState,
        transitionViz,
        vizAction,
        vizInitial;
import 'package:duskmoon_visualization/src/widgets/dm_viz_plot_input.dart'
    show VizPlotInput;
import 'package:duskmoon_visualization/src/dm_viz_layout.dart'
    show normalizeVizTime, vizSeriesHash;
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

typedef Json = Map<String, dynamic>;

Json _read(String directory, String group) {
  var root = Directory.current;
  while (!Directory('${root.path}/specs/visualization/v1').existsSync()) {
    if (root.parent.path == root.path)
      throw StateError('Visualization snapshot not found');
    root = root.parent;
  }
  return jsonDecode(
    File('${root.path}/specs/visualization/v1/$directory/$group.json')
        .readAsStringSync(),
  ) as Json;
}

Color _color(String hex) =>
    Color(int.parse(hex.substring(1), radix: 16) | 0xff000000);
String _hex(Color color) =>
    '#${(color.toARGB32() & 0xffffff).toRadixString(16).padLeft(6, '0').toUpperCase()}';
const _palette = [Color(0xff112233), Color(0xff445566), Color(0xff778899)];

DmVizAxis _axis(Json data) {
  final serialized = data['format'] as Json?;
  final format = serialized == null
      ? null
      : DmVizFormat(
          style: DmVizFormatStyle.values.byName(switch (serialized['style']) {
            'date-time' => 'dateTime',
            'utc-iso' => 'utcIso',
            final String style => style,
            _ => throw FormatException('Expected format style'),
          }),
          locale: serialized['locale'] as String?,
          timeZone: serialized['timeZone'] as String?,
          fractionDigits: serialized['fractionDigits'] as int?,
        );
  return switch (data['type']) {
    'numeric' => DmVizAxis.numeric(
        domain: (data['domain'] as List?)?.cast<num>(),
        tickValues: (data['tickValues'] as List?)?.cast<num>(),
        includeZero: data['includeZero'] == true,
        nice: data['nice'] == true,
        format: format,
      ),
    'category' => DmVizAxis.category(
        domain: (data['domain'] as List?)?.cast<String>(),
        tickValues: (data['tickValues'] as List?)?.cast<String>(),
        format: format,
      ),
    _ => DmVizAxis.time(
        domain: (data['domain'] as List?)?.cast<Object>(),
        tickValues: (data['tickValues'] as List?)?.cast<Object>(),
        nice: data['nice'] == true,
        format: format,
      ),
  };
}

DmVizDatum _datum(Json data) => DmVizDatum(
      id: data['id'] as String,
      x: data['x'],
      y: (data['y'] as num?)?.toDouble(),
      color: data['color'] == null ? null : _color(data['color'] as String),
    );
List<DmVizSeries> _series(Json chart) => (chart['series'] as List)
    .cast<Json>()
    .map(
      (data) => DmVizSeries(
        id: data['id'] as String,
        name: data['name'] as String,
        data: (data['data'] as List).cast<Json>().map(_datum).toList(),
        paletteSlot: data['paletteSlot'] as int?,
        color: data['color'] == null ? null : _color(data['color'] as String),
      ),
    )
    .toList();

List<DmVizCategory> _categories(Object? data) => (data as List)
    .cast<Json>()
    .map(
      (entry) => DmVizCategory(
        id: entry['id'] as String,
        label: entry['label'] as String,
      ),
    )
    .toList();
List<DmVizHeatmapDatum> _cells(Object? data) => (data as List)
    .cast<Json>()
    .map(
      (entry) => DmVizHeatmapDatum(
        id: entry['id'] as String,
        rowId: entry['rowId'] as String,
        columnId: entry['columnId'] as String,
        value: (entry['value'] as num?)?.toDouble(),
      ),
    )
    .toList();

Json _options(Json chart) => chart['options'] as Json? ?? {};
Json _theme(Json chart) => _options(chart)['theme'] as Json? ?? {};
DmVizOptions _vizOptions(Json chart) {
  final options = _options(chart);
  return DmVizOptions(
    seriesColors: (_theme(chart)['seriesColors'] as List?)
        ?.cast<String>()
        .map(_color)
        .toList(),
    hiddenSeriesIds:
        (options['hiddenSeriesIds'] as List?)?.cast<String>().toSet() ?? {},
    domainAfterHide: options['domainAfterHide'] == 'visible',
  );
}

VizXYLayout _xy(Json chart) {
  final options = _options(chart);
  return layoutVizXY(
    kind: DmVizChartKind.values.byName(chart['kind'] as String),
    series: _series(chart),
    xAxis: _axis(chart['xAxis'] as Json),
    yAxis: _axis(chart['yAxis'] as Json),
    palette: _palette,
    options: _vizOptions(chart),
    connectMissing: options['connectMissing'] == true,
    sortX: options['sortX'] == true,
    orientation: options['orientation'] == 'horizontal'
        ? DmVizBarOrientation.horizontal
        : DmVizBarOrientation.vertical,
  );
}

VizHeatmapLayout _heatmap(Json chart) {
  final theme = _theme(chart);
  return layoutVizHeatmap(
    rows: _categories(chart['rows']),
    columns: _categories(chart['columns']),
    data: _cells(chart['cells']),
    missing: _color(theme['missing'] as String),
    colors:
        (theme['heatmapColors'] as List).cast<String>().map(_color).toList(),
  );
}

Object? _domain(Object? domain) =>
    domain is VizDomain ? [domain.$1, domain.$2] : domain;
List<Json> _issues(List<DmVizIssue> issues) => [
      for (final issue in issues)
        {
          'code': issue.code,
          'path': issue.path,
          'severity': issue.warning ? 'warning' : 'error',
        },
    ];

void _geometry(
  Map<String, List<double>> actual,
  Json expected,
  double tolerance,
) {
  expect(actual.keys.toSet(), expected.keys.toSet());
  for (final MapEntry(key: id, value: values) in expected.entries) {
    final coordinates = (values as List).cast<num>();
    expect(actual[id]!.length, coordinates.length);
    for (final (index, coordinate) in coordinates.indexed) {
      expect(
        actual[id]![index],
        closeTo(coordinate, tolerance),
        reason: '$id coordinate $index',
      );
    }
  }
}

void _mutate(Json chart, Json mutation) {
  final path = (mutation['path'] as String).split('/').skip(1).toList();
  var object = chart as Object;
  for (final key in path.take(path.length - 1)) {
    object = object is List
        ? object[int.parse(key)] as Object
        : (object as Json)[key] as Object;
  }
  var value = mutation['value'];
  if (value is Json && value['nativeNumber'] != null) {
    value = double.parse(value['nativeNumber'] as String);
  }
  if (object is List) {
    object[int.parse(path.last)] = value;
  } else {
    (object as Json)[path.last] = value;
  }
}

void main() {
  for (final group in ['xy', 'identity', 'time']) {
    final records = _read('expected', group);
    for (final MapEntry(key: id, value: runner) in _read(
      'fixtures',
      group,
    ).entries) {
      test('$group/$id', () {
        final chart = (runner as Json)['chart'] as Json;
        final expected = records[id] as Json;
        final actual = _xy(chart);
        final points = actual.series.expand((series) => series.points).toList();
        expect(_issues(actual.issues), expected['issues'] ?? []);
        expect(
          points.isEmpty ? 'empty' : 'ready',
          expected['state'] ?? 'ready',
        );
        expect(_domain(actual.xDomain), expected['xDomain']);
        if (expected.containsKey('yDomain'))
          expect(_domain(actual.yDomain), expected['yDomain']);
        if (expected['segments'] case final Map<String, dynamic> segments) {
          expect({
            for (final series in actual.series)
              series.source.id: [
                for (final segment in series.segments)
                  segment.map((point) => point.datum.id).toList(),
              ],
          }, segments);
        }
        if (expected['drawableDatumIds'] case final List ids) {
          expect(points.map((point) => point.datum.id), ids);
        }
        if (expected['clippedDatumIds'] case final List ids) {
          final drawable = points
              .where(
                (point) =>
                    point.position.dx >= 0 &&
                    point.position.dx <= 1 &&
                    point.position.dy >= 0 &&
                    point.position.dy <= 1,
              )
              .map((point) => point.datum.id)
              .toSet();
          expect(
            _series(chart)
                .expand((source) => source.data)
                .where(
                  (datum) =>
                      datum.x != null &&
                      datum.y != null &&
                      !drawable.contains(datum.id),
                )
                .map((datum) => datum.id),
            ids,
          );
        }
        if (expected['geometry'] case final Json geometry) {
          final tolerance = geometry['tolerance'] as double;
          if (geometry['baseline'] case final num baseline) {
            expect(actual.baseline, closeTo(baseline, tolerance));
          }
          if (geometry['points'] case final Json coordinates) {
            _geometry(
              {
                for (final point in points)
                  point.datum.id: [point.position.dx, point.position.dy],
              },
              coordinates,
              tolerance,
            );
          }
          if (geometry['bars'] case final Json coordinates) {
            _geometry(
              {
                for (final point in points)
                  point.datum.id: [
                    point.rect!.left,
                    point.rect!.top,
                    point.rect!.width,
                    point.rect!.height,
                  ],
              },
              coordinates,
              tolerance,
            );
          }
        }
        if (expected['hashes'] case final Json hashes) {
          expect({for (final id in hashes.keys) id: vizSeriesHash(id)}, hashes);
        }
        if (expected['seriesColors'] case final Json colors) {
          expect({
            for (final series in actual.series)
              series.source.id: _hex(series.color),
          }, colors);
        }
        if (expected['datumColors'] case final Json colors) {
          expect({
            for (final series in actual.series.where(
              (entry) => colors.containsKey(entry.source.id),
            ))
              series.source.id: {
                for (final point in series.points)
                  point.datum.id: _hex(point.color),
              },
          }, colors);
        }
        if (expected['xTickValues'] case final List values) {
          expect(actual.xTicks, values);
        }
        if (expected['hiddenSeriesIds'] case final List ids) {
          expect(
            actual.series
                .where((series) => !series.visible)
                .map((series) => series.source.id),
            ids,
          );
        }
        if (expected['displayX'] case final List labels) {
          final axis = _axis(chart['xAxis'] as Json);
          expect(
            _series(chart).single.data.map(
                  (datum) => formatVizValue(normalizeVizTime(datum.x!)!, axis),
                ),
            labels,
          );
        }
        if (expected['normalizedX'] case final List values) {
          expect(
            _series(chart)
                .single
                .data
                .map((datum) => normalizeVizTime(datum.x!)),
            values,
          );
        }
      });
    }
  }

  final heatmapResults = _read('expected', 'heatmap');
  for (final MapEntry(key: id, value: runner) in _read(
    'fixtures',
    'heatmap',
  ).entries) {
    test('heatmap/$id', () {
      final chart = (runner as Json)['chart'] as Json;
      final expected = heatmapResults[id] as Json;
      final actual = _heatmap(chart);
      expect(actual.issues, isEmpty);
      expect(_domain(actual.domain), expected['valueDomain']);
      final present = actual.cells.where((entry) => entry.cell != null);
      expect({
        for (final entry in present) entry.cell!.id: _hex(entry.color),
      }, expected['cellColors']);
      if (expected['absent'] case final List absent) {
        expect([
          for (final entry in actual.cells.where((cell) => cell.cell == null))
            {
              'rowId': entry.row.id,
              'columnId': entry.column.id,
              'color': _hex(entry.color),
            },
        ], absent);
      }
      if (expected['geometry'] case final Json geometry) {
        _geometry(
          {
            for (final entry in present)
              entry.cell!.id: [
                entry.rect.left,
                entry.rect.top,
                entry.rect.width,
                entry.rect.height,
              ],
          },
          geometry['cells'] as Json,
          geometry['tolerance'] as double,
        );
      }
    });
  }

  final invalidResults = _read('expected', 'validation');
  for (final MapEntry(key: id, value: runner) in _read(
    'fixtures',
    'validation',
  ).entries) {
    final input = runner as Json;
    final chart = input['chart'] as Json;
    if (chart['kind'] == 'network' || chart['kind'] == 'map') continue;
    test('validation/$id', () {
      for (final mutation in (input['mutations'] as List).cast<Json>()) {
        _mutate(chart, mutation);
      }
      final issues = chart['kind'] == 'heatmap'
          ? _heatmap(chart).issues
          : _xy(chart).issues;
      expect(_issues(issues), (invalidResults[id] as Json)['issues']);
    });
  }

  testWidgets('contract entries draw line, grouped bars, scatter and heatmap', (
    tester,
  ) async {
    final xy = _read('fixtures', 'xy');
    Json chart(String id) => (xy[id] as Json)['chart'] as Json;
    final line = chart('line-input-order-gap-and-repeated-x');
    final bars = chart('bar-grouped-vertical');
    final scatter = chart('scatter-missing');
    final heatmap =
        (_read('fixtures', 'heatmap')['ordered-continuous-and-missing']
            as Json)['chart'] as Json;
    final heatmapTheme = _theme(heatmap);
    final examples = <(Widget, PaintPattern)>[
      (
        DmVizLineChart.series(
          series: _series(line),
          options: const DmVizOptions(seriesColors: _palette),
        ),
        paints
          ..path(strokeWidth: 3.5)
          ..path(strokeWidth: 2),
      ),
      (
        DmVizBarChart.series(
          series: _series(bars),
          options: const DmVizOptions(seriesColors: _palette),
        ),
        paints
          ..rect()
          ..rect(
            rect: const Rect.fromLTRB(100, 16, 191, 208),
            color: _palette[vizSeriesHash('a') % _palette.length],
          ),
      ),
      (
        DmVizScatterChart.series(
          series: _series(scatter),
          options: const DmVizOptions(seriesColors: _palette),
        ),
        paints..circle(radius: 4),
      ),
      (
        DmVizHeatmap.cells(
          rows: _categories(heatmap['rows']),
          columns: _categories(heatmap['columns']),
          data: _cells(heatmap['cells']),
          options: DmVizOptions(
            missingColor: _color(heatmapTheme['missing'] as String),
            heatmapColors: (heatmapTheme['heatmapColors'] as List)
                .cast<String>()
                .map(_color)
                .toList(),
          ),
        ),
        paints
          ..rect(color: _color('#000000'))
          ..rect(color: _color('#FF0000'))
          ..rect(color: _color('#123456'))
          ..rect(color: _color('#FF8080')),
      ),
    ];
    for (final (example, matcher) in examples) {
      await tester.pumpWidget(
        WidgetsApp(
          color: _palette.first,
          builder: (context, child) => Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: 480, child: example),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(
        find.descendant(
          of: find.byWidget(example),
          matching: find.byWidgetPredicate(
            (widget) => widget is CustomPaint && widget.child is SizedBox,
          ),
        ),
        matcher,
      );
    }
  });
  testWidgets('contract chart fits a bounded parent', (tester) async {
    await tester.pumpWidget(
      WidgetsApp(
        color: _palette.first,
        builder: (context, child) => const Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 320,
            height: 180,
            child: DmVizScatterChart.series(
              series: [
                DmVizSeries(
                  id: 'main',
                  name: 'A series',
                  data: [DmVizDatum(id: 'one', x: 1, y: 1)],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    final plot = find.descendant(
      of: find.byType(DmVizScatterChart),
      matching: find.byWidgetPredicate(
        (widget) => widget is CustomPaint && widget.child is SizedBox,
      ),
    );
    expect(tester.getSize(plot).height, inExclusiveRange(0, 180));
    expect(plot, paints..circle(radius: 4));
  });
  testWidgets('touch hits a zero bar and controlled writeback emits once', (
    tester,
  ) async {
    final fixture = _read('fixtures', 'xy')['bar-grouped-vertical'] as Json;
    final chart = fixture['chart'] as Json;
    final events = <DmVizEvent>[];
    var selection = <DmVizTarget>[];
    await tester.pumpWidget(
      WidgetsApp(
        color: _palette.first,
        builder: (context, child) => Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 480,
            child: StatefulBuilder(
              builder: (context, redraw) => DmVizBarChart.series(
                series: _series(chart),
                interaction: DmVizInteraction(
                  selection: selection,
                  onEvent: (event) {
                    events.add(event);
                    if (event is DmVizSelectionEvent) {
                      redraw(() => selection = event.ids);
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
    final plot = find.byType(VizPlotInput);
    final origin = tester.getTopLeft(plot);
    final size = tester.getSize(plot);
    final width = 480 - 100 - 16;
    final height = size.height - 16 - 28;
    await tester.tapAt(
      origin + Offset(100 + width * .875, 16 + height * .75 + 1),
    );
    await tester.pump();
    expect(events.whereType<DmVizSelectionEvent>().single.ids, [
      const DmVizTarget.datum('b', 'b2'),
    ]);
    expect(events.whereType<DmVizTooltipEvent>().single.raw['y'], 0);
    expect(find.text('0'), findsOneWidget);
    await tester.tap(find.text('Clear selection'));
    await tester.pump();
    expect(events.whereType<DmVizSelectionEvent>().last.ids, isEmpty);
  });

  testWidgets(
    'line keyboard, brush and cancelled gestures return data-space events',
    (tester) async {
      final fixture = _read(
        'fixtures',
        'interaction',
      )['line-controlled-selection-and-reset'] as Json;
      final chart = fixture['chart'] as Json;
      final events = <DmVizEvent>[];
      await tester.pumpWidget(
        WidgetsApp(
          color: _palette.first,
          builder: (context, child) => Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 480,
              child: DmVizLineChart.series(
                series: _series(chart),
                yAxis: const DmVizAxis.numeric(unit: '°C'),
                interaction: DmVizInteraction(onEvent: events.add),
              ),
            ),
          ),
        ),
      );
      final plot = find.byType(VizPlotInput);
      final focus =
          find.descendant(of: plot, matching: find.byType(Focus)).first;
      Focus.of(
        tester.element(
          find.descendant(of: focus, matching: find.byType(Semantics)).first,
        ),
      ).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(events.whereType<DmVizSelectionEvent>().single.ids, [
        const DmVizTarget.datum('a', 'second'),
      ]);
      await tester.sendKeyEvent(LogicalKeyboardKey.equal);
      await tester.pump();
      expect(
        events.whereType<DmVizViewportEvent>().single.viewport.kind,
        DmVizViewportKind.line,
      );

      final origin = tester.getTopLeft(plot);
      final drag = await tester.startGesture(
        origin + const Offset(180, 60),
        kind: PointerDeviceKind.touch,
      );
      await drag.moveBy(const Offset(25, 0));
      await drag.moveBy(const Offset(80, 0));
      await drag.up();
      await tester.pump();
      final brush = events.whereType<DmVizBrushEvent>().single;
      expect(brush.range!.$1, lessThan(brush.range!.$2));

      final cancelled = await tester.startGesture(
        origin + const Offset(170, 60),
      );
      await cancelled.moveBy(const Offset(40, 0));
      await cancelled.cancel();
      await tester.pump();
      expect(events.whereType<DmVizBrushEvent>(), hasLength(1));
      expect(events.whereType<DmVizSelectionEvent>(), hasLength(1));
    },
  );

  final eventFixtures = _read('fixtures', 'interaction');
  final eventResults = _read('expected', 'interaction');
  for (final MapEntry(key: id, value: value) in eventFixtures.entries) {
    final fixture = value as Json;
    final chart = fixture['chart'] as Json;
    final kind = chart['kind'];
    if (kind != 'line' && kind != 'scatter') continue;
    test('interaction/$id', () {
      final layout = _xy(chart);
      final initial = vizInitial(
        viewport: kind == 'line'
            ? DmVizViewport.line(layout.xDomain as VizDomain)
            : DmVizViewport.scatter(
                layout.xDomain as VizDomain,
                layout.yDomain!,
              ),
      );
      final series = _series(chart);
      final yAxis = _axis(chart['yAxis'] as Json);
      final controlled =
          (fixture['controlled'] as List?)?.contains('selection') == true;
      final mode = _options(chart)['selectionMode'] == 'multiple'
          ? DmVizSelectionMode.multiple
          : DmVizSelectionMode.single;
      final log = <Map<String, Object?>>[];
      VizInteractionState state = initial;
      for (final action in (fixture['actions'] as List).cast<Json>()) {
        final type = action['type'] as String;
        DmVizTarget target(Json json) => DmVizTarget.datum(
              json['seriesId'] as String,
              json['datumId'] as String,
            );
        DmVizRange range(List<dynamic> list) =>
            ((list[0] as num).toDouble(), (list[1] as num).toDouble());
        if (type == 'writeSelection') {
          state = (
            ids: (action['ids'] as List).cast<Json>().map(target).toList(),
            hidden: state.hidden,
            viewport: state.viewport,
            brush: state.brush,
            tooltip: state.tooltip,
          );
          continue;
        }
        final rawTarget = action['target'] as Json?;
        final selected = rawTarget == null ? null : target(rawTarget);
        final viewportData = action['viewport'] as Json?;
        final viewport = viewportData == null
            ? null
            : viewportData['kind'] == 'line'
                ? DmVizViewport.line(range(viewportData['x'] as List))
                : DmVizViewport.scatter(
                    range(viewportData['x'] as List),
                    range(viewportData['y'] as List),
                  );
        DmVizTooltipEvent? tooltip;
        if (type == 'focus') {
          final datum = series
              .firstWhere((entry) => entry.id == selected!.seriesId)
              .data
              .firstWhere((data) => data.id == selected!.id);
          final unit = (chart['yAxis'] as Json)['unit'] as String?;
          tooltip = DmVizTooltipEvent(
            target: selected!,
            raw: {'x': datum.x, 'y': datum.y},
            display: formatVizValue(datum.y!, yAxis) +
                (unit == null ? '' : ' $unit'),
            unit: unit,
          );
        }
        final result = transitionViz(
          state,
          vizAction(
            VizActionType.values.byName(type),
            target: selected,
            id: action['seriesId'] as String?,
            tooltip: tooltip,
            viewport: viewport,
            range:
                action['range'] == null ? null : range(action['range'] as List),
          ),
          initial: initial,
          series: series.map((entry) => entry.id).toList(),
          mode: mode,
        );
        log.addAll(result.events.map((event) => event.toJson()));
        final next = result.state;
        state = controlled
            ? (
                ids: state.ids,
                hidden: next.hidden,
                viewport: next.viewport,
                brush: next.brush,
                tooltip: next.tooltip,
              )
            : next;
      }
      expect(log, (eventResults[id] as Json)['events']);
    });
  }
}
