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
    ├── duskmoon_theme_bloc ← Opt-in BLoC for theme persistence (NOT in umbrella)
    ├── duskmoon_widgets    ← 18 adaptive widgets (Material/Cupertino)
    ├── duskmoon_settings   ← Settings UI (Material/Cupertino/Fluent)
    └── duskmoon_feedback   ← Dialogs, snackbars, toasts, bottom sheets
            │
        duskmoon_ui         ← Umbrella: re-exports theme + widgets + settings + feedback
            │
          example           ← 5-page showcase app
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

## Conventions

- Generated files: `.g.dart` suffix in `src/generated/`
- All public classes use `Dm` prefix
- Factory classes are `abstract final` with static methods
- Linting: `flutter_lints` with `--fatal-infos` (infos are errors)
- Tests assert exact hex color values from codegen as golden-value checks
- `duskmoon_theme_bloc` is intentionally excluded from the umbrella re-export
- All packages use `publish_to: none` during development — the release workflow removes it, converts path deps to hosted deps, and publishes to pub.dev
- Each package has its own MIT LICENSE file
