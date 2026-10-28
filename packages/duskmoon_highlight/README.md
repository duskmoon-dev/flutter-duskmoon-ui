# DuskMoon Highlight

Official Tree-sitter parsing for Flutter Markdown and code editors. The package
bundles 95 pinned grammars with source, highlight queries and licenses. Native
build hooks compile the official Tree-sitter 0.27.1 C runtime; browser builds use
the official web-tree-sitter 0.27.1 module and WebAssembly assets. Browser assets
are loaded from the application's own package asset bundle.

Requires Dart 3.10 / Flutter 3.38 or newer and a native C/C++ toolchain when
building native apps. No grammar downloads, CDN configuration or `index.html`
changes are required by consumers. JavaScript and Flutter Wasm builds use the
same grammar assets.

The native build hook supports both the `hooks` 1.x and 2.x dependency families.
Applications using `sqlite_vector` 1.1.2 can resolve its `hooks` 1.x and
`code_assets` 1.0 requirements without dependency overrides. Other applications
can continue using the newer native toolchain; Pub selects compatible versions.

```dart
import 'package:duskmoon_highlight/tree_sitter.dart';

await TreeSitterRuntime.ensureInitialized(languages: {'dart'});
final parser = TreeSitterSession(language: 'dart');
try {
  final first = parser.parse('final answer = 42;');
  final edited = parser.parse('final answer = 43;'); // Incremental parse.
  for (final capture in edited.captures) {
    print('${capture.name}: ${edited.source.substring(capture.from, capture.to)}');
  }
} finally {
  parser.dispose();
}
```

All offsets count UTF-16 code units, matching Dart strings. Each session owns
its mutable parser and previous tree; returned syntax snapshots are immutable
and survive edits and disposal. Share runtime initialization, create a separate
session for each editor, and dispose it when closed.

`TreeSitterRuntime.languages` lists the shipped grammars. `resolveLanguage`
accepts case-insensitive canonical names and aliases, including `js`, `jsx`,
`py`, `sh`, `ts`, `tsx` and `c++`. HTML/XML, JavaScript/TypeScript/TSX and C/C++
have distinct grammars. An unknown language resolves to `null`; callers can
render its original text without highlighting. See [LANGUAGES.md](LANGUAGES.md)
for the complete inventory and migration coverage.

Highlighting uses structural queries and supported text predicates. Local-scope
analysis and embedded-language injection are not implemented; for example, a
Vue block highlights its outer grammar without recursively parsing script/style
contents. Query omissions and transformations are recorded in `grammars.json`.

## Migration from the previous parser

The `Highlight`, `Mode`, `HighlightRenderer` and generated `languages/` / `styles/`
APIs have been removed. Use `TreeSitterSession`, `SyntaxSnapshot` and its captures.
There is no automatic language detection. Markdown and editor widgets load their
web grammars automatically; direct runtime callers must await initialization.
The primary package entrypoint also exports the Tree-sitter API.

## Maintenance

[Source provenance](SOURCE.md), `grammars.json`, `THIRD_PARTY_NOTICES` and
`THIRD_PARTY_LICENSES` record exact revisions, source archive hashes, local
patches and license texts. Native runtime and grammar source is included in
published packages because hosted consumers compile it through the build hook.
Generated parser C files are stored as deterministic gzip files in hosted
packages and unpacked into the build output before compilation. Raw sources
remain in this repository; no network access is needed to unpack them.
The hook tracks the manifest and original parser, scanner, runtime and bridge
inputs. Generated parser and language-dispatch C files stay build outputs, so
unchanged subsequent builds can reuse the native bundle.

From the workspace root, check both checkout and hosted-archive dependency
contracts with a small C/C++ fixture without compiling all 95 grammars:

```sh
dart --packages=.dart_tool/package_config.json packages/duskmoon_highlight/tool/check_build_hook.dart
```

Windows CI also runs the native runtime tests with MSVC, then builds and runs a
minimal Windows Release consumer. Its report requires all 95 bundled grammars
and Crystal heredoc boundary/Unicode and SML comment fixtures to succeed.
Compiler identification, test/build logs and the runtime report are retained as
CI artifacts.

With Python 3, Dart, Tree-sitter CLI 0.26.8 and WASI SDK 29.0 installed:

```sh
python3 packages/duskmoon_highlight/tool/grammars.py build-wasm
python3 packages/duskmoon_highlight/tool/grammars.py generate
python3 packages/duskmoon_highlight/tool/grammars.py verify
```

The build command accepts `--tree-sitter /path/to/tree-sitter` and `--jobs 3`.
Set `TREE_SITTER_WASI_SDK_PATH` for a preinstalled WASI SDK. Keep pinned sources,
curated queries, source/asset hashes, generated Dart and notices together when
updating a grammar. Generated parsers absent from upstream archives are produced
with the CLI version recorded in the manifest; their source grammars are retained.
The `generate` command also refreshes the compressed parsers; `verify` checks
that they decode to the exact pinned source bytes.

```sh
devenv shell -- bash -c 'cd packages/duskmoon_highlight && flutter analyze --no-pub --fatal-infos'
devenv shell -- bash -c 'cd packages/duskmoon_highlight && flutter test --no-pub'
```
