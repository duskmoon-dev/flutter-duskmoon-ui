# DuskMoon Highlight

DuskMoon-maintained Dart syntax highlighting for Flutter. The parser, 195 language
grammars, aliases and light/dark token themes are maintained in this repository.
No JavaScript engine or platform plugin is needed at runtime.

```dart
import 'package:duskmoon_highlight/duskmoon_highlight.dart';
import 'package:duskmoon_highlight/languages/all.dart';

final highlight = Highlight()..registerLanguages(builtinAllLanguages);
final result = highlight.highlight(code: 'final answer = 42;', language: 'dart');
final html = result.toHtml();
```

`getLanguage` accepts case-insensitive aliases. Guard an unknown identifier before
calling `highlight` to provide a plain-text fallback. After parsing, also fall
back when `result.errorRaised != null` or `result.illegal`: safe mode can retain
partial token output on a parser error. Use `result.render` with
`HighlightRenderer` to consume raw token text and scopes without HTML escaping.
`TextSpanRenderer` accepts a Flutter base `TextStyle` and token style map. Individual
grammars and themes remain available under `languages/` and `styles/`.

## Source and licenses

See [SOURCE.md](SOURCE.md) for the exact verified import and changes. `LICENSE`
contains the upstream MIT notice; `THIRD_PARTY_LICENSES` contains the retained
highlight.js and community grammar notices. `THIRD_PARTY_NOTICES` retains grammar
and theme attribution, including theme-specific MIT and CC BY-SA 4.0 notices.
The CC license text is in `CC-BY-SA-4.0.txt`. The checked-in grammar/style sources
retain their original attribution comments; inherited themes keep those licenses.

## Regeneration

Run from the workspace root with the development environment available. Node 18+
and npm are required only for maintenance. `npm ci` uses the checked-in lockfile;
the HighlightJS helper runtime is pinned to 11.12.0. Grammar definitions and CSS
styles are read from this package's `vendor/highlight.js/src`, with Vue/GN source
under their adjacent vendor directories. Edit those inputs rather than generated
Dart grammars or themes.

```sh
npm ci --prefix packages/duskmoon_highlight/tool --ignore-scripts --no-audit --no-fund
npm test --prefix packages/duskmoon_highlight/tool
npm audit --prefix packages/duskmoon_highlight/tool
DART="$PWD/.devenv/profile/bin/dart" npm run generate --prefix packages/duskmoon_highlight/tool
```

The generator works independently of the current shell directory, renames imports
to this package and formats generated output with Dart language version 3.6. Running it twice with the same input
and Dart formatter must produce identical `lib/` bytes. Keep the Node lockfile,
source grammars/styles and generated Dart changes together when updating inputs.
The upstream HighlightJS source version is recorded in `vendor/highlight.js/package.json`.

## Validation

After workspace dependency resolution, run from the root:

```sh
devenv shell -- bash -c 'cd packages/duskmoon_highlight && flutter analyze --no-pub --fatal-infos'
devenv shell -- bash -c 'cd packages/duskmoon_highlight && flutter test --no-pub'
```

API/parser tests and the full original markup fixture suite are retained. Focused
maintenance tests cover the owned registry and text-preservation contract.
