# DuskMoon UI for Flutter

A Flutter component library implementing the [DuskMoon Design System](https://github.com/duskmoon-dev). Codegen-driven theming, adaptive widgets, platform-aware settings UI, and feedback helpers — all in a Melos-managed monorepo.

[Live Demo](https://duskmoon-dev.github.io/flutter-duskmoon-ui/) | [API Reference](https://pub.dev/packages/duskmoon_ui)

## Quick Start

```dart
import 'package:duskmoon_ui/duskmoon_ui.dart';

MaterialApp(
  theme: DmThemeData.sunshine(),
  darkTheme: DmThemeData.moonlight(),
  home: Scaffold(
    appBar: const DmAppBar(title: Text('My App')),
    body: DmButton(
      onPressed: () => showDmSuccessToast(
        context: context,
        message: 'Hello DuskMoon!',
      ),
      child: const Text('Tap me'),
    ),
  ),
);
```

## Packages

| Package | Description |
|---------|-------------|
| [`duskmoon_theme`](packages/duskmoon_theme/) | Codegen-driven theme — Sunshine/Moonlight color schemes, 20 semantic color tokens, M3 text theme |
| [`duskmoon_theme_bloc`](packages/duskmoon_theme_bloc/) | BLoC for theme name + mode persistence via SharedPreferences |
| [`duskmoon_widgets`](packages/duskmoon_widgets/) | 18 adaptive widgets with Material/Cupertino rendering |
| [`duskmoon_settings`](packages/duskmoon_settings/) | Settings UI — 10 tile types, 3 platform renderers (Material/Cupertino/Fluent) |
| [`duskmoon_feedback`](packages/duskmoon_feedback/) | Adaptive dialogs, snackbars, toasts, bottom sheets |
| [`duskmoon_ui`](packages/duskmoon_ui/) | Umbrella — single import for all above (except theme_bloc) |

## Installation

Use the umbrella package for everything:

```bash
flutter pub add duskmoon_ui
```

Or install individual packages:

```bash
flutter pub add duskmoon_theme
flutter pub add duskmoon_widgets
```

For theme persistence with BLoC (opt-in, not included in umbrella):

```bash
flutter pub add duskmoon_theme_bloc
```

## Theme System

Colors are generated from design tokens — no `ColorScheme.fromSeed()`, no runtime color generation.

```dart
// Complete ThemeData with component themes
final light = DmThemeData.sunshine();
final dark = DmThemeData.moonlight();

// Access 20 semantic colors beyond ColorScheme
final dmColors = Theme.of(context).extension<DmColorExtension>()!;
dmColors.info;     // Info blue
dmColors.success;  // Success green
dmColors.warning;  // Warning amber
```

## Adaptive Widgets

Widgets auto-switch between Material and Cupertino based on platform. Override at any level:

```dart
// App-level override
DmPlatformOverride(
  style: DmPlatformStyle.cupertino,
  child: MyApp(),
);

// Per-widget override
DmButton(
  platformOverride: DmPlatformStyle.material,
  onPressed: () {},
  child: Text('Always Material'),
);
```

### Widget Catalog

**Buttons:** `DmButton` (filled/outlined/text/tonal), `DmIconButton`, `DmFab`
**Inputs:** `DmTextField`, `DmCheckbox`, `DmSwitch`, `DmSlider`
**Layout:** `DmCard`, `DmDivider`
**Navigation:** `DmScaffold` (responsive rail/bottom nav), `DmAppBar`, `DmBottomNav`, `DmTabBar`, `DmDrawer`
**Data Display:** `DmBadge`, `DmChip`, `DmAvatar`
**Scaffold:** `DmActionList` (popup/icon/text button modes)

## Settings UI

10 tile types with Material, Cupertino, and Fluent renderers:

```dart
SettingsList(
  sections: [
    SettingsSection(
      title: Text('Account'),
      tiles: [
        SettingsTile.navigation(
          leading: Icon(Icons.person),
          title: Text('Profile'),
        ),
        SettingsTile.switchTile(
          title: Text('Notifications'),
          initialValue: true,
          onToggle: (v) {},
        ),
      ],
    ),
  ],
);
```

## Development

Requires Dart >=3.5.0 and Flutter >=3.24.0.

```bash
dart pub get              # Install dependencies
melos run analyze         # Lint all packages
melos run test            # Test all packages
melos run format          # Check formatting
```

## License

MIT
