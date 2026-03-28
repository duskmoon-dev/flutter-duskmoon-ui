# duskmoon_theme

Codegen-driven Flutter theme package for the DuskMoon Design System. Provides complete `ThemeData` with color schemes, text themes, and semantic color extensions — zero external dependencies.

## Installation

```bash
flutter pub add duskmoon_theme
```

## Usage

```dart
import 'package:duskmoon_theme/duskmoon_theme.dart';

MaterialApp(
  theme: DmThemeData.sunshine(),       // Light theme
  darkTheme: DmThemeData.moonlight(),  // Dark theme
);
```

### Color Schemes

`DmColorScheme` provides `ColorScheme` factory methods generated from design tokens:

```dart
final colorScheme = DmColorScheme.sunshine(); // or .moonlight()
```

### Semantic Color Extension

Access 20 additional semantic tokens via `DmColorExtension`:

```dart
final dmColors = Theme.of(context).extension<DmColorExtension>()!;
final info = dmColors.info;
final success = dmColors.success;
final warning = dmColors.warning;
```

### Text Theme

`DmTextTheme` provides a Material 3 type scale:

```dart
final textTheme = DmTextTheme.textTheme();
```

### Theme Mode Helpers

```dart
final mode = ThemeModeExtension.fromString('dark'); // ThemeMode.dark
final title = ThemeMode.dark.title;  // 'Dark'
final icon = ThemeMode.dark.icon;    // Icons.dark_mode
```

## License

MIT
