# Umbrella Package

The `duskmoon_ui` package re-exports the main DuskMoon packages so app code can use one import for theme, widgets, settings, feedback, forms, visualization, and code-engine primitives.

## Table of Contents

- [Installation](#installation)
- [Exports](#exports)
- [DmEditorTheme](#dmeditortheme)
- [Example](#example)

## Installation

```yaml
dependencies:
  duskmoon_ui: ^1.6.0
```

```dart
import 'package:duskmoon_ui/duskmoon_ui.dart';
```

## Exports

The umbrella barrel directly exports:

| Export | Notes |
|--------|-------|
| `duskmoon_theme` | `DmThemeData`, color schemes, platform resolution |
| `duskmoon_theme_bloc` | Persistent theme selection BLoC |
| `duskmoon_widgets` | Adaptive widgets, markdown, chat, `DmCodeEditor` |
| `duskmoon_settings` | Platform-aware settings lists, sections, and tiles |
| `duskmoon_feedback` | Dialogs, snackbars, toasts, bottom sheets |
| `duskmoon_visualization` | Curated chart widgets and data models |
| `duskmoon_form` | Form BLoCs and adaptive form field builders |
| `duskmoon_code_engine` | Low-level editor engine APIs, exported with `DmCodeEditor` hidden |
| `DmEditorTheme` | Umbrella-only editor theme helpers |

`duskmoon_adaptive_scaffold` is not directly exported by `duskmoon_ui`. Import it separately when you need the low-level adaptive scaffold package:

```dart
import 'package:duskmoon_adaptive_scaffold/duskmoon_adaptive_scaffold.dart';
```

## DmEditorTheme

`DmEditorTheme` derives a code-engine `EditorTheme` from a Flutter `ThemeData`. Use it when you do not have a `BuildContext`, such as in tests, theme previews, or state-layer code.

```dart
final editorTheme = DmEditorTheme.fromTheme(DmThemeData.sunshine());
final lightEditor = DmEditorTheme.sunshine();
final darkEditor = DmEditorTheme.moonlight();
```

Constructor-style API:

| API | Returns | Description |
|-----|---------|-------------|
| `DmEditorTheme.fromTheme(ThemeData themeData)` | `EditorTheme` | Builds editor colors from a Flutter theme and optional `DmColorExtension` |
| `DmEditorTheme.sunshine()` | `EditorTheme` | Editor theme derived from `DmThemeData.sunshine()` |
| `DmEditorTheme.moonlight()` | `EditorTheme` | Editor theme derived from `DmThemeData.moonlight()` |

Inside widget build methods, prefer [`DmCodeEditorTheme.fromContext(context)`](widgets.md#dmcodeeditortheme).

## Example

```dart
import 'package:flutter/material.dart';
import 'package:duskmoon_ui/duskmoon_ui.dart';

class DuskMoonApp extends StatelessWidget {
  const DuskMoonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: DmThemeData.sunshine(),
      darkTheme: DmThemeData.moonlight(),
      home: Scaffold(
        appBar: DmAppBar(title: const Text('DuskMoon')),
        body: DmChatView(
          messages: const [],
          inputPlaceholder: 'Ask anything...',
          onSend: (markdown, attachments) {},
        ),
      ),
    );
  }
}
```
