# Dependency maintenance

This workspace's dependency review was refreshed on 2026-10-19 using Flutter
3.47.0 and Dart 3.13.0. Pub dependencies remain within normal published version
constraints; there are no dependency overrides.

## Upgrading to 2.1

The Tree-sitter migration removes the former Highlight/Mode and
Lezer/StreamLanguage parser APIs. It introduces immutable
syntax snapshots and per-editor incremental sessions shared by Markdown and
the editor. See the [runtime migration guide](../packages/duskmoon_highlight/README.md)
and [editor migration guide](../packages/duskmoon_code_engine/README.md).

The SDK requirements raised in 2.0 still apply, with newer floors for the
Tree-sitter runtime and editor; check the per-package matrix below before upgrading.

The legacy `DmThemeBloc(prefs: ...)` constructor and hosted Markdown AST types
remain compatible. Modern preference stores are opt-in and require an
application-controlled migration of existing stored values.

## SDK support

These declared floors reflect the minimum requirements of each package's direct
dependency constraints and its workspace dependencies. The review was tested on
Flutter 3.47.0 / Dart 3.13.0; the individual floors have not all been exercised
on separate SDK installations.

| Packages | Dart | Flutter |
| --- | --- | --- |
| theme, adaptive_scaffold, feedback, mermaid_renderer | 3.6 | 3.24 |
| code_engine, highlight | 3.10 | 3.38 |
| visualization | 3.10 | 3.38 |
| theme_bloc, widgets, form | 3.11 | 3.41 |
| settings, ui | 3.12 | 3.44 |
| design_preview, duo_screen examples | 3.12 | 3.44 |

Package names in the table use the `duskmoon_` prefix. Developing the complete
workspace requires Dart 3.12 or newer. Melos bootstrap must not impose a single
environment floor on all published packages.

## Source ownership and refresh procedure

| Component | Maintained source and notices | Refresh policy |
| --- | --- | --- |
| Highlighting and code parsing | [Tree-sitter 0.27.1 runtime and pinned grammars](../packages/duskmoon_highlight/SOURCE.md) | Update pinned source, curated queries, native hook inputs, Wasm assets, hashes and notices together. Verify every grammar on native and web plus incremental/fresh tree parity. |
| Markdown | [Official 7.3.1 plus three upstream patches](../packages/duskmoon_widgets/lib/src/vendor/markdown/SOURCE.md) | Keep the hosted AST types. Remove the private parser once a released version passes the regressions for EOF handling and bounded parsing work. |
| Math | [flutter_math_fork 0.7.4 source and KaTeX fonts](../packages/duskmoon_widgets/lib/src/vendor/flutter_math/SOURCE.md) | Private native renderer owned by widgets. Review Flutter API changes, parser/encoder tests, inline/display/error rendering, font bundle and Web/Wasm builds. |
| Adaptive scaffold | [Source record](../packages/duskmoon_adaptive_scaffold/SOURCE.md) | Preserve Flutter BSD and DuskMoon MIT notices. |
| Forms, typeahead, Stepper | [Source record](../packages/duskmoon_form/SOURCE.md) | Preserve original MIT, BSD-2-Clause and Flutter BSD notices. |
| Visualization and maps | [Source record](../packages/duskmoon_visualization/SOURCE.md) | Preserve GSMLG MIT attribution and record Natural Earth data provenance when regenerating. |

The math renderer is private to `duskmoon_widgets`; no additional public package
or hosted math dependency is required. Markdown keeps `package:markdown` as the
public AST boundary so existing nodes, visitors and custom builders retain type
identity. Widget notices are collected in
[THIRD_PARTY_LICENSES](../packages/duskmoon_widgets/THIRD_PARTY_LICENSES).

Tree-sitter maintenance uses CLI 0.26.8 and WASI SDK 29.0. Consumers receive
bundled native source and browser assets; only maintainers rebuild grammar Wasm.
The parser/runtime build does not depend on Highlight.js, Lezer or Node package
lockfiles. See the [source record](../packages/duskmoon_highlight/SOURCE.md) for
source archives, generator versions and the explicit scanner compatibility patch.

## Dependencies retained

RxDart, file_picker, Fluent UI, BLoC and the existing SVG renderer remain in use.
The review found no current reason for a broad replacement. SharedPreferences
has additive async/cache entry points; the legacy constructor remains supported.
Applications control stored-value migration as described in the
[theme BLoC guide](../packages/duskmoon_theme_bloc/README.md).

At review time, ten packages had newer versions that could not be selected under
the current SDK/upstream constraints: test, test_api, test_core, analyzer,
_fe_analyzer_shared, package_config, material_color_utilities, cross_file,
platform and xml. Refresh with `melos run outdated` after SDK or upstream updates;
do not force these versions through dependency overrides.

## Validation commands

Run commands from the repository root inside `devenv shell` when the host lacks
Dart/Flutter:

```bash
melos run outdated
melos run format
melos run analyze
melos run test
```

For grammar changes, run the shared runtime's `tool/grammars.py generate` and
`verify`, affected-package tests, and actual browser checks for both JavaScript
and Flutter Wasm. Native consumers require a C/C++ toolchain. Package validation
must include the build hook, manifest, sources, license texts and browser assets.
The complete bundle intentionally includes all advertised grammars; its build
and application footprint is larger than the previous regex-only package.
At this revision, browser assets occupy about 142 MiB unpacked and the Pub archive
is about 56 MiB. Browsers load grammars on demand, while Flutter includes the
complete grammar bundle in the application's assets. Workspace package tests run
sequentially because Flutter native hooks share a build lock.

### Tree-sitter validation (2.1.0, 2026-10-19)

All 14 workspace members passed formatting and fatal-info analysis, and all
1,941 tests passed, including four typeahead transition regressions. Native
archive-consumer checks and actual JavaScript/Wasm
browser checks covered all 95 grammars. Widget browser checks covered automatic
loading, Unicode, incremental edits, language changes, themes and disposal.
Native targets other than Linux and separate minimum SDK installations remain
unvalidated.

### Previous dependency review (2.0.0, 2026-10-19)

The previous release passed all workspace checks, native math asset/archive
checks and Web/Wasm showcase builds. Those results describe the 2.0.0 release.
Minimum SDK combinations and native targets other than the tested host still
require their own platform validation.
