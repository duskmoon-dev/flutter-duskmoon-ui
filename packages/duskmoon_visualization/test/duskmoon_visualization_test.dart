import 'package:duskmoon_visualization/duskmoon_visualization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('package metadata exposes curated wrapper layer', () {
    expect(DmVisualization.packageName, 'duskmoon_visualization');
    expect(DmVisualization.isScaffold, isFalse);
    expect(DmVisualization.curatedModels, contains('DmVizPoint'));
    expect(DmVisualization.curatedWrappers, contains('DmVizLineChart'));
  });

  testWidgets('curated chart wrappers build inside MaterialApp',
      (tester) async {
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
                  data: [
                    DmVizPoint(x: 0.5, y: 3),
                    DmVizPoint(x: 1.5, y: 8),
                  ],
                ),
              ),
              SizedBox(
                height: 140,
                child: DmVizScatterChart(
                  data: [
                    DmVizPoint(x: 5, y: 10),
                    DmVizPoint(x: 15, y: 30),
                  ],
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
                        id: 'a', label: 'A', x: 30, y: 30, fixed: true),
                    DmVizNetworkNode(
                        id: 'b', label: 'B', x: 90, y: 90, fixed: true),
                  ],
                  links: [
                    DmVizNetworkEdge(source: 'a', target: 'b'),
                  ],
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
