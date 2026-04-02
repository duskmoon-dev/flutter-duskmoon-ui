# DuskMoon UI

A Flutter component library providing codegen-driven theming, adaptive widgets, platform-aware settings, feedback helpers, and BLoC-based form management for Material 3 applications.

## Table of Contents

- [Quick Start](#quick-start)
- [Packages](#packages)
- [Guides](#guides)

## Quick Start

### Install the umbrella package

Add `duskmoon_ui` to your `pubspec.yaml` for access to all components in a single import:

```yaml
dependencies:
  duskmoon_ui: ^1.0.3
```

```dart
import 'package:duskmoon_ui/duskmoon_ui.dart';
```

> **Requirements:** Dart >= 3.5.0, Flutter >= 3.24.0

### Minimal app

```dart
import 'package:flutter/material.dart';
import 'package:duskmoon_ui/duskmoon_ui.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: DmThemeData.sunshine(),
      darkTheme: DmThemeData.moonlight(),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DmAppBar(title: const Text('DuskMoon App')),
      body: Center(
        child: DmButton(
          onPressed: () => showDmSuccessToast(
            context: context,
            message: 'Hello from DuskMoon!',
          ),
          child: const Text('Tap me'),
        ),
      ),
    );
  }
}
```

## Packages

| Package | Description |
|---------|-------------|
| [`duskmoon_ui`](https://pub.dev/packages/duskmoon_ui) | Umbrella — re-exports all packages below |
| [`duskmoon_theme`](theme.md) | Codegen-driven color schemes, text themes, and ThemeData factories |
| [`duskmoon_widgets`](widgets.md) | 18 adaptive widgets (Material / Cupertino) |
| [`duskmoon_settings`](settings.md) | Platform-aware settings UI (Material / Cupertino / Fluent) |
| [`duskmoon_feedback`](feedback.md) | Dialogs, snackbars, toasts, and bottom sheets |
| [`duskmoon_form`](form.md) | BLoC-based form state management with 11 widget builders |
| [`duskmoon_theme_bloc`](theme-bloc.md) | BLoC for persisting theme via SharedPreferences |

### Individual installation

If you only need specific functionality:

```yaml
dependencies:
  duskmoon_theme: ^1.0.3      # Theme only
  duskmoon_widgets: ^1.0.3    # Adaptive widgets
  duskmoon_settings: ^1.0.3   # Settings UI
  duskmoon_feedback: ^1.0.3   # Feedback helpers
  duskmoon_form: ^1.0.3       # BLoC-based form management
  duskmoon_theme_bloc: ^1.0.3 # BLoC persistence (requires flutter_bloc, shared_preferences)
```

## Guides

- [Theme System](theme.md) — Color schemes, text themes, semantic color tokens, ThemeMode helpers
- [Adaptive Widgets](widgets.md) — Platform-aware buttons, inputs, navigation, layout, and data display
- [Settings UI](settings.md) — Cross-platform settings pages with 10 tile types
- [Feedback Helpers](feedback.md) — Adaptive dialogs, snackbars, toasts, and bottom sheets
- [Form Management](form.md) — BLoC-based forms with validation and 11 widget builders
- [Theme BLoC](theme-bloc.md) — Persistent theme switching with BLoC pattern
- [Architecture](architecture.md) — Package dependency graph, design decisions, and conventions
