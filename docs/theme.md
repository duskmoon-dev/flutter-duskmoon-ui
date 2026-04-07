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
- [Generated Tokens](#generated-tokens)

## Installation

```yaml
dependencies:
  duskmoon_theme: ^1.2.3
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

Component themes configured automatically:
- AppBar, NavigationRail, NavigationBar
- Card, Divider, InputDecoration, Chip

### Available themes

```dart
final themes = DmThemeData.themes;
// Returns: [DmThemeEntry(name: 'sunshine', light: ..., dark: ...)]

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
  print(entry.name);   // 'sunshine'
  // entry.light — light ThemeData
  // entry.dark  — dark ThemeData
}
```

## DmTheme

Platform-agnostic token container that holds color tokens without coupling to Flutter's `ThemeData`. Use `DmTheme` when you need renderer-agnostic access to the design tokens, or pass it to `DmThemeData.fromDmTheme()` to produce a full `ThemeData`.

| Member | Type | Description |
|--------|------|-------------|
| `name` | `String` | Human-readable theme name (`'sunshine'` or `'moonlight'`) |
| `colors` | `DmColors` | Bundled color scheme and semantic extension tokens |
| `DmTheme.sunshine` | `static final` | Pre-built light token set |
| `DmTheme.moonlight` | `static final` | Pre-built dark token set |
| `DmTheme.all` | `static List<DmTheme>` | Unmodifiable list containing both themes |

### Usage

```dart
// Access pre-built token sets:
final light = DmTheme.sunshine;
final dark = DmTheme.moonlight;

// Iterate all themes (useful for theme pickers):
for (final theme in DmTheme.all) {
  print(theme.name);                        // 'sunshine' or 'moonlight'
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
| `extension` | `DmColorExtension` | 20 DuskMoon semantic tokens |
| `DmColors.sunshine()` | factory | Light color token bag |
| `DmColors.moonlight()` | factory | Dark color token bag |

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
```

All standard Material 3 color roles are populated: `primary`, `onPrimary`, `primaryContainer`, `secondary`, `tertiary`, `error`, `surface`, `outline`, and all surface container variants.

## DmColorExtension

A `ThemeExtension` carrying 20 semantic color tokens not covered by the standard `ColorScheme`. Access it from any widget:

```dart
final dmColors = Theme.of(context).extension<DmColorExtension>()!;
```

### Available tokens

| Category | Tokens |
|----------|--------|
| Focus variants | `primaryFocus`, `secondaryFocus`, `tertiaryFocus` |
| Accent | `accent`, `accentFocus`, `accentContent` |
| Neutral | `neutral`, `neutralFocus`, `neutralContent`, `neutralVariant` |
| Status | `info`, `infoContent`, `success`, `successContent`, `warning`, `warningContent` |
| Base surfaces | `base100`, `base200`, `base300`, `baseContent` |

### Usage example

```dart
final dmColors = Theme.of(context).extension<DmColorExtension>()!;

Container(
  color: dmColors.base100,
  child: Text(
    'Status: OK',
    style: TextStyle(color: dmColors.success),
  ),
);
```

### Factory methods

```dart
DmColorExtension.sunshine()   // Light tokens
DmColorExtension.moonlight()  // Dark tokens
```

You can also construct a fully custom instance by passing all 20 required color parameters:

```dart
const DmColorExtension(
  primaryFocus: Color(0xFF...),
  accent: Color(0xFF...),
  // ... all 20 parameters required
)
```

`ThemeExtension` methods:

```dart
// Copy with overrides (useful for testing or one-off customization)
final modified = dmColors.copyWith(accent: Colors.purple, success: Colors.teal);

// Lerp between two extensions (used by Flutter for animated theme transitions)
final interpolated = dmColors.lerp(otherExtension, 0.5);
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

## Generated Tokens

For direct access to raw color constants:

```dart
import 'package:duskmoon_theme/duskmoon_theme.dart';

// Light palette
SunshineTokens.primary          // const Color(...)
SunshineTokens.info
SunshineTokens.success

// Dark palette
MoonlightTokens.primary
MoonlightTokens.surface
```

All tokens are `const Color` values. See [`architecture.md`](architecture.md) for how tokens are generated.
