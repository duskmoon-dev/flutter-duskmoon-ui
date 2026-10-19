# Source provenance

Imported from the published `re_highlight` **0.0.3** archive, published 2024-02-05.

- Package: https://pub.dev/packages/re_highlight/versions/0.0.3
- Archive: https://pub.dev/api/archives/re_highlight-0.0.3.tar.gz
- SHA-256: `6c4ac3f76f939fb7ca9df013df98526634e17d8f7460e028bd23a035870024f2`
- Repository: https://github.com/reqable/re-highlight

The archive SHA-256 was verified against the pub.dev API, then every retained
cached source file was compared byte-for-byte with that archive before changes.
This is a maintained source fork, with no runtime dependency on re_highlight.

## Included upstream components

- re_highlight 0.0.3 parser/generators: MIT, original notice in `LICENSE`.
- highlight.js 11.12.0 grammar/style source and markup fixtures: BSD-3-Clause,
  https://github.com/highlightjs/highlight.js/tree/f7f7d3803bd898e37c017ffb881317f0cde04a70.
  Verified source archive: https://codeload.github.com/highlightjs/highlight.js/tar.gz/f7f7d3803bd898e37c017ffb881317f0cde04a70;
  SHA-256: `a1d99a617edfefc7c663804564ee88b361e9c71f88392d80fb2679e1b7db5189`.
- highlightjs-vue 1.0.0 grammar: BSD-3-Clause,
  https://github.com/highlightjs/highlightjs-vue.
- highlightjs-GN 0.1.0 grammar: MIT,
  https://github.com/highlightjs/highlightjs-GN.

Component license texts are retained in `THIRD_PARTY_LICENSES`, including in Pub
packages. `THIRD_PARTY_NOTICES` preserves individual grammar/theme attribution
and license comments. Kimbie and NNFX themes retain their upstream CC BY-SA 4.0
license, whose full text is retained in `CC-BY-SA-4.0.txt`; other theme-specific
notices, including Night Owl/Nord MIT notices, also remain intact. The CC license
text was obtained from the SPDX license-list-data repository:
https://github.com/spdx/license-list-data/blob/main/text/CC-BY-SA-4.0.txt. Individual vendor license files are also retained in the repository.
Theme-specific attribution comments also remain in the original CSS source files.
The Pub archive omits maintenance tools, vendor input and tests, while retaining
this provenance, all root license/notice files, and all generated Dart runtime source.

## Local modifications

- Rename package imports, facade and library/part identifiers to duskmoon_highlight.
- Format Dart source using the workspace Dart formatter; annotate private regex
  matcher string parameters/void return and use Flutter super parameters.
- Add workspace-compatible package metadata and local analysis configuration.
- Rename the upstream alias test to `register_alias_test.dart` so test discovery
  executes it. Keep API/parser tests and all markup fixtures; omit example apps and the upstream
  auto-detection test whose fixture path points at a nonexistent `highlightjs`
  directory (it silently returned for every language). Its meaningful compile-all-
  grammars coverage is retained in the owned `test/maintenance_test.dart`.
- Pin Node generator dependencies and generate grammars/themes from retained
  vendor source, with deterministic ordering and the renamed Dart facade. Mark
  retained HighlightJS source as ES modules for Node import and regenerate a
  publishable attribution inventory alongside the Dart output.

- Replace deprecated circular-json with typed graph references, preserving shared
  modes/cycles while keeping literal tilde/escape strings distinct from references.
- Synchronize HighlightJS helper/runtime inputs to 11.12.0 and port its G-code
  letter-boundary callback to Dart. Retain every upstream markup fixture.
- Add `.js` to the JSON grammar's `./lib/ecmascript` import for Node ESM loading;
  retained source otherwise matches the verified archive, except the documented
  `src/package.json` module marker. Prefix digit-leading theme identifiers with
  `theme` so new upstream theme names remain valid public Dart identifiers.
- Pin generation formatting to Dart language version 3.6 for reproducibility.

See `README.md` for exact generation and validation commands.
