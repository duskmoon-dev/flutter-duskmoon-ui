import 'package:duskmoon_visualization/duskmoon_visualization.dart';
import 'package:duskmoon_visualization/duskmoon_visualization_compat.dart'
    as compat;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('package metadata exposes curated wrapper layer', () {
    expect(DmVisualization.packageName, 'duskmoon_visualization');
    expect(DmVisualization.isScaffold, isFalse);
    expect(DmVisualization.curatedModels, contains('DmVizPoint'));
    expect(DmVisualization.curatedWrappers, contains('DmVizLineChart'));
  });

  testWidgets('legacy map accepts a custom projection and const palette', (
    tester,
  ) async {
    const ink = Color(0xff234567);
    const palette = DmChartPalette(
      background: Color(0xffffffff),
      grid: ink,
      axis: ink,
      primary: ink,
      secondary: ink,
      positive: ink,
      positiveOnColor: ink,
      warning: ink,
      warningOnColor: ink,
      heatmapBorder: ink,
    );
    const point = DmVizPoint(x: 'legacy', y: 2);
    final double legacyY = point.y;
    expect(legacyY, 2);

    final projection = compat.EquirectangularProjection();
    await tester.pumpWidget(
      WidgetsApp(
        color: ink,
        builder: (_, _) => DmVizMapChart(
          geoJson: GeoJsonFeatureCollection([]),
          projection: projection,
          palette: palette,
        ),
      ),
    );
    final map = tester.widget<compat.MapWidget>(find.byType(compat.MapWidget));
    expect(map.projection, same(projection));
    expect(map.strokeColor, ink);
    expect(map.fillColor, ink.withValues(alpha: .15));
    expect(tester.takeException(), isNull);
  });

  testWidgets('shared chart updates its data, theme and container', (
    tester,
  ) async {
    final events = <DmVizEvent>[];
    const a = DmVizDatum(id: 'first', x: 0, y: 2);
    const b = DmVizDatum(id: 'second', x: 1, y: 3);
    Future<void> show({
      required ThemeData theme,
      List<DmVizDatum> data = const [a, b],
      double width = 400,
      bool hidden = false,
    }) => tester.pumpWidget(
      WidgetsApp(
        color: theme.colorScheme.surface,
        builder: (_, _) => Theme(
          data: theme,
          child: Align(
            alignment: Alignment.topLeft,
            child: Offstage(
              offstage: hidden,
              child: SizedBox(
                width: width,
                child: DmVizScatterChart.series(
                  series: [DmVizSeries(id: 'a', name: 'A', data: data)],
                  interaction: DmVizInteraction(onEvent: events.add),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final light = ThemeData.light();
    final dark = ThemeData.dark();
    await show(theme: light);
    final chart = find.byType(DmVizScatterChart);
    final plot = find.semantics.byLabel('Chart data');
    tester.semantics.increase(plot);
    await tester.pump();
    tester.semantics.tap(plot);
    await tester.pump();
    expect(events.whereType<DmVizSelectionEvent>().single.ids, [
      const DmVizTarget.datum('a', 'second'),
    ]);

    await show(theme: dark, data: [a], width: 280, hidden: true);
    expect(chart, findsNothing);
    await show(theme: dark, data: [a], width: 280);
    expect(tester.getSize(chart).width, 280);
    final background = find.descendant(
      of: chart,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is ColoredBox && widget.color == dark.colorScheme.surface,
      ),
    );
    expect(background, findsWidgets);

    tester.semantics.tap(plot);
    await tester.pump();
    expect(events.whereType<DmVizSelectionEvent>().last.ids, [
      const DmVizTarget.datum('a', 'first'),
    ]);
    await show(theme: dark, data: []);
    expect(find.text('No data to display'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    expect(tester.takeException(), isNull);
  });

  testWidgets('curated chart wrappers build inside MaterialApp', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: const [
              SizedBox(
                height: 140,
                child: DmVizLineChart(
                  data: [
                    DmVizPoint(x: 0, y: 12),
                    DmVizPoint(x: 1, y: 24),
                    DmVizPoint(x: 2, y: 18),
                  ],
                ),
              ),
              SizedBox(
                height: 140,
                child: DmVizBarChart(
                  data: [DmVizPoint(x: 0.5, y: 3), DmVizPoint(x: 1.5, y: 8)],
                ),
              ),
              SizedBox(
                height: 140,
                child: DmVizScatterChart(
                  data: [DmVizPoint(x: 5, y: 10), DmVizPoint(x: 15, y: 30)],
                ),
              ),
              SizedBox(
                height: 140,
                child: DmVizHeatmap(
                  data: [
                    DmVizHeatmapCell(row: 0, column: 0, value: 1),
                    DmVizHeatmapCell(row: 0, column: 1, value: 4),
                    DmVizHeatmapCell(row: 1, column: 0, value: 6),
                    DmVizHeatmapCell(row: 1, column: 1, value: 9),
                  ],
                  rows: 2,
                  columns: 2,
                ),
              ),
              SizedBox(
                height: 140,
                child: DmVizNetworkGraph(
                  nodes: [
                    DmVizNetworkNode(
                      id: 'a',
                      label: 'A',
                      x: 30,
                      y: 30,
                      fixed: true,
                    ),
                    DmVizNetworkNode(
                      id: 'b',
                      label: 'B',
                      x: 90,
                      y: 90,
                      fixed: true,
                    ),
                  ],
                  links: [DmVizNetworkEdge(source: 'a', target: 'b')],
                  enableSimulation: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(DmVizLineChart), findsOneWidget);
    expect(find.byType(DmVizBarChart), findsOneWidget);
    expect(find.byType(DmVizScatterChart), findsOneWidget);
    expect(find.byType(DmVizHeatmap), findsOneWidget);
    expect(find.byType(DmVizNetworkGraph), findsOneWidget);
  });
}
