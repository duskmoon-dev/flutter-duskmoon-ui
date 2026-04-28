# Theme System

The `duskmoon_theme` package provides codegen-driven color schemes, a Material 3 text theme, and complete `ThemeData` factories. All colors come from generated design tokens — no runtime color computation.

## Table of Contents

- [Installation](#installation)
- [DmThemeData](#dmthemedata)
- [DmThemeEntry](#dmthemeentry)
- [DmTheme](#dmtheme)
- [DmColors](#dmcolors)
- [DmColorScheme](#dmcolorscheme)
- [DmColorExtension](#dmcolorextension)
- [DmTextTheme](#dmtexttheme)
- [ThemeModeExtension](#thememodeextension)
- [Adaptive Platform System](#adaptive-platform-system)
- [Generated Tokens](#generated-tokens)

## Installation

```yaml
dependencies:
  duskmoon_theme: ^1.6.0
```

```dart
import 'package:duskmoon_theme/duskmoon_theme.dart';
```

Or use the umbrella package `duskmoon_ui` which re-exports everything.

## DmThemeData

Factory class (`abstract final`) that builds complete Material 3 `ThemeData` instances with color scheme, text theme, component theme overrides, and the `DmColorExtension`.

```dart
MaterialApp(
  theme: DmThemeData.sunshine(),      // Light theme
  darkTheme: DmThemeData.moonlight(), // Dark theme
  themeMode: ThemeMode.system,
);
```

### Theme factories

| Method | Brightness | Family |
|--------|-----------|--------|
| `DmThemeData.sunshine()` | light | duskmoon |
| `DmThemeData.moonlight()` | dark | duskmoon |
| `DmThemeData.forest()` | light | ecotone |
| `DmThemeData.ocean()` | dark | ecotone |

Component themes configured automatically:
- AppBar, NavigationRail, NavigationBar
- Card, Divider, InputDecoration, Chip

### Available themes

```dart
final themes = DmThemeData.themes;
// Returns: [
//   DmThemeEntry(name: 'duskmoon', light: sunshine, dark: moonlight),
//   DmThemeEntry(name: 'ecotone', light: forest, dark: ocean),
// ]

// Build from a DmTheme token container:
final themeData = DmThemeData.fromDmTheme(DmTheme.sunshine);
```

### fromDmTheme factory

`DmThemeData.fromDmTheme(DmTheme theme)` builds a complete `ThemeData` from a `DmTheme` token container. This is the bridge between the platform-agnostic token layer and Flutter's `ThemeData`.

```dart
final themeData = DmThemeData.fromDmTheme(DmTheme.sunshine);
```

## DmThemeEntry

Bundles a named theme with its light and dark `ThemeData` variants. Useful for building theme pickers.

```dart
for (final entry in DmThemeData.themes) {
  print(entry.name);   // 'duskmoon' or 'ecotone'
  // entry.light — light ThemeData
  // entry.dark  — dark ThemeData
}
```

## DmTheme

Platform-agnostic token container that holds color tokens without coupling to Flutter's `ThemeData`. Use `DmTheme` when you need renderer-agnostic access to the design tokens, or pass it to `DmThemeData.fromDmTheme()` to produce a full `ThemeData`.

| Member | Type | Description |
|--------|------|-------------|
| `name` | `String` | Theme name (`'sunshine'`, `'moonlight'`, `'forest'`, or `'ocean'`) |
| `colors` | `DmColors` | Bundled color scheme and semantic extension tokens |
| `DmTheme.sunshine` | `static final` | Pre-built light token set (duskmoon family) |
| `DmTheme.moonlight` | `static final` | Pre-built dark token set (duskmoon family) |
| `DmTheme.forest` | `static final` | Pre-built light token set (ecotone family) |
| `DmTheme.ocean` | `static final` | Pre-built dark token set (ecotone family) |
| `DmTheme.all` | `static List<DmTheme>` | Unmodifiable list containing all four themes |

### Usage

```dart
// Access pre-built token sets:
final light = DmTheme.sunshine;   // or DmTheme.forest
final dark = DmTheme.moonlight;   // or DmTheme.ocean

// Iterate all themes (useful for theme pickers):
for (final theme in DmTheme.all) {
  print(theme.name);                        // 'sunshine', 'moonlight', 'forest', or 'ocean'
  print(theme.colors.colorScheme.primary);   // Color
  print(theme.colors.extension.accent);      // Color
}

// Build ThemeData from a DmTheme:
final themeData = DmThemeData.fromDmTheme(DmTheme.sunshine);
```

## DmColors

Immutable (`@immutable`) container that bundles a `ColorScheme` and a `DmColorExtension` into a single object. This is the color half of `DmTheme`.

| Member | Type | Description |
|--------|------|-------------|
| `colorScheme` | `ColorScheme` | Standard Material 3 color roles |
| `extension` | `DmColorExtension` | 28 DuskMoon semantic tokens |
| `DmColors.sunshine()` | factory | Light color token bag (duskmoon) |
| `DmColors.moonlight()` | factory | Dark color token bag (duskmoon) |
| `DmColors.forest()` | factory | Light color token bag (ecotone) |
| `DmColors.ocean()` | factory | Dark color token bag (ecotone) |

### Usage

```dart
final colors = DmColors.sunshine();
colors.colorScheme.primary    // Standard Material 3 color
colors.extension.accent        // DuskMoon semantic token

// Or construct a fully custom instance:
final custom = DmColors(
  colorScheme: myColorScheme,
  extension: myDmColorExtension,
);
```

## DmColorScheme

Factory class that builds `ColorScheme` instances from generated tokens. Use this when you need a raw `ColorScheme` without the full `ThemeData` wrapper.

```dart
final lightColors = DmColorScheme.sunshine();  // Brightness.light
final darkColors = DmColorScheme.moonlight();  // Brightness.dark
final forestLight = DmColorScheme.forest();    // Brightness.light
final oceanDark = DmColorScheme.ocean();       // Brightness.dark
```

All standard Material 3 color roles are populated: `primary`, `onPrimary`, `primaryContainer`, `secondary`, `tertiary`, `error`, `surface`, `outline`, and all surface container variants.

## DmColorExtension

A `ThemeExtension` carrying 28 semantic color tokens not covered by the standard `ColorScheme`. Access it from any widget:

```dart
final dm = Theme.of(context).extension<DmColorExtension>()!;
```

### Available tokens

| Category | Tokens |
|----------|--------|
| Accent | `accent`, `accentContent` |
| Neutral | `neutral`, `neutralContent`, `neutralVariant` |
| Surface | `surfaceVariant` |
| Info status | `info`, `infoContent`, `infoContainer`, `onInfoContainer` |
| Success status | `success`, `successContent`, `successContainer`, `onSuccessContainer` |
| Warning status | `warning`, `warningContent`, `warningContainer`, `onWarningContainer` |
| Base surfaces | `base100` through `base900`, `baseContent` |

### Usage example

```dart
final dm = Theme.of(context).extension<DmColorExtension>()!;

Container(
  color: dm.base100,
  child: Text(
    'Status: OK',
    style: TextStyle(color: dm.success),
  ),
);

// Semantic status containers:
Container(
  color: dm.infoContainer,
  child: Text('Info', style: TextStyle(color: dm.onInfoContainer)),
);
```

### Factory methods

```dart
DmColorExtension.sunshine()   // Light tokens (duskmoon family)
DmColorExtension.moonlight()  // Dark tokens (duskmoon family)
DmColorExtension.forest()     // Light tokens (ecotone family)
DmColorExtension.ocean()      // Dark tokens (ecotone family)
```

You can also construct a fully custom instance by passing all 28 required color parameters:

```dart
const DmColorExtension(
  accent: Color(0xFF...),
  accentContent: Color(0xFF...),
  // ... all 28 parameters required
)
```

`ThemeExtension` methods:

```dart
// Copy with overrides (useful for testing or one-off customization)
final modified = dm.copyWith(accent: Colors.purple, success: Colors.teal);

// Lerp between two extensions (used by Flutter for animated theme transitions)
final interpolated = dm.lerp(otherExtension, 0.5);
```

## DmTextTheme

Factory that returns a `TextTheme` with the exact Material 3 type scale:

```dart
final textTheme = DmTextTheme.textTheme();
```

| Style | Size | Weight |
|-------|------|--------|
| displayLarge | 57sp | w400 |
| displayMedium | 45sp | w400 |
| displaySmall | 36sp | w400 |
| headlineLarge | 32sp | w400 |
| headlineMedium | 28sp | w400 |
| headlineSmall | 24sp | w400 |
| titleLarge | 22sp | w400 |
| titleMedium | 16sp | w500 |
| titleSmall | 14sp | w500 |
| bodyLarge | 16sp | w400 |
| bodyMedium | 14sp | w400 |
| bodySmall | 12sp | w400 |
| labelLarge | 14sp | w500 |
| labelMedium | 12sp | w500 |
| labelSmall | 11sp | w500 |

## ThemeModeExtension

Convenience extension on Flutter's `ThemeMode` enum for serialization and UI display.

### Parsing

```dart
ThemeModeExtension.fromString('dark');   // ThemeMode.dark
ThemeModeExtension.fromString('light');  // ThemeMode.light
ThemeModeExtension.fromString(null);     // ThemeMode.system (default)
```

### Display helpers

```dart
ThemeMode.dark.title           // 'Dark'
ThemeMode.light.title          // 'Light'
ThemeMode.system.title         // 'System'

ThemeMode.dark.icon            // Icon(Icons.dark_mode)
ThemeMode.light.iconOutlined   // Icon(Icons.light_mode_outlined)
ThemeMode.system.icon          // Icon(Icons.brightness_auto)
```

## Adaptive Platform System

The theme package exports a platform resolution system used by `duskmoon_widgets` and other adaptive packages. It determines whether a widget should render in Material, Cupertino, or Fluent style based on a four-level priority chain.

### DmPlatformStyle

An enum representing the three supported rendering styles:

| Value | Description |
|-------|-------------|
| `DmPlatformStyle.material` | Google Material Design |
| `DmPlatformStyle.cupertino` | Apple Cupertino |
| `DmPlatformStyle.fluent` | Microsoft Fluent Design |

### DuskmoonApp

An `InheritedWidget` that declares a default `DmPlatformStyle` for the entire widget tree. Place it above `MaterialApp` or `CupertinoApp`.

```dart
DuskmoonApp(
  platformStyle: DmPlatformStyle.cupertino,
  child: MaterialApp(home: MyHome()),
);
```

When `platformStyle` is null (or `DuskmoonApp` is absent), adaptive widgets fall through to platform-default detection. Query the current value from any descendant with `DuskmoonApp.maybeStyleOf(context)`.

### DmPlatformOverride

An `InheritedWidget` that overrides the platform style for a subtree. This takes priority over `DuskmoonApp` but is overridden by a widget's own `platformOverride` parameter.

```dart
// Force Material rendering in this subtree, regardless of DuskmoonApp setting:
DmPlatformOverride(
  style: DmPlatformStyle.material,
  child: MyWidgetSubtree(),
);
```

Query with `DmPlatformOverride.maybeOf(context)`.

### AdaptiveWidget mixin

A mixin on `StatelessWidget` that provides the `resolveStyle(BuildContext context)` method. Widgets using this mixin call `resolveStyle` in their `build()` method to determine which rendering path to take.

The mixin exposes a `platformOverride` getter (defaults to null) that subclasses can override to accept a per-widget platform parameter.

```dart
class MyButton extends StatelessWidget with AdaptiveWidget {
  const MyButton({super.key, this.platformOverride});

  @override
  final DmPlatformStyle? platformOverride;

  @override
  Widget build(BuildContext context) {
    switch (resolveStyle(context)) {
      case DmPlatformStyle.material:
        return ElevatedButton(onPressed: () {}, child: Text('Material'));
      case DmPlatformStyle.cupertino:
        return CupertinoButton.filled(onPressed: () {}, child: Text('Cupertino'));
      case DmPlatformStyle.fluent:
        return ElevatedButton(onPressed: () {}, child: Text('Fluent'));
    }
  }
}
```

### resolvePlatformStyle function

The standalone function that implements the resolution chain. `AdaptiveWidget.resolveStyle` delegates to this function.

```dart
DmPlatformStyle resolvePlatformStyle(
  BuildContext context, {
  DmPlatformStyle? widgetOverride,
})
```

Resolution order:

1. **widgetOverride** -- per-widget parameter (highest priority)
2. **DmPlatformOverride** -- nearest ancestor `InheritedWidget`
3. **DuskmoonApp** -- app-level `InheritedWidget`
4. **Platform default** -- derived from `Theme.of(context).platform`: iOS/macOS maps to `cupertino`, Windows maps to `fluent`, all others map to `material`

### Example: mixed platforms in one app

```dart
DuskmoonApp(
  platformStyle: DmPlatformStyle.cupertino,
  child: MaterialApp(
    home: Column(children: [
      // Uses cupertino (from DuskmoonApp)
      MyButton(),

      // Uses material (DmPlatformOverride overrides DuskmoonApp)
      DmPlatformOverride(
        style: DmPlatformStyle.material,
        child: MyButton(),
      ),

      // Uses fluent (per-widget override overrides everything)
      MyButton(platformOverride: DmPlatformStyle.fluent),
    ]),
  ),
);
```

## Generated Tokens

For direct access to raw color constants:

```dart
import 'package:duskmoon_theme/duskmoon_theme.dart';

// Duskmoon family
SunshineTokens.primary          // const Color(...) — light
MoonlightTokens.primary         // const Color(...) — dark

// Ecotone family
ForestTokens.primary            // const Color(...) — light
OceanTokens.primary             // const Color(...) — dark
```

All tokens are `const Color` values. See [`architecture.md`](architecture.md) for how tokens are generated.
