# Code Editor Engine

The `duskmoon_code_engine` package is a pure Dart code editor engine -- a ground-up port of the CodeMirror 6 architecture for Flutter. It provides an immutable document model, state management, incremental parsing with syntax highlighting, and an interactive editor widget. Zero external dependencies beyond Flutter.

## Table of Contents

- [Installation](#installation)
- [Quick Start](#quick-start)
- [CodeEditorWidget](#codeeditorwidget)
- [EditorViewController](#editorviewcontroller)
- [Document Model](#document-model)
- [State System](#state-system)
- [Language Support](#language-support)
- [Theming](#theming)
- [Syntax Highlighting](#syntax-highlighting)
- [Extension System](#extension-system)
- [Commands and Keybindings](#commands-and-keybindings)
- [Incremental Parser](#incremental-parser)
- [Complete Example](#complete-example)

## Installation

```yaml
dependencies:
  duskmoon_code_engine: ^1.4.0
```

```dart
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
```

The package is also re-exported by the umbrella `duskmoon_ui` package.

## Quick Start

Drop a code editor into any widget tree:

```dart
CodeEditorWidget(
  initialDoc: 'void main() {\n  print("Hello!");\n}\n',
  language: dartLanguageSupport(),
  theme: EditorTheme.dark(),
  lineNumbers: true,
)
```

This gives you a fully interactive editor with syntax highlighting, cursor movement, selection, undo/redo, and search (Ctrl+F).

## CodeEditorWidget

The main editor widget. Renders lines using `ListView.builder` for virtual scrolling and computes syntax highlighting per line from the current parse tree.

### Constructor

```dart
const CodeEditorWidget({
  String? initialDoc,
  LanguageSupport? language,
  List<Extension> extensions = const [],
  EditorTheme? theme,
  bool readOnly = false,
  bool lineNumbers = true,
  bool highlightActiveLine = true,
  void Function(EditorState state)? onStateChanged,
  EditorViewController? controller,
  FocusNode? focusNode,
  bool autofocus = false,
  double? minHeight,
  double? maxHeight,
  EdgeInsets? padding,
  ScrollPhysics? scrollPhysics,
})
```

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `initialDoc` | `String?` | `null` | Initial document text. Ignored when `controller` is provided |
| `language` | `LanguageSupport?` | `null` | Language for syntax highlighting |
| `extensions` | `List<Extension>` | `[]` | Additional editor extensions |
| `theme` | `EditorTheme?` | `EditorTheme.light()` | Visual theme |
| `readOnly` | `bool` | `false` | Disable user input |
| `lineNumbers` | `bool` | `true` | Show line number gutter |
| `highlightActiveLine` | `bool` | `true` | Highlight the cursor line |
| `onStateChanged` | `Function?` | `null` | Called on every state change |
| `controller` | `EditorViewController?` | `null` | External controller for programmatic access |
| `focusNode` | `FocusNode?` | `null` | External focus node |
| `autofocus` | `bool` | `false` | Focus immediately on mount |
| `minHeight` | `double?` | `null` | Minimum editor height |
| `maxHeight` | `double?` | `null` | Maximum editor height |
| `padding` | `EdgeInsets?` | `null` | Content area padding |
| `scrollPhysics` | `ScrollPhysics?` | `null` | Custom scroll physics |

### Built-in Keyboard Shortcuts

- **Ctrl+F** -- Toggle search panel
- **Escape** -- Close search panel
- Arrow keys, Home/End, Ctrl+Home/End -- Cursor navigation
- Shift+arrows -- Selection
- Ctrl+Z / Ctrl+Y -- Undo/redo (when `historyExtension()` is active)

## EditorViewController

Programmatic controller that wraps `EditorView` with convenience methods. Use it when you need to read or modify editor state from outside the widget.

```dart
final controller = EditorViewController(
  text: 'Hello, world!',
  language: dartLanguageSupport(),
  theme: EditorTheme.dark(),
  extensions: [historyExtension()],
);
```

### Reading State

```dart
controller.state;       // EditorState -- current immutable state
controller.document;    // Document -- current document
controller.text;        // String -- full document text
controller.theme;       // EditorTheme? -- current theme
```

### Modifying Content

```dart
// Replace entire document
controller.text = 'new content';

// Insert at cursor (replaces selection if any)
controller.insertText('inserted text');

// Replace a specific range
controller.replaceRange(0, 5, 'replacement');

// Move cursor or selection
controller.setSelection(EditorSelection.cursor(10));
controller.setSelection(EditorSelection.single(anchor: 5, head: 15));

// Switch language at runtime
controller.language = pythonLanguageSupport();

// Switch theme at runtime
controller.theme = EditorTheme.light();
```

### Dispatching Transactions

For fine-grained control, dispatch raw `TransactionSpec` values:

```dart
controller.dispatch(TransactionSpec(
  changes: ChangeSet.of(controller.document.length, [
    ChangeSpec(from: 0, to: 5, insert: 'Hi'),
  ]),
  selection: EditorSelection.cursor(2),
));
```

### Lifecycle

```dart
// Pass to widget
CodeEditorWidget(controller: controller, ...)

// Dispose when done
controller.dispose();
```

## Document Model

### Document

Immutable document backed by a rope data structure. Every edit produces a new `Document` instance.

```dart
final doc = Document.fromString('line one\nline two\nline three');

doc.length;             // Total character count
doc.lineCount;          // Number of lines
doc.lineAt(1);          // Line at line number 1 (1-based)
doc.lineAtOffset(5);    // Line containing character offset 5
doc.sliceString(0, 8);  // 'line one'
doc.toString();         // Full document text
doc.linesInRange(1, 3); // Iterable<Line> for lines 1-3

// The empty document
Document.empty;
```

### Line

Each `Line` has:

| Property | Type | Description |
|----------|------|-------------|
| `number` | `int` | 1-based line number |
| `from` | `int` | Character offset of line start |
| `to` | `int` | Character offset of line end (excludes newline) |
| `text` | `String` | Line content |
| `length` | `int` | Character count of line content |

### ChangeSpec

A single edit operation: replace `[from, to)` with `insert`.

```dart
// Replacement
ChangeSpec(from: 0, to: 5, insert: 'Hello')

// Pure insertion
ChangeSpec(from: 10, to: 10, insert: ' world')
ChangeSpec.insert(10, ' world')  // Convenience constructor

// Pure deletion
ChangeSpec(from: 0, to: 5)
```

### ChangeSet

An immutable, composable representation of one or more edits.

```dart
// Build from specs (must be sorted by position, non-overlapping)
final changes = ChangeSet.of(doc.length, [
  ChangeSpec(from: 0, to: 5, insert: 'Hello'),
  ChangeSpec(from: 10, to: 10, insert: '!'),
]);

changes.oldLength;          // Original document length
changes.newLength;          // New document length
changes.docChanged;         // Whether any content changed
changes.mapPos(8);          // Map old-doc position to new-doc position
changes.mapPos(8, assoc: -1); // Map before inserted text (default is after)
changes.compose(other);     // Combine two sequential changesets
changes.invert(rope);       // Create inverse for undo
```

## State System

### EditorState

Immutable state snapshot holding the document, selection, facet values, and state field values.

```dart
// Create initial state
final state = EditorState.create(
  docString: 'Hello, world!',
  selection: EditorSelection.cursor(0),
  extensions: [
    dartLanguageSupport().extension,
    historyExtension(),
  ],
);

// Or from an existing Document
final state2 = EditorState.create(
  doc: Document.fromString('Hello'),
);

// Access state
state.doc;                // Document
state.selection;          // EditorSelection
state.facet(someFacet);   // Read facet value
state.field(someField);   // Read state field value
```

### Transaction and TransactionSpec

State transitions are described by `TransactionSpec` and applied through `Transaction`.

```dart
// Describe a change
final spec = TransactionSpec(
  changes: ChangeSet.of(state.doc.length, [
    ChangeSpec(from: 0, to: 5, insert: 'Hi'),
  ]),
  selection: EditorSelection.cursor(2),
  scrollIntoView: true,
);

// Apply to get a transaction
final tr = state.update(spec);

// Access results
tr.startState;       // State before
tr.state;            // State after (lazily computed)
tr.docChanged;       // true if document was modified
tr.selectionChanged; // true if selection changed
```

### EditorSelection

Supports single and multi-cursor selection.

```dart
// Cursor at position 10
EditorSelection.cursor(10)

// Selection from position 5 to 15
EditorSelection.single(anchor: 5, head: 15)

// Multi-cursor
EditorSelection(ranges: [
  SelectionRange.cursor(10),
  SelectionRange(anchor: 20, head: 30),
], mainIndex: 0)

// Access
selection.main;        // Primary SelectionRange
selection.ranges;      // All ranges
selection.main.anchor; // Anchor position
selection.main.head;   // Head (cursor) position
selection.main.from;   // min(anchor, head)
selection.main.to;     // max(anchor, head)
selection.main.isEmpty; // true if collapsed
```

## Language Support

19 built-in language grammars. Each factory function returns a `LanguageSupport` instance.

| Language | Factory Function |
|----------|-----------------|
| Dart | `dartLanguageSupport()` |
| JavaScript / TypeScript | `javascriptLanguageSupport()` |
| Python | `pythonLanguageSupport()` |
| HTML | `htmlLanguageSupport()` |
| CSS | `cssLanguageSupport()` |
| JSON | `jsonLanguageSupport()` |
| Markdown | `markdownLanguageSupport()` |
| Rust | `rustLanguageSupport()` |
| Go | `goLanguageSupport()` |
| YAML | `yamlLanguageSupport()` |
| C / C++ | `cLanguageSupport()` |
| Elixir | `elixirLanguageSupport()` |
| Java | `javaLanguageSupport()` |
| Kotlin | `kotlinLanguageSupport()` |
| PHP | `phpLanguageSupport()` |
| Ruby | `rubyLanguageSupport()` |
| Erlang | `erlangLanguageSupport()` |
| Swift | `swiftLanguageSupport()` |
| Zig | `zigLanguageSupport()` |

### Using a Language

```dart
CodeEditorWidget(
  initialDoc: 'fn main() { println!("Hello"); }',
  language: rustLanguageSupport(),
)
```

### LanguageRegistry

Dynamic language lookup by name, file extension, or MIME type.

```dart
final lang = LanguageRegistry.byName('dart');
final lang2 = LanguageRegistry.byExtension('.py');
final lang3 = LanguageRegistry.byMimeType('application/json');
final allNames = LanguageRegistry.names; // List<String>
```

### StreamLanguage -- Simple Token-Based Languages

For languages that can be tokenized with regular expressions:

```dart
final myLang = StreamLanguage([
  TokenRule(RegExp(r'//.*'), Tag.lineComment),
  TokenRule(RegExp(r'"[^"]*"'), Tag.string),
  TokenRule(RegExp(r'\b(if|else|while|for|return)\b'), Tag.keyword),
  TokenRule(RegExp(r'\d+'), Tag.number),
]);
```

### Language / LanguageSupport Classes

```dart
// Language wraps a parser and metadata
Language(
  name: 'myLang',
  parser: myParser,         // Parser instance
  data: LanguageData(       // Optional metadata
    commentTokens: CommentTokens(line: '//', block: BlockComment('/*', '*/')),
  ),
)

// LanguageSupport bundles a Language with additional Extensions
LanguageSupport(
  language: myLanguage,
  support: [additionalExtension], // Extra extensions for the language
)
```

## Theming

### EditorTheme

Controls all visual aspects of the editor.

```dart
// Built-in themes
EditorTheme.light()  // Light background, dark text
EditorTheme.dark()   // Dark background, light text
```

### EditorTheme Properties

| Property | Type | Description |
|----------|------|-------------|
| `background` | `Color` | Editor background |
| `foreground` | `Color` | Default text color |
| `gutterBackground` | `Color` | Line number gutter background |
| `gutterForeground` | `Color` | Line number color |
| `gutterActiveForeground` | `Color` | Active line number color |
| `selectionBackground` | `Color` | Text selection highlight |
| `cursorColor` | `Color` | Cursor color |
| `cursorWidth` | `double` | Cursor width (default 2.0) |
| `lineHighlight` | `Color` | Active line background |
| `highlightStyle` | `HighlightStyle` | Syntax highlight colors |
| `searchMatchBackground` | `Color` | Search match highlight |
| `searchActiveMatchBackground` | `Color` | Active search match |
| `matchingBracketBackground` | `Color` | Matching bracket highlight |
| `matchingBracketOutline` | `Color` | Matching bracket outline |
| `scrollbarThumb` | `Color` | Scrollbar thumb |
| `scrollbarTrack` | `Color` | Scrollbar track |

### Custom Theme

```dart
final myTheme = EditorTheme(
  background: const Color(0xFF282C34),
  foreground: const Color(0xFFABB2BF),
  gutterBackground: const Color(0xFF282C34),
  gutterForeground: const Color(0xFF636D83),
  gutterActiveForeground: const Color(0xFFABB2BF),
  selectionBackground: const Color(0xFF3E4451),
  cursorColor: const Color(0xFF528BFF),
  cursorWidth: 2.0,
  lineHighlight: const Color(0x0AFFFFFF),
  searchMatchBackground: const Color(0x55FFCC00),
  searchActiveMatchBackground: const Color(0xAAFFCC00),
  matchingBracketBackground: const Color(0x3300CC00),
  matchingBracketOutline: const Color(0xFF00CC00),
  scrollbarThumb: const Color(0x33FFFFFF),
  scrollbarTrack: const Color(0x0AFFFFFF),
  highlightStyle: myHighlightStyle,
);
```

## Syntax Highlighting

### Tag System

Tags form a hierarchy. When resolving styles, the `HighlightStyle` walks up the parent chain to find a matching style.

Key tag categories:

| Category | Tags |
|----------|------|
| Comments | `Tag.comment`, `Tag.lineComment`, `Tag.blockComment` |
| Names | `Tag.name_`, `Tag.variableName`, `Tag.typeName`, `Tag.propertyName`, `Tag.className`, `Tag.namespace` |
| Literals | `Tag.literal`, `Tag.string`, `Tag.number`, `Tag.integer`, `Tag.float`, `Tag.bool_`, `Tag.null_`, `Tag.regexp`, `Tag.escape` |
| Keywords | `Tag.keyword`, `Tag.self_`, `Tag.controlKeyword`, `Tag.definitionKeyword`, `Tag.moduleKeyword`, `Tag.operatorKeyword` |
| Functions | `Tag.function_` |
| Operators | `Tag.operator_` |
| Punctuation | `Tag.punctuation`, `Tag.paren`, `Tag.brace`, `Tag.squareBracket`, `Tag.angleBracket`, `Tag.separator` |
| Content | `Tag.heading`, `Tag.emphasis`, `Tag.strong`, `Tag.link`, `Tag.strikethrough` |
| Meta | `Tag.meta`, `Tag.annotation_` |

### HighlightStyle and TagStyle

```dart
// Define syntax colors with TagStyle pairs
final oneDarkHighlight = HighlightStyle([
  TagStyle(Tag.keyword, TextStyle(color: Color(0xFFC678DD))),
  TagStyle(Tag.string, TextStyle(color: Color(0xFF98C379))),
  TagStyle(Tag.comment, TextStyle(color: Color(0xFF5C6370), fontStyle: FontStyle.italic)),
  TagStyle(Tag.number, TextStyle(color: Color(0xFFD19A66))),
  TagStyle(Tag.typeName, TextStyle(color: Color(0xFFE5C07B))),
  TagStyle(Tag.function_, TextStyle(color: Color(0xFF61AFEF))),
  TagStyle(Tag.variableName, TextStyle(color: Color(0xFFE06C75))),
  TagStyle(Tag.operator_, TextStyle(color: Color(0xFF56B6C2))),
]);

// Resolve a style for a specific tag
final style = oneDarkHighlight.style(Tag.lineComment);
// Falls back to Tag.comment style if lineComment is not defined
```

### Default Highlight Styles

Two pre-built highlight styles are provided:

```dart
defaultLightHighlight  // VS Code light-inspired colors
defaultDarkHighlight   // VS Code dark-inspired colors
```

These are automatically used by `EditorTheme.light()` and `EditorTheme.dark()`.

## Extension System

The editor is configured entirely through extensions. All configuration -- languages, keymaps, state fields, facets -- is expressed as `Extension` values.

### Extension Types

`Extension` is a sealed class with these subtypes:

| Type | Description |
|------|-------------|
| `StateField<T>` | Per-state value computed on creation, updated on each transaction |
| `Facet<Input, Output>` | Aggregated configuration value from multiple providers |
| `ExtensionGroup` | Bundle multiple extensions together |
| `PrecedenceExtension` | Wrap with priority ordering |
| `CompartmentExtension` | Dynamically reconfigurable slot |

### StateField

```dart
final wordCountField = StateField<int>(
  create: (state) => state.doc.toString().split(' ').length,
  update: (transaction, value) {
    if (!transaction.docChanged) return value;
    return transaction.state.doc.toString().split(' ').length;
  },
);

// Use as extension
CodeEditorWidget(
  extensions: [wordCountField],
  ...
)

// Read value from state
final count = state.field(wordCountField);
```

### Precedence

Control extension ordering:

```dart
prec(Precedence.override_, myExtension)  // Highest priority
prec(Precedence.extend, myExtension)
prec(Precedence.base, myExtension)
prec(Precedence.fallback, myExtension)   // Lowest priority
```

### Grouping

```dart
ExtensionGroup([
  historyExtension(),
  dartLanguageSupport().extension,
  myCustomExtension,
])
```

## Commands and Keybindings

### EditorCommands

Static methods that produce `TransactionSpec` values. Each returns `null` if the command cannot execute in the current state.

**Cursor movement:**
`cursorCharRight`, `cursorCharLeft`, `cursorLineDown`, `cursorLineUp`, `cursorLineStart`, `cursorLineEnd`, `cursorDocStart`, `cursorDocEnd`, `cursorWordRight`, `cursorWordLeft`

**Selection:**
`selectCharRight`, `selectCharLeft`, `selectWordRight`, `selectWordLeft`, `selectAll`

**Editing:**
`insertText`, `insertNewline`, `insertTab`, `deleteCharBackward`, `deleteCharForward`, `deleteSelection`, `deleteWordBackward`, `deleteWordForward`

**Line operations:**
`deleteLine`, `duplicateLine`, `moveLineUp`, `moveLineDown`

**History:**
`undo`, `redo` (requires `historyExtension()`)

### Usage

```dart
final spec = EditorCommands.cursorCharRight(state);
if (spec != null) {
  controller.dispatch(spec);
}
```

### Keymap

```dart
// The default keymap is auto-applied by CodeEditorWidget
final keymap = defaultKeymap();

// Custom key bindings
KeyBinding(
  key: LogicalKeyboardKey.keyS,
  ctrl: true,
  run: (view) {
    // Custom save handler
    return true; // handled
  },
)
```

### History Extension

Enable undo/redo support:

```dart
CodeEditorWidget(
  extensions: [historyExtension()],
  ...
)
```

## Incremental Parser

The editor uses a Lezer-based incremental parser. Language grammars compile to `GrammarData` consumed by `LRParser`.

### LRParser

```dart
final parser = LRParser(grammarData);
final tree = parser.parse('let x = 42;');
```

### Syntax Tree Access

```dart
// From editor state
final tree = syntaxTree(state);             // Tree?
final available = syntaxTreeAvailable(state); // bool
```

### Walking the Tree

```dart
final cursor = tree?.cursor();
if (cursor != null) {
  while (cursor.next()) {
    print('${cursor.type.name}: offset ${cursor.from}-${cursor.to}');
  }
}
```

### Key Parser Types

| Type | Description |
|------|-------------|
| `LRParser` | LR parsing engine |
| `GrammarData` | Compiled grammar tables |
| `Tree` | Immutable parse tree |
| `SyntaxNode` | Node in the tree with type, from, to |
| `TreeCursor` | Efficient tree traversal |
| `NodeType` | Type descriptor for syntax nodes |
| `NodeProp` | Typed property on node types |

## Complete Example

A full-featured code editor page with language switching:

```dart
import 'package:flutter/material.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

class CodeEditorPage extends StatefulWidget {
  const CodeEditorPage({super.key});

  @override
  State<CodeEditorPage> createState() => _CodeEditorPageState();
}

class _CodeEditorPageState extends State<CodeEditorPage> {
  late final EditorViewController _controller;
  String _selectedLang = 'dart';

  static const _sampleCode = {
    'dart': 'void main() {\n  print("Hello, Dart!");\n}\n',
    'python': 'def main():\n    print("Hello, Python!")\n\nmain()\n',
    'rust': 'fn main() {\n    println!("Hello, Rust!");\n}\n',
    'javascript': 'function main() {\n  console.log("Hello, JS!");\n}\nmain();\n',
  };

  static final _languages = {
    'dart': dartLanguageSupport(),
    'python': pythonLanguageSupport(),
    'rust': rustLanguageSupport(),
    'javascript': javascriptLanguageSupport(),
  };

  @override
  void initState() {
    super.initState();
    _controller = EditorViewController(
      text: _sampleCode['dart']!,
      language: _languages['dart'],
      theme: EditorTheme.dark(),
      extensions: [historyExtension()],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _switchLanguage(String lang) {
    setState(() => _selectedLang = lang);
    _controller.language = _languages[lang];
    _controller.text = _sampleCode[lang]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Editor'),
        actions: [
          DropdownButton<String>(
            value: _selectedLang,
            items: _languages.keys
                .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                .toList(),
            onChanged: (v) => _switchLanguage(v!),
          ),
        ],
      ),
      body: CodeEditorWidget(
        controller: _controller,
        lineNumbers: true,
        highlightActiveLine: true,
        autofocus: true,
        onStateChanged: (state) {
          // e.g., update line/column display
        },
      ),
    );
  }
}
```
