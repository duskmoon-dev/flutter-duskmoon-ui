## Unreleased

- Replace the Highlight.js-derived regex runtime with official Tree-sitter 0.27.1.
- Bundle 95 pinned native/Wasm grammars, structural queries, sources and licenses.
- Add per-session incremental parsing and immutable UTF-16 syntax snapshots.
- Remove legacy Highlight/Mode, generated languages/themes and Node tooling APIs.
- Require Dart 3.10 / Flutter 3.38 and a native C/C++ toolchain for native builds.

## 2.0.0

- Sync HighlightJS 11.12.0, 195 languages, updated themes and upstream fixtures.
- Upgrade generation tools and replace deprecated circular-json with tested graph
  normalization.
- Align declared Dart and Flutter SDK requirements with package dependencies.

## 1.12.0

- Import the re_highlight 0.0.3 parser, 194 grammars and token themes for DuskMoon maintenance.
- Preserve component MIT/BSD licenses and individual theme licenses and attribution.
- Retain upstream parser/API and markup tests, grammar/theme source and regeneration tools.
- Rename public imports to duskmoon_highlight and pin regeneration dependencies.
