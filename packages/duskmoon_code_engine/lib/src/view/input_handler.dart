import 'package:flutter/services.dart';

import '../document/change.dart';
import '../document/document.dart';
import '../state/annotation.dart';
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
  InputHandler(this._view) {
    _recordKnownState();
  }

  final EditorView _view;
  TextInputConnection? _connection;
  bool _acceptsInput = true;
  TextRange _composing = TextRange.empty;
  bool _hasActiveComposingHistory = false;
  bool _isUpdatingFromIme = false;
  int _lastKnownSessionId = -1;
  Document? _lastKnownDoc;
  EditorSelection? _lastKnownSelection;
  TextEditingValue? _lastSyncedValue;

  void _recordKnownState() {
    _lastKnownSessionId = _view.sessionId;
    _lastKnownDoc = _view.state.doc;
    _lastKnownSelection = _view.state.selection;
  }

  void _checkExternalChange() {
    if (_isUpdatingFromIme) return;
    if (_lastKnownSessionId != -1 &&
        (_view.sessionId != _lastKnownSessionId ||
            !identical(_view.state.doc, _lastKnownDoc) ||
            _view.state.selection != _lastKnownSelection)) {
      resetComposing();
    }
    _recordKnownState();
  }

  /// Whether the platform IME is actively composing text.
  bool get isComposing {
    _checkExternalChange();
    return _composing.isValid && !_composing.isCollapsed;
  }

  /// Clears active composing state.
  void resetComposing() {
    _composing = TextRange.empty;
    _hasActiveComposingHistory = false;
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  /// Connects to the platform IME and shows the software keyboard.
  ///
  /// Reuses an active connection, including after keyboard dismissal.
  void attach() {
    _acceptsInput = true;
    if (_connection?.attached != true) {
      _connection = TextInput.attach(
        this,
        const TextInputConfiguration(
          inputType: TextInputType.multiline,
          inputAction: TextInputAction.newline,
          autocorrect: false,
          enableSuggestions: false,
        ),
      );
    }
    syncState(force: true);
    _connection!.show();
  }

  /// Disconnects from the platform IME.
  void detach() {
    _acceptsInput = false;
    _hasActiveComposingHistory = false;
    _connection?.close();
    _connection = null;
    _lastSyncedValue = null;
  }

  /// Pushes the current editor state to the IME.
  void syncState({bool force = false}) {
    _checkExternalChange();
    if (!_acceptsInput || _connection == null) return;
    final current = currentTextEditingValue;
    if (current == null) return;
    if (!force && _lastSyncedValue == current) {
      return;
    }
    _lastSyncedValue = current;
    _connection!.setEditingState(current);
  }

  // ---------------------------------------------------------------------------
  // TextInputClient
  // ---------------------------------------------------------------------------

  @override
  TextEditingValue? get currentTextEditingValue {
    _checkExternalChange();
    final state = _view.state;
    final text = state.doc.toString();
    final main = state.selection.main;
    final composing = (_composing.isValid && _composing.end <= text.length)
        ? _composing
        : TextRange.empty;
    return TextEditingValue(
      text: text,
      selection: TextSelection(
        baseOffset: main.anchor.clamp(0, text.length),
        extentOffset: main.head.clamp(0, text.length),
      ),
      composing: composing,
    );
  }

  @override
  void updateEditingValue(TextEditingValue value) {
    if (!_acceptsInput || _view.readOnly) return;
    _checkExternalChange();
    _isUpdatingFromIme = true;
    try {
      final oldValue = currentTextEditingValue;
      if (oldValue == null) return;

      final nextComposingActive =
          value.composing.isValid && !value.composing.isCollapsed;
      final shouldCoalesce = _hasActiveComposingHistory;
      _composing = value.composing;

      final oldText = oldValue.text;
      final newText = value.text;

      if (oldText == newText) {
        if (!nextComposingActive) {
          _hasActiveComposingHistory = false;
        }
        // Only selection or composing changed — update selection without a document change.
        final sel = EditorSelection.single(
          anchor: value.selection.baseOffset.clamp(0, newText.length),
          head: value.selection.extentOffset.clamp(0, newText.length),
        );
        if (sel != _view.state.selection) {
          _view.dispatch(TransactionSpec(selection: sel));
        }
        _recordKnownState();
        return;
      }

      final diff = _diff(oldText, newText);
      final changes = ChangeSet.of(oldText.length, [
        ChangeSpec(from: diff.from, to: diff.oldTo, insert: diff.inserted),
      ]);

      final newHead = value.selection.extentOffset.clamp(0, newText.length);
      final newAnchor = value.selection.baseOffset.clamp(0, newText.length);
      final sel = EditorSelection.single(anchor: newAnchor, head: newHead);

      _lastSyncedValue = value;
      _view.dispatch(
        TransactionSpec(
          changes: changes,
          selection: sel,
          annotations: shouldCoalesce
              ? const [Annotation(Annotations.coalesceHistory, true)]
              : const [],
          scrollIntoView: true,
        ),
      );
      _hasActiveComposingHistory = nextComposingActive;
      _recordKnownState();

      final current = currentTextEditingValue;
      if (current != null &&
          (current.text != value.text ||
              current.selection != value.selection)) {
        syncState(force: true);
      }
    } finally {
      _isUpdatingFromIme = false;
    }
  }

  @override
  void performAction(TextInputAction action) {
    // Enter is handled by the keymap; no-op here.
  }

  @override
  void connectionClosed() {
    _acceptsInput = false;
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
