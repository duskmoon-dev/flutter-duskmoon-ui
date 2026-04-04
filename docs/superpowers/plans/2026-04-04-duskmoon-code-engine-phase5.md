# duskmoon_code_engine Phase 5 — Advanced Features Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add clipboard operations (copy/cut/paste), word-level cursor movement (Ctrl-arrows), search & replace with UI overlay, and line operations (duplicate, move, delete) — making the editor production-usable.

**Architecture:** Clipboard uses Flutter's `Clipboard` service for system clipboard integration, with commands that read selection content and dispatch transactions. Word movement scans for word boundaries using character classification. Search uses a StateField to track match state and a search panel overlay widget. Line operations work on whole-line ranges derived from the cursor position. All features are wired to the default keymap with standard bindings.

**Tech Stack:** Dart 3.5+, Flutter SDK (`Clipboard`, `Overlay`)

**Spec:** `docs/code-engine.md` sections 9.3, 10 (search)

**Depends on:** Phases 1-4b (complete)

---

## File Structure

```
packages/duskmoon_code_engine/lib/src/
├── commands/
│   ├── commands.dart               # MODIFY — add word movement, line ops
│   ├── clipboard.dart              # CREATE — copy, cut, paste commands
│   ├── default_keymap.dart         # MODIFY — add new bindings
│   └── search.dart                 # CREATE — search state + commands
│
├── view/
│   └── search_panel.dart           # CREATE — search UI overlay widget

test/src/
├── commands/
│   ├── clipboard_test.dart         # CREATE
│   ├── word_movement_test.dart     # CREATE
│   ├── line_ops_test.dart          # CREATE
│   └── search_test.dart            # CREATE
```

---

## Task 1: Word-level cursor movement

**Files:**
- Modify: `packages/duskmoon_code_engine/lib/src/commands/commands.dart`
- Create: `packages/duskmoon_code_engine/test/src/commands/word_movement_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/src/commands/default_keymap.dart`

Add Ctrl-Left/Right for word-by-word navigation and Ctrl-Shift-Left/Right for word selection.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/commands/word_movement_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('Word movement', () {
    group('cursorWordRight', () {
      test('moves to end of current word', () {
        final state = EditorState.create(
          docString: 'hello world',
          selection: EditorSelection.cursor(0),
        );
        final spec = EditorCommands.cursorWordRight(state);
        expect(spec, isNotNull);
        expect(spec!.selection!.main.head, 5); // end of "hello"
      });

      test('skips whitespace after word', () {
        final state = EditorState.create(
          docString: 'hello world',
          selection: EditorSelection.cursor(5),
        );
        final spec = EditorCommands.cursorWordRight(state);
        expect(spec!.selection!.main.head, 11); // end of "world"
      });

      test('handles punctuation as word boundary', () {
        final state = EditorState.create(
          docString: 'foo.bar',
          selection: EditorSelection.cursor(0),
        );
        final spec = EditorCommands.cursorWordRight(state);
        expect(spec!.selection!.main.head, 3); // stops at "."
      });

      test('returns null at end of document', () {
        final state = EditorState.create(
          docString: 'hello',
          selection: EditorSelection.cursor(5),
        );
        expect(EditorCommands.cursorWordRight(state), isNull);
      });

      test('works across line boundaries', () {
        final state = EditorState.create(
          docString: 'hello\nworld',
          selection: EditorSelection.cursor(5),
        );
        final spec = EditorCommands.cursorWordRight(state);
        expect(spec!.selection!.main.head, 11); // end of "world"
      });
    });

    group('cursorWordLeft', () {
      test('moves to start of current word', () {
        final state = EditorState.create(
          docString: 'hello world',
          selection: EditorSelection.cursor(8),
        );
        final spec = EditorCommands.cursorWordLeft(state);
        expect(spec!.selection!.main.head, 6); // start of "world"
      });

      test('skips whitespace before word', () {
        final state = EditorState.create(
          docString: 'hello world',
          selection: EditorSelection.cursor(6),
        );
        final spec = EditorCommands.cursorWordLeft(state);
        expect(spec!.selection!.main.head, 0); // start of "hello"
      });

      test('returns null at start of document', () {
        final state = EditorState.create(
          docString: 'hello',
          selection: EditorSelection.cursor(0),
        );
        expect(EditorCommands.cursorWordLeft(state), isNull);
      });
    });

    group('selectWordRight', () {
      test('extends selection to end of word', () {
        final state = EditorState.create(
          docString: 'hello world',
          selection: EditorSelection.cursor(0),
        );
        final spec = EditorCommands.selectWordRight(state);
        expect(spec!.selection!.main.anchor, 0);
        expect(spec.selection!.main.head, 5);
      });
    });

    group('selectWordLeft', () {
      test('extends selection to start of word', () {
        final state = EditorState.create(
          docString: 'hello world',
          selection: EditorSelection.cursor(11),
        );
        final spec = EditorCommands.selectWordLeft(state);
        expect(spec!.selection!.main.anchor, 11);
        expect(spec.selection!.main.head, 6);
      });
    });

    group('deleteWordBackward', () {
      test('deletes word before cursor', () {
        final state = EditorState.create(
          docString: 'hello world',
          selection: EditorSelection.cursor(5),
        );
        final spec = EditorCommands.deleteWordBackward(state);
        expect(spec, isNotNull);
        final newState = state.applyTransaction(state.update(spec!));
        expect(newState.doc.toString(), ' world');
      });
    });

    group('deleteWordForward', () {
      test('deletes word after cursor', () {
        final state = EditorState.create(
          docString: 'hello world',
          selection: EditorSelection.cursor(6),
        );
        final spec = EditorCommands.deleteWordForward(state);
        expect(spec, isNotNull);
        final newState = state.applyTransaction(state.update(spec!));
        expect(newState.doc.toString(), 'hello ');
      });
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/commands/word_movement_test.dart
```

- [ ] **Step 3: Implement word movement commands**

Add to `packages/duskmoon_code_engine/lib/src/commands/commands.dart` (inside `EditorCommands` class):

```dart
  // ---------------------------------------------------------------------------
  // Word movement
  // ---------------------------------------------------------------------------

  static TransactionSpec? cursorWordRight(EditorState state) {
    final head = state.selection.main.head;
    if (head >= state.doc.length) return null;
    final pos = _findWordBoundaryRight(state.doc.toString(), head);
    if (pos == head) return null;
    return TransactionSpec(selection: EditorSelection.cursor(pos));
  }

  static TransactionSpec? cursorWordLeft(EditorState state) {
    final head = state.selection.main.head;
    if (head <= 0) return null;
    final pos = _findWordBoundaryLeft(state.doc.toString(), head);
    if (pos == head) return null;
    return TransactionSpec(selection: EditorSelection.cursor(pos));
  }

  static TransactionSpec? selectWordRight(EditorState state) {
    final sel = state.selection.main;
    if (sel.head >= state.doc.length) return null;
    final pos = _findWordBoundaryRight(state.doc.toString(), sel.head);
    if (pos == sel.head) return null;
    return TransactionSpec(
      selection: EditorSelection(ranges: [
        SelectionRange(anchor: sel.anchor, head: pos),
      ]),
    );
  }

  static TransactionSpec? selectWordLeft(EditorState state) {
    final sel = state.selection.main;
    if (sel.head <= 0) return null;
    final pos = _findWordBoundaryLeft(state.doc.toString(), sel.head);
    if (pos == sel.head) return null;
    return TransactionSpec(
      selection: EditorSelection(ranges: [
        SelectionRange(anchor: sel.anchor, head: pos),
      ]),
    );
  }

  static TransactionSpec? deleteWordBackward(EditorState state) {
    final sel = state.selection.main;
    if (!sel.isEmpty) return deleteSelection(state);
    if (sel.head <= 0) return null;
    final pos = _findWordBoundaryLeft(state.doc.toString(), sel.head);
    return TransactionSpec(
      changes: ChangeSet.of(state.doc.length, [ChangeSpec(from: pos, to: sel.head)]),
      selection: EditorSelection.cursor(pos),
    );
  }

  static TransactionSpec? deleteWordForward(EditorState state) {
    final sel = state.selection.main;
    if (!sel.isEmpty) return deleteSelection(state);
    if (sel.head >= state.doc.length) return null;
    final pos = _findWordBoundaryRight(state.doc.toString(), sel.head);
    return TransactionSpec(
      changes: ChangeSet.of(state.doc.length, [ChangeSpec(from: sel.head, to: pos)]),
    );
  }

  // --- Word boundary helpers ---

  static int _findWordBoundaryRight(String text, int pos) {
    if (pos >= text.length) return pos;
    // Skip current word characters
    var i = pos;
    if (_isWordChar(text.codeUnitAt(i))) {
      while (i < text.length && _isWordChar(text.codeUnitAt(i))) {
        i++;
      }
    }
    // Skip whitespace/punctuation
    while (i < text.length && !_isWordChar(text.codeUnitAt(i))) {
      i++;
    }
    // If we only skipped non-word chars, find end of next word
    if (i == pos) {
      while (i < text.length && !_isWordChar(text.codeUnitAt(i))) {
        i++;
      }
    }
    return i > pos ? i : (pos < text.length ? pos + 1 : pos);
  }

  static int _findWordBoundaryLeft(String text, int pos) {
    if (pos <= 0) return 0;
    var i = pos;
    // Skip whitespace/punctuation before cursor
    while (i > 0 && !_isWordChar(text.codeUnitAt(i - 1))) {
      i--;
    }
    // Skip word characters
    while (i > 0 && _isWordChar(text.codeUnitAt(i - 1))) {
      i--;
    }
    return i < pos ? i : (pos > 0 ? pos - 1 : 0);
  }

  static bool _isWordChar(int ch) =>
      (ch >= 0x30 && ch <= 0x39) || // 0-9
      (ch >= 0x41 && ch <= 0x5A) || // A-Z
      (ch >= 0x61 && ch <= 0x7A) || // a-z
      ch == 0x5F; // _
```

- [ ] **Step 4: Add keymap bindings**

Add to `default_keymap.dart` (inside `defaultKeymap()`, after existing cursor bindings):

```dart
    // Word movement
    KeyBinding(key: 'Ctrl-ArrowRight', run: _wrap((s) => EditorCommands.cursorWordRight(s))),
    KeyBinding(key: 'Ctrl-ArrowLeft', run: _wrap((s) => EditorCommands.cursorWordLeft(s))),
    KeyBinding(key: 'Ctrl-Shift-ArrowRight', run: _wrap((s) => EditorCommands.selectWordRight(s))),
    KeyBinding(key: 'Ctrl-Shift-ArrowLeft', run: _wrap((s) => EditorCommands.selectWordLeft(s))),
    KeyBinding(key: 'Ctrl-Backspace', run: _wrap((s) => EditorCommands.deleteWordBackward(s))),
    KeyBinding(key: 'Ctrl-Delete', run: _wrap((s) => EditorCommands.deleteWordForward(s))),
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/commands/word_movement_test.dart -r expanded
```

- [ ] **Step 6: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add word-level cursor movement and deletion"
```

---

## Task 2: Line operations (duplicate, move, delete line)

**Files:**
- Modify: `packages/duskmoon_code_engine/lib/src/commands/commands.dart`
- Create: `packages/duskmoon_code_engine/test/src/commands/line_ops_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/src/commands/default_keymap.dart`

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/commands/line_ops_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('Line operations', () {
    group('deleteLine', () {
      test('deletes current line', () {
        final state = EditorState.create(
          docString: 'aaa\nbbb\nccc',
          selection: EditorSelection.cursor(5), // in "bbb"
        );
        final spec = EditorCommands.deleteLine(state);
        final newState = state.applyTransaction(state.update(spec));
        expect(newState.doc.toString(), 'aaa\nccc');
      });

      test('deletes first line', () {
        final state = EditorState.create(
          docString: 'aaa\nbbb',
          selection: EditorSelection.cursor(1),
        );
        final spec = EditorCommands.deleteLine(state);
        final newState = state.applyTransaction(state.update(spec));
        expect(newState.doc.toString(), 'bbb');
      });

      test('deletes last line', () {
        final state = EditorState.create(
          docString: 'aaa\nbbb',
          selection: EditorSelection.cursor(5),
        );
        final spec = EditorCommands.deleteLine(state);
        final newState = state.applyTransaction(state.update(spec));
        expect(newState.doc.toString(), 'aaa');
      });

      test('deletes only line leaves empty', () {
        final state = EditorState.create(
          docString: 'hello',
          selection: EditorSelection.cursor(2),
        );
        final spec = EditorCommands.deleteLine(state);
        final newState = state.applyTransaction(state.update(spec));
        expect(newState.doc.toString(), '');
      });
    });

    group('duplicateLine', () {
      test('duplicates current line below', () {
        final state = EditorState.create(
          docString: 'aaa\nbbb\nccc',
          selection: EditorSelection.cursor(5),
        );
        final spec = EditorCommands.duplicateLine(state);
        final newState = state.applyTransaction(state.update(spec));
        expect(newState.doc.toString(), 'aaa\nbbb\nbbb\nccc');
      });

      test('duplicates last line', () {
        final state = EditorState.create(
          docString: 'aaa\nbbb',
          selection: EditorSelection.cursor(5),
        );
        final spec = EditorCommands.duplicateLine(state);
        final newState = state.applyTransaction(state.update(spec));
        expect(newState.doc.toString(), 'aaa\nbbb\nbbb');
      });
    });

    group('moveLineUp', () {
      test('swaps current line with line above', () {
        final state = EditorState.create(
          docString: 'aaa\nbbb\nccc',
          selection: EditorSelection.cursor(5),
        );
        final spec = EditorCommands.moveLineUp(state);
        expect(spec, isNotNull);
        final newState = state.applyTransaction(state.update(spec!));
        expect(newState.doc.toString(), 'bbb\naaa\nccc');
      });

      test('returns null when on first line', () {
        final state = EditorState.create(
          docString: 'aaa\nbbb',
          selection: EditorSelection.cursor(1),
        );
        expect(EditorCommands.moveLineUp(state), isNull);
      });
    });

    group('moveLineDown', () {
      test('swaps current line with line below', () {
        final state = EditorState.create(
          docString: 'aaa\nbbb\nccc',
          selection: EditorSelection.cursor(1),
        );
        final spec = EditorCommands.moveLineDown(state);
        expect(spec, isNotNull);
        final newState = state.applyTransaction(state.update(spec!));
        expect(newState.doc.toString(), 'bbb\naaa\nccc');
      });

      test('returns null when on last line', () {
        final state = EditorState.create(
          docString: 'aaa\nbbb',
          selection: EditorSelection.cursor(5),
        );
        expect(EditorCommands.moveLineDown(state), isNull);
      });
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/commands/line_ops_test.dart
```

- [ ] **Step 3: Implement line operations**

Add to `commands.dart` (inside `EditorCommands` class):

```dart
  // ---------------------------------------------------------------------------
  // Line operations
  // ---------------------------------------------------------------------------

  static TransactionSpec deleteLine(EditorState state) {
    final head = state.selection.main.head;
    final line = state.doc.lineAtOffset(head);
    int from;
    int to;
    if (line.number < state.doc.lineCount) {
      // Delete line including trailing newline
      from = line.from;
      to = line.to + 1; // +1 for \n
    } else if (line.number > 1) {
      // Last line: delete including preceding newline
      from = line.from - 1;
      to = line.to;
    } else {
      // Only line: clear everything
      from = 0;
      to = state.doc.length;
    }
    return TransactionSpec(
      changes: ChangeSet.of(state.doc.length, [ChangeSpec(from: from, to: to)]),
      selection: EditorSelection.cursor(from.clamp(0, state.doc.length - (to - from))),
    );
  }

  static TransactionSpec duplicateLine(EditorState state) {
    final head = state.selection.main.head;
    final line = state.doc.lineAtOffset(head);
    final lineText = line.text;
    // Insert a copy of the line after it
    final insertAt = line.to;
    return TransactionSpec(
      changes: ChangeSet.of(
        state.doc.length,
        [ChangeSpec.insert(insertAt, '\n$lineText')],
      ),
      selection: EditorSelection.cursor(head + lineText.length + 1),
    );
  }

  static TransactionSpec? moveLineUp(EditorState state) {
    final head = state.selection.main.head;
    final line = state.doc.lineAtOffset(head);
    if (line.number <= 1) return null;
    final prevLine = state.doc.lineAt(line.number - 1);
    // Swap: replace [prevLine.from..line.to] with [line.text\nprevLine.text]
    final newText = '${line.text}\n${prevLine.text}';
    final col = head - line.from;
    return TransactionSpec(
      changes: ChangeSet.of(
        state.doc.length,
        [ChangeSpec(from: prevLine.from, to: line.to, insert: newText)],
      ),
      selection: EditorSelection.cursor(prevLine.from + col),
    );
  }

  static TransactionSpec? moveLineDown(EditorState state) {
    final head = state.selection.main.head;
    final line = state.doc.lineAtOffset(head);
    if (line.number >= state.doc.lineCount) return null;
    final nextLine = state.doc.lineAt(line.number + 1);
    final newText = '${nextLine.text}\n${line.text}';
    final col = head - line.from;
    return TransactionSpec(
      changes: ChangeSet.of(
        state.doc.length,
        [ChangeSpec(from: line.from, to: nextLine.to, insert: newText)],
      ),
      selection: EditorSelection.cursor(line.from + nextLine.text.length + 1 + col),
    );
  }
```

- [ ] **Step 4: Add keymap bindings**

Add to `default_keymap.dart`:

```dart
    // Line operations
    KeyBinding(key: 'Ctrl-Shift-k', run: _wrapNonNull((s) => EditorCommands.deleteLine(s))),
    KeyBinding(key: 'Ctrl-Shift-d', run: _wrapNonNull((s) => EditorCommands.duplicateLine(s))),
    KeyBinding(key: 'Alt-ArrowUp', run: _wrap((s) => EditorCommands.moveLineUp(s))),
    KeyBinding(key: 'Alt-ArrowDown', run: _wrap((s) => EditorCommands.moveLineDown(s))),
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/commands/line_ops_test.dart -r expanded
```

- [ ] **Step 6: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add line operations (delete, duplicate, move)"
```

---

## Task 3: Clipboard (copy, cut, paste)

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/commands/clipboard.dart`
- Create: `packages/duskmoon_code_engine/test/src/commands/clipboard_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/src/commands/default_keymap.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

Clipboard operations using Flutter's `Clipboard` service. Copy/cut read selection text and put it on the system clipboard. Paste reads from clipboard and inserts.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/commands/clipboard_test.dart`:

```dart
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('ClipboardCommands', () {
    group('getSelectedText', () {
      test('returns selected text', () {
        final state = EditorState.create(
          docString: 'hello world',
          selection: EditorSelection.single(anchor: 0, head: 5),
        );
        expect(ClipboardCommands.getSelectedText(state), 'hello');
      });

      test('returns empty string for cursor (no selection)', () {
        final state = EditorState.create(
          docString: 'hello',
          selection: EditorSelection.cursor(3),
        );
        expect(ClipboardCommands.getSelectedText(state), '');
      });

      test('handles reversed selection', () {
        final state = EditorState.create(
          docString: 'hello world',
          selection: EditorSelection.single(anchor: 5, head: 0),
        );
        expect(ClipboardCommands.getSelectedText(state), 'hello');
      });
    });

    group('cutSpec', () {
      test('deletes selected text', () {
        final state = EditorState.create(
          docString: 'hello world',
          selection: EditorSelection.single(anchor: 5, head: 11),
        );
        final spec = ClipboardCommands.cutSpec(state);
        expect(spec, isNotNull);
        final newState = state.applyTransaction(state.update(spec!));
        expect(newState.doc.toString(), 'hello');
      });

      test('returns null when no selection', () {
        final state = EditorState.create(
          docString: 'hello',
          selection: EditorSelection.cursor(3),
        );
        expect(ClipboardCommands.cutSpec(state), isNull);
      });
    });

    group('pasteSpec', () {
      test('inserts text at cursor', () {
        final state = EditorState.create(
          docString: 'hello',
          selection: EditorSelection.cursor(5),
        );
        final spec = ClipboardCommands.pasteSpec(state, ' world');
        final newState = state.applyTransaction(state.update(spec));
        expect(newState.doc.toString(), 'hello world');
      });

      test('replaces selection with pasted text', () {
        final state = EditorState.create(
          docString: 'hello world',
          selection: EditorSelection.single(anchor: 6, head: 11),
        );
        final spec = ClipboardCommands.pasteSpec(state, 'dart');
        final newState = state.applyTransaction(state.update(spec));
        expect(newState.doc.toString(), 'hello dart');
      });
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/commands/clipboard_test.dart
```

- [ ] **Step 3: Implement ClipboardCommands**

Create `packages/duskmoon_code_engine/lib/src/commands/clipboard.dart`:

```dart
import 'package:flutter/services.dart';

import '../document/change.dart';
import '../state/editor_state.dart';
import '../state/selection.dart';
import '../view/editor_view.dart';
import 'keymap.dart';

/// Clipboard-related commands.
///
/// Copy and cut use [Clipboard.setData] to write to the system clipboard.
/// Paste uses [Clipboard.getData] to read. Since clipboard operations are
/// async, the Command functions handle the async dispatch internally.
abstract final class ClipboardCommands {
  /// Get the currently selected text.
  static String getSelectedText(EditorState state) {
    final sel = state.selection.main;
    if (sel.isEmpty) return '';
    return state.doc.sliceString(sel.from, sel.to);
  }

  /// Create a TransactionSpec that deletes the selection (for cut).
  static TransactionSpec? cutSpec(EditorState state) {
    final sel = state.selection.main;
    if (sel.isEmpty) return null;
    return TransactionSpec(
      changes: ChangeSet.of(
        state.doc.length,
        [ChangeSpec(from: sel.from, to: sel.to)],
      ),
      selection: EditorSelection.cursor(sel.from),
    );
  }

  /// Create a TransactionSpec that inserts pasted text.
  static TransactionSpec pasteSpec(EditorState state, String text) {
    final sel = state.selection.main;
    return TransactionSpec(
      changes: ChangeSet.of(
        state.doc.length,
        [ChangeSpec(from: sel.from, to: sel.to, insert: text)],
      ),
      selection: EditorSelection.cursor(sel.from + text.length),
    );
  }

  /// Copy command: copies selection to system clipboard.
  /// Returns a Command for use in keymaps.
  static Command copyCommand() {
    return (dynamic view) {
      final ev = view as EditorView;
      final text = getSelectedText(ev.state);
      if (text.isEmpty) return false;
      Clipboard.setData(ClipboardData(text: text));
      return true;
    };
  }

  /// Cut command: copies selection to clipboard and deletes it.
  static Command cutCommand() {
    return (dynamic view) {
      final ev = view as EditorView;
      final text = getSelectedText(ev.state);
      if (text.isEmpty) return false;
      Clipboard.setData(ClipboardData(text: text));
      final spec = cutSpec(ev.state);
      if (spec != null) ev.dispatch(spec);
      return true;
    };
  }

  /// Paste command: reads from clipboard and inserts.
  static Command pasteCommand() {
    return (dynamic view) {
      final ev = view as EditorView;
      Clipboard.getData(Clipboard.kTextPlain).then((data) {
        if (data?.text != null && data!.text!.isNotEmpty) {
          ev.dispatch(pasteSpec(ev.state, data.text!));
        }
      });
      return true;
    };
  }
}
```

- [ ] **Step 4: Add keymap bindings and export**

Add to `default_keymap.dart`:

```dart
    // Clipboard
    KeyBinding(key: 'Ctrl-c', run: ClipboardCommands.copyCommand()),
    KeyBinding(key: 'Ctrl-x', run: ClipboardCommands.cutCommand()),
    KeyBinding(key: 'Ctrl-v', run: ClipboardCommands.pasteCommand()),
```

Add import: `import 'clipboard.dart';`

Add to barrel:
```dart
export 'src/commands/clipboard.dart' show ClipboardCommands;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/commands/clipboard_test.dart -r expanded
```

- [ ] **Step 6: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add clipboard copy/cut/paste with Ctrl-C/X/V"
```

---

## Task 4: Search state and commands

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/commands/search.dart`
- Create: `packages/duskmoon_code_engine/test/src/commands/search_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/src/commands/default_keymap.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

Search finds all occurrences of a query in the document. The search state tracks: query string, matches list, active match index, case sensitivity, and regex mode.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/commands/search_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('SearchState', () {
    test('finds all matches', () {
      final doc = Document.fromString('foo bar foo baz foo');
      final result = SearchState.findMatches(doc, 'foo');
      expect(result.length, 3);
      expect(result[0].from, 0);
      expect(result[0].to, 3);
      expect(result[1].from, 8);
      expect(result[2].from, 16);
    });

    test('finds no matches', () {
      final doc = Document.fromString('hello world');
      final result = SearchState.findMatches(doc, 'xyz');
      expect(result, isEmpty);
    });

    test('empty query returns no matches', () {
      final doc = Document.fromString('hello');
      expect(SearchState.findMatches(doc, ''), isEmpty);
    });

    test('case insensitive search', () {
      final doc = Document.fromString('Hello hello HELLO');
      final result = SearchState.findMatches(doc, 'hello', caseSensitive: false);
      expect(result.length, 3);
    });

    test('case sensitive search', () {
      final doc = Document.fromString('Hello hello HELLO');
      final result = SearchState.findMatches(doc, 'hello', caseSensitive: true);
      expect(result.length, 1);
      expect(result[0].from, 6);
    });

    test('regex search', () {
      final doc = Document.fromString('foo123 bar456 baz');
      final result = SearchState.findMatches(doc, r'\d+', useRegex: true);
      expect(result.length, 2);
    });
  });

  group('SearchCommands', () {
    test('findNext moves to next match', () {
      final doc = Document.fromString('foo bar foo baz foo');
      final matches = SearchState.findMatches(doc, 'foo');
      final state = EditorState.create(
        docString: 'foo bar foo baz foo',
        selection: EditorSelection.cursor(0),
      );
      final spec = SearchCommands.findNext(state, matches, 0);
      expect(spec.selection!.main.from, 8);
      expect(spec.selection!.main.to, 11);
    });

    test('findNext wraps around', () {
      final doc = Document.fromString('foo bar foo');
      final matches = SearchState.findMatches(doc, 'foo');
      final state = EditorState.create(
        docString: 'foo bar foo',
        selection: EditorSelection.cursor(8),
      );
      final spec = SearchCommands.findNext(state, matches, 1);
      expect(spec.selection!.main.from, 0); // wraps to first
    });

    test('findPrevious moves to previous match', () {
      final doc = Document.fromString('foo bar foo baz foo');
      final matches = SearchState.findMatches(doc, 'foo');
      final state = EditorState.create(
        docString: 'foo bar foo baz foo',
        selection: EditorSelection.cursor(16),
      );
      final spec = SearchCommands.findPrevious(state, matches, 2);
      expect(spec.selection!.main.from, 8);
    });

    test('replaceOne replaces current match', () {
      final state = EditorState.create(
        docString: 'foo bar foo',
        selection: EditorSelection.single(anchor: 0, head: 3),
      );
      final spec = SearchCommands.replaceOne(state, 0, 3, 'baz');
      final newState = state.applyTransaction(state.update(spec));
      expect(newState.doc.toString(), 'baz bar foo');
    });

    test('replaceAll replaces all matches', () {
      final doc = Document.fromString('foo bar foo baz foo');
      final matches = SearchState.findMatches(doc, 'foo');
      final state = EditorState.create(docString: 'foo bar foo baz foo');
      final spec = SearchCommands.replaceAll(state, matches, 'X');
      final newState = state.applyTransaction(state.update(spec));
      expect(newState.doc.toString(), 'X bar X baz X');
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/commands/search_test.dart
```

- [ ] **Step 3: Implement SearchState and SearchCommands**

Create `packages/duskmoon_code_engine/lib/src/commands/search.dart`:

```dart
import '../document/change.dart';
import '../document/document.dart';
import '../document/position.dart';
import '../state/editor_state.dart';
import '../state/selection.dart';

/// A single search match.
class SearchMatch {
  const SearchMatch(this.from, this.to);
  final int from;
  final int to;
}

/// Search state and match finding.
abstract final class SearchState {
  /// Find all matches of [query] in [doc].
  static List<SearchMatch> findMatches(
    Document doc,
    String query, {
    bool caseSensitive = false,
    bool useRegex = false,
  }) {
    if (query.isEmpty) return const [];

    final text = doc.toString();
    final matches = <SearchMatch>[];

    if (useRegex) {
      try {
        final regex = RegExp(query, caseSensitive: caseSensitive);
        for (final match in regex.allMatches(text)) {
          if (match.end > match.start) {
            matches.add(SearchMatch(match.start, match.end));
          }
        }
      } catch (_) {
        // Invalid regex — return empty
      }
    } else {
      final searchIn = caseSensitive ? text : text.toLowerCase();
      final searchFor = caseSensitive ? query : query.toLowerCase();
      var pos = 0;
      while (true) {
        final idx = searchIn.indexOf(searchFor, pos);
        if (idx < 0) break;
        matches.add(SearchMatch(idx, idx + searchFor.length));
        pos = idx + 1;
      }
    }

    return matches;
  }
}

/// Search navigation and replacement commands.
abstract final class SearchCommands {
  /// Select the next match after [currentIndex]. Wraps around.
  static TransactionSpec findNext(
    EditorState state,
    List<SearchMatch> matches,
    int currentIndex,
  ) {
    if (matches.isEmpty) return const TransactionSpec();
    final nextIdx = (currentIndex + 1) % matches.length;
    final match = matches[nextIdx];
    return TransactionSpec(
      selection: EditorSelection.single(anchor: match.from, head: match.to),
      scrollIntoView: true,
    );
  }

  /// Select the previous match before [currentIndex]. Wraps around.
  static TransactionSpec findPrevious(
    EditorState state,
    List<SearchMatch> matches,
    int currentIndex,
  ) {
    if (matches.isEmpty) return const TransactionSpec();
    final prevIdx = (currentIndex - 1 + matches.length) % matches.length;
    final match = matches[prevIdx];
    return TransactionSpec(
      selection: EditorSelection.single(anchor: match.from, head: match.to),
      scrollIntoView: true,
    );
  }

  /// Replace a single match.
  static TransactionSpec replaceOne(
    EditorState state,
    int from,
    int to,
    String replacement,
  ) {
    return TransactionSpec(
      changes: ChangeSet.of(
        state.doc.length,
        [ChangeSpec(from: from, to: to, insert: replacement)],
      ),
      selection: EditorSelection.cursor(from + replacement.length),
    );
  }

  /// Replace all matches with [replacement].
  static TransactionSpec replaceAll(
    EditorState state,
    List<SearchMatch> matches,
    String replacement,
  ) {
    if (matches.isEmpty) return const TransactionSpec();
    // Apply replacements in reverse order to preserve positions
    final specs = matches.reversed
        .map((m) => ChangeSpec(from: m.from, to: m.to, insert: replacement))
        .toList()
        .reversed
        .toList();
    return TransactionSpec(
      changes: ChangeSet.of(state.doc.length, specs),
    );
  }
}
```

- [ ] **Step 4: Add export and keymap binding**

Add to barrel:
```dart
export 'src/commands/search.dart' show SearchMatch, SearchState, SearchCommands;
```

Add to `default_keymap.dart` (Ctrl-f opens search — for now just a placeholder that returns false since the search panel UI is Task 5):

```dart
    // Search (Ctrl-f placeholder — search panel wiring in Task 5)
    // KeyBinding(key: 'Ctrl-f', run: ...),
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/commands/search_test.dart -r expanded
```

- [ ] **Step 6: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add search state, findNext/Previous, replaceOne/All"
```

---

## Task 5: Search panel widget

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/view/search_panel.dart`
- Modify: `packages/duskmoon_code_engine/lib/src/view/code_editor_widget.dart`
- Modify: `packages/duskmoon_code_engine/lib/src/commands/default_keymap.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

A search bar overlay that appears at the top of the editor when Ctrl-F is pressed. Shows query input, match count, next/previous buttons, and replace input.

- [ ] **Step 1: Implement SearchPanel**

Create `packages/duskmoon_code_engine/lib/src/view/search_panel.dart`:

```dart
import 'package:flutter/material.dart' hide SearchBar;

import '../commands/search.dart';
import '../state/editor_state.dart';
import '../state/selection.dart';
import '../view/editor_view.dart';

/// A search bar widget that overlays the editor.
class SearchPanel extends StatefulWidget {
  const SearchPanel({
    super.key,
    required this.view,
    required this.onClose,
    this.showReplace = false,
  });

  final EditorView view;
  final VoidCallback onClose;
  final bool showReplace;

  @override
  State<SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel> {
  final _queryController = TextEditingController();
  final _replaceController = TextEditingController();
  final _queryFocus = FocusNode();
  List<SearchMatch> _matches = [];
  int _currentIndex = -1;
  bool _caseSensitive = false;
  bool _useRegex = false;
  bool _showReplace = false;

  @override
  void initState() {
    super.initState();
    _showReplace = widget.showReplace;
    _queryController.addListener(_onQueryChanged);
    // Focus the search input
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _queryFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _queryController.dispose();
    _replaceController.dispose();
    _queryFocus.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    final query = _queryController.text;
    setState(() {
      _matches = SearchState.findMatches(
        widget.view.document,
        query,
        caseSensitive: _caseSensitive,
        useRegex: _useRegex,
      );
      _currentIndex = _matches.isNotEmpty ? 0 : -1;
    });
    if (_matches.isNotEmpty) {
      _selectMatch(0);
    }
  }

  void _selectMatch(int index) {
    if (index < 0 || index >= _matches.length) return;
    _currentIndex = index;
    final match = _matches[index];
    widget.view.dispatch(TransactionSpec(
      selection: EditorSelection.single(anchor: match.from, head: match.to),
      scrollIntoView: true,
    ));
  }

  void _findNext() {
    if (_matches.isEmpty) return;
    final next = (_currentIndex + 1) % _matches.length;
    setState(() => _currentIndex = next);
    _selectMatch(next);
  }

  void _findPrevious() {
    if (_matches.isEmpty) return;
    final prev = (_currentIndex - 1 + _matches.length) % _matches.length;
    setState(() => _currentIndex = prev);
    _selectMatch(prev);
  }

  void _replaceOne() {
    if (_currentIndex < 0 || _currentIndex >= _matches.length) return;
    final match = _matches[_currentIndex];
    final replacement = _replaceController.text;
    widget.view.dispatch(
      SearchCommands.replaceOne(widget.view.state, match.from, match.to, replacement),
    );
    // Re-search after replacement
    _onQueryChanged();
  }

  void _replaceAll() {
    if (_matches.isEmpty) return;
    widget.view.dispatch(
      SearchCommands.replaceAll(widget.view.state, _matches, _replaceController.text),
    );
    _onQueryChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search row
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 32,
                    child: TextField(
                      controller: _queryController,
                      focusNode: _queryFocus,
                      decoration: InputDecoration(
                        hintText: 'Find',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6,
                        ),
                        border: const OutlineInputBorder(),
                        suffixText: _matches.isEmpty
                            ? 'No results'
                            : '${_currentIndex + 1} of ${_matches.length}',
                      ),
                      style: const TextStyle(fontSize: 13),
                      onSubmitted: (_) => _findNext(),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.arrow_upward, size: 18),
                  onPressed: _findPrevious,
                  tooltip: 'Previous match',
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  padding: EdgeInsets.zero,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_downward, size: 18),
                  onPressed: _findNext,
                  tooltip: 'Next match',
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  padding: EdgeInsets.zero,
                ),
                IconButton(
                  icon: Icon(
                    _caseSensitive ? Icons.text_fields : Icons.text_fields_outlined,
                    size: 18,
                  ),
                  onPressed: () {
                    setState(() => _caseSensitive = !_caseSensitive);
                    _onQueryChanged();
                  },
                  tooltip: 'Case sensitive',
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  padding: EdgeInsets.zero,
                ),
                IconButton(
                  icon: const Icon(Icons.find_replace, size: 18),
                  onPressed: () => setState(() => _showReplace = !_showReplace),
                  tooltip: 'Toggle replace',
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  padding: EdgeInsets.zero,
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: widget.onClose,
                  tooltip: 'Close',
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            // Replace row
            if (_showReplace) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 32,
                      child: TextField(
                        controller: _replaceController,
                        decoration: const InputDecoration(
                          hintText: 'Replace',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  TextButton(
                    onPressed: _replaceOne,
                    child: const Text('Replace', style: TextStyle(fontSize: 12)),
                  ),
                  TextButton(
                    onPressed: _replaceAll,
                    child: const Text('All', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Wire Ctrl-F to toggle search panel in CodeEditorWidget**

Modify `code_editor_widget.dart`:

Add a `_showSearch` boolean state variable. In the `_handleKeyEvent`, check for Ctrl-F before the keymap:

```dart
// Before keymap resolution:
if (ctrl && key == LogicalKeyboardKey.keyF) {
  setState(() => _showSearch = !_showSearch);
  return KeyEventResult.handled;
}
```

Add Escape to close search:
```dart
if (key == LogicalKeyboardKey.escape && _showSearch) {
  setState(() => _showSearch = false);
  return KeyEventResult.handled;
}
```

In the build method, wrap the container in a Column (or Stack) to show the SearchPanel at the top when `_showSearch` is true:

```dart
Widget editor = container; // existing container

if (_showSearch) {
  editor = Column(
    children: [
      SearchPanel(
        view: _controller.view,
        onClose: () => setState(() => _showSearch = false),
      ),
      Expanded(child: container),
    ],
  );
}
```

- [ ] **Step 3: Add export**

```dart
export 'src/view/search_panel.dart' show SearchPanel;
```

- [ ] **Step 4: Run all tests and analyzer**

```bash
cd packages/duskmoon_code_engine && flutter test && dart analyze --fatal-infos
```

- [ ] **Step 5: Commit**

```bash
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add search panel with find/replace UI and Ctrl-F toggle"
```

---

## Task 6: Final verification

- [ ] **Step 1: Run full test suite**

```bash
cd packages/duskmoon_code_engine && flutter test -r expanded
```

- [ ] **Step 2: Run workspace analyzer**

```bash
melos run analyze
```

- [ ] **Step 3: Commit if needed**

```bash
git add packages/duskmoon_code_engine/
git commit -m "chore(duskmoon_code_engine): finalize Phase 5 barrel exports"
```

---

## Summary

Phase 5 delivers **6 tasks** producing:

| Component | Files | Tests |
|-----------|-------|-------|
| Word movement | commands.dart (modified) | word_movement_test.dart |
| Line operations | commands.dart (modified) | line_ops_test.dart |
| Clipboard | clipboard.dart | clipboard_test.dart |
| Search state | search.dart | search_test.dart |
| Search panel | search_panel.dart + widget integration | — |

**New key bindings:**
- Ctrl-Left/Right: word movement
- Ctrl-Shift-Left/Right: word selection
- Ctrl-Backspace/Delete: word deletion
- Ctrl-Shift-K: delete line
- Ctrl-Shift-D: duplicate line
- Alt-Up/Down: move line
- Ctrl-C/X/V: copy/cut/paste
- Ctrl-F: toggle search panel
- Escape: close search panel

**Deferred to Phase 5b:**
- Multiple cursors
- Autocomplete (completion source + popup)
- Lint/diagnostics (diagnostic markers + gutter)
- Word wrap (HeightMap for variable line heights)
- Minimap
