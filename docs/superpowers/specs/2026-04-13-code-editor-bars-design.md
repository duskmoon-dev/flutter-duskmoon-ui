# DmCodeEditor — Top Bar & Bottom Bar Design

## Summary

Add a `DmCodeEditor` wrapper widget to `duskmoon_code_engine` that composes the existing `CodeEditorWidget` with configurable top and bottom bars. Provides sensible defaults (toolbar + status bar) while allowing full replacement via widget slots.

## Architecture: Wrapper Widget (Composition)

`DmCodeEditor` wraps `CodeEditorWidget` in a `Column` with optional top/bottom bar slots. The existing `CodeEditorWidget` remains unchanged — consumers who want a bare editor continue using it directly.

```
DmCodeEditor (new)
└─ Column
   ├─ topBar: Widget?     // null → DmCodeEditorToolbar
   ├─ Expanded → CodeEditorWidget (existing, unchanged)
   └─ bottomBar: Widget?  // null → DmCodeEditorStatusBar
```

### Bar slot convention

- `null` → use the default bar widget
- Explicit `Widget` → use that widget (full replacement)
- `SizedBox.shrink()` → hide the bar entirely

## DmCodeEditor API

```dart
class DmCodeEditor extends StatefulWidget {
  const DmCodeEditor({
    // — Bar customization —
    this.topBar,                    // null → default toolbar
    this.bottomBar,                 // null → default status bar
    this.title,                     // shown in default toolbar (ignored if topBar provided)
    this.actions,                   // shown in default toolbar (ignored if topBar provided)

    // — Passthrough to CodeEditorWidget —
    this.initialDoc,
    this.language,
    this.extensions = const [],
    this.theme,
    this.readOnly = false,
    this.lineNumbers = true,
    this.highlightActiveLine = true,
    this.onStateChanged,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.minHeight,
    this.maxHeight,
    this.padding,
    this.scrollPhysics,
    super.key,
  });

  final Widget? topBar;
  final Widget? bottomBar;
  final String? title;
  final List<DmEditorAction>? actions;

  // All CodeEditorWidget params passed through
  final String? initialDoc;
  final LanguageSupport? language;
  final List<Extension> extensions;
  final EditorTheme? theme;
  final bool readOnly;
  final bool lineNumbers;
  final bool highlightActiveLine;
  final ValueChanged<EditorState>? onStateChanged;
  final EditorViewController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final double? minHeight;
  final double? maxHeight;
  final EdgeInsets? padding;
  final ScrollPhysics? scrollPhysics;
}
```

**Behavior:** When `topBar` is provided, `title` and `actions` are silently ignored (no assertion error).

**State management:** `DmCodeEditor` creates an internal `EditorViewController` if none is provided (same pattern as `CodeEditorWidget`). This controller is passed to both the inner `CodeEditorWidget` and the default bar widgets.

## DmEditorAction

Simple model for toolbar action buttons with built-in factories for common operations.

```dart
class DmEditorAction {
  const DmEditorAction({
    required this.icon,
    required this.tooltip,
    this.onPressed,  // null → disabled state
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  // Built-in factories
  factory DmEditorAction.undo(EditorViewController controller);
  factory DmEditorAction.redo(EditorViewController controller);
  factory DmEditorAction.search(EditorViewController controller);
  factory DmEditorAction.copy(EditorViewController controller);
}
```

## DmCodeEditorToolbar (Default Top Bar)

Renders as a single `Row`: title on the left (Expanded), action `IconButton`s on the right.

```dart
class DmCodeEditorToolbar extends StatelessWidget {
  const DmCodeEditorToolbar({
    this.title,
    this.actions = const [],
    required this.controller,
    this.decoration,
    super.key,
  });

  final String? title;
  final List<DmEditorAction> actions;
  final EditorViewController controller;
  final BoxDecoration? decoration;
}
```

**Theming:** Derives colors from `EditorTheme` on the controller — background from `gutterBackground`, text/icons from `gutterForeground`. Falls back to `Theme.of(context)` colors when `EditorTheme` doesn't provide them.

**Layout:** Fixed height, horizontal padding of 12px. Actions rendered as `IconButton` with `tooltip`.

## DmCodeEditorStatusBar (Default Bottom Bar)

Renders as a single `Row`: left group (cursor position, language) + Spacer + right group (line count, selection info).

```dart
class DmCodeEditorStatusBar extends StatelessWidget {
  const DmCodeEditorStatusBar({
    required this.controller,
    this.languageName,
    this.decoration,
    super.key,
  });

  final EditorViewController controller;
  final String? languageName;
  final BoxDecoration? decoration;
}
```

**Reactive updates:** Listens to `EditorView` (which is a `ChangeNotifier`) via `ListenableBuilder`. Updates on every state change to reflect current cursor position and selection.

**Status items displayed:**
- Left: `Ln {line}, Col {col}` — cursor position derived from `EditorState.selection`
- Left: Language name (if provided)
- Right: `{n} lines` — total line count from `Document`
- Right: `{n} selected` — character count of selection, only shown when selection is non-empty

**Theming:** Same approach as toolbar — derives from `EditorTheme`, falls back to `Theme.of(context)`. Slightly smaller font size than toolbar.

## File Structure

4 new files in `packages/duskmoon_code_engine/lib/src/view/`:

```
lib/src/view/
├── code_editor_widget.dart         # existing — UNCHANGED
├── dm_code_editor.dart             # NEW — wrapper widget
├── dm_code_editor_toolbar.dart     # NEW — default top bar
├── dm_code_editor_status_bar.dart  # NEW — default bottom bar
├── dm_editor_action.dart           # NEW — action model + factories
├── editor_view_controller.dart     # existing
├── editor_view.dart                # existing
└── ...
```

All 4 new classes exported from `duskmoon_code_engine.dart`.

## Usage Examples

```dart
// 1. Full defaults — just works
DmCodeEditor(
  initialDoc: source,
  language: dartLanguageSupport(),
  title: 'main.dart',
)

// 2. Custom actions in default toolbar
DmCodeEditor(
  initialDoc: source,
  title: 'main.dart',
  actions: [
    DmEditorAction.undo(controller),
    DmEditorAction.redo(controller),
    DmEditorAction(icon: Icons.play_arrow, tooltip: 'Run', onPressed: _run),
  ],
)

// 3. Fully custom top bar, no bottom bar
DmCodeEditor(
  initialDoc: source,
  topBar: MyCustomToolbar(),
  bottomBar: const SizedBox.shrink(),
)

// 4. Default top bar, custom bottom bar
DmCodeEditor(
  initialDoc: source,
  title: 'config.yaml',
  bottomBar: MyValidationStatusBar(controller: controller),
)

// 5. No bars at all (same as using CodeEditorWidget directly)
DmCodeEditor(
  initialDoc: source,
  topBar: const SizedBox.shrink(),
  bottomBar: const SizedBox.shrink(),
)
```

## Testing Strategy

- **DmCodeEditor:** Verify Column layout renders top bar, editor, bottom bar. Verify null slots produce defaults. Verify custom widgets replace defaults. Verify SizedBox.shrink() hides bars. Verify title/actions ignored when topBar is provided.
- **DmCodeEditorToolbar:** Verify title renders. Verify action buttons render and fire callbacks. Verify disabled state when onPressed is null.
- **DmCodeEditorStatusBar:** Verify cursor position updates reactively. Verify selection count appears/disappears. Verify line count. Verify language name display.
- **DmEditorAction factories:** Verify undo/redo/search/copy factories produce correct icon and tooltip.

## Scope

- Package: `duskmoon_code_engine` only
- No changes to existing files (purely additive)
- No changes to other packages in the monorepo
