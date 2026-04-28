# DuskMoon UI

A Flutter component library providing codegen-driven theming, adaptive widgets, platform-aware settings, feedback helpers, BLoC-based form management, and data visualization for Material 3 applications.

## Table of Contents

- [Quick Start](#quick-start)
- [Packages](#packages)
- [Guides](#guides)

## Quick Start

### Install the umbrella package

Add `duskmoon_ui` to your `pubspec.yaml` for access to the primary DuskMoon packages in a single import:

```yaml
dependencies:
  duskmoon_ui: ^1.6.0
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
| [`duskmoon_ui`](ui.md) | Umbrella — re-exports theme, widgets, settings, feedback, forms, visualization, theme BLoC, and code-engine primitives |
| [`duskmoon_theme`](theme.md) | Codegen-driven color schemes, text themes, and ThemeData factories |
| [`duskmoon_widgets`](widgets.md) | Adaptive widgets (Material / Cupertino / Fluent) plus markdown rendering, markdown input, chat, and code editor |
| [`duskmoon_settings`](settings.md) | Platform-aware settings UI (Material / Cupertino / Fluent) |
| [`duskmoon_feedback`](feedback.md) | Dialogs, snackbars, toasts, and bottom sheets |
| [`duskmoon_form`](form.md) | BLoC-based form state management with adaptive field builders |
| [`duskmoon_visualization`](visualization.md) | Data visualization: line, bar, scatter, heatmap, network graph, map chart |
| [`duskmoon_theme_bloc`](theme-bloc.md) | BLoC for persisting theme via SharedPreferences |
| [`duskmoon_adaptive_scaffold`](adaptive-scaffold.md) | Responsive scaffold with M3 adaptive layout and breakpoints; import directly |
| [`duskmoon_code_engine`](code-engine.md) | Pure Dart code editor engine with 19 language grammars |

### Individual installation

If you only need specific functionality:

```yaml
dependencies:
  duskmoon_theme: ^1.6.0      # Theme only
  duskmoon_widgets: ^1.6.0    # Adaptive widgets, markdown, chat
  duskmoon_settings: ^1.6.0   # Settings UI
  duskmoon_feedback: ^1.6.0   # Feedback helpers
  duskmoon_form: ^1.6.0            # BLoC-based form management
  duskmoon_visualization: ^1.6.0   # Data visualization charts
  duskmoon_theme_bloc: ^1.6.0      # BLoC persistence (requires flutter_bloc, shared_preferences)
  duskmoon_adaptive_scaffold: ^1.6.0  # Responsive scaffold (standalone)
  duskmoon_code_engine: ^1.6.0     # Code editor engine (standalone)
```

## Guides

- [Theme System](theme.md) — Color schemes, text themes, semantic color tokens, ThemeMode helpers
- [Umbrella Package](ui.md) — Single-import package exports and `DmEditorTheme`
- [Adaptive Widgets](widgets.md) — Platform-aware buttons, inputs, navigation, layout, chat, and data display
- [Settings UI](settings.md) — Cross-platform settings pages with 10 tile types
- [Feedback Helpers](feedback.md) — Adaptive dialogs, snackbars, toasts, and bottom sheets
- [Form Management](form.md) — BLoC-based forms with validation and adaptive field builders
- [Data Visualization](visualization.md) — Line, bar, scatter, heatmap, and network graph charts
- [Theme BLoC](theme-bloc.md) — Persistent theme switching with BLoC pattern
- [Adaptive Scaffold](adaptive-scaffold.md) — Responsive scaffold with breakpoints and slot-based layout
- [Code Engine](code-engine.md) — Pure Dart code editor with syntax highlighting for 19 languages
- [Architecture](architecture.md) — Package dependency graph, design decisions, and conventions
