# duskmoon_code_engine

[![pub package](https://img.shields.io/pub/v/duskmoon_code_engine.svg)](https://pub.dev/packages/duskmoon_code_engine)

A pure Dart code editor engine for Flutter — a ground-up port of the [CodeMirror 6](https://codemirror.net/) architecture. Zero external dependencies beyond Flutter.

## Features

- **Rope-based document model** — efficient incremental text updates
- **Immutable state system** — `EditorState`, `Transaction`, `Selection`, `Facet`, `Extension`
- **Incremental Lezer parser** — `LRParser`, `SyntaxNode`, `TreeCursor`
- **Tag-based syntax highlighting** — `Tag`, `HighlightStyle`, `TagStyle`
- **19 language grammars** — Dart, JavaScript, TypeScript, Python, HTML, CSS, JSON, Markdown, Rust, Go, YAML, C, C++, Elixir, Java, Kotlin, PHP, Ruby, Erlang, Swift, Zig
- **Built-in commands** — undo/redo, bracket matching, comment toggling, code folding, search & replace, clipboard
- **Flutter widget** — `CodeEditorWidget` with virtual scrolling, gutter, selection painting, cursor blinking, search panel

## Getting Started

```dart
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

CodeEditorWidget(
  initialCode: 'void main() => print("Hello!");',
  language: 'dart',
  theme: HighlightStyle.defaultStyle(),
);
```

## Supported Languages

Dart, JavaScript, TypeScript, Python, HTML, CSS, JSON, Markdown, Rust, Go, YAML, C, C++, Elixir, Java, Kotlin, PHP, Ruby, Erlang, Swift, Zig.

## License

MIT
