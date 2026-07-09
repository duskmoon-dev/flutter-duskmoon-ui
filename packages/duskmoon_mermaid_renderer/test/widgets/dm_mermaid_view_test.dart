import 'package:duskmoon_mermaid_renderer/duskmoon_mermaid_renderer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DmMermaidView paints a flowchart', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DmMermaidView(
            source: 'flowchart TD\nA[Start] --> B{Decision}',
          ),
        ),
      ),
    );

    expect(find.byType(DmMermaidView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('DmMermaidView paints an xy chart', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DmMermaidView(
            source: '''
xychart
  title "Monthly active users"
  x-axis [Jan, Feb, Mar]
  y-axis "Users" 0 --> 120
  bar [32, 45, 63]
  line [28, 40, 58]
''',
          ),
        ),
      ),
    );

    expect(find.byType(DmMermaidView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('DmMermaidView paints chart diagrams', (tester) async {
    const sources = [
      '''
pie showData
  title Diagram coverage
  "Native" : 30
  "Pending" : 0
''',
      '''
quadrantChart
  title Renderer Coverage
  x-axis Low Effort --> High Effort
  y-axis Low Value --> High Value
  quadrant-1 Prioritize
  quadrant-2 Evaluate
  Flowchart: [0.25, 0.80]
  XY Chart: [0.45, 0.72]
''',
      '''
radar-beta
  title Renderer quality
  axis Parser, Layout, Canvas, Tests
  curve Current{8, 6, 7, 9}
  curve Target{10, 10, 10, 10}
''',
      '''
packet
  0-15: "Source Port"
  16-31: "Destination Port"
  32-63: "Sequence Number"
''',
      '''
sankey
  Demos,Native,11
  Demos,Pending,19
  Native,Canvas,11
''',
      '''
timeline
  title Mermaid Renderer
  2026-07-01 : Flowchart
  2026-07-09 : XY Chart
  Next : More diagram types
''',
      '''
mindmap
  root((Mermaid))
    Native
      Flowchart
      XY Chart
    Planned
      Sequence
''',
      '''
kanban
  todo[Todo]
    docs[Read syntax]
  doing[Doing]
    renderer[Build renderer]
''',
      '''
treemap-beta
  "Renderer"
    "Native": 30
    "Pending": 0
  "Docs"
    "Syntax pages": 30
''',
      '''
sequenceDiagram
  participant User
  participant API
  User->>API: Request data
  API-->>User: Response
''',
      '''
stateDiagram-v2
  [*] --> Idle
  Idle --> Loading: fetch
  Loading --> Success
  Success --> [*]
''',
      '''
erDiagram
  CUSTOMER ||--o{ ORDER : places
  ORDER ||--|{ LINE_ITEM : contains
''',
      '''
journey
  title Checkout
  section Browse
    Find product: 5: Customer
    Add to cart: 4: Customer
''',
      '''
gitGraph
  commit id: "init"
  branch feature
  commit id: "work"
  checkout main
  merge feature
''',
      '''
venn-beta
  set A [Flowchart]
  set B [Charts]
  union A B [XY Chart]
''',
      '''
swimlane-beta LR
  subgraph Product
    idea[Idea] --> spec[Spec]
  end
  spec --> build
''',
      '''
classDiagram
  class Animal
  Animal <|-- Cat
''',
      '''
gantt
  title Release plan
  section Build
    Parser :done, p1, 2026-07-01, 2d
''',
      '''
requirementDiagram
  requirement renderer {
  }
  element widget {
  }
  widget - satisfies -> renderer
''',
      '''
C4Context
  Person(user, "User")
  System(app, "DuskMoon UI")
  Rel(user, app, "Views diagrams")
''',
      '''
zenuml
  Customer->Store: place order
  Store-->Customer: accepted
''',
      '''
block-beta
  columns 3
  A["Input"] B["Parser"] C["Canvas"]
  A --> B
''',
      '''
architecture-beta
  group api(cloud)[API]
  service app(server)[App] in api
  service db(database)[Database] in api
  app:R -- L:db
''',
      '''
eventmodeling
  tf 01 ui CartUI
  tf 02 cmd AddItem
  tf 03 evt ItemAdded
''',
      '''
ishikawa-beta
  Diagram error
    Unsupported header
''',
      '''
wardley-beta
  anchor User [0.9, 0.95]
  component Renderer [0.55, 0.45]
  User -> Renderer
''',
      '''
cynefin-beta
  complex
    "Unsupported diagrams"
  confusion
    "Unknown syntax"
''',
      '''
treeView-beta
  project/
    lib/
''',
    ];

    for (final source in sources) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DmMermaidView(source: source),
          ),
        ),
      );

      expect(find.byType(DmMermaidView), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}
