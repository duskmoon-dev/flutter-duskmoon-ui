# Adaptive Platform System

This guide covers the shared platform-resolution APIs used by DuskMoon adaptive widgets. For the widget catalog, see [widgets.md](widgets.md). For settings-specific tiles and sections, see [settings.md](settings.md).

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [DmPlatformStyle](#dmplatformstyle)
- [Resolution Priority](#resolution-priority)
- [DuskmoonApp](#duskmoonapp)
- [DmPlatformOverride](#dmplatformoverride)
- [resolvePlatformStyle](#resolveplatformstyle)
- [Custom Adaptive Widgets](#custom-adaptive-widgets)
- [Settings Interop](#settings-interop)

## Overview

DuskMoon widgets choose Material, Cupertino, or Fluent rendering through a shared resolver from `duskmoon_theme`. The resolver is re-exported by `duskmoon_widgets` and by the umbrella `duskmoon_ui` package.

```dart
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
```

Use this system when you want an app-level platform style switcher, a subtree override, or a one-off widget override.

## Installation

```yaml
dependencies:
  duskmoon_widgets: ^1.6.0
```

Or use the umbrella package:

```yaml
dependencies:
  duskmoon_ui: ^1.6.0
```

## DmPlatformStyle

```dart
enum DmPlatformStyle {
  material,
  cupertino,
  fluent,
}
```

The enum lives in `duskmoon_theme` and is re-exported by `duskmoon_widgets`.

## Resolution Priority

Adaptive widgets resolve their style in this order:

1. Widget `platformOverride`
2. `DmPlatformOverride` inherited from the widget tree
3. `DuskmoonApp` inherited from the widget tree
4. `Theme.of(context).platform`

Windows defaults to Fluent when no override is present.

## DuskmoonApp

`DuskmoonApp` provides an app-level default platform style.

```dart
DuskmoonApp(
  platformStyle: DmPlatformStyle.cupertino,
  child: MaterialApp(
    theme: DmThemeData.sunshine(),
    darkTheme: DmThemeData.moonlight(),
    home: const HomePage(),
  ),
)
```

API:

```dart
class DuskmoonApp extends InheritedWidget {
  const DuskmoonApp({
    required Widget child,
    DmPlatformStyle? platformStyle,
  });

  static DmPlatformStyle? maybeStyleOf(BuildContext context);
}
```

When `platformStyle` is `null`, widgets fall through to subtree overrides or the Flutter theme platform.

## DmPlatformOverride

`DmPlatformOverride` is a subtree-level override.

```dart
DmPlatformOverride(
  style: DmPlatformStyle.material,
  child: SettingsPanel(),
)
```

This is useful when most of the app follows the OS, but one feature should render in a known style.

## resolvePlatformStyle

Use `resolvePlatformStyle(context, widgetOverride)` outside the `AdaptiveWidget` mixin or in helper functions.

```dart
final style = resolvePlatformStyle(context, DmPlatformStyle.fluent);

return switch (style) {
  DmPlatformStyle.material => const MaterialControls(),
  DmPlatformStyle.cupertino => const CupertinoControls(),
  DmPlatformStyle.fluent => const FluentControls(),
};
```

## Custom Adaptive Widgets

For stateless widgets, mix in `AdaptiveWidget` and expose a nullable `platformOverride`.

```dart
class AdaptiveLabel extends StatelessWidget with AdaptiveWidget {
  const AdaptiveLabel({
    super.key,
    required this.text,
    this.platformOverride,
  });

  final String text;

  @override
  final DmPlatformStyle? platformOverride;

  @override
  Widget build(BuildContext context) {
    return switch (resolveStyle(context)) {
      DmPlatformStyle.material => Text(text),
      DmPlatformStyle.cupertino => Text(text),
      DmPlatformStyle.fluent => Text(text),
    };
  }
}
```

## Settings Interop

`duskmoon_settings` still exposes `DevicePlatform` for explicit settings-list overrides and platform-specific renderer code. `SettingsList` converts an explicit `DevicePlatform` to `DmPlatformStyle`; when no explicit platform is provided, it honors the shared `resolvePlatformStyle` chain, including `DuskmoonApp` and `DmPlatformOverride`.

```dart
SettingsList(
  platform: DevicePlatform.iOS,
  sections: const [...],
)
```

Use `DmPlatformStyle` for new adaptive widgets. Use `DevicePlatform` only when working with settings APIs that explicitly require it.
