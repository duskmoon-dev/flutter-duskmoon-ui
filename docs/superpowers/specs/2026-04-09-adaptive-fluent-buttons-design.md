# Adaptive Fluent Buttons Design

**Date:** 2026-04-09
**Package:** `duskmoon_widgets`
**Scope:** `DmButton`, `DmIconButton`, `DmFab`

## Problem

The adaptive button widgets (`DmButton`, `DmIconButton`, `DmFab`) already handle `DmPlatformStyle.fluent` in their switch statements but fall back to Material widgets. This produces an inconsistent experience on Windows where buttons look like Android Material controls instead of native Fluent Design.

## Solution

Add `fluent_ui` as a direct dependency to `duskmoon_widgets` and render native Fluent buttons when `DmPlatformStyle.fluent` is resolved.

## Variant Mapping

### DmButton

| `DmButtonVariant` | Material              | Cupertino              | Fluent (`fluent_ui`)         |
| ------------------ | --------------------- | ---------------------- | ---------------------------- |
| `filled`           | `FilledButton`        | `CupertinoButton.filled` | `fluent_ui.FilledButton`   |
| `outlined`         | `OutlinedButton`      | `CupertinoButton`      | `fluent_ui.OutlinedButton`   |
| `text`             | `TextButton`          | `CupertinoButton`      | `fluent_ui.HyperlinkButton`  |
| `tonal`            | `FilledButton.tonal`  | `CupertinoButton`      | `fluent_ui.Button`           |

### DmIconButton

| Material      | Cupertino                          | Fluent (`fluent_ui`)    |
| ------------- | ---------------------------------- | ----------------------- |
| `IconButton`  | `CupertinoButton(padding: zero)`   | `fluent_ui.IconButton`  |

### DmFab

No change. FAB is a Material concept with no Fluent equivalent. The Fluent case continues to fall back to Material rendering.

## FluentTheme Bridging

`fluent_ui` widgets require a `FluentTheme` ancestor in the widget tree. Rather than requiring users to manually wrap their app with `FluentTheme`, each Fluent build method will wrap its output with a lightweight `FluentTheme` derived from the current Material `ColorScheme`.

A shared helper function will be added:

```dart
// packages/duskmoon_widgets/lib/src/adaptive/fluent_theme_bridge.dart

import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

/// Wraps [child] in a [fluent.FluentTheme] derived from the nearest
/// Material [Theme], so that fluent_ui widgets render correctly without
/// requiring the consumer to set up a FluentTheme ancestor.
Widget wrapWithFluentTheme(BuildContext context, Widget child) {
  final colorScheme = Theme.of(context).colorScheme;
  final brightness = Theme.of(context).brightness;

  final fluentTheme = fluent.FluentThemeData(
    brightness: brightness,
    accentColor: fluent.AccentColor.swatch({
      'normal': colorScheme.primary,
    }),
    scaffoldBackgroundColor: colorScheme.surface,
  );

  return fluent.FluentTheme(
    data: fluentTheme,
    child: child,
  );
}
```

This keeps adaptive widgets self-contained -- consumers don't need to know about `fluent_ui` at all.

## File Changes

### New Files

| File | Purpose |
| --- | --- |
| `lib/src/adaptive/fluent_theme_bridge.dart` | `wrapWithFluentTheme()` helper |

### Modified Files

| File | Change |
| --- | --- |
| `pubspec.yaml` | Add `fluent_ui: ^4.9.0` dependency |
| `lib/src/buttons/dm_button.dart` | Replace `_buildMaterial` fallback with `_buildFluent` using `fluent_ui` widgets |
| `lib/src/buttons/dm_icon_button.dart` | Replace Material `IconButton` fallback with `fluent_ui.IconButton` |
| `lib/src/buttons/dm_fab.dart` | No change (keeps Material fallback) |
| `test/src/buttons/dm_button_test.dart` | Add Fluent test group verifying all 4 variants |
| `test/src/buttons/dm_icon_button_test.dart` | Add Fluent test group |
| `test/src/buttons/dm_fab_test.dart` | Add Fluent test group asserting Material fallback |

### Cupertino Improvement (DmButton only)

The current Cupertino rendering uses plain `CupertinoButton` for all variants, losing the visual distinction between filled/outlined/text. The `filled` variant will be updated to use `CupertinoButton.filled` for better platform fidelity.

## Testing Strategy

Each button test file gets a new `group('Fluent', ...)` that:

1. Sets `platformOverride: DmPlatformStyle.fluent` on the widget
2. Asserts the correct `fluent_ui` widget type is found in the tree
3. For `DmButton`, tests all 4 variants individually
4. For `DmFab`, asserts `FloatingActionButton` is still used (Material fallback)

## Out of Scope

- Adding `fluent_ui` to other adaptive widgets (DmSwitch, DmTextField, etc.) -- future work
- Fluent icon system (`fluentui_system_icons`) -- not needed for buttons
- `DmFab` Fluent-native rendering -- FAB has no Fluent equivalent
