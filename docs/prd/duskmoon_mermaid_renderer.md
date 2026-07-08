# PRD Update: Flutter RenderObject Mermaid Renderer

## Decision

`duskmoon_mermaid_renderer` must not render Mermaid diagrams to SVG.

Instead, it must render diagrams directly through Flutter’s rendering pipeline using:

```text
Mermaid source
  -> parser
  -> IR graph
  -> layout model
  -> render primitives
  -> custom Flutter RenderBox
  -> Canvas painting
```

The package should expose Flutter widgets and render objects, while keeping parser, IR, and layout code free of Flutter UI dependencies where practical.

## Package Type

`duskmoon_mermaid_renderer` is now a **Flutter package**, not a pure Dart package.

```yaml
name: duskmoon_mermaid_renderer
description: Flutter RenderObject-based Mermaid renderer for Duskmoon UI.
version: 0.1.0
resolution: workspace

environment:
  sdk: ">=3.5.0 <4.0.0"
  flutter: ">=3.24.0"

dependencies:
  flutter:
    sdk: flutter
  collection: ^1.19.0
  meta: ^1.15.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```

Do not add:

```yaml
flutter_svg
webview_flutter
flutter_js
```

Do not generate SVG as an intermediate format.

## Architecture

Use four internal layers:

```text
parser/
  Mermaid text -> Graph IR

layout/
  Graph IR -> Layout model

scene/
  Layout model -> render primitives

widgets/
  Flutter Widget -> RenderObject -> Canvas
```

Recommended structure:

```text
packages/duskmoon_mermaid_renderer/
  lib/
    duskmoon_mermaid_renderer.dart

    src/
      config/
        layout_config.dart
        render_options.dart

      error/
        mermaid_error.dart
        parse_error.dart
        unsupported_diagram_error.dart

      ir/
        graph.dart
        node.dart
        edge.dart
        subgraph.dart
        diagram_kind.dart
        direction.dart
        style.dart

      parser/
        parser.dart
        diagram_detector.dart
        flowchart_parser.dart

      layout/
        layout.dart
        layout_types.dart
        flowchart_layout.dart
        ranking.dart
        routing.dart
        label_placement.dart

      scene/
        mermaid_scene.dart
        scene_node.dart
        scene_edge.dart
        scene_label.dart
        scene_shape.dart

      render/
        mermaid_render_object.dart
        mermaid_painter.dart
        shape_painter.dart
        edge_painter.dart
        text_painter.dart
        hit_test.dart

      widgets/
        dm_mermaid_view.dart
        dm_mermaid_controller.dart
```

## Public API

Expose a Flutter widget:

```dart
class DmMermaidView extends LeafRenderObjectWidget {
  const DmMermaidView({
    super.key,
    required this.source,
    this.options = const MermaidRenderOptions(),
    this.onError,
  });

  final String source;
  final MermaidRenderOptions options;
  final ValueChanged<MermaidError>? onError;

  @override
  RenderObject createRenderObject(BuildContext context);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderDmMermaid renderObject,
  );
}
```

Expose parser/layout APIs for testing and future tooling:

```dart
ParseOutput parseMermaid(String source);

MermaidLayout computeMermaidLayout(
  Graph graph,
  MermaidLayoutConfig config,
  MermaidTextMeasurer textMeasurer,
);

MermaidScene buildMermaidScene(
  MermaidLayout layout,
  MermaidTheme theme,
);
```

## RenderObject Design

Implement a custom `RenderBox`:

```dart
class RenderDmMermaid extends RenderBox {
  RenderDmMermaid({
    required String source,
    required MermaidRenderOptions options,
  });

  String get source;
  set source(String value);

  MermaidRenderOptions get options;
  set options(MermaidRenderOptions value);

  @override
  void performLayout();

  @override
  void paint(PaintingContext context, Offset offset);

  @override
  bool hitTestSelf(Offset position) => true;
}
```

Responsibilities:

* Parse Mermaid source.
* Compute layout.
* Build scene primitives.
* Determine intrinsic size.
* Paint nodes, edges, labels, and markers to `Canvas`.
* Cache parsed/layout/scene result by source + options.
* Mark layout dirty only when layout-affecting options change.
* Mark paint dirty only when theme/paint-only options change.
* Never throw during `paint`; invalid diagrams should render an error scene.

## Scene Model

Do not paint directly from parser IR.

Introduce a scene model between layout and render object:

```dart
class MermaidScene {
  const MermaidScene({
    required this.size,
    required this.nodes,
    required this.edges,
    required this.labels,
  });

  final Size size;
  final List<SceneNode> nodes;
  final List<SceneEdge> edges;
  final List<SceneLabel> labels;
}
```

Scene primitives should be independent of `RenderBox`, but may use Flutter geometry types such as:

* `Offset`
* `Size`
* `Rect`
* `Path`
* `RRect`

This makes the painter testable without widget tests.

## Painting Requirements

Use Flutter `Canvas` APIs:

### Nodes

Paint these shapes in v0.1:

* Rectangle
* Rounded rectangle
* Stadium
* Subroutine
* Cylinder
* Circle
* Double circle
* Diamond
* Hexagon
* Parallelogram
* Trapezoid

### Edges

Paint:

* Solid edge
* Dotted edge
* Thick edge
* Arrowhead
* Bidirectional arrowhead
* Edge labels

Use `Path` for edge geometry.

Do not use SVG path strings internally. Store path data as Flutter `Path` or structured point lists.

### Text

Use Flutter `TextPainter` for accurate text layout.

```dart
class FlutterTextMeasurer implements MermaidTextMeasurer {
  const FlutterTextMeasurer({
    required this.textDirection,
    required this.textScaler,
  });
}
```

The renderer package may depend on Flutter, so it should prefer `TextPainter` instead of heuristic-only measurement.

## Layout Flow

The pipeline should be:

```text
source
  -> parseMermaid(source)
  -> computeMermaidLayout(graph, config, textMeasurer)
  -> buildMermaidScene(layout, theme)
  -> RenderDmMermaid.paint()
```

Do not include:

```text
layout -> SVG -> flutter_svg -> widget
```

## Widget Integration

`duskmoon_widgets` should depend on `duskmoon_mermaid_renderer`.

```yaml
dependencies:
  duskmoon_mermaid_renderer: ^0.1.0
```

No `flutter_svg` dependency is required.

Replace the current Mermaid placeholder with:

```dart
if (!enabled) {
  return CodeBlockWidget(code: source, language: 'mermaid');
}

return DmMermaidView(
  source: source,
  options: config.mermaidOptions,
);
```

`DmMarkdownConfig` should expose render options:

```dart
class DmMarkdownConfig {
  const DmMarkdownConfig({
    this.enableGfm = true,
    this.enableKatex = true,
    this.enableMermaid = false,
    this.mermaidOptions = const MermaidRenderOptions(),
    this.enableCodeHighlight = true,
    this.codeTheme,
    this.blockBuilders,
    this.inlineBuilders,
  });

  final bool enableMermaid;
  final MermaidRenderOptions mermaidOptions;
}
```

## Interaction Support

The first release should support passive rendering only.

Optional v0.2+ features:

* Node hit testing
* Node hover
* Link callbacks
* Selection
* Pan/zoom wrapper
* Tooltip support
* Semantics labels

For v0.1, `DmMarkdown` can wrap `DmMermaidView` in:

```text
InteractiveViewer
  -> DmMermaidView
```

The renderer itself should not own scrolling or zooming.

## Error Rendering

Invalid diagrams must render a Flutter error scene, not throw from the render object.

Error scene should include:

* Error icon or warning shape
* Short error message
* Optional line/column if available

Markdown integration should still allow fallback to code block if rendering fails.

## Testing Requirements

### Renderer tests

Use `flutter_test`.

Required tests:

```text
parser/
  flowchart_parser_test.dart

layout/
  flowchart_layout_test.dart

scene/
  scene_builder_test.dart

render/
  render_object_layout_test.dart
  painter_shapes_test.dart
  painter_edges_test.dart
```

### Golden tests

Add basic Flutter golden tests for:

* Basic flowchart
* Labeled edge
* Common node shapes
* Dark theme
* Error scene

Golden tests should target rendered Flutter output, not SVG snapshots.

## Acceptance Criteria

v0.1 is complete when:

* `packages/duskmoon_mermaid_renderer` exists as a Flutter package.
* It exposes `DmMermaidView`.
* It implements a custom `RenderBox`.
* It does not generate SVG.
* It does not depend on `flutter_svg`.
* It renders basic flowcharts directly with `Canvas`.
* It uses `TextPainter` for text measurement.
* It supports common flowchart shapes and edge labels.
* `DmMarkdown` renders Mermaid blocks when `enableMermaid = true`.
* `DmMarkdown` still renders code fallback when `enableMermaid = false`.
* `DmMarkdownInput` preview supports Mermaid blocks.
* `melos run analyze` passes.
* `melos run test` passes.
* Flutter golden tests cover basic rendering.

## Removed From Previous PRD

Remove all requirements related to:

* `SvgDimensions`
* `renderSvg`
* SVG string output
* `flutter_svg`
* SVG snapshot tests
* SVG builder
* SVG marker renderer
* SVG export

Replace them with:

* `MermaidScene`
* `RenderDmMermaid`
* `Canvas` painting
* `TextPainter`
* Flutter golden tests
