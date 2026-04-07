# DmCodeEditor Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `DmCodeEditor` to `duskmoon_widgets` — a `StatefulWidget` wrapping `CodeEditorWidget` that auto-derives its `EditorTheme` from the ambient DuskMoon theme tree, accepts a `String? language` identifier, and exposes both `onChanged(String)` and `onStateChanged(EditorState)` callbacks.

**Architecture:** Thin wrapper + `DmCodeEditorTheme` helper. `DmCodeEditorTheme.fromContext(context)` maps `ColorScheme` + `DmColorExtension` tokens to `EditorTheme` fields. `DmCodeEditor` is a `StatefulWidget` (no `AdaptiveWidget` mixin — code editors have no platform-specific rendering). Internal `EditorViewController` is created and owned by the widget when none is supplied; external controllers are never disposed by the widget.

**Tech Stack:** Flutter, `duskmoon_code_engine` (CodeEditorWidget, EditorViewController, EditorTheme, grammar factories, LanguageRegistry), `duskmoon_theme` (DmColorExtension, DmThemeData), `flutter_test`.

---

## File Map

| Action | Path | Responsibility |
|--------|------|----------------|
| Modify | `packages/duskmoon_widgets/pubspec.yaml` | Add `duskmoon_code_engine` dependency |
| Create | `packages/duskmoon_widgets/lib/src/code_editor/dm_code_editor_theme.dart` | `DmCodeEditorTheme.fromContext()` — maps DuskMoon tokens → `EditorTheme` |
| Create | `packages/duskmoon_widgets/lib/src/code_editor/dm_code_editor.dart` | `DmCodeEditor` widget + `_resolveLanguage` private function |
| Modify | `packages/duskmoon_widgets/lib/duskmoon_widgets.dart` | Export new files + re-export engine types |
| Create | `packages/duskmoon_widgets/test/src/code_editor/dm_code_editor_theme_test.dart` | Unit tests for `DmCodeEditorTheme.fromContext` |
| Create | `packages/duskmoon_widgets/test/src/code_editor/dm_code_editor_test.dart` | Widget tests for `DmCodeEditor` |

---

## Task 1: Add `duskmoon_code_engine` dependency

**Files:**
- Modify: `packages/duskmoon_widgets/pubspec.yaml`

- [ ] **Step 1: Add the dependency**

In `packages/duskmoon_widgets/pubspec.yaml`, add `duskmoon_code_engine` to `dependencies` directly after `duskmoon_theme`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  duskmoon_theme: ^1.1.1
  duskmoon_code_engine: ^1.1.1   # ← add this line
  duskmoon_adaptive_scaffold: ^1.1.0
  markdown: ^7.3.1
  highlighting: ^0.9.0+11.8.0
  flutter_math_fork: ^0.7.4
  url_launcher: ^6.3.0
```

- [ ] **Step 2: Resolve dependencies**

```bash
cd /path/to/flutter-duskmoon-ui
dart pub get
```

Expected: No errors. `duskmoon_code_engine 1.1.1` appears in the resolved output.

- [ ] **Step 3: Commit**

```bash
git add packages/duskmoon_widgets/pubspec.yaml
git commit -m "feat(duskmoon_widgets): add duskmoon_code_engine dependency"
```

---

## Task 2: Write failing tests for `DmCodeEditorTheme`

**Files:**
- Create: `packages/duskmoon_widgets/test/src/code_editor/dm_code_editor_theme_test.dart`

- [ ] **Step 1: Create the test file**

```dart
import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DmCodeEditorTheme.fromContext', () {
    testWidgets('light theme: background = colorScheme.surface', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: DmThemeData.sunshine(),
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final cs = DmThemeData.sunshine().colorScheme;
      expect(result.background, cs.surface);
    });

    testWidgets('light theme: foreground = colorScheme.onSurface', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: DmThemeData.sunshine(),
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final cs = DmThemeData.sunshine().colorScheme;
      expect(result.foreground, cs.onSurface);
    });

    testWidgets('light theme: cursorColor = colorScheme.primary', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: DmThemeData.sunshine(),
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final cs = DmThemeData.sunshine().colorScheme;
      expect(result.cursorColor, cs.primary);
    });

    testWidgets('light theme: gutterBackground = DmColorExtension.base200', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: DmThemeData.sunshine(),
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final ext = DmColorExtension.sunshine();
      expect(result.gutterBackground, ext.base200);
    });

    testWidgets('dark theme: background = colorScheme.surface', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: DmThemeData.moonlight(),
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final cs = DmThemeData.moonlight().colorScheme;
      expect(result.background, cs.surface);
    });

    testWidgets('dark theme: cursorColor = colorScheme.primary', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: DmThemeData.moonlight(),
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final cs = DmThemeData.moonlight().colorScheme;
      expect(result.cursorColor, cs.primary);
    });

    testWidgets('falls back to EditorTheme.light() when DmColorExtension absent', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData.light(), // No DmColorExtension
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final fallback = EditorTheme.light();
      expect(result.background, fallback.background);
      expect(result.foreground, fallback.foreground);
    });

    testWidgets('falls back to EditorTheme.dark() when DmColorExtension absent and dark brightness', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData.dark(), // No DmColorExtension, dark brightness
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final fallback = EditorTheme.dark();
      expect(result.background, fallback.background);
      expect(result.foreground, fallback.foreground);
    });
  });
}
```

- [ ] **Step 2: Run to confirm failure**

```bash
cd packages/duskmoon_widgets
flutter test test/src/code_editor/dm_code_editor_theme_test.dart
```

Expected: FAIL — `Error: 'DmCodeEditorTheme' is not defined` (or similar import error).

---

## Task 3: Implement `DmCodeEditorTheme`

**Files:**
- Create: `packages/duskmoon_widgets/lib/src/code_editor/dm_code_editor_theme.dart`

- [ ] **Step 1: Create the file**

```dart
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:flutter/material.dart';

/// Derives an [EditorTheme] from the ambient DuskMoon theme.
///
/// Falls back to [EditorTheme.light] or [EditorTheme.dark] (based on
/// brightness) when [DmColorExtension] is not present in the theme tree.
abstract final class DmCodeEditorTheme {
  /// Builds an [EditorTheme] from [Theme.of(context)] and [DmColorExtension].
  static EditorTheme fromContext(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<DmColorExtension>();

    if (ext == null) {
      return theme.brightness == Brightness.dark
          ? EditorTheme.dark()
          : EditorTheme.light();
    }

    final isDark = theme.brightness == Brightness.dark;

    return EditorTheme(
      background: cs.surface,
      foreground: cs.onSurface,
      gutterBackground: ext.base200,
      gutterForeground: ext.baseContent.withValues(alpha: 0.5),
      gutterActiveForeground: ext.baseContent,
      selectionBackground: cs.primary.withValues(alpha: 0.2),
      cursorColor: cs.primary,
      lineHighlight: ext.base200.withValues(alpha: 0.5),
      highlightStyle:
          isDark ? defaultDarkHighlight : defaultLightHighlight,
      searchMatchBackground: ext.warning.withValues(alpha: 0.3),
      searchActiveMatchBackground: ext.warning.withValues(alpha: 0.6),
      matchingBracketBackground: ext.accent.withValues(alpha: 0.2),
      matchingBracketOutline: ext.accent,
      scrollbarThumb: cs.onSurface.withValues(alpha: 0.3),
      scrollbarTrack: Colors.transparent,
    );
  }
}
```

- [ ] **Step 2: Add a temporary export to the barrel so tests can find it**

In `packages/duskmoon_widgets/lib/duskmoon_widgets.dart`, add at the bottom (will be reorganized in Task 6):

```dart
// Code Editor (temporary — will be reorganized in Task 6)
export 'src/code_editor/dm_code_editor_theme.dart';
export 'package:duskmoon_code_engine/duskmoon_code_engine.dart'
    show EditorViewController, EditorState, EditorTheme;
```

- [ ] **Step 3: Run the theme tests**

```bash
cd packages/duskmoon_widgets
flutter test test/src/code_editor/dm_code_editor_theme_test.dart
```

Expected: All 7 tests PASS.

- [ ] **Step 4: Commit**

```bash
git add packages/duskmoon_widgets/lib/src/code_editor/dm_code_editor_theme.dart \
        packages/duskmoon_widgets/lib/duskmoon_widgets.dart
git commit -m "feat(duskmoon_widgets): add DmCodeEditorTheme"
```

---

## Task 4: Write failing tests for `DmCodeEditor`

**Files:**
- Create: `packages/duskmoon_widgets/test/src/code_editor/dm_code_editor_test.dart`

- [ ] **Step 1: Create the test file**

```dart
import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {ThemeData? theme}) {
  return MaterialApp(
    theme: theme ?? DmThemeData.sunshine(),
    home: Scaffold(body: child),
  );
}

void main() {
  group('DmCodeEditor', () {
    testWidgets('renders without controller', (tester) async {
      await tester.pumpWidget(_wrap(
        const DmCodeEditor(initialDoc: 'hello'),
      ));
      await tester.pump();
      expect(find.byType(DmCodeEditor), findsOneWidget);
      expect(find.byType(CodeEditorWidget), findsOneWidget);
    });

    testWidgets('renders with external controller', (tester) async {
      final controller = EditorViewController(text: 'world');
      addTearDown(controller.dispose);
      await tester.pumpWidget(_wrap(
        DmCodeEditor(controller: controller),
      ));
      await tester.pump();
      expect(find.byType(DmCodeEditor), findsOneWidget);
    });

    testWidgets('external controller is NOT disposed on widget removal', (tester) async {
      final controller = EditorViewController(text: 'world');
      bool disposed = false;
      // Track disposal via a listener that checks after dispose
      // We verify by checking that controller.text still works after widget is removed
      await tester.pumpWidget(_wrap(DmCodeEditor(controller: controller)));
      await tester.pump();
      await tester.pumpWidget(const SizedBox.shrink());
      // If controller was improperly disposed, accessing .text would throw
      expect(() => controller.text, returnsNormally);
      expect(disposed, isFalse);
      controller.dispose();
    });

    testWidgets('onChanged fires with current text when content changes via controller', (tester) async {
      final controller = EditorViewController(text: '');
      addTearDown(controller.dispose);
      String? lastChanged;
      await tester.pumpWidget(_wrap(
        DmCodeEditor(
          controller: controller,
          onChanged: (t) => lastChanged = t,
        ),
      ));
      await tester.pump();
      controller.insertText('hello');
      await tester.pump();
      expect(lastChanged, 'hello');
    });

    testWidgets('onStateChanged fires when content changes via controller', (tester) async {
      final controller = EditorViewController(text: '');
      addTearDown(controller.dispose);
      EditorState? lastState;
      await tester.pumpWidget(_wrap(
        DmCodeEditor(
          controller: controller,
          onStateChanged: (s) => lastState = s,
        ),
      ));
      await tester.pump();
      controller.insertText('dart');
      await tester.pump();
      expect(lastState, isNotNull);
      expect(lastState!.doc.toString(), 'dart');
    });

    testWidgets('known language "dart" resolves without error', (tester) async {
      await tester.pumpWidget(_wrap(
        const DmCodeEditor(
          language: 'dart',
          initialDoc: 'void main() {}',
        ),
      ));
      await tester.pump();
      expect(find.byType(DmCodeEditor), findsOneWidget);
    });

    testWidgets('unknown language resolves to null without error', (tester) async {
      await tester.pumpWidget(_wrap(
        const DmCodeEditor(
          language: 'brainfuck',
          initialDoc: '+++.',
        ),
      ));
      await tester.pump();
      expect(find.byType(DmCodeEditor), findsOneWidget);
    });

    testWidgets('explicit theme override bypasses DmCodeEditorTheme', (tester) async {
      final customTheme = EditorTheme.dark();
      final controller = EditorViewController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(_wrap(
        DmCodeEditor(
          controller: controller,
          theme: customTheme,
        ),
        theme: DmThemeData.sunshine(), // light app theme
      ));
      await tester.pump();
      // Controller should have the custom dark theme applied
      expect(controller.theme, customTheme);
    });

    testWidgets('theme updates when ThemeData changes in widget tree', (tester) async {
      final controller = EditorViewController();
      addTearDown(controller.dispose);

      // Start with light theme
      await tester.pumpWidget(_wrap(
        DmCodeEditor(controller: controller),
        theme: DmThemeData.sunshine(),
      ));
      await tester.pump();
      final lightBackground = controller.theme?.background;

      // Switch to dark theme
      await tester.pumpWidget(_wrap(
        DmCodeEditor(controller: controller),
        theme: DmThemeData.moonlight(),
      ));
      await tester.pump();
      final darkBackground = controller.theme?.background;

      expect(lightBackground, isNotNull);
      expect(darkBackground, isNotNull);
      expect(lightBackground, isNot(equals(darkBackground)));
    });
  });
}
```

- [ ] **Step 2: Run to confirm failure**

```bash
cd packages/duskmoon_widgets
flutter test test/src/code_editor/dm_code_editor_test.dart
```

Expected: FAIL — `Error: 'DmCodeEditor' is not defined` (or similar).

---

## Task 5: Implement `DmCodeEditor`

**Files:**
- Create: `packages/duskmoon_widgets/lib/src/code_editor/dm_code_editor.dart`

- [ ] **Step 1: Create the file**

```dart
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter/material.dart';

import 'dm_code_editor_theme.dart';

/// Resolves a language name string to a [LanguageSupport] instance.
///
/// Returns `null` for unknown language identifiers (no syntax highlighting,
/// no error thrown). Matching is case-insensitive.
///
/// Supported identifiers: dart, javascript (js), typescript (ts), python (py),
/// html, css, json, markdown (md), rust (rs), go, yaml (yml), c, cpp (c++),
/// elixir (ex, exs), java, kotlin (kt), php, ruby (rb), erlang (erl),
/// swift, zig.
LanguageSupport? _resolveLanguage(String? language) {
  if (language == null) return null;
  return switch (language.toLowerCase()) {
    'dart' => dartLanguageSupport(),
    'javascript' || 'js' => javascriptLanguageSupport(),
    'typescript' || 'ts' => javascriptLanguageSupport(),
    'python' || 'py' => pythonLanguageSupport(),
    'html' => htmlLanguageSupport(),
    'css' => cssLanguageSupport(),
    'json' => jsonLanguageSupport(),
    'markdown' || 'md' => markdownLanguageSupport(),
    'rust' || 'rs' => rustLanguageSupport(),
    'go' => goLanguageSupport(),
    'yaml' || 'yml' => yamlLanguageSupport(),
    'c' || 'cpp' || 'c++' => cLanguageSupport(),
    'elixir' || 'ex' || 'exs' => elixirLanguageSupport(),
    'java' => javaLanguageSupport(),
    'kotlin' || 'kt' => kotlinLanguageSupport(),
    'php' => phpLanguageSupport(),
    'ruby' || 'rb' => rubyLanguageSupport(),
    'erlang' || 'erl' => erlangLanguageSupport(),
    'swift' => swiftLanguageSupport(),
    'zig' => zigLanguageSupport(),
    _ => null,
  };
}

/// A code editor widget that integrates with the DuskMoon design system.
///
/// Wraps [CodeEditorWidget] with automatic theme derivation from the ambient
/// DuskMoon theme tree. Supply a [language] string (e.g. `'dart'`, `'python'`)
/// for syntax highlighting — no engine imports required by the caller.
///
/// When no [controller] is provided, an internal [EditorViewController] is
/// created and disposed automatically. When a controller is provided, the
/// caller owns its lifecycle.
///
/// ## Example
///
/// ```dart
/// DmCodeEditor(
///   initialDoc: 'void main() {}',
///   language: 'dart',
///   onChanged: (text) => print(text),
/// )
/// ```
class DmCodeEditor extends StatefulWidget {
  /// Creates a [DmCodeEditor].
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

  /// Language identifier for syntax highlighting (e.g. `'dart'`, `'python'`).
  /// Case-insensitive. Unknown values are silently ignored (no highlighting).
  final String? language;

  /// Custom editor theme. When `null`, the theme is derived automatically from
  /// the ambient DuskMoon theme via [DmCodeEditorTheme.fromContext].
  final EditorTheme? theme;

  /// Whether the editor is read-only.
  final bool readOnly;

  /// Whether to show line numbers in the gutter.
  final bool lineNumbers;

  /// Whether to highlight the line containing the cursor.
  final bool highlightActiveLine;

  /// Called with the full document text whenever the editor content changes.
  final ValueChanged<String>? onChanged;

  /// Called with the full [EditorState] whenever the editor state changes.
  /// Use when cursor position, selection, or other engine state is needed.
  final void Function(EditorState state)? onStateChanged;

  /// External controller for programmatic access. When `null`, an internal
  /// controller is created and disposed by this widget.
  final EditorViewController? controller;

  /// Optional external [FocusNode].
  final FocusNode? focusNode;

  /// Whether to focus the editor on mount.
  final bool autofocus;

  /// Minimum height of the editor.
  final double? minHeight;

  /// Maximum height of the editor.
  final double? maxHeight;

  /// Padding around the editor content area.
  final EdgeInsets? padding;

  /// Scroll physics for the editor's internal list.
  final ScrollPhysics? scrollPhysics;

  @override
  State<DmCodeEditor> createState() => _DmCodeEditorState();
}

class _DmCodeEditorState extends State<DmCodeEditor> {
  EditorViewController? _internalController;

  EditorViewController get _controller =>
      widget.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = EditorViewController(
        text: widget.initialDoc,
        language: _resolveLanguage(widget.language),
      );
    } else if (widget.language != null) {
      widget.controller!.language = _resolveLanguage(widget.language);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.theme =
        widget.theme ?? DmCodeEditorTheme.fromContext(context);
  }

  @override
  void didUpdateWidget(DmCodeEditor oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle controller swap
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) {
        _internalController?.dispose();
        _internalController = null;
      }
      if (widget.controller == null) {
        _internalController = EditorViewController(
          text: widget.initialDoc,
          language: _resolveLanguage(widget.language),
        );
      }
      _controller.theme =
          widget.theme ?? DmCodeEditorTheme.fromContext(context);
      _controller.language = _resolveLanguage(widget.language);
      return;
    }

    if (widget.language != oldWidget.language) {
      _controller.language = _resolveLanguage(widget.language);
    }
    if (widget.theme != oldWidget.theme) {
      _controller.theme =
          widget.theme ?? DmCodeEditorTheme.fromContext(context);
    }
  }

  void _handleStateChanged(EditorState state) {
    widget.onChanged?.call(state.doc.toString());
    widget.onStateChanged?.call(state);
  }

  @override
  void dispose() {
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CodeEditorWidget(
      controller: _controller,
      readOnly: widget.readOnly,
      lineNumbers: widget.lineNumbers,
      highlightActiveLine: widget.highlightActiveLine,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      minHeight: widget.minHeight,
      maxHeight: widget.maxHeight,
      padding: widget.padding,
      scrollPhysics: widget.scrollPhysics,
      onStateChanged: _handleStateChanged,
    );
  }
}
```

- [ ] **Step 2: Add `DmCodeEditor` to the barrel temporarily**

In `packages/duskmoon_widgets/lib/duskmoon_widgets.dart`, update the temporary export block added in Task 3 to also include `dm_code_editor.dart`:

```dart
// Code Editor (temporary — will be reorganized in Task 6)
export 'src/code_editor/dm_code_editor.dart';
export 'src/code_editor/dm_code_editor_theme.dart';
export 'package:duskmoon_code_engine/duskmoon_code_engine.dart'
    show EditorViewController, EditorState, EditorTheme, CodeEditorWidget;
```

Note: `CodeEditorWidget` is exported here so tests can use `find.byType(CodeEditorWidget)`.

- [ ] **Step 3: Run the widget tests**

```bash
cd packages/duskmoon_widgets
flutter test test/src/code_editor/dm_code_editor_test.dart
```

Expected: All 8 tests PASS.

- [ ] **Step 4: Run full package test suite**

```bash
cd packages/duskmoon_widgets
flutter test
```

Expected: All tests PASS (existing tests unaffected).

- [ ] **Step 5: Commit**

```bash
git add packages/duskmoon_widgets/lib/src/code_editor/dm_code_editor.dart \
        packages/duskmoon_widgets/lib/duskmoon_widgets.dart
git commit -m "feat(duskmoon_widgets): add DmCodeEditor widget"
```

---

## Task 6: Finalize barrel exports and run full analysis

**Files:**
- Modify: `packages/duskmoon_widgets/lib/duskmoon_widgets.dart`

- [ ] **Step 1: Replace the temporary export block with the final organized exports**

Remove the "temporary" comment block and replace with the proper organized section. The full final barrel should look like this (replacing the bottom of the file):

```dart
// Markdown Input
export 'src/markdown_input/dm_markdown_input.dart';
export 'src/markdown_input/dm_markdown_input_controller.dart';
export 'src/markdown_input/dm_markdown_tab.dart';

// Code Editor
export 'src/code_editor/dm_code_editor.dart';
export 'src/code_editor/dm_code_editor_theme.dart';
export 'package:duskmoon_code_engine/duskmoon_code_engine.dart'
    show EditorViewController, EditorState, EditorTheme, CodeEditorWidget;
```

- [ ] **Step 2: Run analysis**

```bash
cd packages/duskmoon_widgets
dart analyze --fatal-infos
```

Expected: No issues.

- [ ] **Step 3: Run the full test suite one final time**

```bash
cd packages/duskmoon_widgets
flutter test
```

Expected: All tests PASS.

- [ ] **Step 4: Commit**

```bash
git add packages/duskmoon_widgets/lib/duskmoon_widgets.dart
git commit -m "feat(duskmoon_widgets): finalize DmCodeEditor barrel exports"
```

---

## Self-Review Checklist

- [x] **Spec coverage:**
  - ✓ `DmCodeEditorTheme.fromContext()` — Task 3
  - ✓ All token mappings from spec table — Task 3, Step 1
  - ✓ Fallback without `DmColorExtension` — Task 3, Step 1 + Task 2 tests
  - ✓ `DmCodeEditor` full API (all props) — Task 5
  - ✓ Internal controller lifecycle — Task 5, `initState` / `dispose`
  - ✓ External controller not disposed — Task 4 test + Task 5 `dispose`
  - ✓ `onChanged(String)` — Task 4 test + Task 5 `_handleStateChanged`
  - ✓ `onStateChanged(EditorState)` — Task 4 test + Task 5 `_handleStateChanged`
  - ✓ `language` string resolved to `LanguageSupport?` — Task 5 `_resolveLanguage`
  - ✓ All 21 language aliases — Task 5 switch
  - ✓ Unknown language → null, no error — Task 4 test + switch `_ => null`
  - ✓ Theme override bypasses auto-derive — Task 4 test + Task 5 `didChangeDependencies`
  - ✓ Theme updates when widget tree theme changes — Task 4 test + `didChangeDependencies`
  - ✓ Barrel exports (`DmCodeEditor`, `DmCodeEditorTheme`, `EditorViewController`, `EditorState`, `EditorTheme`, `CodeEditorWidget`) — Task 6
  - ✓ `pubspec.yaml` dependency — Task 1
  - ✓ Analysis passes — Task 6

- [x] **Placeholder scan:** No TBDs, no vague steps, all code complete.

- [x] **Type consistency:**
  - `_resolveLanguage` returns `LanguageSupport?` — used as `_controller.language = _resolveLanguage(...)` which matches the `EditorViewController.language` setter type.
  - `DmCodeEditorTheme.fromContext` returns `EditorTheme` — matches `EditorViewController.theme` setter and `DmCodeEditor.theme` prop type.
  - `_handleStateChanged` signature `(EditorState state)` matches `CodeEditorWidget.onStateChanged` parameter type.
  - `controller.theme` in tests is compared as `EditorTheme?` — matches `EditorViewController.theme` getter type.
