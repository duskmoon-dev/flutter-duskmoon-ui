# duskmoon_ui

Umbrella package for the DuskMoon Design System. Re-exports all workspace packages in a single import.

## Installation

```bash
flutter pub add duskmoon_ui
```

## Usage

```dart
import 'package:duskmoon_ui/duskmoon_ui.dart';

// Access everything: theme, widgets, chat, settings, feedback, bloc, forms
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
| [`duskmoon_widgets`](https://pub.dev/packages/duskmoon_widgets) | Adaptive Material/Cupertino widgets and chat components |
| [`duskmoon_settings`](https://pub.dev/packages/duskmoon_settings) | Settings UI with 3 platform renderers |
| [`duskmoon_feedback`](https://pub.dev/packages/duskmoon_feedback) | Dialogs, snackbars, toasts, bottom sheets |
| [`duskmoon_theme_bloc`](https://pub.dev/packages/duskmoon_theme_bloc) | Theme persistence BLoC with SharedPreferences support |
| [`duskmoon_form`](https://pub.dev/packages/duskmoon_form) | Form state management and adaptive form widgets |

## License

MIT
