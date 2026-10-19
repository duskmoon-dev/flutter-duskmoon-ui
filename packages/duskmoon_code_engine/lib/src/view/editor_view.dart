import 'package:flutter/foundation.dart';

import '../document/document.dart';
import '../language/syntax.dart';
import '../state/editor_state.dart';
import '../state/extension.dart';

/// Non-widget controller that holds state and dispatches transactions.
class EditorView extends ChangeNotifier {
  EditorView({required EditorState state}) : _state = state;

  EditorState _state;

  EditorState get state => _state;
  Document get document => _state.doc;

  void dispatch(TransactionSpec spec, {List<Extension>? extensions}) {
    if (extensions != null) _state = _state.reconfigure(extensions);
    final tr = _state.update(spec);
    _state = _state.applyTransaction(tr);
    notifyListeners();
  }

  /// Notify all listeners without dispatching a transaction.
  ///
  /// Useful when external state (e.g. theme) changes and the view should
  /// redraw without modifying the document or selection.
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  void invalidate() => notifyListeners();

  @override
  void dispose() {
    disposeSyntax(_state);
    super.dispose();
  }

  Output facet<Input, Output>(Facet<Input, Output> facet) =>
      _state.facet(facet);

  T field<T>(StateField<T> field) => _state.field(field);
}
