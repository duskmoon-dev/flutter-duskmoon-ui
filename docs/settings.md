# Settings UI

The `duskmoon_settings` package provides platform-aware settings pages with three design system renderers: Material, Cupertino, and Fluent.

## Table of Contents

- [Installation](#installation)
- [Overview](#overview)
- [SettingsList](#settingslist)
- [SettingsSection](#settingssection)
- [SettingsTile](#settingstile)
- [SettingsOption](#settingsoption)
- [Platform Detection](#platform-detection)
- [Theming](#theming)
- [Complete Example](#complete-example)

## Installation

```yaml
dependencies:
  duskmoon_settings: ^1.4.0
```

```dart
import 'package:duskmoon_settings/duskmoon_settings.dart';
```

Or use the umbrella `duskmoon_ui` package.

> This package depends on `duskmoon_theme` for color integration.

## Overview

The settings UI uses a compositor pattern. Each widget auto-detects the platform and delegates to the correct renderer:

| Platform | Renderer |
|----------|----------|
| Android, Linux, Web, Fuchsia | Material |
| iOS, macOS | Cupertino |
| Windows | Fluent |

The three main building blocks:
- **`SettingsList`** — scrollable container
- **`SettingsSection`** — groups tiles under an optional title
- **`SettingsTile`** — individual setting items (10 types via named constructors)

## SettingsList

Top-level scrollable container.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `sections` | `List<AbstractSettingsSection>` | required | The settings sections |
| `shrinkWrap` | `bool` | `false` | Whether to shrink-wrap content |
| `physics` | `ScrollPhysics?` | `null` | Custom scroll physics |
| `platform` | `DevicePlatform?` | `null` | Override detected platform |
| `contentPadding` | `EdgeInsetsGeometry?` | `null` | Content padding |

```dart
SettingsList(
  sections: [
    SettingsSection(
      title: const Text('General'),
      tiles: [...],
    ),
  ],
)
```

## SettingsSection

Groups tiles under an optional title widget.

| Parameter | Type | Description |
|-----------|------|-------------|
| `tiles` | `List<AbstractSettingsTile>` | The tiles in this section |
| `title` | `Widget?` | Section header |
| `margin` | `EdgeInsetsDirectional?` | Section margin |

## SettingsTile

The primary UI element. Provides 10 named constructors for different input types.

### Simple tile

A basic tile with a title, optional value, and tap handler.

```dart
SettingsTile(
  title: const Text('About'),
  leading: const Icon(Icons.info),
  description: const Text('App version info'),
  value: const Text('v1.0.1'),
  trailing: const Icon(Icons.chevron_right),
  onPressed: (context) {},
  enabled: true,
)
```

### Navigation tile

Like a simple tile, but with a trailing chevron indicator.

```dart
SettingsTile.navigation(
  title: const Text('Privacy Policy'),
  leading: const Icon(Icons.privacy_tip),
  onPressed: (context) => Navigator.pushNamed(context, '/privacy'),
)
```

### Switch tile

A tile with an integrated toggle switch.

```dart
SettingsTile.switchTile(
  title: const Text('Dark Mode'),
  leading: const Icon(Icons.dark_mode),
  initialValue: isDarkMode,
  onToggle: (value) => setState(() => isDarkMode = value),
  activeSwitchColor: Colors.green,
)
```

### Check tile

A tile with a checkmark indicator.

```dart
SettingsTile.checkTile(
  title: const Text('Option A'),
  checked: isSelected,
  onPressed: (context) => setState(() => isSelected = !isSelected),
)
```

### Input tile

Single-line text input.

```dart
SettingsTile.input(
  title: const Text('Username'),
  inputValue: username,
  onInputChanged: (value) => setState(() => username = value),
  inputHint: 'Enter username',
  inputKeyboardType: TextInputType.text,
  inputMaxLength: 30,
)
```

### Slider tile

Numeric value selection.

```dart
SettingsTile.slider(
  title: const Text('Volume'),
  sliderValue: volume,
  onSliderChanged: (value) => setState(() => volume = value),
  sliderMin: 0,
  sliderMax: 100,
  sliderDivisions: 10,
)
```

### Select tile

Dropdown/picker for option selection.

```dart
SettingsTile.select(
  title: const Text('Theme'),
  options: [
    SettingsOption(value: 'light', label: 'Light'),
    SettingsOption(value: 'dark', label: 'Dark'),
    SettingsOption(value: 'system', label: 'System'),
  ],
  selectValue: selectedTheme,
  onSelectChanged: (value) => setState(() => selectedTheme = value),
)
```

### Textarea tile

Multi-line text input.

```dart
SettingsTile.textarea(
  title: const Text('Bio'),
  textareaValue: bio,
  onTextareaChanged: (value) => setState(() => bio = value),
  textareaHint: 'Tell us about yourself',
  textareaMaxLines: 5,
  textareaMaxLength: 500,
)
```

### Radio group tile

Single selection from a group of options.

```dart
SettingsTile.radioGroup(
  title: const Text('Color'),
  options: [
    SettingsOption(value: 'red', label: 'Red'),
    SettingsOption(value: 'blue', label: 'Blue'),
    SettingsOption(value: 'green', label: 'Green'),
  ],
  radioValue: selectedColor,
  onRadioChanged: (value) => setState(() => selectedColor = value),
)
```

### Checkbox group tile

Multiple selection from a group of options.

```dart
SettingsTile.checkboxGroup(
  title: const Text('Notifications'),
  options: [
    SettingsOption(value: 'email', label: 'Email'),
    SettingsOption(value: 'push', label: 'Push'),
    SettingsOption(value: 'sms', label: 'SMS'),
  ],
  checkboxValues: selectedNotifications,  // Set<String>
  onCheckboxChanged: (values) => setState(() => selectedNotifications = values),
)
```

### Custom tile

For fully custom content, use `CustomSettingsTile`:

```dart
CustomSettingsTile(child: MyCustomWidget())
```

## SettingsTileType

The underlying enum exported by the package. You rarely need this directly — use the named constructors on `SettingsTile` instead. It's available if you need to inspect tile type at runtime:

```dart
enum SettingsTileType {
  simpleTile, switchTile, navigationTile, checkTile,
  inputTile, sliderTile, selectTile, textareaTile,
  radioGroupTile, checkboxGroupTile,
}
```

## SettingsOption

Data class used by `select`, `radioGroup`, and `checkboxGroup` tiles.

| Parameter | Type | Description |
|-----------|------|-------------|
| `value` | `String` | Unique identifier (passed to callbacks) |
| `label` | `String` | Display text |
| `icon` | `Widget?` | Optional leading icon |

```dart
SettingsOption(
  value: 'en',
  label: 'English',
  icon: Icon(Icons.language),
)
```

## Platform Detection

The platform is auto-detected from the build context. Override it to force a specific look:

```dart
SettingsList(
  platform: DevicePlatform.iOS,  // Force Cupertino rendering
  sections: [...],
)
```

Available values: `android`, `iOS`, `macOS`, `windows`, `linux`, `web`, `fuchsia`, `custom`.

## Theming

The settings package auto-derives colors from the app's `ColorScheme` and integrates with `DmColorExtension` when available.

```dart
// Automatic (reads Theme.of(context)):
final themeData = SettingsThemeData.withContext(context, platform);

// From a ColorScheme directly:
final themeData = SettingsThemeData.withColorScheme(colorScheme, platform);
```

### Customizable properties

| Property | Description |
|----------|-------------|
| `settingsListBackground` | Background of the entire list |
| `settingsSectionBackground` | Background of individual sections |
| `titleTextColor` | Section title text color |
| `settingsTileTextColor` | Main tile text color |
| `tileDescriptionTextColor` | Description text color |
| `tileHighlightColor` | Tile press highlight color |
| `leadingIconsColor` | Leading icon color |
| `dividerColor` | Section divider color |
| `trailingTextColor` | Trailing value text color |
| `inactiveTitleColor` | Disabled tile title color |
| `inactiveSubtitleColor` | Disabled tile subtitle color |

## Complete Example

```dart
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _notifications = true;
  double _fontSize = 14;
  String _language = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Appearance'),
            tiles: [
              SettingsTile.switchTile(
                title: const Text('Dark Mode'),
                leading: const Icon(Icons.dark_mode),
                initialValue: _darkMode,
                onToggle: (val) => setState(() => _darkMode = val),
              ),
              SettingsTile.slider(
                title: const Text('Font Size'),
                leading: const Icon(Icons.text_fields),
                sliderValue: _fontSize,
                onSliderChanged: (val) => setState(() => _fontSize = val),
                sliderMin: 10,
                sliderMax: 24,
                sliderDivisions: 14,
              ),
            ],
          ),
          SettingsSection(
            title: const Text('General'),
            tiles: [
              SettingsTile.select(
                title: const Text('Language'),
                leading: const Icon(Icons.language),
                options: [
                  SettingsOption(value: 'en', label: 'English'),
                  SettingsOption(value: 'zh', label: 'Chinese'),
                  SettingsOption(value: 'ja', label: 'Japanese'),
                ],
                selectValue: _language,
                onSelectChanged: (val) =>
                    setState(() => _language = val ?? 'en'),
              ),
              SettingsTile.switchTile(
                title: const Text('Notifications'),
                leading: const Icon(Icons.notifications),
                initialValue: _notifications,
                onToggle: (val) => setState(() => _notifications = val),
              ),
              SettingsTile.navigation(
                title: const Text('About'),
                leading: const Icon(Icons.info),
                onPressed: (context) =>
                    Navigator.pushNamed(context, '/about'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```
