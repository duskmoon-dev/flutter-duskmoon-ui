# PRD: flutter_duskmoon_ui v1.2.0 — DuskmoonApp, DmTheme Token Container, Fluent Enum

> **Version**: 1.2.0
> **Date**: 2026-04-03
> **Status**: Implementation-Ready
> **Base**: v1.0.3 (current main)
> **Scope**: Architectural layer additions — no widget behavior changes

---

## 1. Summary

Three targeted changes to formalize the separation of concerns described in the design document:

1. **`DmTheme`** — introduce a platform-agnostic token container class in `duskmoon_theme`
2. **`DmPlatformStyle.fluent`** — promote to first-class enum value across all packages
3. **`DuskmoonApp`** — add root `InheritedWidget` in `duskmoon_widgets` as app-level platform provider

These are purely additive. No existing public API is removed. No widget rendering logic changes.

---

## 2. Context: Current State

### `duskmoon_theme`

- `DmColorScheme`, `DmThemeData`, `DmColorExtension` exist and are correct
- `DmThemeData` is both token container and Flutter adapter — these concerns are fused
- No `DmTheme` class exists

### `duskmoon_widgets`

- `DmPlatformStyle` enum: `{ material, cupertino }` — Fluent is missing
- `DmPlatformOverride` exists (subtree InheritedWidget)
- `resolvePlatformStyle()` resolution order: widget override → `DmPlatformOverride` → `theme.platform`
- No `DuskmoonApp` exists — app-level platform style provider is absent

### `duskmoon_settings`

- Already implements 3-platform rendering (Material/Cupertino/Fluent) via its own internal enum
- Must be updated to use `DmPlatformStyle` from `duskmoon_widgets` instead of internal enum

---

## 3. Change 1: `DmTheme` Token Container

### Location

`packages/duskmoon_theme/lib/src/dm_theme.dart`

### Motivation

`DmThemeData` currently conflates two roles: (a) holding token references, (b) producing Flutter `ThemeData`. Introducing `DmTheme` gives renderers (Material, Cupertino, Fluent) a shared token source without coupling to Flutter's `ThemeData`.

### Implementation

```dart
// packages/duskmoon_theme/lib/src/dm_theme.dart

import 'package:flutter/material.dart';
import 'color_scheme.dart';
import 'extensions.dart';

/// Platform-agnostic DuskMoon design-token container.
///
/// Holds [DmColors] only. Does not produce [ThemeData].
/// Use [DmThemeData] to convert to a Flutter [ThemeData].
@immutable
class DmTheme {
  const DmTheme({
    required this.colors,
    required this.name,
  });

  /// Display name of this theme ("sunshine" | "moonlight").
  final String name;

  /// Resolved color tokens for this theme.
  final DmColors colors;

  /// Sunshine (light) token set.
  static const DmTheme sunshine = DmTheme(
    name: 'sunshine',
    colors: DmColors.sunshine(),
  );

  /// Moonlight (dark) token set.
  static const DmTheme moonlight = DmTheme(
    name: 'moonlight',
    colors: DmColors.moonlight(),
  );

  /// All available codegen themes.
  static const List<DmTheme> all = [sunshine, moonlight];
}
```

### `DmColors`

```dart
// packages/duskmoon_theme/lib/src/dm_colors.dart

import 'package:flutter/material.dart';
import 'generated/sunshine_tokens.g.dart';
import 'generated/moonlight_tokens.g.dart';

/// Typed color token bag — all DuskMoon color tokens in one place.
///
/// Split into [colorScheme] (maps to Flutter [ColorScheme]) and
/// [extension] (non-ColorScheme tokens via [DmColorExtension]).
@immutable
class DmColors {
  const DmColors({
    required this.colorScheme,
    required this.extension,
  });

  final ColorScheme colorScheme;
  final DmColorExtension extension;

  const factory DmColors.sunshine() = _SunshineColors;
  const factory DmColors.moonlight() = _MoonlightColors;
}

class _SunshineColors extends DmColors {
  const _SunshineColors()
      : super(
          colorScheme: DmColorScheme._fromTokens(SunshineTokens),
          extension: const DmColorExtension(/* ... sunshine fields ... */),
        );
}
// (same pattern for _MoonlightColors)
```

> **Implementation note for Claude Code**: `DmColors` wraps what `DmColorScheme.sunshine()` and `DmColorExtension.sunshine()` already produce. The factory constructors should delegate to the existing static methods — do not duplicate token references.

### Update `DmThemeData`

`DmThemeData` gains an overload that accepts `DmTheme`:

```dart
abstract final class DmThemeData {
  /// Build from a [DmTheme] token container.
  static ThemeData fromDmTheme(DmTheme theme) => _buildThemeData(
        colorScheme: theme.colors.colorScheme,
        colorExtension: theme.colors.extension,
      );

  // Existing factories remain unchanged:
  static ThemeData sunshine() => fromDmTheme(DmTheme.sunshine);
  static ThemeData moonlight() => fromDmTheme(DmTheme.moonlight);
}
```

`_buildThemeData` is unchanged.

### Updated Exports

```dart
// packages/duskmoon_theme/lib/duskmoon_theme.dart
export 'src/dm_theme.dart' show DmTheme;
export 'src/dm_colors.dart' show DmColors;
// all existing exports unchanged
```

---

## 4. Change 2: `DmPlatformStyle.fluent`

### Location

`packages/duskmoon_widgets/lib/src/adaptive/platform_resolver.dart`

### Change

```dart
enum DmPlatformStyle {
  material,
  cupertino,
  fluent,   // ← ADD
}
```

### Update `resolvePlatformStyle`

```dart
DmPlatformStyle resolvePlatformStyle(
  BuildContext context, {
  DmPlatformStyle? widgetOverride,
}) {
  if (widgetOverride != null) return widgetOverride;

  // L2: subtree override
  final subtreeOverride = DmPlatformOverride.maybeOf(context);
  if (subtreeOverride != null) return subtreeOverride;

  // L3: DuskmoonApp app-level style  ← NEW
  final appStyle = DuskmoonApp.maybeStyleOf(context);
  if (appStyle != null) return appStyle;

  // L4: platform default
  return _defaultStyle(Theme.of(context).platform);
}

DmPlatformStyle _defaultStyle(TargetPlatform platform) =>
    switch (platform) {
      TargetPlatform.iOS || TargetPlatform.macOS => DmPlatformStyle.cupertino,
      TargetPlatform.windows => DmPlatformStyle.fluent,
      _ => DmPlatformStyle.material,
    };
```

### Widget Fluent Stub

All existing adaptive widgets (`DmButton`, `DmScaffold`, etc.) have `switch (resolveStyle(context))` with `material` and `cupertino` branches. Add a `fluent` branch that falls through to `material` for now:

```dart
switch (resolveStyle(context)) {
  DmPlatformStyle.material => _buildMaterial(context),
  DmPlatformStyle.cupertino => _buildCupertino(context),
  DmPlatformStyle.fluent => _buildMaterial(context),  // stub — falls through
}
```

This keeps exhaustive switch checks passing without implementing Fluent renderers in this PRD.

---

## 5. Change 3: `DuskmoonApp`

### Location

`packages/duskmoon_widgets/lib/src/adaptive/duskmoon_app.dart`

### Motivation

Without an app-level provider, every adaptive widget falls through directly to `theme.platform` detection. `DuskmoonApp` fills the L3 slot in the resolution stack, letting apps explicitly declare their platform style without wrapping every widget tree in `DmPlatformOverride`.

### Implementation

```dart
// packages/duskmoon_widgets/lib/src/adaptive/duskmoon_app.dart

import 'package:flutter/widgets.dart';
import 'platform_resolver.dart';

/// App-level platform-style provider for DuskMoon adaptive widgets.
///
/// Place above [MaterialApp] or [CupertinoApp] to declare a default
/// [DmPlatformStyle] for all adaptive widgets in the tree.
///
/// Resolution order for adaptive widgets:
/// 1. Per-widget `platformOverride` parameter
/// 2. Nearest [DmPlatformOverride] ancestor
/// 3. Nearest [DuskmoonApp] ancestor  ← this widget
/// 4. Platform default from [Theme.of(context).platform]
///
/// Example:
/// ```dart
/// DuskmoonApp(
///   platformStyle: DmPlatformStyle.cupertino,
///   child: MaterialApp(home: MyHome()),
/// );
/// ```
class DuskmoonApp extends InheritedWidget {
  const DuskmoonApp({
    super.key,
    this.platformStyle,
    required super.child,
  });

  /// Explicit platform style for all adaptive widgets in the subtree.
  ///
  /// When null, adaptive widgets fall through to platform-default detection.
  final DmPlatformStyle? platformStyle;

  /// Returns the [DmPlatformStyle] from the nearest [DuskmoonApp], or null.
  static DmPlatformStyle? maybeStyleOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DuskmoonApp>()
        ?.platformStyle;
  }

  @override
  bool updateShouldNotify(DuskmoonApp oldWidget) =>
      platformStyle != oldWidget.platformStyle;
}
```

### Export

```dart
// packages/duskmoon_widgets/lib/duskmoon_widgets.dart
export 'src/adaptive/duskmoon_app.dart' show DuskmoonApp;
// all existing exports unchanged
```

---

## 6. `duskmoon_settings` Platform Enum Unification

`duskmoon_settings` currently uses its own internal platform detection. Replace with `DmPlatformStyle` from `duskmoon_widgets`.

### pubspec change

```yaml
# packages/duskmoon_settings/pubspec.yaml
dependencies:
  flutter: { sdk: flutter }
  duskmoon_theme: { path: ../duskmoon_theme }
  duskmoon_widgets: { path: ../duskmoon_widgets }  # ← ADD
```

### Platform resolver change

Replace the internal `DevicePlatform` / `settings_ui`-level platform detection in `platform_utils.dart` with:

```dart
import 'package:duskmoon_widgets/duskmoon_widgets.dart';

// Inside SettingsList / SettingsTile build:
final style = resolvePlatformStyle(context);
return switch (style) {
  DmPlatformStyle.cupertino => CupertinoSettingsList(/* ... */),
  DmPlatformStyle.fluent    => FluentSettingsList(/* ... */),
  DmPlatformStyle.material  => MaterialSettingsList(/* ... */),
};
```

The existing 3 renderers (Material/Cupertino/Fluent) are unchanged — only the dispatch mechanism changes.

---

## 7. `duskmoon_ui` Umbrella

No changes needed. All new exports propagate through existing re-exports of `duskmoon_theme` and `duskmoon_widgets`.

---

## 8. Example App Update

`example/lib/main.dart` — wrap with `DuskmoonApp`:

```dart
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DuskmoonApp(
      // null = auto-detect from platform; explicit for demo:
      // platformStyle: DmPlatformStyle.material,
      child: MaterialApp(
        theme: DmThemeData.sunshine(),
        darkTheme: DmThemeData.moonlight(),
        themeMode: ThemeMode.system,
        home: const HomePage(),
      ),
    );
  }
}
```

Add a `DmTheme` demo to `theme_page.dart` showing token access:

```dart
// Accessing token container directly
final tokens = DmTheme.sunshine;
print(tokens.name);                    // "sunshine"
print(tokens.colors.colorScheme.primary); // Color
```

---

## 9. Tests

### `duskmoon_theme`

```
test/dm_theme_test.dart
  - DmTheme.sunshine has name == 'sunshine'
  - DmTheme.all has length 2
  - DmThemeData.fromDmTheme(DmTheme.sunshine) equals DmThemeData.sunshine()
  - DmTheme.sunshine.colors.colorScheme matches DmColorScheme.sunshine()
```

### `duskmoon_widgets`

```
test/adaptive/duskmoon_app_test.dart
  - DuskmoonApp.maybeStyleOf returns null when absent
  - DuskmoonApp.maybeStyleOf returns platformStyle when present
  - DuskmoonApp with null platformStyle falls through to platform default
  - resolvePlatformStyle: widget override beats DuskmoonApp
  - resolvePlatformStyle: DmPlatformOverride beats DuskmoonApp
  - resolvePlatformStyle: DuskmoonApp beats theme.platform default
  - DmPlatformStyle.fluent in enum (compile check)
  - Windows platform defaults to fluent via _defaultStyle
```

### `duskmoon_settings`

```
test/platform_utils_test.dart
  - DmPlatformStyle.fluent dispatches to FluentSettingsList
  - DmPlatformStyle.cupertino dispatches to CupertinoSettingsList
  - DmPlatformStyle.material dispatches to MaterialSettingsList
```

---

## 10. Acceptance Criteria

- [ ] `DmTheme.sunshine` and `DmTheme.moonlight` are `const`, zero runtime allocation
- [ ] `DmThemeData.fromDmTheme(DmTheme.sunshine)` is identical to `DmThemeData.sunshine()`
- [ ] `DmPlatformStyle` has 3 values: `material`, `cupertino`, `fluent`
- [ ] `DuskmoonApp` is exported from `duskmoon_widgets`
- [ ] `DuskmoonApp` with explicit `platformStyle` overrides `theme.platform` default in adaptive widgets
- [ ] `DuskmoonApp` with `platformStyle: null` has no effect (fallthrough)
- [ ] `DmPlatformOverride` still beats `DuskmoonApp` in resolution order
- [ ] `duskmoon_settings` dispatches via `DmPlatformStyle` — no internal platform enum
- [ ] All existing tests pass unmodified
- [ ] New tests pass
- [ ] Zero `dart analyze` warnings
- [ ] Example app builds on Android, iOS, Web, macOS

---

## 11. Non-Goals

- Fluent widget renderers (stub only in this PRD)
- New DuskMoon themes beyond sunshine/moonlight
- `DmTheme` fields beyond `colors` (spacing, radius deferred)
- Changes to `duskmoon_theme_bloc` (already operates on string names; compatible as-is)
- Changes to `duskmoon_feedback` (no platform dispatch needed)

---

*End of PRD v1.2.0*