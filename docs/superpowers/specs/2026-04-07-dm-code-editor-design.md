# DmCodeEditor Design Spec

**Date:** 2026-04-07  
**Package:** `duskmoon_widgets`  
**Status:** Approved

---

## Overview

Add a `DmCodeEditor` widget to `duskmoon_widgets` that wraps `duskmoon_code_engine`'s `CodeEditorWidget` with a curated API and automatic DuskMoon theme integration. Theme is derived from the widget tree (`Theme.of(context)` + `DmColorExtension`) by default, with an optional override for custom themes.

---

## Architecture

### Approach

Thin wrapper + `DmCodeEditorTheme` helper (Approach C). `DmCodeEditor` wraps `CodeEditorWidget` directly with a curated API. Theme derivation is extracted into a standalone `DmCodeEditorTheme.fromContext(context)` static helper, keeping the widget lean, the theme logic testable in isolation, and providing an escape hatch for callers who want to apply DuskMoon theming to a raw `CodeEditorWidget`.

### Files

```
packages/duskmoon_widgets/
├── pubspec.yaml                          ← add duskmoon_code_engine: ^1.1.1
└── lib/
    ├── duskmoon_widgets.dart             ← add exports
    └── src/
        └── code_editor/
            ├── dm_code_editor.dart       ← the widget
            └── dm_code_editor_theme.dart ← theme derivation helper
```

`duskmoon_code_engine` is a direct dependency of `duskmoon_widgets`. Callers of `duskmoon_widgets` get `DmCodeEditor` without needing to add `duskmoon_code_engine` to their own pubspec. `EditorViewController`, `EditorState`, and `EditorTheme` are re-exported from `duskmoon_widgets` so callers can use the controller and `onStateChanged` without a separate import.

---

## Components

### `DmCodeEditorTheme`

```dart
abstract final class DmCodeEditorTheme {
  static EditorTheme fromContext(BuildContext context) { ... }
}
```

Derives an `EditorTheme` from the ambient DuskMoon theme. Falls back to `EditorTheme.light()` or `EditorTheme.dark()` (based on brightness) if `DmColorExtension` is absent from the theme tree.

**Token mapping:**

| `EditorTheme` field             | Source                                          |
|---------------------------------|-------------------------------------------------|
| `background`                    | `colorScheme.surface`                           |
| `foreground`                    | `colorScheme.onSurface`                         |
| `gutterBackground`              | `DmColorExtension.base200`                      |
| `gutterForeground`              | `DmColorExtension.baseContent.withOpacity(0.5)` |
| `gutterActiveForeground`        | `DmColorExtension.baseContent`                  |
| `selectionBackground`           | `colorScheme.primary.withOpacity(0.2)`          |
| `cursorColor`                   | `colorScheme.primary`                           |
| `lineHighlight`                 | `DmColorExtension.base200.withOpacity(0.5)`     |
| `highlightStyle`                | `defaultLightHighlight` / `defaultDarkHighlight` based on brightness |
| `searchMatchBackground`         | `DmColorExtension.warning.withOpacity(0.3)`     |
| `searchActiveMatchBackground`   | `DmColorExtension.warning.withOpacity(0.6)`     |
| `matchingBracketBackground`     | `DmColorExtension.accent.withOpacity(0.2)`      |
| `matchingBracketOutline`        | `DmColorExtension.accent`                       |
| `scrollbarThumb`                | `colorScheme.onSurface.withOpacity(0.3)`        |
| `scrollbarTrack`                | `Colors.transparent`                            |

---

### `DmCodeEditor`

```dart
class DmCodeEditor extends StatefulWidget {
  const DmCodeEditor({
    super.key,
    this.initialDoc,
    this.language,
    this.theme,
    this.readOnly = false,
    this.lineNumbers = true,
    this.highlightActiveLine = true,
    this.onChanged,
    this.onStateChanged,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.minHeight,
    this.maxHeight,
    this.padding,
    this.scrollPhysics,
  });

  /// Initial document text. Ignored when [controller] is provided.
  final String? initialDoc;

  /// Language identifier for syntax highlighting (e.g. 'dart', 'python', 'json').
  /// Unknown values are silently ignored (no highlighting). Resolved internally
  /// via the engine's LanguageRegistry — callers do not import engine types.
  final String? language;

  /// Custom editor theme. When null, theme is derived automatically from the
  /// ambient DuskMoon theme via [DmCodeEditorTheme.fromContext].
  final EditorTheme? theme;

  final bool readOnly;
  final bool lineNumbers;
  final bool highlightActiveLine;

  /// Called with the full document text whenever the content changes.
  final ValueChanged<String>? onChanged;

  /// Called with the full [EditorState] whenever the editor state changes.
  /// Use when cursor position, selection, or other engine state is needed.
  final void Function(EditorState state)? onStateChanged;

  /// External controller for programmatic access (get/set text, insert,
  /// dispatch transactions). When null, an internal controller is created
  /// and disposed by the widget.
  final EditorViewController? controller;

  final FocusNode? focusNode;
  final bool autofocus;
  final double? minHeight;
  final double? maxHeight;
  final EdgeInsets? padding;
  final ScrollPhysics? scrollPhysics;
}
```

---

## Data Flow

1. `build()` calls `DmCodeEditorTheme.fromContext(context)` to derive the current theme (or uses `widget.theme` override).
2. If the derived theme differs from the controller's current theme, it is pushed via `controller.theme = derivedTheme`. This triggers a repaint inside `CodeEditorWidget` without rebuilding `DmCodeEditor`.
3. `CodeEditorWidget.onStateChanged` is wired to both `widget.onStateChanged` (raw engine state) and `widget.onChanged` (extracts `state.doc.toString()`).
4. Language string is resolved once in `initState()` and on `didUpdateWidget()` when `widget.language` changes, via a private `_resolveLanguage(String?)` function backed by the engine's `LanguageRegistry`. The resolved `LanguageSupport?` is pushed to the controller via `controller.language = ...`.

---

## State Management

- When `controller` is **null**: `_DmCodeEditorState` creates an `EditorViewController` in `initState()` and disposes it in `dispose()`.
- When `controller` is **provided**: the widget never disposes it. The caller owns the lifecycle.
- Theme is re-derived on every `build()` call (cheap — token lookups only) and pushed to the controller when it changes.

---

## Language Support

Supported language identifiers (case-insensitive, matched to engine grammars):

`dart`, `javascript`, `typescript`, `python`, `html`, `css`, `json`, `markdown`, `rust`, `go`, `yaml`, `c`, `cpp`, `elixir`, `java`, `kotlin`, `php`, `ruby`, `erlang`, `swift`, `zig`

Unknown strings return `null` (editor renders with no syntax highlighting; no error thrown).

---

## Exports

Added to `duskmoon_widgets.dart`:

```dart
export 'src/code_editor/dm_code_editor.dart';
export 'src/code_editor/dm_code_editor_theme.dart';
// Re-export engine types needed by callers
export 'package:duskmoon_code_engine/duskmoon_code_engine.dart'
    show EditorViewController, EditorState, EditorTheme;
```

---

## Testing

**`dm_code_editor_theme_test.dart`** (unit):
- `fromContext` maps tokens correctly for light theme
- `fromContext` maps tokens correctly for dark theme
- `fromContext` falls back to `EditorTheme.light()` when `DmColorExtension` is absent

**`dm_code_editor_test.dart`** (widget):
- Renders without controller (internal controller created and disposed)
- Renders with external controller (widget does not dispose it)
- `onChanged` fires with correct text on content change
- `onStateChanged` fires on content change
- Known `language` string resolves to syntax highlighting
- Unknown `language` string renders without error
- `theme` override bypasses `DmCodeEditorTheme.fromContext`
- Theme updates when `ThemeData` changes in the widget tree
