import 'package:flutter/services.dart';

import '../document/change.dart';
import '../state/editor_state.dart';
import '../state/selection.dart';
import 'editor_view.dart';

/// TextInputClient adapter for [EditorView].
///
/// Bridges the Flutter platform IME (TextInput system) to the editor's
/// state model. Exposes the full document text to the IME and diffs incoming
/// [TextEditingValue] updates into [ChangeSet]s dispatched to the editor.
///
/// Usage:
/// ```dart
/// final handler = InputHandler(view);
/// handler.attach(); // connect to the platform TextInput
/// // ...
/// handler.detach(); // disconnect when done
/// ```
class InputHandler with TextInputClient {
  InputHandler(this._view);

  final EditorView _view;
  TextInputConnection? _connection;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  /// Connects to the platform IME.
  void attach() {
    _connection = TextInput.attach(
      this,
      const TextInputConfiguration(
        inputType: TextInputType.multiline,
        inputAction: TextInputAction.newline,
      ),
    );
    syncState();
  }

  /// Disconnects from the platform IME.
  void detach() {
    _connection?.close();
    _connection = null;
  }

  /// Pushes the current editor state to the IME.
  void syncState() {
    _connection?.setEditingState(currentTextEditingValue!);
  }

  // ---------------------------------------------------------------------------
  // TextInputClient
  // ---------------------------------------------------------------------------

  @override
  TextEditingValue? get currentTextEditingValue {
    final state = _view.state;
    final text = state.doc.toString();
    final main = state.selection.main;
    return TextEditingValue(
      text: text,
      selection: TextSelection(
        baseOffset: main.anchor,
        extentOffset: main.head,
      ),
    );
  }

  @override
  void updateEditingValue(TextEditingValue value) {
    final oldValue = currentTextEditingValue;
    if (oldValue == null) return;

    final oldText = oldValue.text;
    final newText = value.text;

    if (oldText == newText) {
      // Only selection changed — update selection without a document change.
      final sel = EditorSelection.single(
        anchor: value.selection.baseOffset.clamp(0, newText.length),
        head: value.selection.extentOffset.clamp(0, newText.length),
      );
      _view.dispatch(TransactionSpec(selection: sel));
      return;
    }

    final diff = _diff(oldText, newText);
    final changes = ChangeSet.of(oldText.length, [
      ChangeSpec(
        from: diff.from,
        to: diff.oldTo,
        insert: diff.inserted,
      ),
    ]);

    final newHead = value.selection.extentOffset.clamp(0, newText.length);
    final newAnchor = value.selection.baseOffset.clamp(0, newText.length);
    final sel = EditorSelection.single(anchor: newAnchor, head: newHead);

    _view.dispatch(TransactionSpec(changes: changes, selection: sel));
  }

  @override
  void performAction(TextInputAction action) {
    // Enter is handled by the keymap; no-op here.
  }

  @override
  void connectionClosed() {
    _connection = null;
  }

  // ---------------------------------------------------------------------------
  // No-op TextInputClient overrides
  // ---------------------------------------------------------------------------

  @override
  AutofillScope? get currentAutofillScope => null;

  @override
  void updateFloatingCursor(RawFloatingCursorPoint point) {}

  @override
  void showAutocorrectionPromptRect(int start, int end) {}

  @override
  void performPrivateCommand(String action, Map<String, dynamic> data) {}

  @override
  void insertTextPlaceholder(Size size) {}

  @override
  void removeTextPlaceholder() {}

  @override
  void didChangeInputControl(
    TextInputControl? oldControl,
    TextInputControl? newControl,
  ) {}

  @override
  void performSelector(String selectorName) {}

  // ---------------------------------------------------------------------------
  // Diff
  // ---------------------------------------------------------------------------

  static _Diff _diff(String oldText, String newText) {
    var prefixLen = 0;
    final minLen =
        oldText.length < newText.length ? oldText.length : newText.length;
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
    return _Diff(prefixLen, oldSuffix, newText.substring(prefixLen, newSuffix));
  }
}

// ---------------------------------------------------------------------------
// Internal
// ---------------------------------------------------------------------------

class _Diff {
  const _Diff(this.from, this.oldTo, this.inserted);

  final int from;
  final int oldTo;
  final String inserted;
}
