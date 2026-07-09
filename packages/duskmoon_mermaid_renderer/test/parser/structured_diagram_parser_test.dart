import 'package:duskmoon_mermaid_renderer/duskmoon_mermaid_renderer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('structured diagram parsers', () {
    test('parses packet ranges and counted fields', () {
      final output = parseMermaid('''
packet
  0-15: "Source Port"
  +16: "Destination Port"
  +32: "Sequence Number"
''');

      final diagram = output.graph.packetDiagram!;
      expect(output.graph.kind, MermaidDiagramKind.packet);
      expect(diagram.fields.map((field) => field.label), [
        'Source Port',
        'Destination Port',
        'Sequence Number',
      ]);
      expect(diagram.fields[1].start, 16);
      expect(diagram.fields[1].end, 31);
    });

    test('parses sankey CSV links', () {
      final output = parseMermaid('''
sankey
  Demos,Native,11
  Demos,Pending,19
  Native,Canvas,11
''');

      final diagram = output.graph.sankeyDiagram!;
      expect(output.graph.kind, MermaidDiagramKind.sankey);
      expect(diagram.links, hasLength(3));
      expect(diagram.links.first.source, 'Demos');
      expect(diagram.links.first.target, 'Native');
      expect(diagram.links.first.value, 11);
    });

    test('parses timeline periods and events', () {
      final output = parseMermaid('''
timeline
  title Mermaid Renderer
  2026-07-01 : Flowchart
  2026-07-09 : XY Chart : Pie Chart
  Next : More diagram types
''');

      final diagram = output.graph.timelineDiagram!;
      expect(output.graph.kind, MermaidDiagramKind.timeline);
      expect(diagram.title, 'Mermaid Renderer');
      expect(diagram.periods, hasLength(3));
      expect(diagram.periods[1].events, ['XY Chart', 'Pie Chart']);
    });

    test('parses indentation-based mindmap', () {
      final output = parseMermaid('''
mindmap
  root((Mermaid))
    Native
      Flowchart
      XY Chart
    Planned
      Sequence
''');

      final diagram = output.graph.mindmapDiagram!;
      expect(output.graph.kind, MermaidDiagramKind.mindmap);
      expect(diagram.root.label, 'Mermaid');
      expect(diagram.root.children.map((node) => node.label), [
        'Native',
        'Planned',
      ]);
      expect(diagram.root.children.first.children.last.label, 'XY Chart');
    });

    test('parses kanban columns and tasks', () {
      final output = parseMermaid('''
kanban
  todo[Todo]
    docs[Read syntax]
  doing[Doing]
    renderer[Build renderer]
''');

      final diagram = output.graph.kanbanDiagram!;
      expect(output.graph.kind, MermaidDiagramKind.kanban);
      expect(diagram.columns.map((column) => column.title), [
        'Todo',
        'Doing',
      ]);
      expect(diagram.columns.last.tasks.single.title, 'Build renderer');
    });

    test('parses treemap hierarchy and values', () {
      final output = parseMermaid('''
treemap-beta
  "Renderer"
    "Native": 11
    "Pending": 19
  "Docs"
    "Syntax pages": 30
''');

      final diagram = output.graph.treemapDiagram!;
      expect(output.graph.kind, MermaidDiagramKind.treemap);
      expect(diagram.roots.map((node) => node.label), ['Renderer', 'Docs']);
      expect(diagram.roots.first.children.first.value, 11);
      expect(diagram.roots.last.totalValue, 30);
    });
  });
}
