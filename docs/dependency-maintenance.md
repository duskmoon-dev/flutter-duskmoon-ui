# Dependency maintenance

This workspace's dependency review was refreshed on 2026-10-19 using Flutter
3.47.0 and Dart 3.13.0. Pub dependencies remain within normal published version
constraints; there are no dependency overrides.

## Upgrading to 2.0

This release raises the declared SDK requirements to match dependencies that
already need newer SDKs; check the per-package matrix below before upgrading.

`GrammarData.states` now uses `Uint32List` to retain Lezer's full state values.
Direct constructor callers must replace `Uint16List` state arrays with
`Uint32List`. Code using `LRParser.deserialize` can continue to supply
`List<int>` arrays. The LR runtime limitation described in the generator guide
still applies.

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
| theme, adaptive_scaffold, code_engine, feedback, highlight, mermaid_renderer | 3.6 | 3.24 |
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
| Highlighting | [HighlightJS 11.12.0 and parser provenance](../packages/duskmoon_highlight/SOURCE.md) | Update vendor grammars, fixtures, generated Dart and notices together. Run Node graph tests, all markup fixtures and two byte-identical generations. |
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

Highlighter tooling pins lodash 4.18.1, PostCSS 8.5.31 and HighlightJS 11.12.0.
Deprecated circular-json was removed; its graph handling is covered by tests for
cycles, shared references and ordinary tilde strings. These Node dependencies
are generation tools and are excluded from the published highlighter package.
Lezer tooling is pinned with a lockfile; see its
[generator contract and limitations](../packages/duskmoon_code_engine/tool/README.md).

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

Run the two tool directories' `npm ci`, `npm test` and `npm audit` when changing
their lockfiles. Generator changes also require generated-code verification;
successful metadata generation alone does not establish parser compatibility.

### Verified on 2026-10-19

- All 14 workspace members pass formatting and fatal-info analysis; 2,684 tests
  pass across the workspace.
- Highlighter Node tests (4) and Lezer generator/consumer tests (3) pass. Both
  npm audits report zero vulnerabilities. Two highlighter generations match the
  tested output byte for byte across 479 files.
- The showcase builds in release mode for Web and Wasm. Both asset bundles
  contain the 12 owned math font families and all 20 original TTF files.
- Archive-content checks cover widgets, highlighter, adaptive scaffold, form and
  visualization. Required runtime source, fonts and notices are present; Node
  dependencies are excluded. Publish dry runs report only uncommitted-file
  warnings (exit 65); no package was published during this update.
- `melos run outdated` confirms the newest resolvable dependency set. The ten
  constrained newer versions listed above remain unchanged.

Separate browser execution, platform-store migration on Windows and every
declared minimum SDK combination were not tested in this review.
