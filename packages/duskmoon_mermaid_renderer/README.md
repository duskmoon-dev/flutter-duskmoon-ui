# duskmoon_mermaid_renderer

Flutter RenderObject-based Mermaid renderer for Duskmoon UI.

This package parses basic Mermaid flowcharts into an intermediate graph,
computes a deterministic layout, builds render primitives, and paints diagrams
directly with Flutter `Canvas`.

## Status

| Diagram type | v0.1 status |
| ------------ | ----------- |
| Flowchart | Supported, basic |
| Sequence | Planned |
| Class | Planned |
| State | Planned |
| ER | Planned |
| Pie | Planned |
| Gantt | Not yet |
| Mindmap | Not yet |
| Git graph | Not yet |
| C4 | Not yet |
| Sankey | Not yet |
| XY chart | Not yet |

## Usage

```dart
const DmMermaidView(
  source: '''
flowchart LR
  A[Start] --> B{Decision}
  B -->|yes| C[OK]
''',
)
```

## Stage APIs

```dart
final output = parseMermaid(source);
final layout = computeMermaidLayout(
  output.graph,
  const MermaidLayoutConfig(),
  const FlutterTextMeasurer(
    textDirection: TextDirection.ltr,
    textScaler: TextScaler.noScaling,
  ),
);
final scene = buildMermaidScene(layout, MermaidTheme.modern);
```

## Limitations

The first release supports a small flowchart subset. It does not use SVG,
WebView, JavaScript, Rust FFI, or platform-native rendering.

This package ports architecture and selected algorithms from
mermaid-rs-renderer by 1jehuang, licensed under MIT.
