# DuskMoon UI for Flutter

[![CI](https://github.com/duskmoon-dev/flutter-duskmoon-ui/actions/workflows/ci.yml/badge.svg)](https://github.com/duskmoon-dev/flutter-duskmoon-ui/actions/workflows/ci.yml)
[![Deploy Pages](https://github.com/duskmoon-dev/flutter-duskmoon-ui/actions/workflows/deploy-pages.yml/badge.svg)](https://github.com/duskmoon-dev/flutter-duskmoon-ui/actions/workflows/deploy-pages.yml)

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

| Package | Description | pub.dev |
|---------|-------------|---------|
| [`duskmoon_theme`](packages/duskmoon_theme/) | Codegen-driven theme — Sunshine/Moonlight color schemes, 20 semantic color tokens, M3 text theme | [![pub package](https://img.shields.io/pub/v/duskmoon_theme.svg)](https://pub.dev/packages/duskmoon_theme) |
| [`duskmoon_theme_bloc`](packages/duskmoon_theme_bloc/) | BLoC for theme name + mode persistence via SharedPreferences | [![pub package](https://img.shields.io/pub/v/duskmoon_theme_bloc.svg)](https://pub.dev/packages/duskmoon_theme_bloc) |
| [`duskmoon_widgets`](packages/duskmoon_widgets/) | Adaptive widgets and chat components with Material/Cupertino rendering | [![pub package](https://img.shields.io/pub/v/duskmoon_widgets.svg)](https://pub.dev/packages/duskmoon_widgets) |
| [`duskmoon_settings`](packages/duskmoon_settings/) | Settings UI — 10 tile types, 3 platform renderers (Material/Cupertino/Fluent) | [![pub package](https://img.shields.io/pub/v/duskmoon_settings.svg)](https://pub.dev/packages/duskmoon_settings) |
| [`duskmoon_feedback`](packages/duskmoon_feedback/) | Adaptive dialogs, snackbars, toasts, bottom sheets | [![pub package](https://img.shields.io/pub/v/duskmoon_feedback.svg)](https://pub.dev/packages/duskmoon_feedback) |
| [`duskmoon_form`](packages/duskmoon_form/) | BLoC-based form management with 7 field types | [![pub package](https://img.shields.io/pub/v/duskmoon_form.svg)](https://pub.dev/packages/duskmoon_form) |
| [`duskmoon_visualization`](packages/duskmoon_visualization/) | Data visualization widgets | [![pub package](https://img.shields.io/pub/v/duskmoon_visualization.svg)](https://pub.dev/packages/duskmoon_visualization) |
| [`duskmoon_adaptive_scaffold`](packages/duskmoon_adaptive_scaffold/) | Adaptive scaffold with responsive nav (forked from flutter_adaptive_scaffold) | [![pub package](https://img.shields.io/pub/v/duskmoon_adaptive_scaffold.svg)](https://pub.dev/packages/duskmoon_adaptive_scaffold) |
| [`duskmoon_code_engine`](packages/duskmoon_code_engine/) | Pure Dart code editor — 19-language syntax highlighting, CodeMirror 6 architecture | [![pub package](https://img.shields.io/pub/v/duskmoon_code_engine.svg)](https://pub.dev/packages/duskmoon_code_engine) |
| [`duskmoon_ui`](packages/duskmoon_ui/) | Umbrella — single import for all above (except theme_bloc) | [![pub package](https://img.shields.io/pub/v/duskmoon_ui.svg)](https://pub.dev/packages/duskmoon_ui) |

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
**Chat:** `DmChatView`, `DmChatInput`, `DmChatBubble`, message/block models, attachments, tool calls

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

## Code Editor

A pure Dart code editor engine with 19-language syntax highlighting, built on a CodeMirror 6-inspired architecture:

```dart
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

CodeEditorWidget(
  initialCode: 'void main() => print("Hello!");',
  language: 'dart',
  theme: HighlightStyle.defaultStyle(),
);
```

Supported languages: Dart, JavaScript, TypeScript, Python, HTML, CSS, JSON, Markdown, Rust, Go, YAML, C, C++, Elixir, Java, Kotlin, PHP, Ruby, Erlang, Swift, Zig.

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
