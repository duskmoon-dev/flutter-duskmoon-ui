# Architecture

This document covers the package dependency graph, key design decisions, and conventions used across the DuskMoon UI library.

## Table of Contents

- [Package Dependency Graph](#package-dependency-graph)
- [Design Decisions](#design-decisions)
- [Conventions](#conventions)
- [Development](#development)

## Package Dependency Graph

```
duskmoon_theme                  <-- Pure theme, zero external dependencies
    |-- duskmoon_theme_bloc     <-- BLoC for theme persistence
    |-- duskmoon_widgets        <-- 19 adaptive widgets + markdown + code editor
    |       |-- duskmoon_code_engine (for DmCodeEditor)
    |-- duskmoon_settings       <-- Settings UI (Material/Cupertino/Fluent)
    |-- duskmoon_feedback       <-- Dialogs, snackbars, toasts, bottom sheets
    |-- duskmoon_form           <-- BLoC-based form management (depends on theme + widgets)
    |-- duskmoon_visualization  <-- Data visualization charts (depends on theme)
            |
        duskmoon_ui             <-- Umbrella: re-exports all packages

duskmoon_code_engine            <-- Pure Dart code editor (standalone)
duskmoon_adaptive_scaffold      <-- Responsive scaffold (forked, independently versioned)
```

All packages depend on `duskmoon_theme` for consistent color tokens and theme data. `duskmoon_form` additionally depends on `duskmoon_widgets`. `duskmoon_widgets` depends on `duskmoon_code_engine` for code editor functionality. `duskmoon_visualization` uses `DmColorExtension` for palette derivation. The umbrella `duskmoon_ui` re-exports all packages, including `duskmoon_theme_bloc` and `duskmoon_code_engine`. `duskmoon_code_engine` and `duskmoon_adaptive_scaffold` are standalone packages with no DuskMoon theme dependency.

## Design Decisions

### Codegen-driven theming

Colors are **never generated at runtime**. Design tokens flow through a codegen pipeline:

```
Design tokens (external repo) --> codegen script --> *Tokens classes (.g.dart)
    --> DmColorScheme --> DmThemeData (complete ThemeData)
```

This ensures exact color reproduction and eliminates runtime overhead. Token files live in `src/generated/` with the `.g.dart` suffix.

The token container layer uses `DmTheme` and `DmColors` to provide a structured API over the raw generated token classes, making theme data easier to consume in widget code.

### Adaptive widget pattern

Widgets use a four-tier platform resolution system:

1. **Widget `platformOverride`** — per-instance override (highest priority)
2. **`DmPlatformOverride` InheritedWidget** — subtree-level override
3. **`DuskmoonApp`** — app-level platform setting
4. **`Theme.of(context).platform`** — default platform detection

Each adaptive widget uses the `AdaptiveWidget` mixin and switches rendering in its `build()` method. `DmPlatformStyle` supports three values: `material`, `cupertino`, and `fluent`.

### Settings compositor pattern

The settings package uses a compositor pattern with three platform renderers:

- **Material** — Android, Linux, Web, Fuchsia
- **Cupertino** — iOS, macOS
- **Fluent** — Windows

`SettingsList`, `SettingsSection`, and `SettingsTile` detect the platform and delegate to the appropriate renderer. This allows the same code to produce native-looking settings on every platform.

### DmEditorTheme vs DmCodeEditorTheme

Two classes provide editor theme derivation at different abstraction levels:

- **`DmEditorTheme`** (in `duskmoon_ui`) — derives an `EditorTheme` from a `ThemeData` object without requiring a `BuildContext`. Provides `DmEditorTheme.fromTheme(ThemeData)`, plus static factories `DmEditorTheme.sunshine()` and `DmEditorTheme.moonlight()`.
- **`DmCodeEditorTheme`** (in `duskmoon_widgets`) — derives an `EditorTheme` from a `BuildContext` via `DmCodeEditorTheme.fromContext(context)`. This is more convenient inside widget `build()` methods where a context is available.

Use `DmEditorTheme` when you have a `ThemeData` but no `BuildContext` (e.g., in tests, BLoC logic, or theme previews). Use `DmCodeEditorTheme` when building widget trees.

### Form BLoC naming convention

In `duskmoon_form`, BLoC classes that users subclass (e.g., `FormBloc`, `TextFieldBloc`) keep their original names for ergonomic API. Only UI-facing widget classes get the `Dm` prefix (e.g., `DmTextFieldBlocBuilder`, `DmFormBlocListener`). This matches the pattern where `DmButton`, `DmTextField`, etc. are UI components.

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
