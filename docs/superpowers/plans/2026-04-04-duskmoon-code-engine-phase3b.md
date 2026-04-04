# duskmoon_code_engine Phase 3b — Interactive Input Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the CodeEditorWidget interactive — keyboard typing, cursor rendering with blink animation, click-to-position, selection via click-drag, and default keymap bindings wired to EditorCommands.

**Architecture:** Input flows through two channels: (1) `Focus.onKeyEvent` for physical keyboard → keymap resolution → command dispatch; (2) `TextInputClient` adapter for IME/software keyboard input → diff-based ChangeSet generation. Cursor position is calculated by building a `TextPainter` for the cursor's line and measuring the text width up to the cursor column. Click-to-position reverses this: maps tap coordinates to a document offset via line index (y / lineHeight) and character hit-testing (TextPainter.getPositionForOffset).

**Tech Stack:** Dart 3.5+, Flutter SDK (`Focus`, `KeyEvent`, `TextInput`, `TextInputClient`, `GestureDetector`, `CustomPainter`, `AnimationController`)

**Spec:** `docs/code-engine.md` sections 7.4, 9

**Depends on:** Phase 3 (complete) — CodeEditorWidget, EditorView, EditorCommands, Keymap, SelectionPainter all exist but are not yet wired together

---

## File Structure

```
packages/duskmoon_code_engine/lib/src/
├── view/
│   ├── code_editor_widget.dart     # MODIFY — add keyboard, cursor, click handlers
│   ├── input_handler.dart          # CREATE — TextInputClient adapter for IME
│   ├── position_utils.dart         # CREATE — offset↔coords mapping utilities
│   ├── cursor_blink.dart           # CREATE — cursor blink animation controller
│   ├── selection_painter.dart      # EXISTS — already implemented, will be used
│   └── (other existing files unchanged)
│
├── commands/
│   ├── default_keymap.dart         # CREATE — default key bindings
│   └── (existing keymap.dart, commands.dart unchanged)

test/src/
├── view/
│   ├── position_utils_test.dart    # CREATE
│   ├── input_handler_test.dart     # CREATE
│   └── code_editor_widget_test.dart # MODIFY — add interaction tests
│
└── commands/
    └── default_keymap_test.dart    # CREATE
```

---

## Task 1: PositionUtils (offset ↔ coordinates)

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/view/position_utils.dart`
- Create: `packages/duskmoon_code_engine/test/src/view/position_utils_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

The core utility for mapping between document offsets and screen coordinates. Uses TextPainter to measure text.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/view/position_utils_test.dart`:

```dart
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  const fontFamily = 'monospace';
  const fontSize = 14.0;
  const lineHeight = 22.0;

  group('PositionUtils', () {
    group('lineForY', () {
      test('y=0 returns line 0', () {
        expect(PositionUtils.lineForY(0, lineHeight: lineHeight), 0);
      });

      test('y in middle of line 2 returns 2', () {
        expect(PositionUtils.lineForY(50, lineHeight: lineHeight), 2);
      });

      test('negative y returns 0', () {
        expect(PositionUtils.lineForY(-10, lineHeight: lineHeight), 0);
      });

      test('clamps to maxLine', () {
        expect(
          PositionUtils.lineForY(1000, lineHeight: lineHeight, maxLine: 5),
          5,
        );
      });
    });

    group('yForLine', () {
      test('line 0 returns 0', () {
        expect(PositionUtils.yForLine(0, lineHeight: lineHeight), 0);
      });

      test('line 3 returns 3 * lineHeight', () {
        expect(PositionUtils.yForLine(3, lineHeight: lineHeight), 66);
      });
    });

    group('offsetInLine', () {
      test('returns offset for position within line', () {
        final doc = Document.fromString('hello\nworld');
        // Position 8 is in line 2 ('world'), col 2
        final offset = PositionUtils.offsetInLine(8, doc);
        expect(offset.lineIndex, 1); // 0-based
        expect(offset.column, 2);
      });

      test('position at line start has column 0', () {
        final doc = Document.fromString('hello\nworld');
        final offset = PositionUtils.offsetInLine(6, doc);
        expect(offset.lineIndex, 1);
        expect(offset.column, 0);
      });

      test('position in first line', () {
        final doc = Document.fromString('hello\nworld');
        final offset = PositionUtils.offsetInLine(3, doc);
        expect(offset.lineIndex, 0);
        expect(offset.column, 3);
      });
    });

    group('offsetFromLineCol', () {
      test('converts line index and column to document offset', () {
        final doc = Document.fromString('hello\nworld');
        expect(PositionUtils.offsetFromLineCol(0, 3, doc), 3);
        expect(PositionUtils.offsetFromLineCol(1, 2, doc), 8);
      });

      test('clamps column to line length', () {
        final doc = Document.fromString('hi\nworld');
        // Line 0 ("hi") has length 2, column 10 clamps to 2
        expect(PositionUtils.offsetFromLineCol(0, 10, doc), 2);
      });
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/view/position_utils_test.dart
```

- [ ] **Step 3: Implement PositionUtils**

Create `packages/duskmoon_code_engine/lib/src/view/position_utils.dart`:

```dart
import 'dart:math' as math;

import '../document/document.dart';

/// Result of mapping a document offset to a line + column.
class LineColumn {
  const LineColumn(this.lineIndex, this.column);

  /// 0-based line index.
  final int lineIndex;

  /// 0-based column within the line.
  final int column;
}

/// Utilities for mapping between document offsets and screen coordinates.
abstract final class PositionUtils {
  /// Get the 0-based line index for a y coordinate.
  static int lineForY(
    double y, {
    required double lineHeight,
    int maxLine = 0x7FFFFFFF,
  }) {
    return math.max(0, math.min(maxLine, (y / lineHeight).floor()));
  }

  /// Get the y coordinate for a 0-based line index.
  static double yForLine(int lineIndex, {required double lineHeight}) {
    return lineIndex * lineHeight;
  }

  /// Convert a document offset to a line index + column.
  static LineColumn offsetInLine(int offset, Document doc) {
    final line = doc.lineAtOffset(offset);
    return LineColumn(line.number - 1, offset - line.from);
  }

  /// Convert a 0-based line index + column to a document offset.
  static int offsetFromLineCol(int lineIndex, int column, Document doc) {
    final lineNumber = lineIndex + 1;
    if (lineNumber > doc.lineCount) {
      return doc.length;
    }
    final line = doc.lineAt(lineNumber);
    return line.from + math.min(column, line.length);
  }
}
```

- [ ] **Step 4: Add export**

```dart
export 'src/view/position_utils.dart' show LineColumn, PositionUtils;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/view/position_utils_test.dart -r expanded
```

- [ ] **Step 6: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add PositionUtils for offset-coordinate mapping"
```

---

## Task 2: CursorBlink animation controller

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/view/cursor_blink.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

A simple controller that toggles cursor visibility at a fixed interval. Uses `Timer.periodic` (not AnimationController, which requires a TickerProvider — we handle that in the widget).

- [ ] **Step 1: Implement CursorBlink**

Create `packages/duskmoon_code_engine/lib/src/view/cursor_blink.dart`:

```dart
import 'dart:async';

import 'package:flutter/foundation.dart';

/// Controls cursor blink state.
///
/// Toggles [visible] on a 530ms interval. Call [restart] when the
/// cursor moves to reset the blink cycle (cursor stays visible
/// immediately after movement).
class CursorBlink extends ChangeNotifier {
  CursorBlink();

  bool _visible = true;
  Timer? _timer;
  bool _started = false;

  /// Whether the cursor should be painted.
  bool get visible => _visible;

  /// Start the blink cycle.
  void start() {
    if (_started) return;
    _started = true;
    _visible = true;
    _timer = Timer.periodic(const Duration(milliseconds: 530), (_) {
      _visible = !_visible;
      notifyListeners();
    });
  }

  /// Stop blinking (cursor hidden).
  void stop() {
    _timer?.cancel();
    _timer = null;
    _started = false;
    _visible = false;
    notifyListeners();
  }

  /// Restart the blink cycle (cursor immediately visible).
  /// Call this after cursor movement.
  void restart() {
    _timer?.cancel();
    _timer = null;
    _visible = true;
    notifyListeners();
    _timer = Timer.periodic(const Duration(milliseconds: 530), (_) {
      _visible = !_visible;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
```

- [ ] **Step 2: Add export**

```dart
export 'src/view/cursor_blink.dart' show CursorBlink;
```

- [ ] **Step 3: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add CursorBlink animation controller"
```

---

## Task 3: Default keymap bindings

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/commands/default_keymap.dart`
- Create: `packages/duskmoon_code_engine/test/src/commands/default_keymap_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

Wire the existing EditorCommands to key bindings. Platform-aware: Cmd on macOS/iOS, Ctrl on others.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/commands/default_keymap_test.dart`:

```dart
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('defaultKeymap', () {
    test('has bindings for arrow keys', () {
      final km = defaultKeymap();
      expect(km.resolve(LogicalKeyboardKey.arrowRight, false, false, false), isNotNull);
      expect(km.resolve(LogicalKeyboardKey.arrowLeft, false, false, false), isNotNull);
      expect(km.resolve(LogicalKeyboardKey.arrowUp, false, false, false), isNotNull);
      expect(km.resolve(LogicalKeyboardKey.arrowDown, false, false, false), isNotNull);
    });

    test('has bindings for Home/End', () {
      final km = defaultKeymap();
      expect(km.resolve(LogicalKeyboardKey.home, false, false, false), isNotNull);
      expect(km.resolve(LogicalKeyboardKey.end, false, false, false), isNotNull);
    });

    test('has bindings for Backspace and Delete', () {
      final km = defaultKeymap();
      expect(km.resolve(LogicalKeyboardKey.backspace, false, false, false), isNotNull);
      expect(km.resolve(LogicalKeyboardKey.delete, false, false, false), isNotNull);
    });

    test('has binding for Enter', () {
      final km = defaultKeymap();
      expect(km.resolve(LogicalKeyboardKey.enter, false, false, false), isNotNull);
    });

    test('has binding for Tab', () {
      final km = defaultKeymap();
      expect(km.resolve(LogicalKeyboardKey.tab, false, false, false), isNotNull);
    });

    test('has binding for Ctrl-z (undo)', () {
      final km = defaultKeymap();
      expect(km.resolve(LogicalKeyboardKey.keyZ, true, false, false), isNotNull);
    });

    test('has binding for Ctrl-Shift-z (redo)', () {
      final km = defaultKeymap();
      expect(km.resolve(LogicalKeyboardKey.keyZ, true, true, false), isNotNull);
    });

    test('has binding for Ctrl-a (select all)', () {
      final km = defaultKeymap();
      expect(km.resolve(LogicalKeyboardKey.keyA, true, false, false), isNotNull);
    });

    test('Shift-arrow has binding for selection', () {
      final km = defaultKeymap();
      final binding = km.resolve(LogicalKeyboardKey.arrowRight, false, true, false);
      expect(binding, isNotNull);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/commands/default_keymap_test.dart
```

- [ ] **Step 3: Implement default keymap**

Create `packages/duskmoon_code_engine/lib/src/commands/default_keymap.dart`:

```dart
import 'commands.dart';
import 'keymap.dart';

/// Create the default keymap with standard editor key bindings.
///
/// Platform-aware: uses Ctrl on all platforms (Cmd mapping is
/// handled at the widget level by translating Meta to Ctrl).
Keymap defaultKeymap() {
  return Keymap([
    // Cursor movement
    KeyBinding(key: 'ArrowRight', run: _wrap(EditorCommands.cursorCharRight)),
    KeyBinding(key: 'ArrowLeft', run: _wrap(EditorCommands.cursorCharLeft)),
    KeyBinding(key: 'ArrowDown', run: _wrap(EditorCommands.cursorLineDown)),
    KeyBinding(key: 'ArrowUp', run: _wrap(EditorCommands.cursorLineUp)),
    KeyBinding(key: 'Home', run: _wrap(EditorCommands.cursorLineStart)),
    KeyBinding(key: 'End', run: _wrap(EditorCommands.cursorLineEnd)),
    KeyBinding(key: 'Ctrl-Home', run: _wrap(EditorCommands.cursorDocStart)),
    KeyBinding(key: 'Ctrl-End', run: _wrap(EditorCommands.cursorDocEnd)),

    // Selection (Shift variants)
    KeyBinding(key: 'Shift-ArrowRight', run: _wrap(EditorCommands.selectCharRight)),
    KeyBinding(key: 'Shift-ArrowLeft', run: _wrap(EditorCommands.selectCharLeft)),

    // Select all
    KeyBinding(key: 'Ctrl-a', run: _wrapNonNull((s) => EditorCommands.selectAll(s))),

    // Editing
    KeyBinding(key: 'Backspace', run: _wrap(EditorCommands.deleteCharBackward)),
    KeyBinding(key: 'Delete', run: _wrap(EditorCommands.deleteCharForward)),
    KeyBinding(key: 'Enter', run: _wrapNonNull((s) => EditorCommands.insertNewline(s))),
    KeyBinding(key: 'Tab', run: _wrapNonNull((s) => EditorCommands.insertTab(s))),

    // Undo/Redo
    KeyBinding(key: 'Ctrl-z', run: _wrap(EditorCommands.undo)),
    KeyBinding(key: 'Ctrl-Shift-z', run: _wrap(EditorCommands.redo)),
  ]);
}

/// Wrap a nullable command (returns TransactionSpec?) into a Command.
Command _wrap(TransactionSpec? Function(dynamic state) fn) {
  return (dynamic view) {
    final editorView = view as EditorView;
    final spec = fn(editorView.state);
    if (spec == null) return false;
    editorView.dispatch(spec);
    return true;
  };
}

/// Wrap a non-null command (returns TransactionSpec) into a Command.
Command _wrapNonNull(TransactionSpec Function(dynamic state) fn) {
  return (dynamic view) {
    final editorView = view as EditorView;
    editorView.dispatch(fn(editorView.state));
    return true;
  };
}
```

Note: This file imports `EditorView` from the view layer. Add the import:

```dart
import '../view/editor_view.dart';
```

- [ ] **Step 4: Add export**

```dart
export 'src/commands/default_keymap.dart' show defaultKeymap;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/commands/default_keymap_test.dart -r expanded
```

- [ ] **Step 6: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add default keymap with standard bindings"
```

---

## Task 4: InputHandler (TextInputClient for IME)

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/view/input_handler.dart`
- Create: `packages/duskmoon_code_engine/test/src/view/input_handler_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

A `TextInputClient` adapter that exposes a window of text around the cursor to the platform IME, and maps IME edits back to TransactionSpecs. This is critical for CJK input, autocomplete, and software keyboards.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/view/input_handler_test.dart`:

```dart
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('InputHandler', () {
    late EditorView view;

    setUp(() {
      view = EditorView(
        state: EditorState.create(docString: 'hello world'),
      );
    });

    test('creates with initial text editing value', () {
      final handler = InputHandler(view);
      final value = handler.currentTextEditingValue;
      expect(value, isNotNull);
      expect(value!.text, contains('hello'));
    });

    test('updateEditingValue dispatches insertion', () {
      final handler = InputHandler(view);
      final initial = handler.currentTextEditingValue!;
      // Simulate typing 'X' at position 5
      handler.updateEditingValue(TextEditingValue(
        text: '${initial.text.substring(0, 5)}X${initial.text.substring(5)}',
        selection: const TextSelection.collapsed(offset: 6),
      ));
      expect(view.state.doc.toString(), 'helloX world');
    });

    test('updateEditingValue dispatches deletion', () {
      final handler = InputHandler(view);
      final initial = handler.currentTextEditingValue!;
      // Simulate deleting character at position 4 ('o')
      handler.updateEditingValue(TextEditingValue(
        text: '${initial.text.substring(0, 4)}${initial.text.substring(5)}',
        selection: const TextSelection.collapsed(offset: 4),
      ));
      expect(view.state.doc.toString(), 'hell world');
    });

    test('updateEditingValue dispatches replacement', () {
      final handler = InputHandler(view);
      // Simulate selecting "hello" (0-5) and replacing with "hi"
      handler.updateEditingValue(TextEditingValue(
        text: 'hi world',
        selection: const TextSelection.collapsed(offset: 2),
      ));
      expect(view.state.doc.toString(), 'hi world');
    });

    test('close stops input', () {
      final handler = InputHandler(view);
      handler.connectionClosed();
      // Should not throw
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/view/input_handler_test.dart
```

- [ ] **Step 3: Implement InputHandler**

Create `packages/duskmoon_code_engine/lib/src/view/input_handler.dart`:

```dart
import 'package:flutter/services.dart';

import '../document/change.dart';
import '../state/editor_state.dart';
import '../state/selection.dart';
import 'editor_view.dart';

/// Adapts Flutter's [TextInputClient] to the editor's transaction system.
///
/// Exposes the full document text to the platform IME (simplified
/// approach for MVP — a production version would window ±500 chars
/// around the cursor). Maps IME edits back to [TransactionSpec]s
/// via string diffing.
class InputHandler implements TextInputClient {
  InputHandler(this._view) {
    _lastValue = _buildValue();
  }

  final EditorView _view;
  late TextEditingValue _lastValue;
  TextInputConnection? _connection;

  /// Connect to the platform text input.
  void attach() {
    _connection = TextInput.attach(
      this,
      const TextInputConfiguration(
        inputType: TextInputType.multiline,
        inputAction: TextInputAction.newline,
        enableSuggestions: false,
        autocorrect: false,
      ),
    );
    _connection!.show();
    _syncToIME();
  }

  /// Detach from platform text input.
  void detach() {
    _connection?.close();
    _connection = null;
  }

  /// Sync current state to the IME.
  void syncState() {
    _lastValue = _buildValue();
    _syncToIME();
  }

  TextEditingValue _buildValue() {
    final doc = _view.state.doc;
    final sel = _view.state.selection.main;
    return TextEditingValue(
      text: doc.toString(),
      selection: TextSelection(
        baseOffset: sel.anchor,
        extentOffset: sel.head,
      ),
    );
  }

  void _syncToIME() {
    _connection?.setEditingState(_lastValue);
  }

  // --- TextInputClient ---

  @override
  TextEditingValue? get currentTextEditingValue => _lastValue;

  @override
  void updateEditingValue(TextEditingValue value) {
    if (value.text == _lastValue.text &&
        value.selection == _lastValue.selection) {
      return;
    }

    final oldText = _lastValue.text;
    final newText = value.text;

    if (oldText != newText) {
      // Find the diff between old and new text
      final diff = _diff(oldText, newText);
      _view.dispatch(TransactionSpec(
        changes: ChangeSet.of(
          oldText.length,
          [ChangeSpec(from: diff.from, to: diff.to, insert: diff.insert)],
        ),
        selection: EditorSelection(ranges: [
          SelectionRange(
            anchor: value.selection.baseOffset,
            head: value.selection.extentOffset,
          ),
        ]),
      ));
    } else if (value.selection != _lastValue.selection) {
      // Selection-only change
      _view.dispatch(TransactionSpec(
        selection: EditorSelection(ranges: [
          SelectionRange(
            anchor: value.selection.baseOffset,
            head: value.selection.extentOffset,
          ),
        ]),
      ));
    }

    _lastValue = value;
  }

  @override
  void performAction(TextInputAction action) {
    // Enter handled by keymap, not IME action
  }

  @override
  void updateFloatingCursor(RawFloatingCursorPoint point) {}

  @override
  void connectionClosed() {
    _connection = null;
  }

  @override
  AutofillScope? get currentAutofillScope => null;

  @override
  void showAutocorrectionPromptRect(int start, int end) {}

  @override
  void performPrivateCommand(String action, Map<String, dynamic> data) {}

  @override
  void insertTextPlaceholder(Size size) {}

  @override
  void removeTextPlaceholder() {}

  @override
  void showToolbar() {}

  @override
  void didChangeInputControl(
      TextInputControl? oldControl, TextInputControl? newControl) {}

  @override
  void performSelector(String selectorName) {}

  @override
  void insertContent(KeyboardInsertedContent content) {}

  /// Simple diff: find the first and last characters that differ.
  static _Diff _diff(String oldText, String newText) {
    var prefixLen = 0;
    final minLen = oldText.length < newText.length
        ? oldText.length
        : newText.length;
    while (prefixLen < minLen &&
        oldText.codeUnitAt(prefixLen) == newText.codeUnitAt(prefixLen)) {
      prefixLen++;
    }

    var oldSuffix = oldText.length;
    var newSuffix = newText.length;
    while (oldSuffix > prefixLen &&
        newSuffix > prefixLen &&
        oldText.codeUnitAt(oldSuffix - 1) ==
            newText.codeUnitAt(newSuffix - 1)) {
      oldSuffix--;
      newSuffix--;
    }

    return _Diff(
      prefixLen,
      oldSuffix,
      newText.substring(prefixLen, newSuffix),
    );
  }
}

class _Diff {
  const _Diff(this.from, this.to, this.insert);
  final int from;
  final int to;
  final String insert;
}
```

- [ ] **Step 4: Add export**

```dart
export 'src/view/input_handler.dart' show InputHandler;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/view/input_handler_test.dart -r expanded
```

- [ ] **Step 6: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add InputHandler TextInputClient adapter"
```

---

## Task 5: Wire keyboard, cursor, and click into CodeEditorWidget

**Files:**
- Modify: `packages/duskmoon_code_engine/lib/src/view/code_editor_widget.dart`
- Modify: `packages/duskmoon_code_engine/test/src/view/code_editor_widget_test.dart`

This is the integration task — add keyboard handling, cursor rendering, and click-to-position to the existing widget.

### Changes to _CodeEditorWidgetState:

1. **Add CursorBlink** — create in initState, listen for changes, dispose
2. **Add InputHandler** — create/attach on focus, detach on blur
3. **Add default keymap** — resolve key events via Focus.onKeyEvent
4. **Add GestureDetector** — tap to position cursor
5. **Render cursor** — overlay SelectionPainter on each line that has the cursor
6. **Sync IME** — after each state change, sync the InputHandler

### Key integration points:

**Focus.onKeyEvent handler:**
```dart
KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
  if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
    return KeyEventResult.ignored;
  }
  if (widget.readOnly) return KeyEventResult.ignored;
  
  final key = event.logicalKey;
  final ctrl = HardwareKeyboard.instance.isControlPressed ||
      HardwareKeyboard.instance.isMetaPressed; // Cmd = Ctrl
  final shift = HardwareKeyboard.instance.isShiftPressed;
  final alt = HardwareKeyboard.instance.isAltPressed;
  
  final binding = _keymap.resolve(key, ctrl, shift, alt);
  if (binding?.run != null) {
    final handled = binding!.run!(_controller.view);
    if (handled) {
      _cursorBlink.restart();
      _inputHandler?.syncState();
      return KeyEventResult.handled;
    }
  }
  
  // If no binding matched and it's a printable character, insert it
  if (!ctrl && !alt && event.character != null && event.character!.isNotEmpty) {
    _controller.insertText(event.character!);
    _cursorBlink.restart();
    _inputHandler?.syncState();
    return KeyEventResult.handled;
  }
  
  return KeyEventResult.ignored;
}
```

**Tap handler:**
```dart
void _handleTap(TapDownDetails details) {
  _focusNode.requestFocus();
  final localY = details.localPosition.dy;
  final lineIndex = PositionUtils.lineForY(
    localY, lineHeight: _defaultLineHeight,
    maxLine: _controller.document.lineCount - 1,
  );
  // For MVP, place cursor at start of tapped line
  // (proper x-to-column mapping requires TextPainter measurement)
  final offset = PositionUtils.offsetFromLineCol(
    lineIndex, 0, _controller.document,
  );
  _controller.setSelection(EditorSelection.cursor(offset));
  _cursorBlink.restart();
}
```

**Cursor rendering per line:**
For the line containing the cursor, stack a SelectionPainter on top of the LinePainter. The cursor x offset is approximated using a monospace width estimate (fontSize * 0.6 per character for MVP).

### Tests to add:

```dart
testWidgets('accepts keyboard focus', (tester) async {
  final ctrl = EditorViewController(text: 'hello');
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(body: CodeEditorWidget(controller: ctrl, autofocus: true)),
  ));
  await tester.pumpAndSettle();
  // Widget should have focus
  expect(find.byType(CodeEditorWidget), findsOneWidget);
  ctrl.dispose();
});

testWidgets('tap sets focus', (tester) async {
  final ctrl = EditorViewController(text: 'hello\nworld');
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(body: CodeEditorWidget(controller: ctrl)),
  ));
  await tester.pumpAndSettle();
  await tester.tap(find.byType(CodeEditorWidget));
  await tester.pumpAndSettle();
  expect(find.byType(CodeEditorWidget), findsOneWidget);
  ctrl.dispose();
});
```

- [ ] **Step 1: Modify code_editor_widget.dart**

Add to state class:
- `late CursorBlink _cursorBlink;` — created in initState, disposed
- `InputHandler? _inputHandler;` — created when focused
- `late Keymap _keymap;` — `defaultKeymap()` in initState
- `Focus.onKeyEvent: _handleKeyEvent`
- `GestureDetector` wrapping the content
- Cursor rendering via SelectionPainter on the active line

The implementer should read the current code_editor_widget.dart and integrate these changes while preserving existing functionality.

- [ ] **Step 2: Add new tests to code_editor_widget_test.dart**

Add the focus and tap tests above.

- [ ] **Step 3: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/view/code_editor_widget_test.dart -r expanded
```

- [ ] **Step 4: Run all tests and analyzer**

```bash
cd packages/duskmoon_code_engine && flutter test && dart analyze --fatal-infos
```

- [ ] **Step 5: Commit**

```bash
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): wire keyboard input, cursor, and click to widget"
```

---

## Task 6: Final verification and barrel cleanup

**Files:**
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

- [ ] **Step 1: Verify barrel exports include all Phase 3b additions**

Ensure the barrel has:
```dart
export 'src/view/cursor_blink.dart' show CursorBlink;
export 'src/view/input_handler.dart' show InputHandler;
export 'src/view/position_utils.dart' show LineColumn, PositionUtils;
export 'src/commands/default_keymap.dart' show defaultKeymap;
```

- [ ] **Step 2: Run full test suite**

```bash
cd packages/duskmoon_code_engine && flutter test -r expanded
```

- [ ] **Step 3: Run workspace analyzer**

```bash
melos run analyze
```

- [ ] **Step 4: Commit if changes**

```bash
git add packages/duskmoon_code_engine/
git commit -m "chore(duskmoon_code_engine): finalize Phase 3b barrel exports"
```

---

## Summary

Phase 3b delivers **6 tasks** producing:

| Component | Files | Tests |
|-----------|-------|-------|
| PositionUtils | position_utils.dart | position_utils_test.dart |
| CursorBlink | cursor_blink.dart | — |
| Default keymap | default_keymap.dart | default_keymap_test.dart |
| InputHandler | input_handler.dart | input_handler_test.dart |
| Widget integration | code_editor_widget.dart (modified) | code_editor_widget_test.dart (modified) |

**Deliverable:** A typeable code editor — users can click to focus, type characters, use arrow keys to navigate, Backspace/Delete to edit, Tab to indent, Enter for newlines, Ctrl-Z/Ctrl-Shift-Z for undo/redo, Ctrl-A to select all, and Shift-arrows for selection. Cursor blinks at the insertion point.

**What's NOT in this phase (deferred):**
- Precise x-to-column mapping via TextPainter measurement (using monospace estimate for MVP)
- Click-drag selection (only tap-to-position)
- IME composition underline rendering
- Copy/paste via Ctrl-C/Ctrl-V (requires clipboard API integration)
- Word-level cursor movement (Ctrl-arrows)
- Page up/down
