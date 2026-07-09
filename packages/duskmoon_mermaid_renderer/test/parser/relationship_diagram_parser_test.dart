import 'package:duskmoon_mermaid_renderer/duskmoon_mermaid_renderer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('relationship diagram parsers', () {
    test('parses sequence participants and messages', () {
      final output = parseMermaid('''
sequenceDiagram
  participant User
  participant API
  User->>API: Request data
  API-->>User: Response
''');

      final diagram = output.graph.sequenceDiagram!;
      expect(output.graph.kind, MermaidDiagramKind.sequence);
      expect(diagram.participants.map((participant) => participant.id), [
        'User',
        'API',
      ]);
      expect(diagram.messages.first.text, 'Request data');
      expect(diagram.messages.last.dotted, isTrue);
    });

    test('parses state transitions into generic graph nodes', () {
      final output = parseMermaid('''
stateDiagram-v2
  [*] --> Idle
  Idle --> Loading: fetch
  Loading --> Success
  Success --> [*]
''');

      expect(output.graph.kind, MermaidDiagramKind.state);
      expect(output.graph.nodes.keys, containsAll(['__state_start', 'Idle']));
      expect(output.graph.edges.map((edge) => edge.label), contains('fetch'));
    });

    test('parses er relationships into generic graph edges', () {
      final output = parseMermaid('''
erDiagram
  CUSTOMER ||--o{ ORDER : places
  ORDER ||--|{ LINE_ITEM : contains
''');

      expect(output.graph.kind, MermaidDiagramKind.er);
      expect(output.graph.nodes.keys, containsAll(['CUSTOMER', 'ORDER']));
      expect(output.graph.edges.first.arrowEnd, isFalse);
      expect(output.graph.edges.first.label, '|| places o{');
    });

    test('parses journey sections and scored tasks', () {
      final output = parseMermaid('''
journey
  title Checkout
  section Browse
    Find product: 5: Customer
    Add to cart: 4: Customer, Clerk
''');

      final diagram = output.graph.journeyDiagram!;
      expect(output.graph.kind, MermaidDiagramKind.journey);
      expect(diagram.title, 'Checkout');
      expect(diagram.sections.single.tasks.first.score, 5);
      expect(diagram.sections.single.tasks.last.actors, ['Customer', 'Clerk']);
    });

    test('parses gitgraph branches commits and merges', () {
      final output = parseMermaid('''
gitGraph
  commit id: "init"
  branch feature
  commit id: "work"
  checkout main
  merge feature
''');

      final diagram = output.graph.gitGraphDiagram!;
      expect(output.graph.kind, MermaidDiagramKind.gitGraph);
      expect(diagram.branches, ['main', 'feature']);
      expect(diagram.commits.map((commit) => commit.label), ['init', 'work']);
      expect(diagram.merges.single.fromBranch, 'feature');
      expect(diagram.merges.single.toBranch, 'main');
    });

    test('parses venn sets and unions', () {
      final output = parseMermaid('''
venn-beta
  set A [Flowchart]: 2
  set B [Charts]
  union A B [XY Chart]
''');

      final diagram = output.graph.vennDiagram!;
      expect(output.graph.kind, MermaidDiagramKind.venn);
      expect(diagram.sets.first.label, 'Flowchart');
      expect(diagram.sets.first.size, 2);
      expect(diagram.unions.single.ids, ['A', 'B']);
      expect(diagram.unions.single.label, 'XY Chart');
    });
  });
}
