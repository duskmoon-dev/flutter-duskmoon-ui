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
- highlight.js 11.9.0 grammar/style source and markup fixtures: BSD-3-Clause,
  https://github.com/highlightjs/highlight.js/tree/11.9.0.
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

See `README.md` for exact generation and validation commands.
