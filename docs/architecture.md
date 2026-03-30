# Architecture

This document covers the package dependency graph, key design decisions, and conventions used across the DuskMoon UI library.

## Table of Contents

- [Package Dependency Graph](#package-dependency-graph)
- [Design Decisions](#design-decisions)
- [Conventions](#conventions)
- [Development](#development)

## Package Dependency Graph

```
duskmoon_theme              <-- Pure theme, zero external dependencies
    |-- duskmoon_theme_bloc <-- Opt-in BLoC for theme persistence (NOT in umbrella)
    |-- duskmoon_widgets    <-- 18 adaptive widgets (Material/Cupertino)
    |-- duskmoon_settings   <-- Settings UI (Material/Cupertino/Fluent)
    |-- duskmoon_feedback   <-- Dialogs, snackbars, toasts, bottom sheets
            |
        duskmoon_ui         <-- Umbrella: re-exports theme + widgets + settings + feedback
```

All packages depend on `duskmoon_theme` for consistent color tokens and theme data. The umbrella `duskmoon_ui` re-exports everything except `duskmoon_theme_bloc`, which is opt-in for apps that use the BLoC pattern.

## Design Decisions

### Codegen-driven theming

Colors are **never generated at runtime**. Design tokens flow through a codegen pipeline:

```
Design tokens (external repo) --> codegen script --> *Tokens classes (.g.dart)
    --> DmColorScheme --> DmThemeData (complete ThemeData)
```

This ensures exact color reproduction and eliminates runtime overhead. Token files live in `src/generated/` with the `.g.dart` suffix.

### Adaptive widget pattern

Widgets use a three-tier platform resolution system:

1. **Widget `platformOverride`** — per-instance override (highest priority)
2. **`DmPlatformOverride` InheritedWidget** — subtree-level override
3. **`Theme.of(context).platform`** — default platform detection

Each adaptive widget uses the `AdaptiveWidget` mixin and switches rendering between Material and Cupertino in its `build()` method.

### Settings compositor pattern

The settings package uses a compositor pattern with three platform renderers:

- **Material** — Android, Linux, Web, Fuchsia
- **Cupertino** — iOS, macOS
- **Fluent** — Windows

`SettingsList`, `SettingsSection`, and `SettingsTile` detect the platform and delegate to the appropriate renderer. This allows the same code to produce native-looking settings on every platform.

### Umbrella exclusion of theme_bloc

`duskmoon_theme_bloc` is intentionally excluded from the `duskmoon_ui` umbrella because:

- Not all apps use the BLoC pattern
- It introduces dependencies on `flutter_bloc`, `shared_preferences`, `equatable`, and `bloc`
- Apps using other state management solutions should not pay for these dependencies

Import it separately when needed:

```dart
import 'package:duskmoon_theme_bloc/duskmoon_theme_bloc.dart';
```

## Conventions

### Naming

- All public classes use the **`Dm` prefix** (e.g., `DmButton`, `DmThemeData`, `DmColorExtension`)
- Factory classes are **`abstract final`** with static methods (e.g., `DmThemeData`, `DmColorScheme`, `DmTextTheme`)
- Generated files use the **`.g.dart` suffix** in `src/generated/`

### Code style

- Linting: `flutter_lints` with `--fatal-infos` (info-level diagnostics are treated as errors)
- Tests assert **exact hex color values** from codegen as golden-value checks
- All packages use `publish_to: none` during development; the release workflow removes it before publishing

### Package structure

Each package follows the same layout:

```
packages/<name>/
  lib/
    <name>.dart           # Barrel file with public exports
    src/                  # Implementation files
      generated/          # Codegen output (.g.dart)
  test/
  pubspec.yaml
  LICENSE                 # MIT
```

## Development

### Workspace setup

This is a Dart native workspace with Melos 7.x. Configuration lives in the root `pubspec.yaml` under the `melos:` key.

```bash
dart pub get                   # Install all workspace dependencies
melos run analyze              # dart analyze --fatal-infos in all packages
melos run test                 # flutter test in all packages
melos run format               # dart format --set-exit-if-changed in all packages
melos run codegen              # Regenerate design tokens from external repo
```

### Single package development

```bash
cd packages/duskmoon_theme && flutter test
cd packages/duskmoon_theme && dart analyze --fatal-infos
```

### Release process

The release workflow:
1. Removes `publish_to: none` from each package
2. Converts path dependencies to hosted dependencies
3. Publishes to pub.dev
