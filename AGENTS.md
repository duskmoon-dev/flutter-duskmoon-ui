# AGENTS.md

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
    ├── duskmoon_widgets    ← 18 adaptive widgets (Material/Cupertino)
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

- `DmThemeData` — static factories returning complete `ThemeData` (`.sunshine()`, `.moonlight()`)
- `DmColorScheme` — static factories returning `ColorScheme`
- `DmColorExtension` — `ThemeExtension` with 20 semantic tokens (info, success, warning, accent, neutral, base100-300)
- `DmTextTheme` — Material 3 type scale
- `ThemeModeExtension` — `fromString()`, `title`, `icon` helpers on `ThemeMode`
- `DmThemeEntry` — bundles theme name with light/dark `ThemeData`

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
