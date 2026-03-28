# duskmoon_settings

Settings UI for the DuskMoon Design System with Material, Cupertino, and Fluent platform renderers.

## Installation

```bash
flutter pub add duskmoon_settings
```

## Usage

```dart
import 'package:duskmoon_settings/duskmoon_settings.dart';

SettingsList(
  sections: [
    SettingsSection(
      title: const Text('General'),
      tiles: [
        SettingsTile.switchTile(
          title: const Text('Dark Mode'),
          initialValue: isDark,
          onToggle: (value) {},
          leading: const Icon(Icons.dark_mode),
        ),
        SettingsTile.navigation(
          title: const Text('Language'),
          value: const Text('English'),
          leading: const Icon(Icons.language),
          onPressed: (context) {},
        ),
      ],
    ),
  ],
);
```

### Platform Rendering

The settings list automatically renders in the appropriate platform style. Override with `DevicePlatform`:

```dart
SettingsList(
  platform: DevicePlatform.iOS,  // Force Cupertino style
  sections: [...],
);
```

### Theme Integration

When used with `duskmoon_theme`, the settings UI automatically picks up `DmColorExtension` semantic colors for background, section headers, and tile colors.

## License

MIT
