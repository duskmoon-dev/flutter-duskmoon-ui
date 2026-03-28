# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter monorepo implementing the DuskMoon Design System component library, managed by **Melos**. Requires Dart >=3.5.0 and Flutter >=3.24.0.

## Commands

```bash
melos bootstrap                # Install all workspace dependencies (run first)
melos run analyze              # dart analyze --fatal-infos in all packages
melos run test                 # flutter test in all packages
melos run format               # dart format --set-exit-if-changed in all packages
melos run codegen              # Regenerate design tokens from external repo

# Single package operations
cd packages/duskmoon_theme && flutter test              # Test one package
cd packages/duskmoon_theme && dart analyze --fatal-infos # Analyze one package
```

## Architecture

### Package Dependency Graph

```
duskmoon_theme              ← Pure theme package, zero external deps
    ├── duskmoon_theme_bloc ← Opt-in BLoC for theme persistence (not in umbrella)
    ├── duskmoon_widgets    ← Adaptive widgets (material/cupertino)
    ├── duskmoon_settings   ← Settings UI components
    └── duskmoon_feedback   ← Dialogs, snackbars, toasts, bottom sheets
            │
        duskmoon_ui         ← Umbrella: re-exports theme + widgets + settings + feedback
            │
          example           ← Showcase app (uses duskmoon_ui + duskmoon_theme_bloc)
```

### Theme System (`duskmoon_theme` — fully implemented)

**Codegen-driven, no runtime color generation.** Colors come exclusively from generated `*Tokens` classes (`src/generated/*.g.dart`).

Flow: **Design tokens → codegen → `*Tokens` classes → `DmColorScheme` → `DmThemeData`**

- `DmColorScheme` — static factory methods returning `ColorScheme` (e.g., `sunshine()`, `moonlight()`)
- `DmThemeData` — static factory methods returning complete `ThemeData` with component themes
- `DmColorExtension` — `ThemeExtension` carrying 20 non-standard semantic tokens (info, success, warning, accent, neutral, base100-300, etc.)
- `DmTextTheme` — Material 3 type scale with exact M3 spec values
- `ThemeModeExtension` — `fromString()`, `title`, `icon` helpers on `ThemeMode`
- `DmThemeEntry` — bundles a theme name with its light/dark `ThemeData` variants

### Adaptive Widget Pattern (`duskmoon_widgets` — platform layer only)

Three-tier resolution: **widget override → `DmPlatformOverride` InheritedWidget → `Theme.of(context).platform`**

- `DmPlatformStyle` enum: `material` | `cupertino`
- `AdaptiveWidget` mixin on `StatelessWidget` for platform-aware rendering
- `DmPlatformOverride` InheritedWidget for app-level style override

### Settings UI (`duskmoon_settings` — fully implemented)

**Compositor pattern with 3 platform renderers** (Material, Cupertino, Fluent).

- `DevicePlatform` enum with `fromContext(BuildContext)` — resolves via `Theme.of(context).platform` + `kIsWeb`
- `SettingsList` → routes to `MaterialSettingsList` / `CupertinoSettingsList` / `FluentSettingsList`
- `SettingsSection` → platform-specific section rendering with title/margin
- `SettingsTile` — 10 tile types: simple, navigation, switch, check, input, slider, select, textarea, radioGroup, checkboxGroup
- `CustomSettingsTile` — wraps arbitrary widgets with platform-aware styling
- `SettingsTheme` / `SettingsThemeData` — InheritedWidget + 11-color theme data with platform factories
- Integrates with `DmColorExtension` semantic colors when available (base100/200/300, baseContent)

### Implementation Status

| Phase | Package | Status |
|-------|---------|--------|
| 1 | `duskmoon_theme` | Done |
| 2 | `duskmoon_theme_bloc` | Done |
| 3 | `duskmoon_settings` | Done |
| 4 | `duskmoon_feedback` | Stubs |
| 5 | `duskmoon_widgets` | Platform layer only |

## Conventions

- Generated files use `.g.dart` suffix in `src/generated/`
- All classes use `Dm` prefix (e.g., `DmThemeData`, `DmColorScheme`)
- Factory classes are `abstract final` with static methods (no instantiation)
- Linting: `flutter_lints` with `--fatal-infos` (infos are errors)
- Tests assert exact hex color values from codegen as golden-value checks
- `duskmoon_theme_bloc` is intentionally excluded from the umbrella re-export
