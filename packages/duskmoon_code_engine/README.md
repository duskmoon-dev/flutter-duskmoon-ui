# duskmoon_code_engine

[![pub package](https://img.shields.io/pub/v/duskmoon_code_engine.svg)](https://pub.dev/packages/duskmoon_code_engine)

A Flutter code editor with an immutable document/state model and official
Tree-sitter incremental parsing, provided by `duskmoon_highlight`.

## Features

- Rope-based document model and immutable transactions, selections and facets.
- Per-editor Tree-sitter sessions with immutable UTF-16 syntax snapshots.
- Bundled grammars, including distinct JavaScript/JSX, TypeScript/TSX and C/C++ support.
- Owned `Tag`, `HighlightStyle` and `TagStyle` syntax colors.
- Undo/redo, bracket matching, comments, folding, search, selection and clipboard commands.
- Virtual scrolling, gutters, selection painting and an interactive Flutter widget.

## Getting started

```dart
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

CodeEditorWidget(
  initialDoc: 'void main() => print("Hello!");',
  language: dartLanguageSupport(),
  theme: EditorTheme.dark(),
);
```

Widgets and `EditorViewController` automatically initialize web grammar assets.
Await `controller.ready` when programmatic work requires syntax to be available.
Edits made during loading are retained and parsed when initialization completes.

Use a named factory such as `typescriptLanguageSupport()`, `tsxLanguageSupport()`
or `cppLanguageSupport()`, or `treeSitterLanguageSupport('bash')` for any grammar
in the [shared inventory](../duskmoon_highlight/LANGUAGES.md).

Raw `EditorState` users on web should await `support.ensureInitialized()` before
creating the state, or retain the new state returned by
`await ensureSyntaxTree(state)`. Read its immutable snapshot with
`syntaxTree(state)` and release resources with `disposeSyntax(state)`.
Controllers and widgets dispose their sessions automatically.

## Migration

Requires Dart 3.10 / Flutter 3.38 and a native C/C++ build toolchain. Browser
builds use bundled same-origin WebAssembly assets, with no CDN/index.html setup.
The Lezer/regex parser APIs (`GrammarData`, `LRParser`, `Tree`, `TreeCursor`,
`NodeType`, `NodeProp`, `StreamLanguage`, `TokenRule`) and generator are removed.
`Language` now takes a bundled Tree-sitter name and optional editor metadata.
`SyntaxSnapshot.rootNode` exposes copied nodes with `type`, `from`, `to` and
`children`; offsets are UTF-16. Custom style tags remain supported.

The [code engine guide](../../docs/code-engine.md) describes the editor APIs.
See the [runtime guide](../duskmoon_highlight/README.md) for query/injection limits
and source maintenance.

## License

MIT. Tree-sitter and grammar license notices ship with `duskmoon_highlight`.
