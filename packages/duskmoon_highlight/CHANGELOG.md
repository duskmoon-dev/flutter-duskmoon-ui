## Unreleased

- Support both native asset hook API generations so applications can use
  `sqlite_vector` 1.1.2 alongside DuskMoon without dependency overrides.

## 2.2.5

- Release 2.2.5 (2026-10-26)

## 2.2.4

- Keep generated native C files out of build-hook dependencies so unchanged
  checkout and hosted builds can reuse the compiled grammar bundle. Manifest,
  parser archives, scanner/runtime headers and native sources remain tracked.

## 2.2.3

- Release 2.2.3 (2026-10-21)

## 2.2.2

- Release 2.2.2 (2026-10-21)

## 2.2.1

- Release 2.2.1 (2026-10-20)

## 2.2.0

- Release 2.2.0 (2026-10-20)

## 2.1.1

- Compress bundled parser C sources in hosted archives to fit Pub's 256 MiB
  unpacked size limit while retaining all 95 grammars, sources and licenses.
- Unpack native parser sources into the build output before compilation.

## 2.1.0

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
