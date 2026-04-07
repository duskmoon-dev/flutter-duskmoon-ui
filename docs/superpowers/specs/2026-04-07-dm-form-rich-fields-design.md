# DmForm Rich Fields Design Spec

**Date:** 2026-04-07
**Package:** `duskmoon_form`
**Status:** Approved

---

## Overview

Add `MarkdownFieldBloc` and `CodeEditorFieldBloc` to `duskmoon_form`, each with a dedicated state class and widget builder. Both hold `String` values and follow the existing `SingleFieldBloc` pattern. The markdown field carries mutable `DmMarkdownTab` state; the code editor field carries mutable `String? language` state.

---

## Architecture

### Files

```
packages/duskmoon_form/
└── lib/
    ├── duskmoon_form.dart                          ← add exports + re-exports
    └── src/
        ├── blocs/
        │   ├── markdown_field/
        │   │   ├── markdown_field_bloc.dart
        │   │   └── markdown_field_bloc_state.dart
        │   └── code_editor_field/
        │       ├── code_editor_field_bloc.dart
        │       └── code_editor_field_bloc_state.dart
        ├── widgets/
        │   ├── dm_markdown_field_bloc_builder.dart
        │   └── dm_code_editor_field_bloc_builder.dart
        └── theme/
            └── form_bloc_theme.dart                ← add markdownTheme + codeEditorTheme
```

### Dependencies

No new `pubspec.yaml` dependencies. `duskmoon_form` already depends on `duskmoon_widgets`, which provides `DmMarkdownInput`, `DmCodeEditor`, `DmMarkdownInputController`, `DmMarkdownTab`, `DmMarkdownConfig`, and re-exports `EditorViewController`, `EditorState`, `EditorTheme` from `duskmoon_code_engine`.

### BLoC hierarchy

Both BLoCs sit at the same level as `TextFieldBloc`:

```
SingleFieldBloc<String, String, *State<ExtraData?>, ExtraData?>
  ├── TextFieldBloc<ExtraData>       (existing)
  ├── MarkdownFieldBloc<ExtraData>   (new)
  └── CodeEditorFieldBloc<ExtraData> (new)
```

---

## Components

### `MarkdownFieldBlocState<ExtraData>`

```dart
class MarkdownFieldBlocState<ExtraData>
    extends FieldBlocState<String, String, ExtraData?> {
  final DmMarkdownTab tab;

  // copyWith overrides parent, threading all inherited fields + tab
  MarkdownFieldBlocState copyWith({DmMarkdownTab? tab, ...});
}
```

### `MarkdownFieldBloc<ExtraData>`

```dart
class MarkdownFieldBloc<ExtraData>
    extends SingleFieldBloc<String, String,
        MarkdownFieldBlocState<ExtraData?>, ExtraData?> {
  MarkdownFieldBloc({
    String? name,
    String initialValue = '',
    DmMarkdownTab initialTab = DmMarkdownTab.write,
    List<Validator<String>>? validators,
    List<AsyncValidator<String>>? asyncValidators,
    Duration asyncValidatorDebounceTime = const Duration(milliseconds: 500),
    Suggestions<String>? suggestions,
    ExtraData? extraData,
  });

  /// Emits a new state with [tab] updated.
  void updateTab(DmMarkdownTab tab) => emit(state.copyWith(tab: tab));
}
```

---

### `CodeEditorFieldBlocState<ExtraData>`

```dart
class CodeEditorFieldBlocState<ExtraData>
    extends FieldBlocState<String, String, ExtraData?> {
  final String? language;

  CodeEditorFieldBlocState copyWith({String? language, ...});
}
```

### `CodeEditorFieldBloc<ExtraData>`

```dart
class CodeEditorFieldBloc<ExtraData>
    extends SingleFieldBloc<String, String,
        CodeEditorFieldBlocState<ExtraData?>, ExtraData?> {
  CodeEditorFieldBloc({
    String? name,
    String initialValue = '',
    String? initialLanguage,
    List<Validator<String>>? validators,
    List<AsyncValidator<String>>? asyncValidators,
    Duration asyncValidatorDebounceTime = const Duration(milliseconds: 500),
    Suggestions<String>? suggestions,
    ExtraData? extraData,
  });

  /// Emits a new state with [language] updated.
  void updateLanguage(String? language) =>
      emit(state.copyWith(language: language));
}
```

---

## Widget Builders

### `DmMarkdownFieldBlocBuilder`

```dart
class DmMarkdownFieldBlocBuilder extends StatefulWidget {
  const DmMarkdownFieldBlocBuilder({
    super.key,
    required this.markdownFieldBloc,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.errorBuilder,
    this.padding,
    this.animateWhenCanShow = true,
    this.config = const DmMarkdownConfig(),
    this.tabLabelWrite = 'Write',
    this.tabLabelPreview = 'Preview',
    this.showLineNumbers = false,
    this.maxLines,
    this.minLines = 10,
    this.onLinkTap,
    this.decoration,
  });

  final MarkdownFieldBloc markdownFieldBloc;
  final bool enableOnlyWhenFormBlocCanSubmit;
  final bool isEnabled;
  final FieldBlocErrorBuilder? errorBuilder;
  final EdgeInsetsGeometry? padding;
  final bool animateWhenCanShow;
  final DmMarkdownConfig config;
  final String tabLabelWrite;
  final String tabLabelPreview;
  final bool showLineNumbers;
  final int? maxLines;
  final int minLines;
  final void Function(String url, String? title)? onLinkTap;
  final InputDecoration? decoration;
}
```

**Data flow:**

- `_DmMarkdownFieldBlocBuilderState` creates a `DmMarkdownInputController` in `initState` with `text: markdownFieldBloc.state.value`.
- `DmMarkdownInput.onChanged` → `markdownFieldBloc.changeValue(text)`.
- `DmMarkdownInput.onTabChanged` → `markdownFieldBloc.updateTab(tab)`.
- `DmMarkdownInput` receives `ValueKey(state.tab)`: when `state.tab` changes via `updateTab()`, Flutter tears down and rebuilds `DmMarkdownInput` with the new `initialTab`. The external `DmMarkdownInputController` preserves the text value through the rebuild.
- `isEnabled` / `enableOnlyWhenFormBlocCanSubmit` sets `DmMarkdownInput.enabled`.

---

### `DmCodeEditorFieldBlocBuilder`

```dart
class DmCodeEditorFieldBlocBuilder extends StatefulWidget {
  const DmCodeEditorFieldBlocBuilder({
    super.key,
    required this.codeEditorFieldBloc,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.errorBuilder,
    this.padding,
    this.animateWhenCanShow = true,
    this.lineNumbers = true,
    this.highlightActiveLine = true,
    this.theme,
    this.minHeight,
    this.maxHeight,
    this.editorPadding,
    this.scrollPhysics,
  });

  final CodeEditorFieldBloc codeEditorFieldBloc;
  final bool enableOnlyWhenFormBlocCanSubmit;
  final bool isEnabled;
  final FieldBlocErrorBuilder? errorBuilder;
  final EdgeInsetsGeometry? padding;
  final bool animateWhenCanShow;
  final bool lineNumbers;
  final bool highlightActiveLine;

  /// Per-instance editor theme override. When null, falls back to
  /// [CodeEditorFieldTheme.editorTheme] from [DmFormTheme], then to
  /// [DmCodeEditorTheme.fromContext].
  final EditorTheme? theme;
  final double? minHeight;
  final double? maxHeight;
  final EdgeInsets? editorPadding;
  final ScrollPhysics? scrollPhysics;
}
```

**Data flow:**

- `_DmCodeEditorFieldBlocBuilderState` creates an `EditorViewController` in `initState` with `text: codeEditorFieldBloc.state.value`.
- `DmCodeEditor.onChanged` → `codeEditorFieldBloc.changeValue(text)`.
- `state.language` is passed as the `language` prop to `DmCodeEditor`. When `updateLanguage()` emits a new state, `BlocBuilder` rebuilds and the new `language` prop is handled by `DmCodeEditor.didUpdateWidget`.
- If `state.value` changes externally (e.g., `changeValue()` called programmatically), `BlocBuilder` detects the value change and syncs the controller: `if (state.value != _controller.text) _controller.text = state.value`.
- `isEnabled` maps to `DmCodeEditor.readOnly = !isEnabled`.

---

## Theme

### `MarkdownFieldTheme`

Extends `FieldTheme` (inherits `textStyle`, `textColor`, `decorationTheme`). No additional fields — `DmMarkdownInput`'s internal styling is self-contained.

```dart
class MarkdownFieldTheme extends FieldTheme {
  const MarkdownFieldTheme({
    super.textStyle,
    super.textColor,
    super.decorationTheme,
  });
}
```

### `CodeEditorFieldTheme`

Does not extend `FieldTheme` (`textStyle`/`textColor`/`decorationTheme` do not apply to the code editor). Single field: `EditorTheme? editorTheme` — form-level default applied when neither the builder's `theme:` prop nor `DmCodeEditorTheme.fromContext` override is preferred.

```dart
class CodeEditorFieldTheme extends Equatable {
  const CodeEditorFieldTheme({this.editorTheme});
  final EditorTheme? editorTheme;
}
```

**Resolution order for editor theme:**
1. Builder `theme:` prop (highest priority)
2. `DmFormTheme.codeEditorTheme.editorTheme`
3. `DmCodeEditorTheme.fromContext(context)` (auto-derived from DuskMoon theme)

### `DmFormTheme` additions

```dart
class DmFormTheme extends Equatable {
  // ... existing fields ...
  final MarkdownFieldTheme markdownTheme;    // default: MarkdownFieldTheme()
  final CodeEditorFieldTheme codeEditorTheme; // default: CodeEditorFieldTheme()
}
```

---

## Exports

Added to `lib/duskmoon_form.dart`:

```dart
// Markdown field
export 'src/blocs/markdown_field/markdown_field_bloc.dart';
export 'src/blocs/markdown_field/markdown_field_bloc_state.dart';
export 'src/widgets/dm_markdown_field_bloc_builder.dart';

// Code editor field
export 'src/blocs/code_editor_field/code_editor_field_bloc.dart';
export 'src/blocs/code_editor_field/code_editor_field_bloc_state.dart';
export 'src/widgets/dm_code_editor_field_bloc_builder.dart';

// Re-export types callers need without a separate duskmoon_widgets import
export 'package:duskmoon_widgets/duskmoon_widgets.dart'
    show DmMarkdownTab, DmMarkdownConfig, EditorTheme;
```

---

## Testing

### BLoC unit tests (`test/src/blocs/`)

**`markdown_field_bloc_test.dart`:**
- Initial state has `tab = DmMarkdownTab.write` (default)
- Initial state has `tab = DmMarkdownTab.preview` when `initialTab: DmMarkdownTab.preview`
- `updateTab(DmMarkdownTab.preview)` emits state with updated tab
- `initialValue` and validators behave identically to `TextFieldBloc`

**`code_editor_field_bloc_test.dart`:**
- Initial state has `language = null` (default)
- Initial state has `language = 'dart'` when `initialLanguage: 'dart'`
- `updateLanguage('python')` emits state with updated language
- `updateLanguage(null)` emits state with null language
- `initialValue` and validators behave identically to `TextFieldBloc`

### Widget tests (`test/src/widgets/`)

**`dm_markdown_field_bloc_builder_test.dart`:**
- Renders `DmMarkdownInput` inside `DmSimpleFieldBlocBuilder`
- `onChanged` from `DmMarkdownInput` fires `markdownFieldBloc.changeValue()`
- `onTabChanged` fires `markdownFieldBloc.updateTab()`
- `updateTab()` from BLoC causes widget rebuild with new `initialTab`
- `isEnabled = false` sets `DmMarkdownInput.enabled = false`

**`dm_code_editor_field_bloc_builder_test.dart`:**
- Renders `DmCodeEditor`
- `onChanged` fires `codeEditorFieldBloc.changeValue()`
- `updateLanguage('python')` causes `DmCodeEditor` to receive updated `language` prop
- External `changeValue()` syncs controller text
- `isEnabled = false` sets `DmCodeEditor.readOnly = true`
