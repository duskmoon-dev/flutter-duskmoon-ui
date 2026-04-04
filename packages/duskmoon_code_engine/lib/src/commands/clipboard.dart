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
      changes: ChangeSet.of(
        state.doc.length,
        [ChangeSpec(from: sel.from, to: sel.to)],
      ),
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
  /// Returns `false` (not handled) when nothing is selected.
  static Command cutCommand() => (dynamic view) {
        final ev = view as EditorView;
        final text = getSelectedText(ev.state);
        if (text.isEmpty) return false;
        Clipboard.setData(ClipboardData(text: text));
        final spec = cutSpec(ev.state);
        if (spec != null) ev.dispatch(spec);
        return true;
      };

  /// A [Command] that pastes plain text from the clipboard at the current
  /// selection, replacing any selected text.
  ///
  /// Always returns `true` because the intent to paste is unambiguously handled
  /// even if the clipboard is empty.
  static Command pasteCommand() => (dynamic view) {
        final ev = view as EditorView;
        Clipboard.getData(Clipboard.kTextPlain).then((data) {
          if (data?.text != null && data!.text!.isNotEmpty) {
            ev.dispatch(pasteSpec(ev.state, data.text!));
          }
        });
        return true;
      };
}
