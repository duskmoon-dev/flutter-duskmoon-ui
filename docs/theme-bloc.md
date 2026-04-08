# Theme BLoC

The `duskmoon_theme_bloc` package provides a BLoC for persisting theme selection and mode via SharedPreferences. It is **included in the umbrella `duskmoon_ui` package** (re-exported automatically) but can also be imported separately for a lighter dependency footprint.

## Table of Contents

- [Installation](#installation)
- [DmThemeBloc](#dmthemebloc)
- [Events](#events)
- [DmThemeState](#dmthemestate)
- [Complete Setup](#complete-setup)
- [Theme Picker Pattern](#theme-picker-pattern)

## Installation

```yaml
dependencies:
  duskmoon_theme_bloc: ^1.3.0
  duskmoon_theme: ^1.3.0
  flutter_bloc: ^9.0.0
  shared_preferences: ^2.3.0
```

```dart
import 'package:duskmoon_theme_bloc/duskmoon_theme_bloc.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart';
```

## DmThemeBloc

Manages theme name and `ThemeMode` with automatic SharedPreferences persistence.

On construction, the bloc restores any previously persisted theme name and mode. Changes are written to SharedPreferences immediately.

**Persisted keys:**
- `dm_theme_name` — theme name string (e.g., `'sunshine'`)
- `dm_theme_mode` — theme mode string (e.g., `'dark'`, `'light'`, `'system'`)

```dart
final prefs = await SharedPreferences.getInstance();
final themeBloc = DmThemeBloc(prefs: prefs);
```

## Events

### DmSetTheme

Change the active theme by name.

```dart
context.read<DmThemeBloc>().add(const DmSetTheme('duskmoon'));  // or 'ecotone'
```

### DmSetThemeMode

Change the theme mode.

```dart
context.read<DmThemeBloc>().add(const DmSetThemeMode(ThemeMode.dark));
context.read<DmThemeBloc>().add(const DmSetThemeMode(ThemeMode.light));
context.read<DmThemeBloc>().add(const DmSetThemeMode(ThemeMode.system));
```

## DmThemeState

Immutable state holding the current theme name and mode.

| Property | Type | Description |
|----------|------|-------------|
| `themeName` | `String` | Name of the selected theme |
| `themeMode` | `ThemeMode` | Current mode (light / dark / system) |

### Resolving theme data

```dart
final state = context.read<DmThemeBloc>().state;

// Get the DmThemeEntry (name + light + dark ThemeData)
final entry = state.entry;

// Resolve to a single ThemeData based on platform brightness
final brightness = MediaQuery.platformBrightnessOf(context);
final themeData = state.resolveTheme(brightness);
```

## Complete Setup

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:duskmoon_theme_bloc/duskmoon_theme_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.prefs});
  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DmThemeBloc(prefs: prefs),
      child: BlocBuilder<DmThemeBloc, DmThemeState>(
        builder: (context, state) {
          final entry = state.entry;
          return MaterialApp(
            theme: entry.light,
            darkTheme: entry.dark,
            themeMode: state.themeMode,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
```

## Theme Picker Pattern

A reusable widget for letting users choose a theme and mode:

```dart
class ThemePicker extends StatelessWidget {
  const ThemePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DmThemeBloc, DmThemeState>(
      builder: (context, state) {
        return Column(
          children: [
            // Theme selection
            for (final theme in DmThemeData.themes)
              RadioListTile<String>(
                title: Text(theme.name),
                value: theme.name,
                groupValue: state.themeName,
                onChanged: (name) {
                  if (name != null) {
                    context.read<DmThemeBloc>().add(DmSetTheme(name));
                  }
                },
              ),

            const Divider(),

            // Mode selection
            SegmentedButton<ThemeMode>(
              segments: [
                for (final mode in ThemeMode.values)
                  ButtonSegment(
                    value: mode,
                    label: Text(mode.title),
                    icon: mode.iconOutlined,
                  ),
              ],
              selected: {state.themeMode},
              onSelectionChanged: (modes) {
                context.read<DmThemeBloc>().add(
                      DmSetThemeMode(modes.first),
                    );
              },
            ),
          ],
        );
      },
    );
  }
}
```

This pattern integrates with the [`ThemeModeExtension`](theme.md#thememodeextension) helpers for display titles and icons.
