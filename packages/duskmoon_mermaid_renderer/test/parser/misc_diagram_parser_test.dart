import 'package:duskmoon_mermaid_renderer/duskmoon_mermaid_renderer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('misc Mermaid diagram parsers', () {
    test('parses swimlanes as graph content', () {
      final output = parseMermaid('''
swimlane-beta LR
  subgraph Product
    idea[Idea] --> spec[Spec]
  end
  spec --> build
''');

      expect(output.graph.kind, MermaidDiagramKind.swimlanes);
      expect(output.graph.nodes.keys, containsAll(['idea', 'spec', 'build']));
    });

    test('parses class diagrams', () {
      final output = parseMermaid('''
classDiagram
  class Animal
  Animal <|-- Cat
''');

      expect(output.graph.kind, MermaidDiagramKind.classDiagram);
      expect(output.graph.nodes.keys, containsAll(['Animal', 'Cat']));
      expect(output.graph.edges.single.label, '<|--');
    });

    test('parses gantt tasks', () {
      final output = parseMermaid('''
gantt
  title Release plan
  section Build
    Parser :done, p1, 2026-07-01, 2d
''');

      final diagram = output.graph.ganttDiagram!;
      expect(output.graph.kind, MermaidDiagramKind.gantt);
      expect(diagram.title, 'Release plan');
      expect(diagram.sections.single.tasks.single.status, 'done');
    });

    test('parses requirements and C4 diagrams', () {
      final requirement = parseMermaid('''
requirementDiagram
  requirement renderer {
  }
  element widget {
  }
  widget - satisfies -> renderer
''');
      final c4 = parseMermaid('''
C4Context
  Person(user, "User")
  System(app, "DuskMoon UI")
  Rel(user, app, "Views diagrams")
''');

      expect(requirement.graph.kind, MermaidDiagramKind.requirement);
      expect(requirement.graph.edges.single.label, 'satisfies');
      expect(c4.graph.kind, MermaidDiagramKind.c4);
      expect(c4.graph.nodes['app']?.label, 'DuskMoon UI');
    });

    test('parses ZenUML and block diagrams', () {
      final zen = parseMermaid('''
zenuml
  Customer->Store: place order
  Store-->Customer: accepted
''');
      final block = parseMermaid('''
block-beta
  columns 3
  A["Input"] B["Parser"] C["Canvas"]
  A --> B
''');

      expect(zen.graph.kind, MermaidDiagramKind.zenUml);
      expect(zen.graph.sequenceDiagram!.messages, hasLength(2));
      expect(block.graph.kind, MermaidDiagramKind.block);
      expect(block.graph.nodes.keys, containsAll(['A', 'B', 'C']));
    });

    test('parses architecture and event modeling diagrams', () {
      final architecture = parseMermaid('''
architecture-beta
  group api(cloud)[API]
  service app(server)[App] in api
  service db(database)[Database] in api
  app:R -- L:db
''');
      final eventModeling = parseMermaid('''
eventmodeling
  tf 01 ui CartUI
  tf 02 cmd AddItem
  tf 03 evt ItemAdded
''');

      expect(architecture.graph.kind, MermaidDiagramKind.architecture);
      expect(architecture.graph.nodes.keys, containsAll(['app', 'db']));
      expect(eventModeling.graph.kind, MermaidDiagramKind.eventModeling);
      expect(eventModeling.graph.edges, hasLength(2));
    });

    test('parses Ishikawa Wardley Cynefin and TreeView diagrams', () {
      final ishikawa = parseMermaid('''
ishikawa-beta
  Diagram error
    Unsupported header
''');
      final wardley = parseMermaid('''
wardley-beta
  title Renderer Map
  anchor User [0.9, 0.95]
  component Renderer [0.55, 0.45]
  User -> Renderer
''');
      final cynefin = parseMermaid('''
cynefin-beta
  complex
    "Unsupported diagrams"
  confusion
    "Unknown syntax"
''');
      final tree = parseMermaid('''
treeView-beta
  project/
    lib/
''');

      expect(ishikawa.graph.kind, MermaidDiagramKind.ishikawa);
      expect(ishikawa.graph.ishikawaDiagram!.root.label, 'Diagram error');
      expect(wardley.graph.kind, MermaidDiagramKind.wardley);
      expect(wardley.graph.wardleyMapDiagram!.components, hasLength(2));
      expect(cynefin.graph.kind, MermaidDiagramKind.cynefin);
      expect(cynefin.graph.cynefinDiagram!.domains['disorder'],
          ['Unknown syntax']);
      expect(tree.graph.kind, MermaidDiagramKind.treeView);
      expect(tree.graph.treeViewDiagram!.root.label, 'project');
    });
  });
}
