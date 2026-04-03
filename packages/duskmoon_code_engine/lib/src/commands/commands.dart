import '../document/change.dart';
import '../state/editor_state.dart';
import '../state/selection.dart';

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
}
