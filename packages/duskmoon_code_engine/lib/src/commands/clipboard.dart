import 'package:flutter/services.dart';
import '../document/change.dart';
import '../state/editor_state.dart';
import '../state/selection.dart';
import '../view/editor_view.dart';
import 'keymap.dart';

/// Clipboard operations: copy, cut, and paste.
abstract final class ClipboardCommands {
  /// Returns the text covered by the main selection, or an empty string when
  /// the selection is a cursor (empty range).
  static String getSelectedText(EditorState state) {
    final sel = state.selection.main;
    if (sel.isEmpty) return '';
    return state.doc.sliceString(sel.from, sel.to);
  }

  /// Returns a [TransactionSpec] that deletes the main selection and moves
  /// the cursor to the start of the deleted range. Returns `null` when the
  /// selection is empty (cursor only).
  static TransactionSpec? cutSpec(EditorState state) {
    final sel = state.selection.main;
    if (sel.isEmpty) return null;
    return TransactionSpec(
      changes: ChangeSet.of(state.doc.length, [
        ChangeSpec(from: sel.from, to: sel.to),
      ]),
      selection: EditorSelection.cursor(sel.from),
    );
  }

  /// Returns a [TransactionSpec] that inserts [text] at the current selection,
  /// replacing it when non-empty, and places the cursor after the inserted text.
  static TransactionSpec pasteSpec(EditorState state, String text) {
    final sel = state.selection.main;
    return TransactionSpec(
      changes: ChangeSet.of(state.doc.length, [
        ChangeSpec(from: sel.from, to: sel.to, insert: text),
      ]),
      selection: EditorSelection.cursor(sel.from + text.length),
    );
  }

  /// A [Command] that copies the selected text to the clipboard.
  ///
  /// Returns `false` (not handled) when nothing is selected.
  static Command copyCommand() => (dynamic view) {
        final ev = view as EditorView;
        final text = getSelectedText(ev.state);
        if (text.isEmpty) return false;
        Clipboard.setData(ClipboardData(text: text));
        return true;
      };

  /// A [Command] that cuts the selected text to the clipboard, removing it
  /// from the document.
  ///
  /// Returns `false` (not handled) when nothing is selected or when read-only.
  static Command cutCommand() => (dynamic view) {
        final ev = view as EditorView;
        if (ev.isDisposed || ev.readOnly) return false;
        final text = getSelectedText(ev.state);
        if (text.isEmpty) return false;
        final spec = cutSpec(ev.state);
        if (spec == null) return false;
        Clipboard.setData(ClipboardData(text: text));
        ev.dispatch(spec);
        return true;
      };

  /// A [Command] that pastes plain text from the clipboard at the current
  /// selection, replacing any selected text.
  ///
  /// Returns `false` when disposed or in read-only mode.
  static Command pasteCommand() => (dynamic view) {
        final ev = view as EditorView;
        if (ev.isDisposed || ev.readOnly) return false;
        final initialSessionId = ev.sessionId;
        final initialDoc = ev.state.doc;
        final initialSel = ev.state.selection;
        Clipboard.getData(Clipboard.kTextPlain).then((data) {
          if (ev.isDisposed || ev.readOnly) return;
          if (ev.sessionId != initialSessionId) return;
          final text = data?.text;
          if (text == null || text.isEmpty) return;

          final EditorSelection targetSel;
          if (identical(ev.state.doc, initialDoc)) {
            targetSel = initialSel;
          } else {
            final since = ev.changesSince(initialDoc);
            if (since == null ||
                since.touchesRange(initialSel.main.from, initialSel.main.to)) {
              return;
            }
            targetSel = initialSel.map(since);
          }
          if (targetSel.main.to > ev.state.doc.length) return;

          final spec = TransactionSpec(
            changes: ChangeSet.of(ev.state.doc.length, [
              ChangeSpec(
                from: targetSel.main.from,
                to: targetSel.main.to,
                insert: text,
              ),
            ]),
            selection:
                EditorSelection.cursor(targetSel.main.from + text.length),
            scrollIntoView: true,
          );
          ev.dispatch(spec);
        });
        return true;
      };
}
