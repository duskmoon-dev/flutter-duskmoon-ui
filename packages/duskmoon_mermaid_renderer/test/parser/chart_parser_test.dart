import 'package:duskmoon_mermaid_renderer/duskmoon_mermaid_renderer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('chart parsers', () {
    test('parses pie chart title, data flag, and slices', () {
      final output = parseMermaid('''
pie showData
  title Diagram coverage
  "Native" : 5
  "Pending" : 25
''');

      final chart = output.graph.pieChart!;
      expect(output.graph.kind, MermaidDiagramKind.pie);
      expect(chart.showData, isTrue);
      expect(chart.title, 'Diagram coverage');
      expect(chart.slices.map((slice) => slice.label), ['Native', 'Pending']);
      expect(chart.slices.map((slice) => slice.value), [5, 25]);
    });

    test('allows zero pie slices when the total is positive', () {
      final output = parseMermaid('''
pie
  "Native": 30
  "Pending": 0
''');

      expect(output.graph.pieChart!.slices.map((slice) => slice.value), [
        30,
        0,
      ]);
    });

    test('rejects negative or all-zero pie values', () {
      expect(
        () => parseMermaid('pie\n"Invalid": -1'),
        throwsA(isA<MermaidParseError>()),
      );
      expect(
        () => parseMermaid('pie\n"Invalid": 0'),
        throwsA(isA<MermaidParseError>()),
      );
    });

    test('parses quadrant chart axes, labels, and points', () {
      final output = parseMermaid('''
quadrantChart
  title Renderer Coverage
  x-axis Low Effort --> High Effort
  y-axis Low Value --> High Value
  quadrant-1 Prioritize
  quadrant-2 Evaluate
  Flowchart: [0.25, 0.80]
  XY Chart: [0.45, 0.72]
''');

      final chart = output.graph.quadrantChart!;
      expect(output.graph.kind, MermaidDiagramKind.quadrant);
      expect(chart.title, 'Renderer Coverage');
      expect(chart.xAxis.start, 'Low Effort');
      expect(chart.xAxis.end, 'High Effort');
      expect(chart.yAxis.start, 'Low Value');
      expect(chart.yAxis.end, 'High Value');
      expect(chart.quadrants[1], 'Prioritize');
      expect(chart.points.map((point) => point.label), [
        'Flowchart',
        'XY Chart',
      ]);
    });

    test('parses radar chart axes, curves, and options', () {
      final output = parseMermaid('''
radar-beta
  title Renderer quality
  axis Parser, Layout, Canvas, Tests
  curve Current{8, 6, 7, 9}
  curve Target{Parser: 10, Layout: 10, Canvas: 10, Tests: 10}
  max 10
  min 0
  ticks 4
  graticule polygon
''');

      final chart = output.graph.radarChart!;
      expect(output.graph.kind, MermaidDiagramKind.radar);
      expect(chart.title, 'Renderer quality');
      expect(chart.axes.map((axis) => axis.label), [
        'Parser',
        'Layout',
        'Canvas',
        'Tests',
      ]);
      expect(chart.curves, hasLength(2));
      expect(chart.curves.first.values['Parser'], 8);
      expect(chart.curves.last.values['Tests'], 10);
      expect(chart.max, 10);
      expect(chart.min, 0);
      expect(chart.ticks, 4);
      expect(chart.graticule, RadarGraticule.polygon);
    });
  });
}
