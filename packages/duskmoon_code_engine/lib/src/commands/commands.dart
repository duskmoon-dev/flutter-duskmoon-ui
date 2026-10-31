import 'package:characters/characters.dart';

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
  // Unicode Grapheme Helpers
  // ---------------------------------------------------------------------------

  static bool _isLowSurrogate(String str) {
    if (str.isEmpty) return false;
    final code = str.codeUnitAt(0);
    return code >= 0xDC00 && code <= 0xDFFF;
  }

  static int _prevGraphemeLength(EditorState state, int offset) {
    if (offset <= 0) return 0;
    final start = (offset - 64).clamp(0, offset);
    final adjStart =
        (start > 0 && _isLowSurrogate(state.doc.sliceString(start, start + 1)))
            ? start - 1
            : start;
    final slice = state.doc.sliceString(adjStart, offset);
    return slice.characters.last.length;
  }

  static int _nextGraphemeLength(EditorState state, int offset) {
    if (offset >= state.doc.length) return 0;
    final end = (offset + 64).clamp(offset, state.doc.length);
    final slice = state.doc.sliceString(offset, end);
    return slice.characters.first.length;
  }

  static int _clampToGraphemeBoundary(
    EditorState state,
    int offset,
    int minOffset,
  ) {
    if (offset > minOffset &&
        offset < state.doc.length &&
        _isLowSurrogate(state.doc.sliceString(offset, offset + 1))) {
      return offset - 1;
    }
    return offset;
  }

  /// Returns the `(from, to)` character offsets of the word at [offset]
  /// within the same line, or `(offset, offset)` if none.
  static (int, int) wordRangeAt(EditorState state, int offset) {
    final clamped = offset.clamp(0, state.doc.length);
    final line = state.doc.lineAtOffset(clamped);
    final lineText = line.text;
    if (lineText.isEmpty) return (line.from, line.from);
    var col = (clamped - line.from).clamp(0, lineText.length);
    if (col == lineText.length && col > 0) col--;
    col =
        _clampToGraphemeBoundary(state, line.from + col, line.from) - line.from;

    final isWord = _isWordChar(lineText[col]);
    var start = col;
    var end = col;
    if (isWord) {
      while (start > 0 && _isWordChar(lineText[start - 1])) {
        start--;
      }
      while (end < lineText.length && _isWordChar(lineText[end])) {
        end++;
      }
    } else if (lineText[col].trim().isEmpty) {
      while (start > 0 && lineText[start - 1].trim().isEmpty) {
        start--;
      }
      while (end < lineText.length && lineText[end].trim().isEmpty) {
        end++;
      }
    } else {
      end = (col + _nextGraphemeLength(state, line.from + col)).clamp(
        0,
        lineText.length,
      );
    }
    return (line.from + start, line.from + end);
  }

  // ---------------------------------------------------------------------------
  // Cursor movement
  // ---------------------------------------------------------------------------

  /// Move the cursor one character to the right.
  /// If a non-empty selection is active, collapses the cursor to its end.
  /// Returns null if the cursor is already at the end of the document.
  static TransactionSpec? cursorCharRight(EditorState state) {
    final main = state.selection.main;
    if (!main.isEmpty) {
      return TransactionSpec(
        selection: EditorSelection.cursor(main.to),
        scrollIntoView: true,
      );
    }
    final head = main.head;
    if (head >= state.doc.length) return null;
    final len = _nextGraphemeLength(state, head);
    return TransactionSpec(
      selection: EditorSelection.cursor(head + len),
      scrollIntoView: true,
    );
  }

  /// Move the cursor one character to the left.
  /// If a non-empty selection is active, collapses the cursor to its start.
  /// Returns null if the cursor is already at the start of the document.
  static TransactionSpec? cursorCharLeft(EditorState state) {
    final main = state.selection.main;
    if (!main.isEmpty) {
      return TransactionSpec(
        selection: EditorSelection.cursor(main.from),
        scrollIntoView: true,
      );
    }
    final head = main.head;
    if (head <= 0) return null;
    final len = _prevGraphemeLength(state, head);
    return TransactionSpec(
      selection: EditorSelection.cursor(head - len),
      scrollIntoView: true,
    );
  }

  /// Move the cursor down one line, preserving column as much as possible.
  /// Returns null if the cursor is already on the last line.
  static TransactionSpec? cursorLineDown(EditorState state) {
    final head = state.selection.main.head;
    final line = state.doc.lineAtOffset(head);
    if (line.number >= state.doc.lineCount) return null;
    final col = head - line.from;
    final nextLine = state.doc.lineAt(line.number + 1);
    final rawHead = nextLine.from + col.clamp(0, nextLine.length);
    final newHead = _clampToGraphemeBoundary(state, rawHead, nextLine.from);
    return TransactionSpec(
      selection: EditorSelection.cursor(newHead),
      scrollIntoView: true,
    );
  }

  /// Move the cursor up one line, preserving column as much as possible.
  /// Returns null if the cursor is already on the first line.
  static TransactionSpec? cursorLineUp(EditorState state) {
    final head = state.selection.main.head;
    final line = state.doc.lineAtOffset(head);
    if (line.number <= 1) return null;
    final col = head - line.from;
    final prevLine = state.doc.lineAt(line.number - 1);
    final rawHead = prevLine.from + col.clamp(0, prevLine.length);
    final newHead = _clampToGraphemeBoundary(state, rawHead, prevLine.from);
    return TransactionSpec(
      selection: EditorSelection.cursor(newHead),
      scrollIntoView: true,
    );
  }

  /// Move the cursor to the start of the current line.
  static TransactionSpec cursorLineStart(EditorState state) {
    final head = state.selection.main.head;
    final line = state.doc.lineAtOffset(head);
    return TransactionSpec(
      selection: EditorSelection.cursor(line.from),
      scrollIntoView: true,
    );
  }

  /// Move the cursor to the end of the current line.
  static TransactionSpec cursorLineEnd(EditorState state) {
    final head = state.selection.main.head;
    final line = state.doc.lineAtOffset(head);
    return TransactionSpec(
      selection: EditorSelection.cursor(line.to),
      scrollIntoView: true,
    );
  }

  /// Move the cursor to the start of the document.
  static TransactionSpec cursorDocStart(EditorState state) {
    return TransactionSpec(
      selection: EditorSelection.cursor(0),
      scrollIntoView: true,
    );
  }

  /// Move the cursor to the end of the document.
  static TransactionSpec cursorDocEnd(EditorState state) {
    return TransactionSpec(
      selection: EditorSelection.cursor(state.doc.length),
      scrollIntoView: true,
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
    final len = _nextGraphemeLength(state, main.head);
    return TransactionSpec(
      selection: EditorSelection.single(
        anchor: main.anchor,
        head: main.head + len,
      ),
      scrollIntoView: true,
    );
  }

  /// Extend the selection one character to the left (keep anchor, move head).
  /// Returns null if the head is already at the start of the document.
  static TransactionSpec? selectCharLeft(EditorState state) {
    final main = state.selection.main;
    if (main.head <= 0) return null;
    final len = _prevGraphemeLength(state, main.head);
    return TransactionSpec(
      selection: EditorSelection.single(
        anchor: main.anchor,
        head: main.head - len,
      ),
      scrollIntoView: true,
    );
  }

  /// Extend the selection down one line.
  static TransactionSpec? selectLineDown(EditorState state) {
    final main = state.selection.main;
    final line = state.doc.lineAtOffset(main.head);
    if (line.number >= state.doc.lineCount) {
      if (main.head >= state.doc.length) return null;
      return TransactionSpec(
        selection: EditorSelection.single(
          anchor: main.anchor,
          head: state.doc.length,
        ),
        scrollIntoView: true,
      );
    }
    final col = main.head - line.from;
    final nextLine = state.doc.lineAt(line.number + 1);
    final rawHead = nextLine.from + col.clamp(0, nextLine.length);
    final newHead = _clampToGraphemeBoundary(state, rawHead, nextLine.from);
    return TransactionSpec(
      selection: EditorSelection.single(anchor: main.anchor, head: newHead),
      scrollIntoView: true,
    );
  }

  /// Extend the selection up one line.
  static TransactionSpec? selectLineUp(EditorState state) {
    final main = state.selection.main;
    final line = state.doc.lineAtOffset(main.head);
    if (line.number <= 1) {
      if (main.head <= 0) return null;
      return TransactionSpec(
        selection: EditorSelection.single(anchor: main.anchor, head: 0),
        scrollIntoView: true,
      );
    }
    final col = main.head - line.from;
    final prevLine = state.doc.lineAt(line.number - 1);
    final rawHead = prevLine.from + col.clamp(0, prevLine.length);
    final newHead = _clampToGraphemeBoundary(state, rawHead, prevLine.from);
    return TransactionSpec(
      selection: EditorSelection.single(anchor: main.anchor, head: newHead),
      scrollIntoView: true,
    );
  }

  /// Extend the selection to the start of the current line.
  static TransactionSpec selectLineStart(EditorState state) {
    final main = state.selection.main;
    final line = state.doc.lineAtOffset(main.head);
    return TransactionSpec(
      selection: EditorSelection.single(anchor: main.anchor, head: line.from),
      scrollIntoView: true,
    );
  }

  /// Extend the selection to the end of the current line.
  static TransactionSpec selectLineEnd(EditorState state) {
    final main = state.selection.main;
    final line = state.doc.lineAtOffset(main.head);
    return TransactionSpec(
      selection: EditorSelection.single(anchor: main.anchor, head: line.to),
      scrollIntoView: true,
    );
  }

  /// Extend the selection to the start of the document.
  static TransactionSpec selectDocStart(EditorState state) {
    final main = state.selection.main;
    return TransactionSpec(
      selection: EditorSelection.single(anchor: main.anchor, head: 0),
      scrollIntoView: true,
    );
  }

  /// Extend the selection to the end of the document.
  static TransactionSpec selectDocEnd(EditorState state) {
    final main = state.selection.main;
    return TransactionSpec(
      selection: EditorSelection.single(
        anchor: main.anchor,
        head: state.doc.length,
      ),
      scrollIntoView: true,
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
      scrollIntoView: true,
    );
  }

  /// Insert a newline character at the cursor position.
  static TransactionSpec insertNewline(EditorState state) =>
      insertText(state, '\n');

  /// Insert two spaces (soft tab) at the cursor position.
  static TransactionSpec insertTab(EditorState state) =>
      insertText(state, '  ');

  /// Outdent the selected lines (or current line) by up to two leading spaces
  /// or one leading tab character.
  static TransactionSpec? indentLess(EditorState state) {
    final main = state.selection.main;
    final startLine = state.doc.lineAtOffset(main.from).number;
    final endLine = state.doc.lineAtOffset(main.to).number;
    final specs = <ChangeSpec>[];

    for (var n = startLine; n <= endLine; n++) {
      final line = state.doc.lineAt(n);
      final text = line.text;
      if (text.startsWith('  ')) {
        specs.add(ChangeSpec(from: line.from, to: line.from + 2));
      } else if (text.startsWith(' ') || text.startsWith('\t')) {
        specs.add(ChangeSpec(from: line.from, to: line.from + 1));
      }
    }

    if (specs.isEmpty) return null;
    final changes = ChangeSet.of(state.doc.length, specs);
    return TransactionSpec(
      changes: changes,
      selection: state.selection.map(changes),
      scrollIntoView: true,
    );
  }

  /// Delete the character before the cursor, or the selection if non-empty.
  /// Returns null if the cursor is at the start of the document with no
  /// selection.
  static TransactionSpec? deleteCharBackward(EditorState state) {
    final main = state.selection.main;
    if (!main.isEmpty) return deleteSelection(state);
    final head = main.head;
    if (head <= 0) return null;
    final len = _prevGraphemeLength(state, head);
    final changes = ChangeSet.of(state.doc.length, [
      ChangeSpec(from: head - len, to: head),
    ]);
    return TransactionSpec(
      changes: changes,
      selection: EditorSelection.cursor(head - len),
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
    final len = _nextGraphemeLength(state, head);
    final changes = ChangeSet.of(state.doc.length, [
      ChangeSpec(from: head, to: head + len),
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
    final (window, posInWindow, windowStart) = _wordWindow(
      state,
      head,
      rightward: true,
    );
    final newPosInWindow = _findWordBoundaryRight(window, posInWindow);
    final newPos = windowStart + newPosInWindow;
    if (newPos == head) return null;
    return TransactionSpec(selection: EditorSelection.cursor(newPos));
  }

  /// Move the cursor to the start of the current word (or end of previous
  /// word). Word characters: a-z, A-Z, 0-9, _.
  /// Returns null if the cursor is already at the start of the document.
  static TransactionSpec? cursorWordLeft(EditorState state) {
    final head = state.selection.main.head;
    if (head <= 0) return null;
    final (window, posInWindow, windowStart) = _wordWindow(
      state,
      head,
      rightward: false,
    );
    final newPosInWindow = _findWordBoundaryLeft(window, posInWindow);
    final newPos = windowStart + newPosInWindow;
    if (newPos == head) return null;
    return TransactionSpec(selection: EditorSelection.cursor(newPos));
  }

  /// Extend the selection head to the next word boundary to the right.
  /// Returns null if the head is already at the end of the document.
  static TransactionSpec? selectWordRight(EditorState state) {
    final main = state.selection.main;
    if (main.head >= state.doc.length) return null;
    final (window, posInWindow, windowStart) = _wordWindow(
      state,
      main.head,
      rightward: true,
    );
    final newHeadInWindow = _findWordBoundaryRight(window, posInWindow);
    final newHead = windowStart + newHeadInWindow;
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
    final (window, posInWindow, windowStart) = _wordWindow(
      state,
      main.head,
      rightward: false,
    );
    final newHeadInWindow = _findWordBoundaryLeft(window, posInWindow);
    final newHead = windowStart + newHeadInWindow;
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
    final (window, posInWindow, windowStart) = _wordWindow(
      state,
      head,
      rightward: false,
    );
    final boundaryInWindow = _findWordBoundaryLeft(window, posInWindow);
    final boundary = windowStart + boundaryInWindow;
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
    final (window, posInWindow, windowStart) = _wordWindow(
      state,
      head,
      rightward: true,
    );
    final boundaryInWindow = _findWordBoundaryRight(window, posInWindow);
    final boundary = windowStart + boundaryInWindow;
    if (boundary == head) return null;
    final changes = ChangeSet.of(state.doc.length, [
      ChangeSpec(from: head, to: boundary),
    ]);
    return TransactionSpec(
      changes: changes,
      selection: EditorSelection.cursor(head),
    );
  }

  /// Extract a ±200-character window around [pos] from the document.
  ///
  /// Returns a record of (windowText, posInWindow, windowStart) so callers
  /// can pass [posInWindow] to the boundary-finding helpers and add
  /// [windowStart] back to translate the result to a document offset.
  static (String, int, int) _wordWindow(
    EditorState state,
    int pos, {
    required bool rightward,
  }) {
    final windowStart = (pos - 200).clamp(0, state.doc.length);
    final windowEnd = (pos + 200).clamp(0, state.doc.length);
    final window = state.doc.sliceString(windowStart, windowEnd);
    final posInWindow = pos - windowStart;
    return (window, posInWindow, windowStart);
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

  /// Whether there are edits that can be undone.
  static bool canUndo(EditorState state) {
    try {
      return state.field(historyField).undoStack.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Whether there are undone edits that can be redone.
  static bool canRedo(EditorState state) {
    try {
      return state.field(historyField).redoStack.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
