import 'package:flutter/foundation.dart';

import '../document/change.dart';
import '../document/document.dart';
import '../language/syntax.dart';
import '../state/editor_state.dart';
import '../state/extension.dart';
import '../state/selection.dart';

class _SessionChangeRecord {
  const _SessionChangeRecord(this.fromDoc, this.toDoc, this.changes);
  final Document fromDoc;
  final Document toDoc;
  final ChangeSet changes;
}

/// Non-widget controller that holds state and dispatches transactions.
class EditorView extends ChangeNotifier {
  EditorView({required EditorState state, this.readOnly = false})
      : _state = state;

  EditorState _state;
  bool _lastDocChanged = false;
  bool _shouldRevealCursor = false;
  int _sessionId = 0;
  int _searchToggleCount = 0;
  final List<_SessionChangeRecord> _sessionChanges = [];

  /// Whether the editor is currently in read-only mode.
  bool readOnly;

  EditorState get state => _state;
  Document get document => _state.doc;

  /// Monotonically increasing identifier for the active document session.
  /// Incremented every time [openDocument] replaces the document.
  int get sessionId => _sessionId;

  /// Counter incremented whenever [toggleSearch] is invoked.
  int get searchToggleCount => _searchToggleCount;

  /// Whether the last dispatched transaction modified the document content.
  bool get lastDocChanged => _lastDocChanged;

  /// Whether the viewport should scroll to reveal the cursor on this update.
  bool get shouldRevealCursor => _shouldRevealCursor;

  void dispatch(TransactionSpec spec, {List<Extension>? extensions}) {
    if (extensions != null) _state = _state.reconfigure(extensions);
    final oldDoc = _state.doc;
    final tr = _state.update(spec);
    _state = _state.applyTransaction(tr);
    _lastDocChanged = _state.doc.version != oldDoc.version;
    if (_lastDocChanged && tr.changes != null) {
      _sessionChanges.add(
        _SessionChangeRecord(oldDoc, _state.doc, tr.changes!),
      );
      if (_sessionChanges.length > 64) {
        _sessionChanges.removeAt(0);
      }
    }
    _shouldRevealCursor =
        _lastDocChanged || tr.selectionChanged || spec.scrollIntoView;
    notifyListeners();
  }

  /// Returns the composed [ChangeSet] from [startDoc] to the current [document]
  /// within the same session, or `null` if [startDoc] is not reachable.
  ChangeSet? changesSince(Document startDoc) {
    if (identical(startDoc, _state.doc)) {
      return ChangeSet.of(startDoc.length, const []);
    }
    var startIndex = -1;
    for (var i = 0; i < _sessionChanges.length; i++) {
      if (identical(_sessionChanges[i].fromDoc, startDoc)) {
        startIndex = i;
        break;
      }
    }
    if (startIndex == -1) return null;
    var composed = _sessionChanges[startIndex].changes;
    var currentDoc = _sessionChanges[startIndex].toDoc;
    for (var i = startIndex + 1; i < _sessionChanges.length; i++) {
      final rec = _sessionChanges[i];
      if (!identical(rec.fromDoc, currentDoc)) return null;
      composed = composed.compose(rec.changes);
      currentDoc = rec.toDoc;
    }
    if (!identical(currentDoc, _state.doc)) return null;
    return composed;
  }

  /// Replaces the current session with [newDoc], resetting selection,
  /// syntax lifecycle, and extensions.
  void openDocument(Document newDoc, {List<Extension>? extensions}) {
    disposeSyntax(_state);
    _sessionId++;
    _sessionChanges.clear();
    final exts = extensions ?? _state.extensions;
    _state = EditorState.create(
      doc: newDoc,
      selection: EditorSelection.cursor(0),
      extensions: exts,
    );
    _lastDocChanged = true;
    _shouldRevealCursor = true;
    notifyListeners();
  }

  /// Requests any attached editor widget to toggle its search panel.
  void toggleSearch() {
    _searchToggleCount++;
    _lastDocChanged = false;
    _shouldRevealCursor = false;
    notifyListeners();
  }

  bool _disposed = false;

  /// Whether this view has been disposed.
  bool get isDisposed => _disposed;

  /// Notify all listeners without dispatching a transaction.
  ///
  /// Useful when external state (e.g. theme) changes and the view should
  /// redraw without modifying the document or selection.
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  void invalidate() {
    _lastDocChanged = false;
    _shouldRevealCursor = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    disposeSyntax(_state);
    super.dispose();
  }

  Output facet<Input, Output>(Facet<Input, Output> facet) =>
      _state.facet(facet);

  T field<T>(StateField<T> field) => _state.field(field);
}
