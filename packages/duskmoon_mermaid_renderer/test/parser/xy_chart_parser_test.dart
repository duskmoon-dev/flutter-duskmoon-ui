import 'package:duskmoon_mermaid_renderer/duskmoon_mermaid_renderer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseXyChart', () {
    test('parses title axes and series', () {
      final output = parseMermaid('''
xychart
  title "Monthly active users"
  x-axis [Jan, Feb, Mar]
  y-axis "Users" 0 --> 120
  bar [32, 45, 63]
  line [28, 40, 58]
''');

      final chart = output.graph.xyChart!;
      expect(output.graph.kind, MermaidDiagramKind.xyChart);
      expect(chart.title, 'Monthly active users');
      expect(chart.xAxis.categories, ['Jan', 'Feb', 'Mar']);
      expect(chart.yAxis.title, 'Users');
      expect(chart.yAxis.min, 0);
      expect(chart.yAxis.max, 120);
      expect(chart.series, hasLength(2));
      expect(chart.series.first.type, XyChartSeriesType.bar);
      expect(chart.series.last.type, XyChartSeriesType.line);
      expect(chart.series.first.values.map((value) => value.value), [
        32,
        45,
        63,
      ]);
    });

    test('parses horizontal chart and line point labels', () {
      final output = parseMermaid('''
xychart horizontal
  x-axis Score 0 --> 10
  line [2 "low", 8 "high"]
''');

      final chart = output.graph.xyChart!;
      expect(chart.orientation, XyChartOrientation.horizontal);
      expect(chart.xAxis.title, 'Score');
      expect(chart.series.single.values.first.label, 'low');
      expect(chart.series.single.values.last.label, 'high');
    });

    test('reports empty charts', () {
      expect(
        () => parseMermaid('xychart\n  title Empty'),
        throwsA(isA<MermaidParseError>()),
      );
    });
  });
}
