## 2.2.6

- Release 2.2.6 (2026-10-28)

## 2.2.5

- Release 2.2.5 (2026-10-26)

## 2.2.4

- Disconnect focused IME input immediately when `readOnly` becomes true and
  reconnect the current document when editing resumes. Reject queued updates
  after an input handler is detached or closed.
- Show the mobile software keyboard for editable focus and touch, including
  retapping after keyboard dismissal, while preserving read-only focus.
- Reconcile input connections when the controller or focus node changes.

## 2.2.3

- Release 2.2.3 (2026-10-21)

## 2.2.2

- Release 2.2.2 (2026-10-21)

## 2.2.1

- Release 2.2.1 (2026-10-20)

## 2.2.0

- Release 2.2.0 (2026-10-20)

## 2.1.1

- Release 2.1.1 (2026-10-19)

## 2.1.0

- Replace Lezer/regex parsing with the shared official Tree-sitter runtime.
- Use per-editor sessions and immutable syntax snapshots; initialize browser
  grammar assets automatically and preserve edits made during initialization.
- Add distinct JSX, TypeScript, TSX and C++ support plus the shared grammar registry.
- Remove Lezer types, StreamLanguage and the old grammar generator; retain owned
  style tags. Require Dart 3.10 / Flutter 3.38.

## 2.0.0

- Pin Lezer generation dependencies and add a reproducible lockfile.
- Correct grammar metadata export and verify that generated Dart compiles and
  preserves node properties, token precedence and 32-bit states.
- `GrammarData.states` now uses `Uint32List`; direct callers must update their
  constructor arguments. `LRParser.deserialize` keeps its `List<int>` inputs.
- Align declared SDK requirements. The LR runtime remains a JSON tokenizer;
  generated metadata does not yet enable arbitrary Lezer grammar parsing.

## 1.12.0

- Release 1.12.0 (2026-10-17)

## 1.11.1

- Release 1.11.1 (2026-10-09)

## 1.11.0

- Release 1.11.0 (2026-10-09)

## 1.10.1

- Release 1.10.1 (2026-10-09)

## 1.10.0

- Release 1.10.0 (2026-10-07)

## 1.9.2

- Release 1.9.2 (2026-10-07)

## 1.9.1

- Release 1.9.1 (2026-10-06)

## 1.9.0

- Release 1.9.0 (2026-10-05)

## 1.8.0

- Release 1.8.0 (2026-07-17)

## 1.7.1

- Release 1.7.1 (2026-07-08)

## 1.7.0

- Release 1.7.0 (2026-06-29)

## 1.6.2

- Release 1.6.2 (2026-06-18)

## 1.6.1

- Release 1.6.1 (2026-06-16)

## 1.6.0

- Release 1.6.0 (2026-04-28)

## 1.5.0

- Release 1.5.0 (2026-04-13)

## 1.4.4

- Release 1.4.4 (2026-04-13)

## 1.4.3

- Release 1.4.3 (2026-04-12)

## 1.4.2

- Release 1.4.2 (2026-04-11)

## 1.4.1

- Release 1.4.1 (2026-04-10)

## 1.4.0

- Release 1.4.0 (2026-04-08)

## 1.3.0

- Release 1.3.0 (2026-04-08)

## 1.2.3

- Release 1.2.3 (2026-04-07)

## 1.2.2

- Release 1.2.2 (2026-04-07)

## 1.2.1

- Release 1.2.1 (2026-04-07)

## 0.1.0

- Initial release
- Rope-based document model with incremental updates
- Immutable editor state system (EditorState, Transaction, Selection, Facet, Extension)
- Incremental Lezer parser (LRParser, SyntaxNode, TreeCursor)
- Tag-based syntax highlighting
- 19 language grammars: Dart, JS/TS, Python, HTML, CSS, JSON, Markdown, Rust, Go, YAML, C/C++, Elixir, Java, Kotlin, PHP, Ruby, Erlang, Swift, Zig
- Built-in commands: undo/redo, bracket matching, comment toggling, code folding, search & replace, clipboard
- CodeEditorWidget with virtual scrolling, gutter, selection painting, cursor blinking, search panel
