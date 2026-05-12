# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter monorepo for the DuskMoon Design System component library. Uses Dart native workspace + Melos 7.x (config in root `pubspec.yaml` under `melos:` key — no standalone `melos.yaml`). Requires Dart >=3.5.0 and Flutter >=3.24.0.

## Commands

```bash
dart pub get                   # Install all workspace dependencies (run first)
melos run analyze              # dart analyze --fatal-infos in all packages
melos run test                 # flutter test in all packages
melos run format               # dart format --set-exit-if-changed in all packages
melos run codegen              # Regenerate design tokens from external repo

# Single package
cd packages/duskmoon_theme && flutter test
cd packages/duskmoon_theme && dart analyze --fatal-infos
```

## Architecture

### Package Dependency Graph

```
duskmoon_theme              ← Pure theme, zero external deps
    ├── duskmoon_theme_bloc ← BLoC for theme persistence
    ├── duskmoon_widgets    ← 19 adaptive widgets (Material/Cupertino)
    ├── duskmoon_settings   ← Settings UI (Material/Cupertino/Fluent)
    ├── duskmoon_feedback   ← Dialogs, snackbars, toasts, bottom sheets
    └── duskmoon_form       ← BLoC-based form management (depends on theme + widgets)
            │
        duskmoon_ui         ← Umbrella: re-exports all packages
            │
          example           ← 9-page showcase app

duskmoon_code_engine        ← Pure Dart code editor (standalone, no DuskMoon deps)
duskmoon_visualization      ← Data viz with vendored chart modules (standalone)
duskmoon_adaptive_scaffold  ← Responsive scaffold (forked flutter_adaptive_scaffold)
```

### Theme System (`duskmoon_theme`)

**Codegen-driven, no runtime color generation.** Flow: design tokens → codegen → `*Tokens` classes → `DmColorScheme` → `DmThemeData`.

- `DmThemeData` — static factories returning complete `ThemeData` (`.sunshine()`, `.moonlight()`, `.forest()`, `.ocean()`)
- `DmColorScheme` — static factories returning `ColorScheme` (4 themes: sunshine, moonlight, forest, ocean)
- `DmColorExtension` — `ThemeExtension` with 28 semantic tokens (info/success/warning with containers and onContainer variants, accent, neutral, surfaceVariant, base100-900)
- `DmTextTheme` — Material 3 type scale
- `ThemeModeExtension` — `fromString()`, `title`, `icon` helpers on `ThemeMode`
- `DmThemeEntry` — bundles theme name with light/dark `ThemeData` (duskmoon + ecotone families)

### Adaptive Widget Pattern (`duskmoon_widgets`)

Three-tier platform resolution: **widget `platformOverride` → `DmPlatformOverride` InheritedWidget → `Theme.of(context).platform`**

- `DmPlatformStyle` enum: `material` | `cupertino`
- `AdaptiveWidget` mixin provides `resolveStyle(context)` for platform-aware `build()`
- Each widget switches Material/Cupertino rendering via `switch (resolveStyle(context))`

### Settings UI (`duskmoon_settings`)

Compositor pattern with **3 platform renderers** (Material, Cupertino, Fluent). `SettingsList` auto-detects platform and routes to the correct renderer. 10 tile types via named constructors on `SettingsTile`. `SettingsThemeData.withContext()` auto-derives colors from `ColorScheme` and optional `DmColorExtension`.

### Feedback (`duskmoon_feedback`)

Adaptive feedback helpers: `showDmDialog()` (uses `AlertDialog.adaptive`), `DmDialogAction` (platform-switches Material/Cupertino), `showDmSnackbar()`, `showDmUndoSnackbar()`, `showDmSuccessToast()`, `showDmErrorToast()`, `showDmBottomSheetActionList()`, `showDmFullscreenDialog()`.

### Form Management (`duskmoon_form`)

BLoC-based form state management merged from `form_bloc` + `flutter_form_bloc`. 7 field BLoCs (`TextFieldBloc`, `BooleanFieldBloc`, `SelectFieldBloc`, `MultiSelectFieldBloc`, `InputFieldBloc`, `GroupFieldBloc`, `ListFieldBloc`) + `FormBloc` for form orchestration. 11 Dm-prefixed widget builders. Sync/async validators with debouncing. Multi-step form support. `DmFormTheme` + `DmFormThemeProvider` for theming. BLoC classes keep original names (user-subclassable); only UI widgets get `Dm` prefix.

### Code Editor (`duskmoon_code_engine`)

Pure Dart code editor engine — ground-up port of CodeMirror 6 architecture. No external dependencies beyond Flutter.

- **Document model** — rope-based incremental updates (`Document`, `Rope`, `ChangeSet`)
- **State system** — immutable snapshots (`EditorState`, `Transaction`, `Selection`, `Facet`, `Extension`)
- **Lezer parser** — incremental parsing (`LRParser`, `SyntaxNode`, `TreeCursor`)
- **Highlight system** — tag-based (`Tag`, `HighlightStyle`, `TagStyle`)
- **19 language grammars** — Dart, JS/TS, Python, HTML, CSS, JSON, Markdown, Rust, Go, YAML, C/C++, Elixir, Java, Kotlin, PHP, Ruby, Erlang, Swift, Zig
- **View layer** — `CodeEditorWidget` with virtual ListView, `LinePainter`, `SelectionPainter`, `GutterPainter`, search panel, cursor blinking

### Data Visualization (`duskmoon_visualization`)

5 curated DmViz chart widgets (`DmVizLineChart`, `DmVizBarChart`, `DmVizScatterChart`, `DmVizHeatmap`, `DmVizNetworkGraph`) backed by vendored `dv_*` modules (35+ chart types including geographic/map viz). Data models: `DmVizPoint`, `DmVizHeatmapCell`, `DmVizNetworkNode/Edge`. `DmChartPalette` for theming.

### Adaptive Scaffold (`duskmoon_adaptive_scaffold`)

Forked from `flutter_adaptive_scaffold`. `AdaptiveScaffold` implements M3 adaptive layout with responsive breakpoints (compact <600dp, medium 600-840dp, expanded 1200dp+). `SlotLayout` for composable layout positions.

## Conventions

- Generated files: `.g.dart` suffix in `src/generated/`
- All public classes use `Dm` prefix
- Factory classes are `abstract final` with static methods
- Linting: `flutter_lints` with `--fatal-infos` (infos are errors)
- Tests assert exact hex color values from codegen as golden-value checks
- In `duskmoon_form`, BLoC classes keep original names (e.g., `FormBloc`); only UI widgets get `Dm` prefix
- All packages use `publish_to: none` during development — the release workflow removes it, converts path deps to hosted deps, and publishes to pub.dev
- Each package has its own MIT LICENSE file
- `duskmoon_adaptive_scaffold` is forked from `flutter_adaptive_scaffold`, versioned in sync with all other packages

## CI/CD

- **ci.yml** — Format + analysis on all pushes/PRs
- **test.yml** — Unit tests on main pushes/PRs
- **release.yml** (manual) — Version bump, path→hosted dep conversion, tag push
- **publish.yml** — Publishes to pub.dev on tag push; respects dependency order (adaptive_scaffold first → theme → dependents → duskmoon_ui last)
- **deploy-pages.yml** — Builds example as Flutter web → GitHub Pages

<!-- gitnexus:start -->
# GitNexus — Code Intelligence

This project is indexed by GitNexus as **flutter-duskmoon-ui** (6434 symbols, 14661 relationships, 257 execution flows). Use the GitNexus MCP tools to understand code, assess impact, and navigate safely.

> If any GitNexus tool warns the index is stale, run `npx gitnexus analyze` in terminal first.

## Always Do

- **MUST run impact analysis before editing any symbol.** Before modifying a function, class, or method, run `gitnexus_impact({target: "symbolName", direction: "upstream"})` and report the blast radius (direct callers, affected processes, risk level) to the user.
- **MUST run `gitnexus_detect_changes()` before committing** to verify your changes only affect expected symbols and execution flows.
- **MUST warn the user** if impact analysis returns HIGH or CRITICAL risk before proceeding with edits.
- When exploring unfamiliar code, use `gitnexus_query({query: "concept"})` to find execution flows instead of grepping. It returns process-grouped results ranked by relevance.
- When you need full context on a specific symbol — callers, callees, which execution flows it participates in — use `gitnexus_context({name: "symbolName"})`.

## Never Do

- NEVER edit a function, class, or method without first running `gitnexus_impact` on it.
- NEVER ignore HIGH or CRITICAL risk warnings from impact analysis.
- NEVER rename symbols with find-and-replace — use `gitnexus_rename` which understands the call graph.
- NEVER commit changes without running `gitnexus_detect_changes()` to check affected scope.

## Resources

| Resource | Use for |
|----------|---------|
| `gitnexus://repo/flutter-duskmoon-ui/context` | Codebase overview, check index freshness |
| `gitnexus://repo/flutter-duskmoon-ui/clusters` | All functional areas |
| `gitnexus://repo/flutter-duskmoon-ui/processes` | All execution flows |
| `gitnexus://repo/flutter-duskmoon-ui/process/{name}` | Step-by-step execution trace |

## CLI

| Task | Read this skill file |
|------|---------------------|
| Understand architecture / "How does X work?" | `.claude/skills/gitnexus/gitnexus-exploring/SKILL.md` |
| Blast radius / "What breaks if I change X?" | `.claude/skills/gitnexus/gitnexus-impact-analysis/SKILL.md` |
| Trace bugs / "Why is X failing?" | `.claude/skills/gitnexus/gitnexus-debugging/SKILL.md` |
| Rename / extract / split / refactor | `.claude/skills/gitnexus/gitnexus-refactoring/SKILL.md` |
| Tools, resources, schema reference | `.claude/skills/gitnexus/gitnexus-guide/SKILL.md` |
| Index, status, clean, wiki CLI commands | `.claude/skills/gitnexus/gitnexus-cli/SKILL.md` |

<!-- gitnexus:end -->
