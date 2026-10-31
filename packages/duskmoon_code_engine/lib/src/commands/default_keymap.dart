import '../language/syntax.dart';
import '../state/editor_state.dart';
import '../view/editor_view.dart';
import 'clipboard.dart';
import 'commands.dart';
import 'comment.dart';
import 'keymap.dart';

/// Returns the default [Keymap] with standard editor key bindings.
///
/// Wires standard cursor movement, selection, editing, and history commands
/// to their conventional key bindings.
Keymap defaultKeymap() {
  return Keymap([
    // Cursor movement
    KeyBinding(
      key: 'ArrowRight',
      run: _wrap((s) => EditorCommands.cursorCharRight(s)),
    ),
    KeyBinding(
      key: 'ArrowLeft',
      run: _wrap((s) => EditorCommands.cursorCharLeft(s)),
    ),
    KeyBinding(
      key: 'ArrowDown',
      run: _wrap((s) => EditorCommands.cursorLineDown(s)),
    ),
    KeyBinding(
      key: 'ArrowUp',
      run: _wrap((s) => EditorCommands.cursorLineUp(s)),
    ),
    KeyBinding(
      key: 'Home',
      run: _wrap((s) => EditorCommands.cursorLineStart(s)),
    ),
    KeyBinding(key: 'End', run: _wrap((s) => EditorCommands.cursorLineEnd(s))),
    KeyBinding(
      key: 'Ctrl-Home',
      run: _wrap((s) => EditorCommands.cursorDocStart(s)),
    ),
    KeyBinding(
      key: 'Ctrl-End',
      run: _wrap((s) => EditorCommands.cursorDocEnd(s)),
    ),
    KeyBinding(
      key: 'Ctrl-ArrowRight',
      run: _wrap((s) => EditorCommands.cursorWordRight(s)),
    ),
    KeyBinding(
      key: 'Ctrl-ArrowLeft',
      run: _wrap((s) => EditorCommands.cursorWordLeft(s)),
    ),

    // Selection
    KeyBinding(
      key: 'Shift-ArrowRight',
      run: _wrap((s) => EditorCommands.selectCharRight(s)),
    ),
    KeyBinding(
      key: 'Shift-ArrowLeft',
      run: _wrap((s) => EditorCommands.selectCharLeft(s)),
    ),
    KeyBinding(
      key: 'Shift-ArrowDown',
      run: _wrap((s) => EditorCommands.selectLineDown(s)),
    ),
    KeyBinding(
      key: 'Shift-ArrowUp',
      run: _wrap((s) => EditorCommands.selectLineUp(s)),
    ),
    KeyBinding(
      key: 'Shift-Home',
      run: _wrapNonNull((s) => EditorCommands.selectLineStart(s)),
    ),
    KeyBinding(
      key: 'Shift-End',
      run: _wrapNonNull((s) => EditorCommands.selectLineEnd(s)),
    ),
    KeyBinding(
      key: 'Ctrl-Shift-Home',
      run: _wrapNonNull((s) => EditorCommands.selectDocStart(s)),
    ),
    KeyBinding(
      key: 'Ctrl-Shift-End',
      run: _wrapNonNull((s) => EditorCommands.selectDocEnd(s)),
    ),
    KeyBinding(
      key: 'Ctrl-a',
      run: _wrapNonNull((s) => EditorCommands.selectAll(s)),
    ),
    KeyBinding(
      key: 'Ctrl-Shift-ArrowRight',
      run: _wrap((s) => EditorCommands.selectWordRight(s)),
    ),
    KeyBinding(
      key: 'Ctrl-Shift-ArrowLeft',
      run: _wrap((s) => EditorCommands.selectWordLeft(s)),
    ),

    // Editing
    KeyBinding(
      key: 'Backspace',
      run: _wrapEdit((s) => EditorCommands.deleteCharBackward(s)),
    ),
    KeyBinding(
      key: 'Delete',
      run: _wrapEdit((s) => EditorCommands.deleteCharForward(s)),
    ),
    KeyBinding(
      key: 'Enter',
      run: _wrapEditNonNull((s) => EditorCommands.insertNewline(s)),
    ),
    KeyBinding(
      key: 'Tab',
      run: _wrapEditNonNull((s) => EditorCommands.insertTab(s)),
    ),
    KeyBinding(
      key: 'Shift-Tab',
      run: _wrapEdit((s) => EditorCommands.indentLess(s)),
    ),
    KeyBinding(
      key: 'Ctrl-Backspace',
      run: _wrapEdit((s) => EditorCommands.deleteWordBackward(s)),
    ),
    KeyBinding(
      key: 'Ctrl-Delete',
      run: _wrapEdit((s) => EditorCommands.deleteWordForward(s)),
    ),

    // Line operations
    KeyBinding(
      key: 'Ctrl-Shift-k',
      run: _wrapEditNonNull((s) => EditorCommands.deleteLine(s)),
    ),
    KeyBinding(
      key: 'Ctrl-Shift-d',
      run: _wrapEditNonNull((s) => EditorCommands.duplicateLine(s)),
    ),
    KeyBinding(
      key: 'Alt-ArrowUp',
      run: _wrapEdit((s) => EditorCommands.moveLineUp(s)),
    ),
    KeyBinding(
      key: 'Alt-ArrowDown',
      run: _wrapEdit((s) => EditorCommands.moveLineDown(s)),
    ),

    // Undo/Redo
    KeyBinding(key: 'Ctrl-z', run: _wrapEdit((s) => EditorCommands.undo(s))),
    KeyBinding(
      key: 'Ctrl-Shift-z',
      run: _wrapEdit((s) => EditorCommands.redo(s)),
    ),

    // Clipboard
    KeyBinding(key: 'Ctrl-c', run: ClipboardCommands.copyCommand()),
    KeyBinding(key: 'Ctrl-x', run: ClipboardCommands.cutCommand()),
    KeyBinding(key: 'Ctrl-v', run: ClipboardCommands.pasteCommand()),

    // Comment toggling
    KeyBinding(
      key: 'Ctrl-/',
      run: (dynamic view) {
        final ev = view as EditorView;
        if (ev.readOnly) return false;
        final token =
            syntaxState(ev.state)?.language?.data.commentTokens?.line ??
                ev.state.facet(syntaxLanguage)?.data.commentTokens?.line ??
                '//';
        final spec = CommentCommands.toggleLineComment(ev.state, token);
        if (spec == null) return false;
        ev.dispatch(spec);
        return true;
      },
    ),
  ]);
}

Command _wrap(TransactionSpec? Function(dynamic state) fn) {
  return (dynamic view) {
    final ev = view as EditorView;
    final spec = fn(ev.state);
    if (spec == null) return false;
    ev.dispatch(spec);
    return true;
  };
}

Command _wrapNonNull(TransactionSpec Function(dynamic state) fn) {
  return (dynamic view) {
    final ev = view as EditorView;
    ev.dispatch(fn(ev.state));
    return true;
  };
}

Command _wrapEdit(TransactionSpec? Function(dynamic state) fn) {
  return (dynamic view) {
    final ev = view as EditorView;
    if (ev.readOnly) return false;
    final spec = fn(ev.state);
    if (spec == null) return false;
    ev.dispatch(spec);
    return true;
  };
}

Command _wrapEditNonNull(TransactionSpec Function(dynamic state) fn) {
  return (dynamic view) {
    final ev = view as EditorView;
    if (ev.readOnly) return false;
    ev.dispatch(fn(ev.state));
    return true;
  };
}
