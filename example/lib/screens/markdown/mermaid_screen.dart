import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';

import '../../destination.dart';

class MermaidScreen extends StatelessWidget {
  static const name = 'Mermaid Gallery';
  static const path = 'mermaid';
  static int get exampleCount => _examples.length;
  static int get nativeExampleCount =>
      _examples.where((example) => example.native).length;

  const MermaidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DmAdaptiveScaffold(
      selectedIndex: Destinations.indexOf(const Key('Widgets')),
      onSelectedIndexChange: (idx) => Destinations.changeHandler(idx, context),
      destinations: Destinations.navs,
      useDrawer: true,
      transitionDuration: Duration.zero,
      appBar: DmAppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: const BackButton(),
        title: const Text('Mermaid'),
        actions: const [PlatformSwitchAction()],
      ),
      appBarBreakpoint: Breakpoints.standard,
      body: (_) => const _MermaidGalleryBody(),
    );
  }
}

class _MermaidGalleryBody extends StatelessWidget {
  const _MermaidGalleryBody();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth - 32;
        final columns = contentWidth >= 1140
            ? 3
            : contentWidth >= 760
                ? 2
                : 1;
        final cardWidth = (contentWidth - (columns - 1) * 12) / columns;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Mermaid Diagram Types',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                _StatusPill(
                  label: '${MermaidScreen.exampleCount} types',
                  foreground: colorScheme.onSecondaryContainer,
                  background: colorScheme.secondaryContainer,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Native canvas coverage: ${MermaidScreen.nativeExampleCount} of ${MermaidScreen.exampleCount} types',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final example in _examples)
                  SizedBox(
                    width: cardWidth,
                    child: _MermaidExampleCard(example: example),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _MermaidExampleCard extends StatelessWidget {
  const _MermaidExampleCard({required this.example});

  final _MermaidExample example;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DmCard(
      key: ValueKey<String>('mermaid-example-${example.slug}'),
      margin: EdgeInsets.zero,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        example.title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        example.docsPath,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                _StatusPill(
                  label: example.native ? 'Native' : 'Pending',
                  foreground: example.native
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onTertiaryContainer,
                  background: example.native
                      ? colorScheme.primaryContainer
                      : colorScheme.tertiaryContainer,
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (example.native)
              _NativePreview(source: example.source)
            else
              _PendingPreview(kind: example.title),
            const SizedBox(height: 12),
            _SourcePreview(source: example.source),
          ],
        ),
      ),
    );
  }
}

class _NativePreview extends StatelessWidget {
  const _NativePreview({required this.source});

  final String source;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 220,
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant, width: 0.5),
      ),
      child: DmMermaidView(
        source: source,
        options: MermaidRenderOptions(
          layoutConfig: const MermaidLayoutConfig(
            nodeSpacing: 56,
            rankSpacing: 88,
            padding: 20,
          ),
          theme: Theme.of(context).brightness == Brightness.dark
              ? MermaidTheme.dark
              : MermaidTheme.light,
        ),
      ),
    );
  }
}

class _PendingPreview extends StatelessWidget {
  const _PendingPreview({required this.kind});

  final String kind;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 116,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant, width: 0.5),
      ),
      child: Row(
        children: [
          Icon(Icons.pending_outlined, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$kind native renderer pending',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SourcePreview extends StatelessWidget {
  const _SourcePreview({required this.source});

  final String source;

  @override
  Widget build(BuildContext context) {
    final code = '```mermaid\n$source\n```';
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 260),
      child: SingleChildScrollView(
        child: DmMarkdown(
          data: code,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.foreground,
    required this.background,
  });

  final String label;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _MermaidExample {
  const _MermaidExample({
    required this.title,
    required this.slug,
    required this.docsPath,
    required this.source,
    this.native = false,
  });

  final String title;
  final String slug;
  final String docsPath;
  final String source;
  final bool native;
}

const _examples = [
  _MermaidExample(
    title: 'Flowchart',
    slug: 'flowchart',
    docsPath: '/syntax/flowchart',
    native: true,
    source: r'''flowchart LR
  A[Start] --> B{Ready?}
  B -->|Yes| C[Ship]
  B -->|No| D[Fix]''',
  ),
  _MermaidExample(
    title: 'Swimlanes Diagram',
    slug: 'swimlanes',
    docsPath: '/syntax/swimlanes',
    native: true,
    source: r'''swimlane-beta LR
  subgraph Product
    idea[Idea] --> spec[Spec]
  end
  subgraph Engineering
    build[Build] --> test[Test]
  end
  spec --> build''',
  ),
  _MermaidExample(
    title: 'Sequence Diagram',
    slug: 'sequence',
    docsPath: '/syntax/sequenceDiagram',
    native: true,
    source: r'''sequenceDiagram
  participant User
  participant API
  User->>API: Request data
  API-->>User: Response''',
  ),
  _MermaidExample(
    title: 'Class Diagram',
    slug: 'class',
    docsPath: '/syntax/classDiagram',
    native: true,
    source: r'''classDiagram
  class Animal {
    +String name
    +move()
  }
  Animal <|-- Cat
  Animal <|-- Dog''',
  ),
  _MermaidExample(
    title: 'State Diagram',
    slug: 'state',
    docsPath: '/syntax/stateDiagram',
    native: true,
    source: r'''stateDiagram-v2
  [*] --> Idle
  Idle --> Loading: fetch
  Loading --> Success
  Loading --> Error
  Success --> [*]''',
  ),
  _MermaidExample(
    title: 'Entity Relationship Diagram',
    slug: 'er',
    docsPath: '/syntax/entityRelationshipDiagram',
    native: true,
    source: r'''erDiagram
  CUSTOMER ||--o{ ORDER : places
  ORDER ||--|{ LINE_ITEM : contains
  PRODUCT ||--o{ LINE_ITEM : includes''',
  ),
  _MermaidExample(
    title: 'User Journey',
    slug: 'journey',
    docsPath: '/syntax/userJourney',
    native: true,
    source: r'''journey
  title Checkout
  section Browse
    Find product: 5: Customer
    Add to cart: 4: Customer
  section Pay
    Enter details: 3: Customer''',
  ),
  _MermaidExample(
    title: 'Gantt',
    slug: 'gantt',
    docsPath: '/syntax/gantt',
    native: true,
    source: r'''gantt
  title Release plan
  dateFormat  YYYY-MM-DD
  section Build
    Parser      :done, p1, 2026-07-01, 2d
    Renderer    :active, p2, after p1, 3d''',
  ),
  _MermaidExample(
    title: 'Pie Chart',
    slug: 'pie',
    docsPath: '/syntax/pie',
    source: r'''pie showData
  title Diagram coverage
  "Native" : 30
  "Pending" : 0''',
    native: true,
  ),
  _MermaidExample(
    title: 'Quadrant Chart',
    slug: 'quadrant',
    docsPath: '/syntax/quadrantChart',
    native: true,
    source: r'''quadrantChart
  title Renderer Coverage
  x-axis Low Effort --> High Effort
  y-axis Low Value --> High Value
  quadrant-1 Prioritize
  quadrant-2 Evaluate
  quadrant-3 Defer
  quadrant-4 Plan
  Flowchart: [0.25, 0.80]
  XY Chart: [0.45, 0.72]''',
  ),
  _MermaidExample(
    title: 'Requirement Diagram',
    slug: 'requirement',
    docsPath: '/syntax/requirementDiagram',
    native: true,
    source: r'''requirementDiagram
  requirement renderer {
    id: 1
    text: Native canvas rendering
    risk: High
    verifymethod: Test
  }
  element widget {
    type: Flutter
    docref: DmMermaidView
  }
  widget - satisfies -> renderer''',
  ),
  _MermaidExample(
    title: 'GitGraph Diagram',
    slug: 'gitgraph',
    docsPath: '/syntax/gitgraph',
    native: true,
    source: r'''gitGraph
  commit id: "init"
  branch feature
  checkout feature
  commit id: "xychart"
  checkout main
  merge feature''',
  ),
  _MermaidExample(
    title: 'C4 Diagram',
    slug: 'c4',
    docsPath: '/syntax/c4',
    native: true,
    source: r'''C4Context
  title System Context
  Person(user, "User")
  System(app, "DuskMoon UI")
  Rel(user, app, "Views diagrams")''',
  ),
  _MermaidExample(
    title: 'Mindmap',
    slug: 'mindmap',
    docsPath: '/syntax/mindmap',
    native: true,
    source: r'''mindmap
  root((Mermaid))
    Native
      Flowchart
      XY Chart
    Planned
      Sequence
      Class''',
  ),
  _MermaidExample(
    title: 'Timeline',
    slug: 'timeline',
    docsPath: '/syntax/timeline',
    native: true,
    source: r'''timeline
  title Mermaid Renderer
  2026-07-01 : Flowchart
  2026-07-09 : XY Chart
  Next : More diagram types''',
  ),
  _MermaidExample(
    title: 'ZenUML',
    slug: 'zenuml',
    docsPath: '/syntax/zenuml',
    native: true,
    source: r'''zenuml
  title Order
  Customer->Store: place order
  Store->Warehouse: reserve item
  Warehouse-->Store: reserved''',
  ),
  _MermaidExample(
    title: 'Sankey',
    slug: 'sankey',
    docsPath: '/syntax/sankey',
    native: true,
    source: r'''sankey
  Demos,Native,17
  Demos,Native,30
  Demos,Pending,0
  Native,Canvas,30''',
  ),
  _MermaidExample(
    title: 'XY Chart',
    slug: 'xy-chart',
    docsPath: '/syntax/xyChart',
    native: true,
    source: r'''xychart
  title "Monthly active users"
  x-axis [Jan, Feb, Mar, Apr, May, Jun]
  y-axis "Users" 0 --> 120
  bar [32, 45, 63, 74, 98, 111]
  line [28, 40, 58, 70, 92, 105]''',
  ),
  _MermaidExample(
    title: 'Block Diagram',
    slug: 'block',
    docsPath: '/syntax/block',
    native: true,
    source: r'''block-beta
  columns 3
  A["Input"] B["Parser"] C["Canvas"]
  A --> B
  B --> C''',
  ),
  _MermaidExample(
    title: 'Packet',
    slug: 'packet',
    docsPath: '/syntax/packet',
    native: true,
    source: r'''packet
  0-15: "Source Port"
  16-31: "Destination Port"
  32-63: "Sequence Number"''',
  ),
  _MermaidExample(
    title: 'Kanban',
    slug: 'kanban',
    docsPath: '/syntax/kanban',
    native: true,
    source: r'''kanban
  todo[Todo]
    docs[Read syntax]
  doing[Doing]
    renderer[Build renderer]
  done[Done]
    flowchart[Flowchart]''',
  ),
  _MermaidExample(
    title: 'Architecture',
    slug: 'architecture',
    docsPath: '/syntax/architecture',
    native: true,
    source: r'''architecture-beta
  group api(cloud)[API]
  service app(server)[App] in api
  service db(database)[Database] in api
  app:R -- L:db''',
  ),
  _MermaidExample(
    title: 'Radar',
    slug: 'radar',
    docsPath: '/syntax/radar',
    native: true,
    source: r'''radar-beta
  title Renderer quality
  axis Parser, Layout, Canvas, Tests
  curve Current{8, 6, 7, 9}
  curve Target{10, 10, 10, 10}''',
  ),
  _MermaidExample(
    title: 'Event Modeling',
    slug: 'event-modeling',
    docsPath: '/syntax/eventmodeling',
    native: true,
    source: r'''eventmodeling
  tf 01 ui CartUI
  tf 02 cmd AddItem
  tf 03 evt ItemAdded''',
  ),
  _MermaidExample(
    title: 'Treemap',
    slug: 'treemap',
    docsPath: '/syntax/treemap',
    native: true,
    source: r'''treemap-beta
  "Renderer"
    "Native": 30
    "Pending": 0
  "Docs"
    "Syntax pages": 30''',
  ),
  _MermaidExample(
    title: 'Venn',
    slug: 'venn',
    docsPath: '/syntax/venn',
    native: true,
    source: r'''venn-beta
  set A [Flowchart]
  set B [Charts]
  union A B [XY Chart]''',
  ),
  _MermaidExample(
    title: 'Ishikawa',
    slug: 'ishikawa',
    docsPath: '/syntax/ishikawa',
    native: true,
    source: r'''ishikawa-beta
  Diagram error
    Unsupported header
      Missing detector
      Missing parser
    Rendering
      Native gap''',
  ),
  _MermaidExample(
    title: 'Wardley',
    slug: 'wardley',
    docsPath: '/syntax/wardley',
    native: true,
    source: r'''wardley-beta
  title Renderer Map
  size [700, 420]
  anchor User [0.9, 0.95]
  component Markdown [0.75, 0.65]
  component Renderer [0.55, 0.45]
  User -> Markdown
  Markdown -> Renderer''',
  ),
  _MermaidExample(
    title: 'Cynefin',
    slug: 'cynefin',
    docsPath: '/syntax/cynefin',
    native: true,
    source: r'''cynefin-beta
  title Renderer work
  complex
    "Unsupported diagrams"
  complicated
    "Parser architecture"
  clear
    "Flowchart rendering"
  chaotic
    "Runtime error"
  confusion
    "Unknown syntax"''',
  ),
  _MermaidExample(
    title: 'TreeView',
    slug: 'treeview',
    docsPath: '/syntax/treeView',
    native: true,
    source: r'''treeView-beta
  flutter-duskmoon-ui/
    example/
      lib/
        screens/
    packages/
      duskmoon_mermaid_renderer/''',
  ),
];
