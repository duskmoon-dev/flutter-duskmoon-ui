import 'package:duskmoon_mermaid_renderer/duskmoon_mermaid_renderer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseMermaid', () {
    test('parses flowchart header and direction', () {
      final output = parseMermaid('''
flowchart LR
  A --> B
''');

      expect(output.graph.direction, MermaidDirection.leftRight);
      expect(output.graph.nodes.keys, containsAll(<String>['A', 'B']));
      expect(output.graph.edges, hasLength(1));
    });

    test('parses labels, shapes, and edge labels', () {
      final output = parseMermaid('''
graph TD
  A[Start] --> B{Decision}
  B -->|yes| C((OK))
  B -- no --> D[(Cancel)]
''');

      expect(output.graph.nodes['A']?.label, 'Start');
      expect(output.graph.nodes['B']?.shape, NodeShape.diamond);
      expect(output.graph.nodes['C']?.shape, NodeShape.circle);
      expect(output.graph.nodes['D']?.shape, NodeShape.cylinder);
      expect(output.graph.edges.map((edge) => edge.label), contains('yes'));
      expect(output.graph.edges.map((edge) => edge.label), contains('no'));
    });

    test('parses edge-only flowchart syntax', () {
      final output = parseMermaid('A -.-> B;');

      expect(output.graph.edges.single.style, EdgeStyle.dotted);
      expect(output.graph.edges.single.arrowEnd, isTrue);
    });

    test('reports unsupported diagram kinds', () {
      expect(
        () => parseMermaid('sequenceDiagram\nA->>B: hello'),
        throwsA(isA<UnsupportedDiagramError>()),
      );
    });

    test('reports invalid init directives', () {
      expect(
        () => parseMermaid('%%{ init: { "theme": "dark" }\nflowchart LR'),
        throwsA(isA<MermaidParseError>()),
      );
    });
  });
}
