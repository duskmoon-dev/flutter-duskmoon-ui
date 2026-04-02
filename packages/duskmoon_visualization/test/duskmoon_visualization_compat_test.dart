import 'package:duskmoon_visualization/duskmoon_visualization_compat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('compat entrypoint still exposes raw vendored widgets', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: 120,
                child: XYChart(
                  children: [
                    LineSeries(
                      data: [
                        XYDataPoint(x: 0, y: 1),
                        XYDataPoint(x: 1, y: 2),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 120,
                child: Heatmap(
                  data: [
                    HeatmapDataPoint(row: 0, column: 0, value: 1),
                    HeatmapDataPoint(row: 0, column: 1, value: 2),
                    HeatmapDataPoint(row: 1, column: 0, value: 3),
                    HeatmapDataPoint(row: 1, column: 1, value: 4),
                  ],
                  rows: 2,
                  columns: 2,
                  colorScale: HeatmapColorScale.viridis(
                    minValue: 1,
                    maxValue: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(XYChart), findsOneWidget);
    expect(find.byType(LineSeries), findsOneWidget);
    expect(find.byType(Heatmap), findsOneWidget);
  });
}
