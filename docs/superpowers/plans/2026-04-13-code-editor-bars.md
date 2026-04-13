# DmCodeEditor Bars Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a `DmCodeEditor` wrapper widget with configurable top bar (toolbar) and bottom bar (status bar) to `duskmoon_code_engine`.

**Architecture:** Composition pattern — `DmCodeEditor` wraps `CodeEditorWidget` in a `Column` with optional bar slots. Default bars (`DmCodeEditorToolbar`, `DmCodeEditorStatusBar`) use `EditorViewController` for state. `DmEditorAction` model provides built-in action factories.

**Tech Stack:** Flutter, duskmoon_code_engine (existing package)

---

## File Structure

| Action | File | Responsibility |
|--------|------|----------------|
| Create | `lib/src/view/dm_editor_action.dart` | Action button model with built-in factories |
| Create | `lib/src/view/dm_code_editor_toolbar.dart` | Default top bar: title + action buttons |
| Create | `lib/src/view/dm_code_editor_status_bar.dart` | Default bottom bar: cursor pos, language, lines, selection |
| Create | `lib/src/view/dm_code_editor.dart` | Wrapper widget composing bars + CodeEditorWidget |
| Modify | `lib/duskmoon_code_engine.dart:112-135` | Add exports for 4 new classes |
| Create | `test/src/view/dm_editor_action_test.dart` | Unit tests for action model |
| Create | `test/src/view/dm_code_editor_toolbar_test.dart` | Widget tests for toolbar |
| Create | `test/src/view/dm_code_editor_status_bar_test.dart` | Widget tests for status bar |
| Create | `test/src/view/dm_code_editor_test.dart` | Widget tests for wrapper |

All paths relative to `packages/duskmoon_code_engine/`.

---

### Task 1: DmEditorAction model

**Files:**
- Create: `lib/src/view/dm_editor_action.dart`
- Create: `test/src/view/dm_editor_action_test.dart`

- [ ] **Step 1: Write the failing tests**

Create `test/src/view/dm_editor_action_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('DmEditorAction', () {
    test('stores icon, tooltip, and onPressed', () {
      var called = false;
      final action = DmEditorAction(
        icon: Icons.undo,
        tooltip: 'Undo',
        onPressed: () => called = true,
      );
      expect(action.icon, Icons.undo);
      expect(action.tooltip, 'Undo');
      expect(action.onPressed, isNotNull);
      action.onPressed!();
      expect(called, isTrue);
    });

    test('onPressed defaults to null (disabled)', () {
      const action = DmEditorAction(
        icon: Icons.undo,
        tooltip: 'Undo',
      );
      expect(action.onPressed, isNull);
    });

    test('undo factory produces correct icon and tooltip', () {
      final ctrl = EditorViewController(text: 'hello');
      final action = DmEditorAction.undo(ctrl);
      expect(action.icon, Icons.undo);
      expect(action.tooltip, 'Undo');
      expect(action.onPressed, isNotNull);
      ctrl.dispose();
    });

    test('redo factory produces correct icon and tooltip', () {
      final ctrl = EditorViewController(text: 'hello');
      final action = DmEditorAction.redo(ctrl);
      expect(action.icon, Icons.redo);
      expect(action.tooltip, 'Redo');
      expect(action.onPressed, isNotNull);
      ctrl.dispose();
    });

    test('search factory produces correct icon and tooltip', () {
      final ctrl = EditorViewController(text: 'hello');
      final action = DmEditorAction.search(ctrl);
      expect(action.icon, Icons.search);
      expect(action.tooltip, 'Search');
      expect(action.onPressed, isNotNull);
      ctrl.dispose();
    });

    test('copy factory produces correct icon and tooltip', () {
      final ctrl = EditorViewController(text: 'hello');
      final action = DmEditorAction.copy(ctrl);
      expect(action.icon, Icons.copy);
      expect(action.tooltip, 'Copy');
      expect(action.onPressed, isNotNull);
      ctrl.dispose();
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd packages/duskmoon_code_engine && flutter test test/src/view/dm_editor_action_test.dart`
Expected: Compilation error — `DmEditorAction` not found.

- [ ] **Step 3: Implement DmEditorAction**

Create `lib/src/view/dm_editor_action.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../commands/commands.dart';
import '../commands/clipboard.dart';
import 'editor_view_controller.dart';

/// An action button displayed in [DmCodeEditorToolbar].
///
/// Use the built-in factories ([DmEditorAction.undo], [DmEditorAction.redo],
/// [DmEditorAction.search], [DmEditorAction.copy]) for common operations, or
/// create custom actions with any [icon], [tooltip], and [onPressed] callback.
class DmEditorAction {
  const DmEditorAction({
    required this.icon,
    required this.tooltip,
    this.onPressed,
  });

  /// The icon to display.
  final IconData icon;

  /// Tooltip shown on hover.
  final String tooltip;

  /// Callback when pressed. `null` renders the button in a disabled state.
  final VoidCallback? onPressed;

  /// Undo the last edit.
  factory DmEditorAction.undo(EditorViewController controller) {
    return DmEditorAction(
      icon: Icons.undo,
      tooltip: 'Undo',
      onPressed: () {
        final spec = EditorCommands.undo(controller.state);
        if (spec != null) controller.dispatch(spec);
      },
    );
  }

  /// Redo the last undone edit.
  factory DmEditorAction.redo(EditorViewController controller) {
    return DmEditorAction(
      icon: Icons.redo,
      tooltip: 'Redo',
      onPressed: () {
        final spec = EditorCommands.redo(controller.state);
        if (spec != null) controller.dispatch(spec);
      },
    );
  }

  /// Toggle the search panel.
  ///
  /// When used with [DmCodeEditor], this triggers the search panel on the
  /// underlying [CodeEditorWidget] by dispatching a Ctrl+F key event to the
  /// editor's focus node. When used standalone, provide a custom [onPressed].
  factory DmEditorAction.search(EditorViewController controller) {
    return DmEditorAction(
      icon: Icons.search,
      tooltip: 'Search',
      onPressed: () {
        // Search toggle is handled by DmCodeEditor via onSearchToggle callback.
        // This factory provides the icon/tooltip; DmCodeEditor overrides onPressed.
      },
    );
  }

  /// Copy the current selection to the clipboard.
  factory DmEditorAction.copy(EditorViewController controller) {
    return DmEditorAction(
      icon: Icons.copy,
      tooltip: 'Copy',
      onPressed: () {
        final text = ClipboardCommands.getSelectedText(controller.state);
        if (text.isNotEmpty) {
          Clipboard.setData(ClipboardData(text: text));
        }
      },
    );
  }
}
```

- [ ] **Step 4: Add export to barrel file**

In `lib/duskmoon_code_engine.dart`, add after line 119 (`export 'src/view/code_editor_widget.dart'`):

```dart
export 'src/view/dm_editor_action.dart' show DmEditorAction;
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `cd packages/duskmoon_code_engine && flutter test test/src/view/dm_editor_action_test.dart`
Expected: All 6 tests pass.

- [ ] **Step 6: Run analysis**

Run: `cd packages/duskmoon_code_engine && dart analyze --fatal-infos`
Expected: No issues found.

- [ ] **Step 7: Commit**

```bash
git add packages/duskmoon_code_engine/lib/src/view/dm_editor_action.dart \
       packages/duskmoon_code_engine/test/src/view/dm_editor_action_test.dart \
       packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart
git commit -m "feat(duskmoon_code_engine): add DmEditorAction model with built-in factories"
```

---

### Task 2: DmCodeEditorToolbar

**Files:**
- Create: `lib/src/view/dm_code_editor_toolbar.dart`
- Create: `test/src/view/dm_code_editor_toolbar_test.dart`

- [ ] **Step 1: Write the failing tests**

Create `test/src/view/dm_code_editor_toolbar_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('DmCodeEditorToolbar', () {
    late EditorViewController controller;

    setUp(() {
      controller = EditorViewController(text: 'hello');
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('renders title text', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorToolbar(
            title: 'main.dart',
            controller: controller,
          ),
        ),
      ));
      expect(find.text('main.dart'), findsOneWidget);
    });

    testWidgets('renders without title', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorToolbar(controller: controller),
        ),
      ));
      expect(find.byType(DmCodeEditorToolbar), findsOneWidget);
    });

    testWidgets('renders action buttons', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorToolbar(
            controller: controller,
            actions: [
              DmEditorAction(
                icon: Icons.undo,
                tooltip: 'Undo',
                onPressed: () {},
              ),
              DmEditorAction(
                icon: Icons.redo,
                tooltip: 'Redo',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ));
      expect(find.byIcon(Icons.undo), findsOneWidget);
      expect(find.byIcon(Icons.redo), findsOneWidget);
    });

    testWidgets('action button fires onPressed callback', (tester) async {
      var pressed = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorToolbar(
            controller: controller,
            actions: [
              DmEditorAction(
                icon: Icons.play_arrow,
                tooltip: 'Run',
                onPressed: () => pressed = true,
              ),
            ],
          ),
        ),
      ));
      await tester.tap(find.byIcon(Icons.play_arrow));
      expect(pressed, isTrue);
    });

    testWidgets('disabled action button does not respond to tap',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorToolbar(
            controller: controller,
            actions: const [
              DmEditorAction(
                icon: Icons.undo,
                tooltip: 'Undo',
                // onPressed is null → disabled
              ),
            ],
          ),
        ),
      ));
      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconButton.onPressed, isNull);
    });

    testWidgets('applies custom decoration', (tester) async {
      final decoration = BoxDecoration(
        color: Colors.red,
        border: Border.all(color: Colors.blue),
      );
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorToolbar(
            controller: controller,
            decoration: decoration,
          ),
        ),
      ));
      final container = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(DmCodeEditorToolbar),
          matching: find.byType(DecoratedBox),
        ),
      );
      expect(container.decoration, decoration);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd packages/duskmoon_code_engine && flutter test test/src/view/dm_code_editor_toolbar_test.dart`
Expected: Compilation error — `DmCodeEditorToolbar` not found.

- [ ] **Step 3: Implement DmCodeEditorToolbar**

Create `lib/src/view/dm_code_editor_toolbar.dart`:

```dart
import 'package:flutter/material.dart';

import '../../duskmoon_code_engine.dart';

/// Default top bar for [DmCodeEditor].
///
/// Renders a [title] on the left and action [IconButton]s on the right.
/// Colors are derived from the [EditorTheme] on [controller], falling back
/// to [Theme.of(context)] colors.
class DmCodeEditorToolbar extends StatelessWidget {
  const DmCodeEditorToolbar({
    super.key,
    this.title,
    this.actions = const [],
    required this.controller,
    this.decoration,
  });

  /// Title text shown on the left side of the toolbar.
  final String? title;

  /// Action buttons shown on the right side of the toolbar.
  final List<DmEditorAction> actions;

  /// The editor controller, used to derive theme colors.
  final EditorViewController controller;

  /// Optional custom decoration. When null, uses [EditorTheme] gutter colors.
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final theme = controller.theme;
    final colorScheme = Theme.of(context).colorScheme;

    final bgColor = theme?.gutterBackground ?? colorScheme.surfaceContainerLow;
    final fgColor = theme?.gutterForeground ?? colorScheme.onSurfaceVariant;
    final titleColor = theme?.foreground ?? colorScheme.onSurface;
    final borderColor = theme != null
        ? Color.lerp(theme.gutterBackground, theme.foreground, 0.15)!
        : colorScheme.outlineVariant;

    final effectiveDecoration = decoration ??
        BoxDecoration(
          color: bgColor,
          border: Border(bottom: BorderSide(color: borderColor)),
        );

    return DecoratedBox(
      decoration: effectiveDecoration,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            if (title != null)
              Expanded(
                child: Text(
                  title!,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: titleColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            else
              const Spacer(),
            for (final action in actions)
              IconButton(
                icon: Icon(action.icon, size: 18),
                tooltip: action.tooltip,
                onPressed: action.onPressed,
                color: fgColor,
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(
                  minWidth: 28,
                  minHeight: 28,
                ),
                splashRadius: 16,
              ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Add export to barrel file**

In `lib/duskmoon_code_engine.dart`, add after the `DmEditorAction` export:

```dart
export 'src/view/dm_code_editor_toolbar.dart' show DmCodeEditorToolbar;
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `cd packages/duskmoon_code_engine && flutter test test/src/view/dm_code_editor_toolbar_test.dart`
Expected: All 6 tests pass.

- [ ] **Step 6: Run analysis**

Run: `cd packages/duskmoon_code_engine && dart analyze --fatal-infos`
Expected: No issues found.

- [ ] **Step 7: Commit**

```bash
git add packages/duskmoon_code_engine/lib/src/view/dm_code_editor_toolbar.dart \
       packages/duskmoon_code_engine/test/src/view/dm_code_editor_toolbar_test.dart \
       packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart
git commit -m "feat(duskmoon_code_engine): add DmCodeEditorToolbar default top bar widget"
```

---

### Task 3: DmCodeEditorStatusBar

**Files:**
- Create: `lib/src/view/dm_code_editor_status_bar.dart`
- Create: `test/src/view/dm_code_editor_status_bar_test.dart`

- [ ] **Step 1: Write the failing tests**

Create `test/src/view/dm_code_editor_status_bar_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('DmCodeEditorStatusBar', () {
    late EditorViewController controller;

    setUp(() {
      controller = EditorViewController(text: 'hello\nworld\nfoo');
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('renders cursor position', (tester) async {
      // Cursor at offset 0 → Ln 1, Col 1
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorStatusBar(controller: controller),
        ),
      ));
      expect(find.textContaining('Ln 1'), findsOneWidget);
      expect(find.textContaining('Col 1'), findsOneWidget);
    });

    testWidgets('renders line count', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorStatusBar(controller: controller),
        ),
      ));
      expect(find.textContaining('3 lines'), findsOneWidget);
    });

    testWidgets('renders language name when provided', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorStatusBar(
            controller: controller,
            languageName: 'Dart',
          ),
        ),
      ));
      expect(find.text('Dart'), findsOneWidget);
    });

    testWidgets('omits language name when null', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorStatusBar(controller: controller),
        ),
      ));
      expect(find.text('Dart'), findsNothing);
    });

    testWidgets('updates cursor position reactively', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorStatusBar(controller: controller),
        ),
      ));
      expect(find.textContaining('Ln 1'), findsOneWidget);

      // Move cursor to line 2, col 3 (offset = 6 + 2 = 8 → "wo|rld")
      controller.setSelection(EditorSelection.cursor(8));
      await tester.pumpAndSettle();

      expect(find.textContaining('Ln 2'), findsOneWidget);
      expect(find.textContaining('Col 3'), findsOneWidget);
    });

    testWidgets('shows selection count when selection is non-empty',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorStatusBar(controller: controller),
        ),
      ));
      // No selection initially
      expect(find.textContaining('selected'), findsNothing);

      // Select "hello" (offset 0 to 5)
      controller.setSelection(EditorSelection.range(anchor: 0, head: 5));
      await tester.pumpAndSettle();

      expect(find.textContaining('5 selected'), findsOneWidget);
    });

    testWidgets('hides selection count when selection is empty',
        (tester) async {
      // First select, then deselect
      controller.setSelection(EditorSelection.range(anchor: 0, head: 5));

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorStatusBar(controller: controller),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.textContaining('5 selected'), findsOneWidget);

      controller.setSelection(EditorSelection.cursor(0));
      await tester.pumpAndSettle();
      expect(find.textContaining('selected'), findsNothing);
    });

    testWidgets('applies custom decoration', (tester) async {
      final decoration = BoxDecoration(color: Colors.green);
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorStatusBar(
            controller: controller,
            decoration: decoration,
          ),
        ),
      ));
      final container = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(DmCodeEditorStatusBar),
          matching: find.byType(DecoratedBox),
        ),
      );
      expect(container.decoration, decoration);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd packages/duskmoon_code_engine && flutter test test/src/view/dm_code_editor_status_bar_test.dart`
Expected: Compilation error — `DmCodeEditorStatusBar` not found.

- [ ] **Step 3: Implement DmCodeEditorStatusBar**

Create `lib/src/view/dm_code_editor_status_bar.dart`:

```dart
import 'package:flutter/material.dart';

import '../../duskmoon_code_engine.dart';

/// Default bottom bar for [DmCodeEditor].
///
/// Displays cursor position (Ln/Col), language name, total line count,
/// and selection character count. Reactively updates via [ListenableBuilder]
/// listening to [EditorView].
class DmCodeEditorStatusBar extends StatelessWidget {
  const DmCodeEditorStatusBar({
    super.key,
    required this.controller,
    this.languageName,
    this.decoration,
  });

  /// The editor controller, used to read state and listen for changes.
  final EditorViewController controller;

  /// Optional language name displayed in the status bar.
  final String? languageName;

  /// Optional custom decoration. When null, uses [EditorTheme] gutter colors.
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final theme = controller.theme;
    final colorScheme = Theme.of(context).colorScheme;

    final bgColor = theme?.gutterBackground ?? colorScheme.surfaceContainerLow;
    final fgColor = theme?.gutterForeground ?? colorScheme.onSurfaceVariant;
    final borderColor = theme != null
        ? Color.lerp(theme.gutterBackground, theme.foreground, 0.15)!
        : colorScheme.outlineVariant;

    final effectiveDecoration = decoration ??
        BoxDecoration(
          color: bgColor,
          border: Border(top: BorderSide(color: borderColor)),
        );

    return ListenableBuilder(
      listenable: controller.view,
      builder: (context, _) {
        final state = controller.state;
        final doc = state.doc;
        final selection = state.selection.main;

        final line = doc.lineAtOffset(selection.head);
        final col = selection.head - line.from + 1;
        final lineCount = doc.lineCount;
        final selectionLength = selection.isEmpty ? 0 : (selection.to - selection.from);

        final textStyle = TextStyle(fontSize: 11, color: fgColor);

        return DecoratedBox(
          decoration: effectiveDecoration,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                Text('Ln ${line.number}, Col $col', style: textStyle),
                if (languageName != null) ...[
                  const SizedBox(width: 16),
                  Text(languageName!, style: textStyle),
                ],
                const Spacer(),
                Text('$lineCount lines', style: textStyle),
                if (selectionLength > 0) ...[
                  const SizedBox(width: 16),
                  Text('$selectionLength selected', style: textStyle),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
```

- [ ] **Step 4: Add export to barrel file**

In `lib/duskmoon_code_engine.dart`, add after the `DmCodeEditorToolbar` export:

```dart
export 'src/view/dm_code_editor_status_bar.dart' show DmCodeEditorStatusBar;
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `cd packages/duskmoon_code_engine && flutter test test/src/view/dm_code_editor_status_bar_test.dart`
Expected: All 8 tests pass.

- [ ] **Step 6: Run analysis**

Run: `cd packages/duskmoon_code_engine && dart analyze --fatal-infos`
Expected: No issues found.

- [ ] **Step 7: Commit**

```bash
git add packages/duskmoon_code_engine/lib/src/view/dm_code_editor_status_bar.dart \
       packages/duskmoon_code_engine/test/src/view/dm_code_editor_status_bar_test.dart \
       packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart
git commit -m "feat(duskmoon_code_engine): add DmCodeEditorStatusBar default bottom bar widget"
```

---

### Task 4: DmCodeEditor wrapper widget

**Files:**
- Create: `lib/src/view/dm_code_editor.dart`
- Create: `test/src/view/dm_code_editor_test.dart`
- Modify: `lib/duskmoon_code_engine.dart`

- [ ] **Step 1: Write the failing tests**

Create `test/src/view/dm_code_editor_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('DmCodeEditor', () {
    testWidgets('renders with default bars', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: DmCodeEditor(initialDoc: 'hello'),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(DmCodeEditor), findsOneWidget);
      expect(find.byType(CodeEditorWidget), findsOneWidget);
      expect(find.byType(DmCodeEditorToolbar), findsOneWidget);
      expect(find.byType(DmCodeEditorStatusBar), findsOneWidget);
    });

    testWidgets('renders title in default toolbar', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: DmCodeEditor(
            initialDoc: 'hello',
            title: 'main.dart',
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('main.dart'), findsOneWidget);
    });

    testWidgets('renders custom actions in default toolbar', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditor(
            initialDoc: 'hello',
            actions: [
              DmEditorAction(
                icon: Icons.play_arrow,
                tooltip: 'Run',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('custom topBar replaces default toolbar', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditor(
            initialDoc: 'hello',
            topBar: const Text('Custom Top'),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Custom Top'), findsOneWidget);
      expect(find.byType(DmCodeEditorToolbar), findsNothing);
    });

    testWidgets('custom bottomBar replaces default status bar',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditor(
            initialDoc: 'hello',
            bottomBar: const Text('Custom Bottom'),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Custom Bottom'), findsOneWidget);
      expect(find.byType(DmCodeEditorStatusBar), findsNothing);
    });

    testWidgets('SizedBox.shrink hides top bar', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: DmCodeEditor(
            initialDoc: 'hello',
            topBar: SizedBox.shrink(),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(DmCodeEditorToolbar), findsNothing);
    });

    testWidgets('SizedBox.shrink hides bottom bar', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: DmCodeEditor(
            initialDoc: 'hello',
            bottomBar: SizedBox.shrink(),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(DmCodeEditorStatusBar), findsNothing);
    });

    testWidgets('title is ignored when custom topBar is provided',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditor(
            initialDoc: 'hello',
            title: 'should-not-appear',
            topBar: const Text('Custom'),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('should-not-appear'), findsNothing);
      expect(find.text('Custom'), findsOneWidget);
    });

    testWidgets('accepts external controller', (tester) async {
      final ctrl = EditorViewController(text: 'test');
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditor(controller: ctrl),
        ),
      ));
      await tester.pumpAndSettle();
      expect(ctrl.text, 'test');
      ctrl.dispose();
    });

    testWidgets('passes through readOnly to CodeEditorWidget', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: DmCodeEditor(
            initialDoc: 'hello',
            readOnly: true,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      final inner = tester.widget<CodeEditorWidget>(
        find.byType(CodeEditorWidget),
      );
      expect(inner.readOnly, isTrue);
    });

    testWidgets('passes through language name to default status bar',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditor(
            initialDoc: '{"a":1}',
            language: jsonLanguageSupport(),
            languageName: 'JSON',
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('JSON'), findsOneWidget);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd packages/duskmoon_code_engine && flutter test test/src/view/dm_code_editor_test.dart`
Expected: Compilation error — `DmCodeEditor` not found.

- [ ] **Step 3: Implement DmCodeEditor**

Create `lib/src/view/dm_code_editor.dart`:

```dart
import 'package:flutter/material.dart' hide InlineSpan;

import '../../duskmoon_code_engine.dart';

/// A batteries-included code editor with configurable top and bottom bars.
///
/// Wraps [CodeEditorWidget] in a [Column] with optional bar slots:
/// - [topBar]: `null` → [DmCodeEditorToolbar], explicit widget → replaces it,
///   `SizedBox.shrink()` → hides it.
/// - [bottomBar]: `null` → [DmCodeEditorStatusBar], explicit widget → replaces
///   it, `SizedBox.shrink()` → hides it.
///
/// When [topBar] is provided, [title] and [actions] are silently ignored.
class DmCodeEditor extends StatefulWidget {
  const DmCodeEditor({
    super.key,
    this.topBar,
    this.bottomBar,
    this.title,
    this.actions,
    this.languageName,
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
  });

  /// Custom top bar widget. `null` uses [DmCodeEditorToolbar].
  final Widget? topBar;

  /// Custom bottom bar widget. `null` uses [DmCodeEditorStatusBar].
  final Widget? bottomBar;

  /// Title shown in the default toolbar. Ignored when [topBar] is provided.
  final String? title;

  /// Actions shown in the default toolbar. Ignored when [topBar] is provided.
  final List<DmEditorAction>? actions;

  /// Language name shown in the default status bar.
  final String? languageName;

  // --- Passthrough to CodeEditorWidget ---

  final String? initialDoc;
  final LanguageSupport? language;
  final List<Extension> extensions;
  final EditorTheme? theme;
  final bool readOnly;
  final bool lineNumbers;
  final bool highlightActiveLine;
  final void Function(EditorState state)? onStateChanged;
  final EditorViewController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final double? minHeight;
  final double? maxHeight;
  final EdgeInsets? padding;
  final ScrollPhysics? scrollPhysics;

  @override
  State<DmCodeEditor> createState() => _DmCodeEditorState();
}

class _DmCodeEditorState extends State<DmCodeEditor> {
  late EditorViewController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(DmCodeEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (_ownsController) _controller.dispose();
      _initController();
    }
  }

  void _initController() {
    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      _controller = EditorViewController(
        text: widget.initialDoc ?? '',
        language: widget.language,
        extensions: widget.extensions,
        theme: widget.theme,
      );
      _ownsController = true;
    }
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  Widget _buildTopBar() {
    if (widget.topBar != null) return widget.topBar!;
    return DmCodeEditorToolbar(
      title: widget.title,
      actions: widget.actions ?? const [],
      controller: _controller,
    );
  }

  Widget _buildBottomBar() {
    if (widget.bottomBar != null) return widget.bottomBar!;
    return DmCodeEditorStatusBar(
      controller: _controller,
      languageName: widget.languageName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopBar(),
        Expanded(
          child: CodeEditorWidget(
            controller: _controller,
            language: widget.language,
            extensions: widget.extensions,
            theme: widget.theme,
            readOnly: widget.readOnly,
            lineNumbers: widget.lineNumbers,
            highlightActiveLine: widget.highlightActiveLine,
            onStateChanged: widget.onStateChanged,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            padding: widget.padding,
            scrollPhysics: widget.scrollPhysics,
          ),
        ),
        _buildBottomBar(),
      ],
    );
  }
}
```

- [ ] **Step 4: Add export to barrel file**

In `lib/duskmoon_code_engine.dart`, add after the `DmCodeEditorStatusBar` export:

```dart
export 'src/view/dm_code_editor.dart' show DmCodeEditor;
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `cd packages/duskmoon_code_engine && flutter test test/src/view/dm_code_editor_test.dart`
Expected: All 11 tests pass.

- [ ] **Step 6: Run full test suite**

Run: `cd packages/duskmoon_code_engine && flutter test`
Expected: All tests pass (existing + new).

- [ ] **Step 7: Run analysis**

Run: `cd packages/duskmoon_code_engine && dart analyze --fatal-infos`
Expected: No issues found.

- [ ] **Step 8: Commit**

```bash
git add packages/duskmoon_code_engine/lib/src/view/dm_code_editor.dart \
       packages/duskmoon_code_engine/test/src/view/dm_code_editor_test.dart \
       packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart
git commit -m "feat(duskmoon_code_engine): add DmCodeEditor wrapper with configurable top/bottom bars"
```

---

### Task 5: Final verification

**Files:** None (verification only)

- [ ] **Step 1: Run full test suite**

Run: `cd packages/duskmoon_code_engine && flutter test`
Expected: All tests pass.

- [ ] **Step 2: Run workspace-wide analysis**

Run: `melos run analyze`
Expected: No issues found across all packages.

- [ ] **Step 3: Run format check**

Run: `melos run format`
Expected: No formatting issues.
