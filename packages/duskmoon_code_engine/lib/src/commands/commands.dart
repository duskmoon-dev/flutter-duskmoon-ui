import '../document/change.dart';
import '../state/annotation.dart';
import '../state/editor_state.dart';
import '../state/selection.dart';
import 'history.dart';

/// A collection of standard editor commands that produce [TransactionSpec]s.
///
/// Each command takes an [EditorState] and returns a [TransactionSpec] that
/// can be applied via `state.update(spec)`, or null if the command cannot be
/// executed in the current state (e.g. cursor already at document start).
abstract final class EditorCommands {
  // ---------------------------------------------------------------------------
  // Cursor movement
  // ---------------------------------------------------------------------------

  /// Move the cursor one character to the right.
  /// Returns null if the cursor is already at the end of the document.
  static TransactionSpec? cursorCharRight(EditorState state) {
    final head = state.selection.main.head;
    if (head >= state.doc.length) return null;
    return TransactionSpec(selection: EditorSelection.cursor(head + 1));
  }

  /// Move the cursor one character to the left.
  /// Returns null if the cursor is already at the start of the document.
  static TransactionSpec? cursorCharLeft(EditorState state) {
    final head = state.selection.main.head;
    if (head <= 0) return null;
    return TransactionSpec(selection: EditorSelection.cursor(head - 1));
  }

  /// Move the cursor down one line, preserving column as much as possible.
  /// Returns null if the cursor is already on the last line.
  static TransactionSpec? cursorLineDown(EditorState state) {
    final head = state.selection.main.head;
    final line = state.doc.lineAtOffset(head);
    if (line.number >= state.doc.lineCount) return null;
    final col = head - line.from;
    final nextLine = state.doc.lineAt(line.number + 1);
    final newHead = nextLine.from + col.clamp(0, nextLine.length);
    return TransactionSpec(selection: EditorSelection.cursor(newHead));
  }

  /// Move the cursor up one line, preserving column as much as possible.
  /// Returns null if the cursor is already on the first line.
  static TransactionSpec? cursorLineUp(EditorState state) {
    final head = state.selection.main.head;
    final line = state.doc.lineAtOffset(head);
    if (line.number <= 1) return null;
    final col = head - line.from;
    final prevLine = state.doc.lineAt(line.number - 1);
    final newHead = prevLine.from + col.clamp(0, prevLine.length);
    return TransactionSpec(selection: EditorSelection.cursor(newHead));
  }

  /// Move the cursor to the start of the current line.
  static TransactionSpec cursorLineStart(EditorState state) {
    final head = state.selection.main.head;
    final line = state.doc.lineAtOffset(head);
    return TransactionSpec(selection: EditorSelection.cursor(line.from));
  }

  /// Move the cursor to the end of the current line.
  static TransactionSpec cursorLineEnd(EditorState state) {
    final head = state.selection.main.head;
    final line = state.doc.lineAtOffset(head);
    return TransactionSpec(selection: EditorSelection.cursor(line.to));
  }

  /// Move the cursor to the start of the document.
  static TransactionSpec cursorDocStart(EditorState state) {
    return TransactionSpec(selection: EditorSelection.cursor(0));
  }

  /// Move the cursor to the end of the document.
  static TransactionSpec cursorDocEnd(EditorState state) {
    return TransactionSpec(
      selection: EditorSelection.cursor(state.doc.length),
    );
  }

  // ---------------------------------------------------------------------------
  // Selection
  // ---------------------------------------------------------------------------

  /// Extend the selection one character to the right (keep anchor, move head).
  /// Returns null if the head is already at the end of the document.
  static TransactionSpec? selectCharRight(EditorState state) {
    final main = state.selection.main;
    if (main.head >= state.doc.length) return null;
    return TransactionSpec(
      selection: EditorSelection.single(
        anchor: main.anchor,
        head: main.head + 1,
      ),
    );
  }

  /// Extend the selection one character to the left (keep anchor, move head).
  /// Returns null if the head is already at the start of the document.
  static TransactionSpec? selectCharLeft(EditorState state) {
    final main = state.selection.main;
    if (main.head <= 0) return null;
    return TransactionSpec(
      selection: EditorSelection.single(
        anchor: main.anchor,
        head: main.head - 1,
      ),
    );
  }

  /// Select the entire document (anchor=0, head=doc.length).
  static TransactionSpec selectAll(EditorState state) {
    return TransactionSpec(
      selection: EditorSelection.single(anchor: 0, head: state.doc.length),
    );
  }

  // ---------------------------------------------------------------------------
  // Editing
  // ---------------------------------------------------------------------------

  /// Insert [text] at the cursor, replacing any active selection.
  /// The cursor is placed after the inserted text.
  static TransactionSpec insertText(EditorState state, String text) {
    final main = state.selection.main;
    final from = main.from;
    final to = main.to;
    final changes = ChangeSet.of(state.doc.length, [
      ChangeSpec(from: from, to: to, insert: text),
    ]);
    return TransactionSpec(
      changes: changes,
      selection: EditorSelection.cursor(from + text.length),
    );
  }

  /// Insert a newline character at the cursor position.
  static TransactionSpec insertNewline(EditorState state) =>
      insertText(state, '\n');

  /// Insert two spaces (soft tab) at the cursor position.
  static TransactionSpec insertTab(EditorState state) =>
      insertText(state, '  ');

  /// Delete the character before the cursor, or the selection if non-empty.
  /// Returns null if the cursor is at the start of the document with no
  /// selection.
  static TransactionSpec? deleteCharBackward(EditorState state) {
    final main = state.selection.main;
    if (!main.isEmpty) return deleteSelection(state);
    final head = main.head;
    if (head <= 0) return null;
    final changes = ChangeSet.of(state.doc.length, [
      ChangeSpec(from: head - 1, to: head),
    ]);
    return TransactionSpec(
      changes: changes,
      selection: EditorSelection.cursor(head - 1),
    );
  }

  /// Delete the character after the cursor, or the selection if non-empty.
  /// Returns null if the cursor is at the end of the document with no
  /// selection.
  static TransactionSpec? deleteCharForward(EditorState state) {
    final main = state.selection.main;
    if (!main.isEmpty) return deleteSelection(state);
    final head = main.head;
    if (head >= state.doc.length) return null;
    final changes = ChangeSet.of(state.doc.length, [
      ChangeSpec(from: head, to: head + 1),
    ]);
    return TransactionSpec(
      changes: changes,
      selection: EditorSelection.cursor(head),
    );
  }

  /// Delete the currently selected range.
  /// Returns null if the selection is empty (nothing to delete).
  static TransactionSpec? deleteSelection(EditorState state) {
    final main = state.selection.main;
    if (main.isEmpty) return null;
    final changes = ChangeSet.of(state.doc.length, [
      ChangeSpec(from: main.from, to: main.to),
    ]);
    return TransactionSpec(
      changes: changes,
      selection: EditorSelection.cursor(main.from),
    );
  }

  // ---------------------------------------------------------------------------
  // Word-level cursor movement
  // ---------------------------------------------------------------------------

  /// Move the cursor to the end of the current word (or start of next word
  /// after whitespace). Word characters: a-z, A-Z, 0-9, _.
  /// Returns null if the cursor is already at the end of the document.
  static TransactionSpec? cursorWordRight(EditorState state) {
    final head = state.selection.main.head;
    if (head >= state.doc.length) return null;
    final text = state.doc.toString();
    final newPos = _findWordBoundaryRight(text, head);
    if (newPos == head) return null;
    return TransactionSpec(selection: EditorSelection.cursor(newPos));
  }

  /// Move the cursor to the start of the current word (or end of previous
  /// word). Word characters: a-z, A-Z, 0-9, _.
  /// Returns null if the cursor is already at the start of the document.
  static TransactionSpec? cursorWordLeft(EditorState state) {
    final head = state.selection.main.head;
    if (head <= 0) return null;
    final text = state.doc.toString();
    final newPos = _findWordBoundaryLeft(text, head);
    if (newPos == head) return null;
    return TransactionSpec(selection: EditorSelection.cursor(newPos));
  }

  /// Extend the selection head to the next word boundary to the right.
  /// Returns null if the head is already at the end of the document.
  static TransactionSpec? selectWordRight(EditorState state) {
    final main = state.selection.main;
    if (main.head >= state.doc.length) return null;
    final text = state.doc.toString();
    final newHead = _findWordBoundaryRight(text, main.head);
    if (newHead == main.head) return null;
    return TransactionSpec(
      selection: EditorSelection.single(anchor: main.anchor, head: newHead),
    );
  }

  /// Extend the selection head to the next word boundary to the left.
  /// Returns null if the head is already at the start of the document.
  static TransactionSpec? selectWordLeft(EditorState state) {
    final main = state.selection.main;
    if (main.head <= 0) return null;
    final text = state.doc.toString();
    final newHead = _findWordBoundaryLeft(text, main.head);
    if (newHead == main.head) return null;
    return TransactionSpec(
      selection: EditorSelection.single(anchor: main.anchor, head: newHead),
    );
  }

  /// Delete from the cursor to the word boundary to the left.
  /// Returns null if the cursor is at the start of the document.
  static TransactionSpec? deleteWordBackward(EditorState state) {
    final main = state.selection.main;
    if (!main.isEmpty) return deleteSelection(state);
    final head = main.head;
    if (head <= 0) return null;
    final text = state.doc.toString();
    final boundary = _findWordBoundaryLeft(text, head);
    if (boundary == head) return null;
    final changes = ChangeSet.of(state.doc.length, [
      ChangeSpec(from: boundary, to: head),
    ]);
    return TransactionSpec(
      changes: changes,
      selection: EditorSelection.cursor(boundary),
    );
  }

  /// Delete from the cursor to the word boundary to the right.
  /// Returns null if the cursor is at the end of the document.
  static TransactionSpec? deleteWordForward(EditorState state) {
    final main = state.selection.main;
    if (!main.isEmpty) return deleteSelection(state);
    final head = main.head;
    if (head >= state.doc.length) return null;
    final text = state.doc.toString();
    final boundary = _findWordBoundaryRight(text, head);
    if (boundary == head) return null;
    final changes = ChangeSet.of(state.doc.length, [
      ChangeSpec(from: head, to: boundary),
    ]);
    return TransactionSpec(
      changes: changes,
      selection: EditorSelection.cursor(head),
    );
  }

  /// Scan right from [pos]: skip word chars, then skip non-word chars.
  static int _findWordBoundaryRight(String text, int pos) {
    final len = text.length;
    // Skip over word characters first
    while (pos < len && _isWordChar(text[pos])) {
      pos++;
    }
    // Then skip over non-word characters (whitespace / punctuation)
    while (pos < len && !_isWordChar(text[pos])) {
      pos++;
    }
    return pos;
  }

  /// Scan left from [pos]: skip non-word chars, then skip word chars.
  static int _findWordBoundaryLeft(String text, int pos) {
    // Skip over non-word characters first
    while (pos > 0 && !_isWordChar(text[pos - 1])) {
      pos--;
    }
    // Then skip over word characters
    while (pos > 0 && _isWordChar(text[pos - 1])) {
      pos--;
    }
    return pos;
  }

  static bool _isWordChar(String ch) {
    final c = ch.codeUnitAt(0);
    return (c >= 65 && c <= 90) || // A-Z
        (c >= 97 && c <= 122) || // a-z
        (c >= 48 && c <= 57) || // 0-9
        c == 95; // _
  }

  // ---------------------------------------------------------------------------
  // Line operations
  // ---------------------------------------------------------------------------

  /// Delete the line containing the cursor, including its newline.
  /// Handles first, last, only, and middle lines.
  static TransactionSpec deleteLine(EditorState state) {
    final head = state.selection.main.head;
    final line = state.doc.lineAtOffset(head);
    final int from;
    final int to;

    if (state.doc.lineCount == 1) {
      // Only line: delete all content but leave empty document.
      from = 0;
      to = line.to;
    } else if (line.number < state.doc.lineCount) {
      // Not the last line: delete from line start through the trailing newline.
      from = line.from;
      to = line.to + 1; // +1 to consume the '\n'
    } else {
      // Last line: delete the preceding newline and the line content.
      from = line.from - 1; // consume the '\n' before this line
      to = line.to;
    }

    final changes = ChangeSet.of(state.doc.length, [
      ChangeSpec(from: from, to: to),
    ]);
    final newHead = from.clamp(0, state.doc.length - (to - from));
    return TransactionSpec(
      changes: changes,
      selection: EditorSelection.cursor(newHead),
    );
  }

  /// Insert a copy of the current line after itself.
  /// Cursor is placed at the same column on the duplicated line.
  static TransactionSpec duplicateLine(EditorState state) {
    final head = state.selection.main.head;
    final line = state.doc.lineAtOffset(head);
    final col = head - line.from;
    final insert = '\n${line.text}';
    final changes = ChangeSet.of(state.doc.length, [
      ChangeSpec(from: line.to, to: line.to, insert: insert),
    ]);
    // New head is on the duplicated line at the same column.
    final newHead = line.to + 1 + col.clamp(0, line.length);
    return TransactionSpec(
      changes: changes,
      selection: EditorSelection.cursor(newHead),
    );
  }

  /// Swap the current line with the line above it.
  /// Returns null if the cursor is on the first line.
  static TransactionSpec? moveLineUp(EditorState state) {
    final head = state.selection.main.head;
    final line = state.doc.lineAtOffset(head);
    if (line.number <= 1) return null;
    final prevLine = state.doc.lineAt(line.number - 1);
    final col = head - line.from;

    // Replace the two-line block (prevLine\nline) with (line\nprevLine).
    final from = prevLine.from;
    final to = line.to;
    final newText = '${line.text}\n${prevLine.text}';
    final changes = ChangeSet.of(state.doc.length, [
      ChangeSpec(from: from, to: to, insert: newText),
    ]);
    final newHead = from + col.clamp(0, line.length);
    return TransactionSpec(
      changes: changes,
      selection: EditorSelection.cursor(newHead),
    );
  }

  /// Swap the current line with the line below it.
  /// Returns null if the cursor is on the last line.
  static TransactionSpec? moveLineDown(EditorState state) {
    final head = state.selection.main.head;
    final line = state.doc.lineAtOffset(head);
    if (line.number >= state.doc.lineCount) return null;
    final nextLine = state.doc.lineAt(line.number + 1);
    final col = head - line.from;

    // Replace the two-line block (line\nnextLine) with (nextLine\nline).
    final from = line.from;
    final to = nextLine.to;
    final newText = '${nextLine.text}\n${line.text}';
    final changes = ChangeSet.of(state.doc.length, [
      ChangeSpec(from: from, to: to, insert: newText),
    ]);
    // Cursor stays on the same logical content, now on line.number + 1.
    final newHead = from + nextLine.length + 1 + col.clamp(0, line.length);
    return TransactionSpec(
      changes: changes,
      selection: EditorSelection.cursor(newHead),
    );
  }

  // ---------------------------------------------------------------------------
  // History
  // ---------------------------------------------------------------------------

  /// Undo the last edit.
  ///
  /// Returns null if the [historyField] is not present in [state] or the undo
  /// stack is empty.
  static TransactionSpec? undo(EditorState state) {
    final HistoryState history;
    try {
      history = state.field(historyField);
    } catch (_) {
      return null;
    }
    if (history.undoStack.isEmpty) return null;
    final entry = history.undoStack.last;
    return TransactionSpec(
      changes: entry.changes,
      selection: entry.selection,
      effects: [undoEffect.of(true)],
      annotations: [const Annotation(Annotations.addToHistory, false)],
    );
  }

  /// Redo the last undone edit.
  ///
  /// Returns null if the [historyField] is not present in [state] or the redo
  /// stack is empty.
  static TransactionSpec? redo(EditorState state) {
    final HistoryState history;
    try {
      history = state.field(historyField);
    } catch (_) {
      return null;
    }
    if (history.redoStack.isEmpty) return null;
    final entry = history.redoStack.last;
    return TransactionSpec(
      changes: entry.changes,
      selection: entry.selection,
      effects: [redoEffect.of(true)],
      annotations: [const Annotation(Annotations.addToHistory, false)],
    );
  }
}
