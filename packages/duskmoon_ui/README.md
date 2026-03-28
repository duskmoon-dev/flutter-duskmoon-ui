# duskmoon_ui

Umbrella package for the DuskMoon Design System. Re-exports all core packages in a single import.

## Installation

```bash
flutter pub add duskmoon_ui
```

## Usage

```dart
import 'package:duskmoon_ui/duskmoon_ui.dart';

// Access everything: theme, widgets, settings, feedback
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

## Included Packages

| Package | Description |
|---------|-------------|
| [`duskmoon_theme`](https://pub.dev/packages/duskmoon_theme) | Codegen-driven theme with color schemes and extensions |
| [`duskmoon_widgets`](https://pub.dev/packages/duskmoon_widgets) | 18 adaptive Material/Cupertino widgets |
| [`duskmoon_settings`](https://pub.dev/packages/duskmoon_settings) | Settings UI with 3 platform renderers |
| [`duskmoon_feedback`](https://pub.dev/packages/duskmoon_feedback) | Dialogs, snackbars, toasts, bottom sheets |

> **Note:** `duskmoon_theme_bloc` is intentionally excluded — add it separately if you use BLoC for theme persistence.

## License

MIT
