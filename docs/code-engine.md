# Design: `duskmoon_code_engine`

> Flutter port of the CodeMirror 6 / Lezer architecture
> Location: `flutter_duskmoon_ui/packages/duskmoon_code_engine`
> Pure Dart — no FFI, no platform channels
> Status: Draft v1.0.0

---

## 1. Overview

A pure-Dart code editor engine for Flutter, architecturally derived from CodeMirror 6. Single collapsed package providing: document model, incremental parser (Lezer runtime port), state management, virtual-viewport rendering, syntax highlighting, and 20+ language grammars.

This is **not** a wrapper around CM6 — it's a ground-up Dart implementation that preserves CM6's architectural decisions (immutable state, facet system, transaction pipeline, viewport-only rendering) while being idiomatic to Dart and Flutter.

### Goals

- Pure Dart — runs on all Flutter targets (iOS, Android, macOS, Windows, Linux, Web) with zero platform dependencies
- Virtual viewport rendering — handle 100K+ line files with constant memory
- Incremental parsing — Lezer LR runtime ported to Dart, sub-frame re-parse on edits
- Single package — no internal package graph, one `pubspec.yaml`
- DuskMoon design system integration — consumes `DmDesignTokens` for theming
- 20+ grammars shipped: Dart, TS, JS, Elixir, Rust, Go, HTML, CSS, JSON, Markdown, YAML, PHP, Ruby, Python, Erlang, Zig, C, C++, Swift, Java, Kotlin

### Non-Goals

- Not a full IDE (no LSP, no project tree, no terminal)
- Not a drop-in replacement for `TextField` — purpose-built for code
- No collaborative editing in v1 (no CRDT/OT)
- No diff view in v1 (future phase)

---

## 2. Architecture

### 2.1 Layer Diagram

```
┌─────────────────────────────────────────────────────┐
│                   CodeEditorWidget                   │  ← Flutter Widget layer
│                  (public API surface)                │
├─────────────────────────────────────────────────────┤
│                    ViewState                         │  ← Viewport management
│         (visible range, scroll, cursor blink,        │
│          IME composition, selection painting)         │
├─────────────────────────────────────────────────────┤
│                   EditorState                        │  ← Immutable state snapshots
│         (doc, selection, extensions, facets)          │
├──────────────────────┬──────────────────────────────┤
│     Document         │       Language               │
│  (rope + line cache) │  (Lezer runtime + grammars)  │
└──────────────────────┴──────────────────────────────┘
```

### 2.2 Module Map (src/ layout)

```
lib/
├── duskmoon_code_engine.dart          # barrel export
└── src/
    ├── document/
    │   ├── document.dart              # Document (immutable rope)
    │   ├── rope.dart                  # Rope data structure
    │   ├── text.dart                  # Text/Line abstractions
    │   ├── change.dart                # ChangeSet, ChangeDesc
    │   └── position.dart              # Pos, Range, SelectionRange
    │
    ├── state/
    │   ├── editor_state.dart          # EditorState
    │   ├── transaction.dart           # Transaction, TransactionSpec
    │   ├── selection.dart             # EditorSelection
    │   ├── facet.dart                 # Facet<Input, Output>
    │   ├── compartment.dart           # Compartment (dynamic reconfiguration)
    │   ├── state_field.dart           # StateField<T>
    │   ├── state_effect.dart          # StateEffect<T>
    │   ├── extension.dart             # Extension type + precedence
    │   └── annotation.dart            # Transaction annotations
    │
    ├── lezer/
    │   ├── common/
    │   │   ├── tree.dart              # Tree, TreeBuffer, SyntaxNode
    │   │   ├── tree_cursor.dart       # TreeCursor for traversal
    │   │   ├── node_type.dart         # NodeType, NodeSet, NodeProp
    │   │   ├── node_group.dart        # NodeGroup (formerly NodeSet)
    │   │   ├── parser.dart            # Parser abstract interface
    │   │   ├── mixed_parser.dart      # Mixed-language support (overlay/nested)
    │   │   └── token.dart             # Token, ExternalTokenizer
    │   ├── lr/
    │   │   ├── lr_parser.dart         # LRParser (table-driven)
    │   │   ├── parse_state.dart       # Incremental parse stack
    │   │   ├── token_cache.dart       # Token caching layer
    │   │   ├── parse_worker.dart      # Background isolate for heavy parses
    │   │   ├── tree_serializer.dart   # Binary tree encode/decode for isolate transfer
    │   │   └── grammar_data.dart      # Serialized grammar table types
    │   └── highlight/
    │       ├── highlight.dart         # HighlightStyle, tags → styles
    │       ├── tags.dart              # Tag definitions (keyword, string, etc.)
    │       └── class_highlighter.dart # Tag → TextStyle resolver
    │
    ├── language/
    │   ├── language.dart              # Language, LanguageSupport
    │   ├── language_data.dart         # LanguageData facet
    │   ├── parse_scheduler.dart       # Two-tier parse orchestration (main + isolate)
    │   ├── indentation.dart           # Auto-indent engine
    │   ├── folding.dart               # Code folding via syntax tree
    │   ├── syntax.dart                # syntaxTree(), syntaxTreeAvailable()
    │   └── stream_language.dart       # StreamLanguage for legacy modes
    │
    ├── grammars/
    │   ├── dart.dart                  # Dart grammar tables
    │   ├── typescript.dart
    │   ├── javascript.dart
    │   ├── elixir.dart
    │   ├── erlang.dart
    │   ├── rust.dart
    │   ├── go.dart
    │   ├── python.dart
    │   ├── ruby.dart
    │   ├── php.dart
    │   ├── html.dart
    │   ├── css.dart
    │   ├── json.dart
    │   ├── markdown.dart
    │   ├── yaml.dart
    │   ├── zig.dart
    │   ├── c.dart
    │   ├── cpp.dart
    │   ├── swift.dart
    │   ├── java.dart
    │   ├── kotlin.dart
    │   └── _registry.dart             # Language name → Language lookup
    │
    ├── view/
    │   ├── code_editor_widget.dart    # Top-level StatefulWidget
    │   ├── editor_view.dart           # EditorView (non-widget controller)
    │   ├── viewport.dart              # Viewport range calculation
    │   ├── line_painter.dart          # CustomPainter for visible lines
    │   ├── gutter_painter.dart        # Line numbers + fold markers
    │   ├── selection_painter.dart     # Selection + cursor rendering
    │   ├── scroll_controller.dart     # Virtual scroll management
    │   ├── input_handler.dart         # Keyboard + IME composition
    │   ├── decoration.dart            # Decoration, DecorationSet
    │   ├── view_plugin.dart           # ViewPlugin (side-effect extensions)
    │   └── tooltip.dart               # Tooltip positioning
    │
    ├── commands/
    │   ├── commands.dart              # Standard editing commands
    │   ├── history.dart               # Undo/redo
    │   ├── comment.dart               # Toggle comment
    │   └── keymap.dart                # Keymap facet + binding resolution
    │
    ├── search/
    │   ├── search.dart                # Search state + commands
    │   └── search_panel.dart          # Search UI overlay widget
    │
    ├── autocomplete/
    │   ├── autocomplete.dart          # Completion source + state
    │   └── completion_widget.dart     # Completion popup overlay
    │
    ├── lint/
    │   ├── lint.dart                  # Diagnostic source + state
    │   └── lint_gutter.dart           # Gutter markers for diagnostics
    │
    └── theme/
        ├── editor_theme.dart          # EditorTheme (TextStyles + colors)
        └── default_highlight.dart     # Default syntax highlight styles
```

---

## 3. Document Model

### 3.1 Rope

Balanced rope tree for O(log n) character access, line lookup, and splice operations. Mirrors CM6's `Text` but implemented as a proper rope rather than CM6's flat-array-of-lines approach (which is fine for JS but Dart benefits from structural sharing for large files).

```dart
/// Immutable rope node. Leaves hold ≤1KB of text.
/// Internal nodes hold left/right with cached length + line count.
sealed class RopeNode {
  int get length;
  int get lineCount;
}

final class RopeLeaf extends RopeNode {
  final String text;
  // ...
}

final class RopeBranch extends RopeNode {
  final RopeNode left;
  final RopeNode right;
  // Cached aggregates
  final int length;
  final int lineCount;
  // ...
}
```

### 3.2 Document

```dart
/// Immutable document. Every edit produces a new Document.
class Document {
  final RopeNode _root;

  /// Total character length.
  int get length;

  /// Number of lines (always ≥ 1).
  int get lineCount;

  /// Get line content by 1-based line number.
  Line lineAt(int lineNumber);

  /// Get line containing character offset.
  Line lineAtOffset(int offset);

  /// Extract substring.
  String sliceString(int from, [int? to]);

  /// Apply a ChangeSet, return new Document.
  Document replace(ChangeSet changes);

  /// Iterate lines in range (for viewport rendering).
  Iterable<Line> linesInRange(int fromLine, int toLine);
}

class Line {
  final int number;     // 1-based
  final int from;       // start offset (inclusive)
  final int to;         // end offset (exclusive, before newline)
  final String text;
}
```

### 3.3 ChangeSet

Mirrors CM6's `ChangeSet` — a compact representation of a document edit as a sequence of retained/inserted/deleted spans.

```dart
class ChangeSet {
  /// Sections: positive = retained length, negative = deleted length.
  /// Insertions stored separately aligned to sections.
  final List<int> sections;
  final List<String> inserted;

  /// Compose two sequential changes into one.
  ChangeSet compose(ChangeSet other);

  /// Map a position through this change.
  int mapPos(int pos, {int assoc = -1});

  /// Create from a single replacement.
  factory ChangeSet.of(int docLength, List<ChangeSpec> changes);
}
```

---

## 4. State System

### 4.1 Facets

Direct port of CM6's facet system — the core mechanism for composable, typed extension points.

```dart
/// A facet defines a typed extension point.
/// Multiple extensions can provide values; a combine function reduces them.
class Facet<Input, Output> {
  final Output Function(List<Input>) combine;
  final List<Facet>? dependencies;
  final bool static; // true = value never changes after creation

  /// Create an extension that provides a value to this facet.
  Extension of(Input value);

  /// Create a computed extension derived from other facets.
  Extension compute(List<Facet> deps, Input Function(EditorState) get);
}
```

### 4.2 EditorState

```dart
/// Immutable editor state snapshot.
class EditorState {
  final Document doc;
  final EditorSelection selection;
  // Facet values resolved from extensions (internal)
  final _FacetStore _facets;

  /// Read a facet value.
  T facet<T>(Facet<dynamic, T> facet);

  /// Read a state field.
  T field<T>(StateField<T> field);

  /// Create a transaction that modifies this state.
  Transaction update(TransactionSpec spec);

  /// Apply a transaction, produce new state.
  EditorState applyTransaction(Transaction tr);

  /// Create initial state.
  factory EditorState.create({
    Document? doc,
    String? docString,
    EditorSelection? selection,
    List<Extension> extensions = const [],
  });
}
```

### 4.3 Transaction

```dart
class Transaction {
  final EditorState startState;
  final ChangeSet changes;
  final EditorSelection selection;
  final List<StateEffect> effects;
  final Map<Annotation, Object> annotations;
  final bool scrollIntoView;

  /// New state after applying this transaction.
  EditorState get state;

  /// Whether the document changed.
  bool get docChanged;

  /// Whether the selection changed.
  bool get selectionChanged;
}
```

### 4.4 StateField

```dart
/// Persistent state attached to EditorState, updated per transaction.
class StateField<T> {
  final T Function(EditorState) create;
  final T Function(Transaction, T) update;
  final Extension? provide; // optionally provide to a facet

  Extension get extension;
}
```

### 4.5 Compartment

```dart
/// Dynamic reconfiguration boundary.
/// Wrap extensions in a compartment to swap them at runtime.
class Compartment {
  Extension of(Extension ext);
  StateEffect<Extension> reconfigure(Extension ext);
}
```

This is how language switching works at runtime — the language extension lives in a `Compartment`, and a `reconfigure` effect swaps it.

---

## 5. Lezer Runtime (Pure Dart)

### 5.1 Port Strategy

Port `@lezer/common` (tree structure, node types, cursors) and `@lezer/lr` (table-driven incremental LR parser) to Dart. This is the heaviest single subsystem (~3K lines of JS → ~4K lines of Dart).

Key adaptations:
- JS `Uint16Array` → Dart `Uint16List` (identical semantics)
- JS `class` with mutable fields → Dart classes (same, but use `final` where CM6 could have)
- JS WeakMap → Dart `Expando` (for tree node caching)
- JS generator functions → Dart `Iterable` / `Iterator`

### 5.2 Grammar Data Format

Lezer grammars compile to serialized parse tables (arrays of integers). On the web, these are JS files exporting `LRParser.deserialize(...)` with a data string.

For Dart, two options for shipping grammar tables:

**Option A — Dart source literals** (chosen):
Grammar tables compiled to Dart `const` lists. Each grammar is a `.dart` file with `const` data:

```dart
// lib/src/grammars/dart.dart
import '../lezer/lr/lr_parser.dart';

final dartLanguage = LRParser.deserialize(
  // parse table as const Uint16List
  states: _states,
  stateData: _stateData,
  goto: _goto,
  nodeNames: _nodeNames,
  // ...
);

const _states = <int>[0, 1, 5, 2, ...]; // thousands of entries
```

**Option B — Binary asset** (deferred):
Ship `.grammar.bin` files loaded via `rootBundle`, deserialize at runtime. Better for code size but adds async initialization.

### 5.3 Grammar Compilation Pipeline

Lezer's `@lezer/generator` compiles `.grammar` files to parse tables. We need a build-time tool:

```
lezer .grammar source (upstream, unmodified)
        │
        ▼
@lezer/generator (runs in Bun/Node at build time)
        │
        ▼
JSON intermediate (parse tables + node names)
        │
        ▼
grammar_to_dart.dart (codegen script)
        │
        ▼
lib/src/grammars/<lang>.dart (Dart const data)
```

The `.grammar` files are NOT ported — they stay in Lezer's DSL and compile using the existing JS toolchain. Only the **runtime** is ported to Dart. The Elixir grammar is sourced from the web `duskmoon-dev/code-engine` repo. Adding a new grammar:

1. Copy upstream `.grammar` file (or write new one; for Elixir, export from web code-engine)
2. Run `bun run codegen:grammars` locally — invokes `@lezer/generator`, pipes output through `grammar_to_dart`
3. Generated `.dart` file lands in `lib/src/grammars/`
4. **Commit the generated `.dart` file** — CI does not run grammar codegen, generated files are checked in

### 5.4 Incremental Parsing

The key property of Lezer's LR parser: given a previous parse tree and a `ChangeSet`, it reuses unchanged subtrees and only re-parses the modified region. This is critical for sub-frame highlighting after edits.

```dart
class LRParser extends Parser {
  /// Parse a document, optionally reusing a previous tree.
  @override
  Tree parse(
    String input, {
    Tree? previousTree,
    List<ChangedRange>? changedRanges,
    int? startPos,
    int? stopAt, // time budget — yield partial tree
  });
}
```

The `stopAt` parameter enables **time-sliced parsing**: parse for N microseconds, yield a partial tree, continue in the next idle callback. Used for incremental re-parses on the main isolate.

### 5.5 Parse Scheduling (Isolate Architecture)

Parsing runs on **two tiers** to balance latency and throughput:

```
                        ┌─────────────────────────┐
  keystroke/edit ──────▶│    Main Isolate          │
                        │  time-sliced incremental │◀── small edits (<5KB changed)
                        │  parse (stopAt budget)   │    sub-ms, no overhead
                        └────────────┬────────────┘
                                     │
                          change > threshold?
                                     │ yes
                                     ▼
                        ┌─────────────────────────┐
                        │  Background Isolate      │
                        │  (ParseWorker)           │◀── initial file open
                        │  full/recovery parse     │    large paste (>5KB)
                        └────────────┬────────────┘    file reload
                                     │
                          tree serialized via
                          TransferableTypedData
                                     │
                                     ▼
                        ┌─────────────────────────┐
                        │    Main Isolate          │
                        │  tree deserialized,      │
                        │  StateField updated,     │
                        │  view repaints           │
                        └─────────────────────────┘
```

**Tier 1 — Main isolate, time-sliced** (default path):

After each edit, the parser runs incrementally on the main isolate with a `stopAt` budget (default: 8ms — half a frame at 60fps). Small edits (typing, delete, single-line paste) typically re-parse in <1ms because Lezer reuses unchanged subtrees. If the budget expires, a partial tree is stored and parsing resumes on the next `SchedulerBinding.scheduleTask` callback at `Priority.animation`.

This is the hot path — zero isolate overhead, zero serialization cost.

**Tier 2 — Background isolate** (heavy work):

Triggered when:
- **Initial file open** — first parse of the entire document
- **Large edit** — `ChangeSet` affects >5KB of text (e.g., large paste, reformatter)
- **Recovery** — time-sliced parser fell behind (partial tree age > 500ms)

The background isolate receives:
- Document text as `String` (transferred, not copied, when possible)
- Grammar parse tables (sent once on isolate spawn, retained)
- Previous tree in serialized binary form (if incremental)
- Changed ranges

Returns the complete `Tree` as a serialized binary blob via `TransferableTypedData` — zero-copy transfer to the main isolate.

```dart
/// Long-lived background isolate for heavy parsing.
class ParseWorker {
  late final Isolate _isolate;
  late final SendPort _sendPort;

  /// Spawn the worker. Call once, reuse across parses.
  Future<void> spawn();

  /// Request a parse. Returns when complete tree is available.
  Future<Tree> parse({
    required String text,
    required GrammarData grammar,
    Tree? previousTree,
    List<ChangedRange>? changes,
  });

  /// Dispose the isolate.
  void dispose();
}
```

**Tree serialization format:**

Trees must cross the isolate boundary efficiently. A compact binary encoding:

```
[nodeType:uint16] [from:uint32] [to:uint32] [childCount:uint16] [children...]
```

Flat pre-order traversal into a `Uint8List`. Deserialization reconstructs the `Tree` on the main isolate. The `TransferableTypedData` wrapper ensures the byte buffer is moved, not copied.

Estimated overhead: ~50µs for a 10K-node tree (typical for a 1K-line file). Negligible compared to the parse itself.

**Parse state machine:**

```dart
enum ParseStatus {
  /// Tree is current — no pending work.
  current,

  /// Time-sliced parse in progress on main isolate.
  slicing,

  /// Background isolate parse in progress.
  backgroundPending,

  /// Partial tree available, not yet fully parsed.
  partial,
}
```

The `Language` `StateField` tracks `ParseStatus` and exposes it via `syntaxTreeAvailable()`. The view layer uses partial trees for highlighting (better than no highlighting) — nodes below the parsed frontier get a default style.

**Isolate lifecycle:**

- One `ParseWorker` per `EditorView`, spawned lazily on first heavy parse
- Worker stays alive for the editor's lifetime (avoids repeated spawn cost ~5ms)
- Grammar tables sent once per language switch, cached in worker
- Worker disposed when `EditorViewController.dispose()` is called

**Flutter Web note:**

On Flutter web, `Isolate.spawn` maps to Web Workers. `TransferableTypedData` maps to `Transferable` objects. The same API works, but with caveats: web workers have higher spawn cost (~50ms) and message passing goes through structured clone. The lazy-spawn + long-lived worker pattern is even more important on web. Grammar tables should be transferred once and cached in the worker's global scope.

### 5.6 Mixed-Language Support

HTML embeds CSS and JS. Markdown embeds fenced code blocks. The `MixedParser` handles this by delegating subtree regions to child parsers:

```dart
class MixedParser extends Parser {
  final Parser baseParser;
  final List<MixedParserSpec> nested;
  // Overlays child parsers onto regions identified by the base tree
}
```

This is how HTML + CSS + JS works: the HTML grammar parses the structure, `MixedParser` identifies `<style>` and `<script>` regions, and delegates to the CSS/JS parsers.

---

## 6. Language System

### 6.1 Language

```dart
/// A language definition: parser + metadata.
class Language {
  final String name;
  final Parser parser;
  final LanguageData data; // indentation, folding, comment tokens, etc.

  /// Get the syntax tree from an EditorState.
  static Tree? syntaxTree(EditorState state);

  /// Check if parsing is complete.
  static bool syntaxTreeAvailable(EditorState state);
}

/// Bundles a Language with support extensions (autocomplete, etc.)
class LanguageSupport {
  final Language language;
  final List<Extension> support; // autocomplete, linting, etc.

  Extension get extension;
}
```

### 6.2 Language Registry

```dart
/// Lookup language by name, file extension, or MIME type.
class LanguageRegistry {
  static LanguageSupport? byName(String name);
  static LanguageSupport? byExtension(String ext);
  static LanguageSupport? byMimeType(String mime);

  /// All registered language names.
  static List<String> get names;
}
```

Grammars are registered at library initialization via top-level code in each grammar file. Tree-shaking ensures unused grammars don't bloat the binary — only grammars that are `import`ed get included.

### 6.3 Grammar Inventory (21 languages)

| Language   | Grammar Source          | Mixed Parsing | Priority |
|------------|------------------------|---------------|----------|
| Dart       | lezer-dart (community) | No            | P0       |
| TypeScript | @lezer/javascript      | No            | P0       |
| JavaScript | @lezer/javascript      | No            | P0       |
| HTML       | @lezer/html            | CSS + JS      | P0       |
| CSS        | @lezer/css             | No            | P0       |
| JSON       | @lezer/json            | No            | P0       |
| Markdown   | @lezer/markdown        | Fenced blocks | P0       |
| Python     | @lezer/python          | No            | P1       |
| Rust       | @lezer/rust            | No            | P1       |
| Go         | @lezer/go (community)  | No            | P1       |
| Elixir     | code-engine repo       | HEEx          | P1       |
| YAML       | @lezer/yaml            | No            | P1       |
| C          | @lezer/cpp             | No            | P1       |
| C++        | @lezer/cpp             | No            | P1       |
| Java       | @lezer/java            | No            | P2       |
| Kotlin     | community/custom       | No            | P2       |
| PHP        | @lezer/php             | HTML          | P2       |
| Ruby       | community/custom       | No            | P2       |
| Erlang     | community/custom       | No            | P2       |
| Swift      | community/custom       | No            | P2       |
| Zig        | community/custom       | No            | P2       |

"community/custom" grammars: either find existing Lezer grammar or write `.grammar` files from scratch. Opus handles this in loki mode.

---

## 7. View Layer

### 7.1 Architecture

The view layer uses Flutter's `Sliver` protocol for virtual rendering. Only lines visible in the viewport (plus a small overscan buffer) are laid out and painted.

```
CodeEditorWidget (StatefulWidget)
  └── CustomScrollView
        ├── SliverGutter          (line numbers, fold markers, lint markers)
        └── SliverEditorContent   (code lines — virtual)
              └── per-line: RenderEditorLine (RenderBox via CustomPainter)
                    ├── text spans (syntax highlighted)
                    ├── selection rectangles
                    ├── cursor caret
                    ├── decoration marks
                    └── IME composition underline
```

### 7.2 Virtual Viewport

```dart
/// Manages which lines are materialized in the widget tree.
class EditorViewport {
  /// Current scroll offset in pixels.
  double scrollOffset;

  /// Height of the visible viewport in pixels.
  double viewportHeight;

  /// Line height (fixed — monospace font).
  double lineHeight;

  /// Overscan: extra lines above/below viewport to reduce flicker.
  int overscan = 5;

  /// First visible line (0-based).
  int get firstVisibleLine =>
      max(0, (scrollOffset / lineHeight).floor() - overscan);

  /// Last visible line (exclusive).
  int get lastVisibleLine =>
      min(document.lineCount,
          ((scrollOffset + viewportHeight) / lineHeight).ceil() + overscan);

  /// Total scroll extent.
  double get maxScrollExtent => document.lineCount * lineHeight;
}
```

Fixed line height is a deliberate constraint. Monospace code fonts have uniform line height; this gives us O(1) line ↔ pixel mapping (no cumulative height cache, no binary search). Word wrap, if enabled, complicates this — see §7.5.

### 7.3 Line Rendering

Each visible line is painted via `CustomPainter`, not built as a `RichText` widget. This avoids the widget-per-line overhead and gives us direct canvas control for:

- Selection rectangle painting (arbitrary ranges, multi-cursor)
- Cursor caret with blink animation
- Bracket match highlighting
- Decoration underlines/backgrounds
- IME composition styling

```dart
class LinePainter extends CustomPainter {
  final Line line;
  final List<InlineSpan> spans;       // syntax highlight spans
  final List<SelectionRange> selections;
  final CursorState? cursor;
  final List<Decoration> decorations;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Paint line background decorations
    // 2. Paint selection rectangles
    // 3. Paint text spans (TextPainter with styled TextSpan)
    // 4. Paint inline decorations (underlines, etc.)
    // 5. Paint cursor caret
  }
}
```

### 7.4 Input Handling

Flutter's `TextInput` protocol handles IME, but it expects a `TextEditingValue` — which conflicts with our rope-based document. Strategy: **thin `TextInputClient` adapter** that exposes a window of text around the cursor to the platform's IME, and maps IME operations back to `Transaction`s.

```dart
class EditorInputHandler implements TextInputClient {
  final EditorView view;

  @override
  TextEditingValue get currentTextEditingValue {
    // Return text around cursor (±500 chars) for IME context
    // Full document is NOT exposed to platform
  }

  @override
  void updateEditingValue(TextEditingValue value) {
    // Diff against last known value → ChangeSet → Transaction
  }

  @override
  void performAction(TextInputAction action) {
    // Enter, tab, etc. → command dispatch
  }
}
```

For physical keyboard input, `RawKeyboardListener` / `HardwareKeyboard` + `KeyboardListener` handles key events → command dispatch via the keymap facet.

### 7.5 Word Wrap (Optional)

When word wrap is enabled, a single document line may span multiple visual lines. This breaks the O(1) line-height assumption. Solution: a `HeightMap` that caches visual line count per document line, updated incrementally on edits. This mirrors CM6's `HeightMap`.

Deferred to Phase 3 — initial implementation assumes no wrap (horizontal scroll).

### 7.6 EditorView (Controller)

```dart
/// The non-widget controller. Holds state, dispatches transactions.
/// Conceptually equivalent to CM6's EditorView minus DOM management.
class EditorView {
  EditorState state;

  /// Dispatch a transaction. Triggers rebuild of affected view regions.
  void dispatch(TransactionSpec spec);

  /// Dispatch multiple specs as one transaction.
  void dispatchMulti(List<TransactionSpec> specs);

  /// Read a facet from current state.
  T facet<T>(Facet<dynamic, T> facet);

  /// Current viewport information.
  EditorViewport get viewport;

  /// Focus the editor.
  void focus();

  /// Scroll a position into view.
  void scrollToPos(int pos);

  /// Coordinate ↔ position mapping.
  int? posAtCoords(Offset coords);
  Offset? coordsAtPos(int pos);
}
```

---

## 8. Decoration System

Mirrors CM6's `Decoration` / `DecorationSet` for marking up rendered content.

```dart
/// Types of decorations that can be applied.
sealed class Decoration {
  final int from;
  final int to;
}

/// Inline styling (syntax highlighting, search match, etc.)
class MarkDecoration extends Decoration {
  final TextStyle? style;
  final String? cssClass; // unused in Flutter, kept for compat
  final Map<String, String>? attributes;
}

/// Widget inserted at a position (e.g., fold placeholder, lint icon).
class WidgetDecoration extends Decoration {
  final Widget widget;
  final bool isBlock; // block = full line, inline = within text
}

/// Replaces a range with a widget (e.g., folded code).
class ReplaceDecoration extends Decoration {
  final Widget? widget; // null = invisible (folded)
}

/// Line-level decoration (background color, gutter marker).
class LineDecoration extends Decoration {
  final Color? backgroundColor;
  final Widget? gutterMarker;
}
```

Decorations are provided via `StateField<DecorationSet>` and composed by the view layer using a `RangeSet`-like structure for efficient viewport queries.

---

## 9. Commands & Keybindings

### 9.1 Command Type

```dart
/// A command is a function that reads state and optionally dispatches.
/// Returns true if handled, false to fall through.
typedef Command = bool Function(EditorView view);
```

### 9.2 Keymap

```dart
/// Bind key combinations to commands.
class KeyBinding {
  final String key;       // e.g., "Ctrl-z", "Cmd-s", "Shift-Enter"
  final Command? run;     // normal mode
  final Command? shift;   // with shift (for selection extension)
  final bool preventDefault;
}

/// Standard keymaps.
final List<KeyBinding> defaultKeymap;
final List<KeyBinding> historyKeymap;     // Ctrl-Z, Ctrl-Shift-Z
final List<KeyBinding> searchKeymap;      // Ctrl-F, Ctrl-H
final List<KeyBinding> commentKeymap;     // Ctrl-/
final List<KeyBinding> foldKeymap;        // Ctrl-Shift-[, Ctrl-Shift-]
```

Platform-aware: `Cmd` on macOS/iOS, `Ctrl` on others. Resolved at runtime via `defaultTargetPlatform`.

### 9.3 Standard Commands

```dart
// Cursor movement
Command cursorCharLeft, cursorCharRight;
Command cursorLineUp, cursorLineDown;
Command cursorLineStart, cursorLineEnd;
Command cursorDocStart, cursorDocEnd;
Command cursorPageUp, cursorPageDown;
Command cursorWordLeft, cursorWordRight;

// Selection (shift variants of above)
Command selectCharLeft, selectCharRight;
// ... etc.

// Editing
Command insertNewline, insertTab;
Command deleteCharBackward, deleteCharForward;
Command deleteWordBackward, deleteWordForward;
Command deleteLine;

// Indentation
Command indentMore, indentLess;
Command indentSelection; // auto-indent based on syntax

// History
Command undo, redo;

// Clipboard
Command copySelection, cutSelection, pasteClipboard;

// Comment
Command toggleComment, toggleBlockComment;

// Folding
Command foldCode, unfoldCode, foldAll, unfoldAll;

// Selection manipulation
Command selectAll, selectLine;
Command cursorMatchingBracket;
```

---

## 10. Theming

### 10.1 EditorTheme

```dart
class EditorTheme {
  // Editor chrome
  final Color background;
  final Color foreground;
  final Color gutterBackground;
  final Color gutterForeground;
  final Color gutterActiveForeground;
  final Color selectionBackground;
  final Color selectionForegroundMatch; // matching selection highlight
  final Color cursorColor;
  final double cursorWidth;
  final Color lineHighlight;           // active line background
  final Color foldPlaceholderForeground;

  // Syntax highlighting (tag → TextStyle map)
  final HighlightStyle highlightStyle;

  // Scrollbar
  final Color scrollbarThumb;
  final Color scrollbarTrack;

  // Search
  final Color searchMatchBackground;
  final Color searchActiveMatchBackground;

  // Bracket matching
  final Color matchingBracketBackground;
  final Color matchingBracketOutline;
}
```

### 10.2 DmDesignTokens Integration (external)

The adapter from `DmDesignTokens → EditorTheme` lives **outside** this package (in `duskmoon_theme` or the `duskmoon_ui` umbrella), keeping `duskmoon_code_engine` standalone:

```dart
// In duskmoon_theme or duskmoon_ui — NOT in duskmoon_code_engine
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart';

extension DmCodeTheme on DmDesignTokens {
  EditorTheme toEditorTheme() => EditorTheme(
    background: surface,
    foreground: onSurface,
    gutterBackground: surfaceContainerLow,
    gutterForeground: onSurfaceVariant,
    selectionBackground: primaryContainer,
    cursorColor: primary,
    lineHighlight: surfaceContainerHighest.withOpacity(0.5),
    highlightStyle: _buildHighlightStyle(),
    // ...
  );

  HighlightStyle _buildHighlightStyle() => HighlightStyle(
    keyword: TextStyle(color: primary, fontWeight: FontWeight.bold),
    string: TextStyle(color: tertiary),
    comment: TextStyle(color: onSurfaceVariant, fontStyle: FontStyle.italic),
    number: TextStyle(color: secondary),
    typeName: TextStyle(color: primary),
    function: TextStyle(color: onSurface),
    operator: TextStyle(color: onSurfaceVariant),
    // ... mapped from design tokens
  );
}
```

### 10.3 Default Themes

Two built-in themes that work without `duskmoon_theme`:

- `EditorTheme.light()` — sensible light theme with Material-adjacent colors
- `EditorTheme.dark()` — sensible dark theme

When `DmDesignTokens` is available, `toEditorTheme()` overrides these.

---

## 11. Public API Surface

### 11.1 Widget

```dart
class CodeEditorWidget extends StatefulWidget {
  const CodeEditorWidget({
    super.key,
    this.initialDoc,
    this.language,
    this.extensions = const [],
    this.theme,
    this.readOnly = false,
    this.lineNumbers = true,
    this.foldGutter = true,
    this.highlightActiveLine = true,
    this.bracketMatching = true,
    this.autocompletion = false,
    this.search = true,
    this.onStateChanged,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.minHeight,
    this.maxHeight,
    this.padding,
    this.scrollPhysics,
  });

  final String? initialDoc;
  final LanguageSupport? language;
  final List<Extension> extensions;
  final EditorTheme? theme;
  final bool readOnly;
  final bool lineNumbers;
  final bool foldGutter;
  final bool highlightActiveLine;
  final bool bracketMatching;
  final bool autocompletion;
  final bool search;
  final void Function(EditorState state)? onStateChanged;
  final EditorViewController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final double? minHeight;
  final double? maxHeight;
  final EdgeInsets? padding;
  final ScrollPhysics? scrollPhysics;
}
```

### 11.2 Controller

```dart
class EditorViewController {
  EditorView get view;
  EditorState get state;
  Document get document;
  String get text;

  /// Replace entire document.
  set text(String value);

  /// Switch language at runtime.
  set language(LanguageSupport lang);

  /// Switch theme at runtime.
  set theme(EditorTheme theme);

  /// Dispatch a transaction.
  void dispatch(TransactionSpec spec);

  /// Programmatic selection.
  void setSelection(EditorSelection selection);

  /// Insert text at cursor.
  void insertText(String text);

  /// Replace range.
  void replaceRange(int from, int to, String text);

  /// Focus.
  void focus();

  /// Dispose.
  void dispose();
}
```

---

## 12. Integration with Flutter Monorepo

### 12.1 Package Placement

```
flutter_duskmoon_ui/
├── packages/
│   ├── duskmoon_theme/            # design tokens
│   ├── duskmoon_theme_bloc/       # theme state management
│   ├── duskmoon_widgets/          # Material widgets
│   ├── duskmoon_settings/
│   ├── duskmoon_feedback/
│   ├── duskmoon_code_engine/      # ← THIS PACKAGE
│   │   ├── lib/
│   │   ├── test/
│   │   ├── tool/                  # grammar codegen scripts
│   │   │   └── grammar_to_dart.dart
│   │   ├── grammars/              # upstream .grammar source files
│   │   │   ├── dart.grammar
│   │   │   ├── javascript.grammar
│   │   │   └── ...
│   │   ├── pubspec.yaml
│   │   ├── analysis_options.yaml
│   │   └── README.md
│   └── duskmoon_ui/              # umbrella package
```

### 12.2 Dependencies

```yaml
# pubspec.yaml
name: duskmoon_code_engine
description: Pure Dart code editor engine with incremental parsing
version: 0.1.0

environment:
  sdk: ">=3.5.0 <4.0.0"
  flutter: ">=3.24.0"

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

**Zero external dependencies** beyond Flutter SDK. The package owns its own `EditorTheme` system. Integration with `DmDesignTokens` is provided by an adapter in `duskmoon_theme` or the `duskmoon_ui` umbrella — not in this package.

### 12.3 Melos Integration

```yaml
# melos.yaml addition
packages:
  - packages/duskmoon_code_engine

scripts:
  codegen:grammars:
    description: Compile Lezer grammars to Dart (local dev only — output committed to repo)
    run: |
      cd packages/duskmoon_code_engine
      dart run tool/grammar_to_dart.dart
```

---

## 13. Phasing

### Phase 1 — Foundation (blocks everything)

**Document model**: `Rope`, `Document`, `ChangeSet`, `Line`, `Position`
**State core**: `EditorState`, `Transaction`, `Facet`, `StateField`, `StateEffect`, `Compartment`, `EditorSelection`
**Deliverable**: Can create state, apply changes, read facets. No rendering.
**Test**: Unit tests for rope operations, changeset composition, facet resolution.

### Phase 2 — Lezer Runtime

**Port**: `@lezer/common` (Tree, TreeCursor, NodeType, NodeProp, Parser)
**Port**: `@lezer/lr` (LRParser, incremental parse stack, token cache)
**Port**: `@lezer/highlight` (Tag, HighlightStyle, classHighlighter)
**Isolate**: `ParseWorker`, `TreeSerializer`, `ParseScheduler` (two-tier orchestration)
**Grammar pipeline**: `grammar_to_dart.dart` codegen tool
**First grammars**: JSON (simplest), JavaScript, Dart, HTML+CSS (mixed)
**Deliverable**: Can parse a string → Tree, traverse nodes, get highlight spans. Background isolate handles initial parse of large files.
**Test**: Parse correctness (differential vs upstream), isolate round-trip fidelity, time-sliced budget compliance.

### Phase 3 — View Layer (MVP)

**Virtual viewport**: `EditorViewport`, `SliverEditorContent`
**Line rendering**: `LinePainter` with syntax highlight spans
**Gutter**: `SliverGutter` with line numbers
**Cursor + selection**: painting, blink animation
**Input**: `TextInputClient` adapter, physical keyboard handler
**Basic commands**: cursor movement, selection, insert, delete, clipboard
**History**: undo/redo
**Widget**: `CodeEditorWidget` with `EditorViewController`
**Deliverable**: Functional code editor — type, navigate, select, copy/paste, undo.
**Test**: Widget tests, golden tests for rendering.

### Phase 4 — Language Ecosystem

**Remaining grammars**: all 21 languages compiled + registered
**Mixed parsing**: HTML (CSS+JS), PHP (HTML), Markdown (fenced blocks)
**Indentation engine**: syntax-tree-based auto-indent
**Code folding**: syntax-tree-based fold detection + UI
**Bracket matching**: highlight matching brackets
**Comment toggling**: line + block comments per language
**Language registry**: lookup by name/extension/MIME
**Deliverable**: Full multi-language editor with folding and smart editing.

### Phase 5 — Advanced Features

**Search & replace**: search state, regex support, search panel overlay
**Autocomplete**: completion source interface, popup overlay
**Lint**: diagnostic source, gutter markers, inline squiggles
**Word wrap**: `HeightMap` for variable visual line heights
**Minimap**: scaled overview painter (optional)
**Multiple cursors**: multi-selection support in commands and rendering
**Vim/Emacs keybindings**: port from web code-engine keymaps

### Phase 6 — Polish & Integration

**Accessibility**: semantics tree for screen readers, high-contrast themes
**Performance**: profiling, paint optimization, parse budget tuning
**DmDesignTokens**: adapter extension in `duskmoon_theme` or umbrella (maps all 5 themes to EditorTheme)
**Diff view**: side-by-side and unified diff widget (separate from editor)
**Documentation**: dartdoc, example app, integration guide

---

## 14. Key Technical Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Lezer LR runtime port correctness | High — incorrect parsing breaks everything | Differential testing: parse same files with JS Lezer and Dart port, compare tree output |
| Grammar table codegen fidelity | High — wrong tables = wrong parse | Golden test: generated Dart tables must byte-match JSON intermediate |
| IME handling on all platforms | Medium — CJK input, composition | Test on iOS (Japanese), Android (Chinese), macOS (Korean) early in Phase 3 |
| Isolate tree transfer cost | Medium — serialization overhead on large trees | Binary format + TransferableTypedData for zero-copy; benchmark at 50K+ node trees |
| Isolate spawn latency | Low — ~5ms first spawn | Lazy spawn, keep worker alive for editor lifetime |
| Performance of rope on very large files | Medium — potential GC pressure | Benchmark at 100K, 500K, 1M lines; tune leaf size |
| CustomPainter repaint granularity | Medium — over-painting kills framerate | RepaintBoundary per visible line; dirty-flag per line on state change |
| Missing Lezer grammars (Erlang, Zig, Kotlin) | Low — grammars can be written | Opus writes `.grammar` files in loki mode; Elixir already exists in web code-engine repo |
| Flutter Web performance (canvas overhead) | Low — virtual rendering helps | Test on Chrome/Firefox; fall back to DOM-based rendering if needed |

---

## 15. Testing Strategy

### Unit Tests (Phase 1-2)

- Rope: splice, line lookup, slice at every boundary condition
- ChangeSet: compose, map position, invert
- Facet: resolution, precedence, computed facets
- EditorState: create, transaction, field updates
- LRParser: parse correctness vs upstream (differential)
- Tree: cursor traversal, node queries
- Highlight: tag resolution, style application

### Widget Tests (Phase 3+)

- CodeEditorWidget: renders, accepts focus, shows cursor
- Virtual viewport: correct lines materialized at scroll positions
- Selection: click, shift-click, drag, double-click word select
- Input: typing, delete, newline, tab
- Undo/redo: state restoration
- Language switch: syntax colors update
- Theme switch: editor colors update

### Golden Tests

- Rendered editor snapshots for each language grammar
- Cursor positions at line boundaries
- Selection painting across wrapped lines

### Integration Tests

- Large file (100K lines): scroll performance, parse time
- Rapid typing: no dropped frames
- IME composition: CJK input completes correctly

### Differential Tests (Lezer)

For each grammar, maintain a corpus of source files. Parse with both JS Lezer and Dart Lezer. Assert identical tree structure (node types, ranges). Run in CI.

---

## 16. Resolved Decisions

1. **`duskmoon_theme` dependency** — `duskmoon_code_engine` is fully standalone with its own `EditorTheme`. Zero dependency on `duskmoon_theme`. The `duskmoon_theme` package (or umbrella) provides an extension method to convert `DmDesignTokens → EditorTheme` — the adapter lives outside the code engine.

2. **Grammar codegen** — compiled Dart grammar files are committed to the repo. No Bun/Node required in CI. The `tool/grammar_to_dart.dart` script is run manually (or by Opus) when grammars are added/updated, and the generated `.dart` files are checked in.

3. **Minimum Flutter version** — `>=3.24.0` (Dart 3.5). Gives sealed classes, patterns, class modifiers, plus Dart 3.5 improvements.

4. **Umbrella re-export** — `duskmoon_ui` re-exports `duskmoon_code_engine`. Consumers can also import it directly.

5. **Elixir grammar** — the web `duskmoon-dev/code-engine` repo already has an Elixir Lezer grammar. Export it through the same `grammar_to_dart` pipeline — no need to write from scratch.

---

## 17. References

- [CodeMirror 6 System Guide](https://codemirror.net/docs/guide/)
- [Lezer Parser System](https://lezer.codemirror.net/)
- [CM6 Reference Manual](https://codemirror.net/docs/ref/)
- [`@duskmoon-dev/code-engine` PRD (web)](code-engine-fork-PRD.md) — sibling web package
- [Flutter `TextInputClient`](https://api.flutter.dev/flutter/services/TextInputClient-class.html)
- [Flutter Slivers](https://api.flutter.dev/flutter/widgets/CustomScrollView-class.html)