import 'package:flutter/foundation.dart';

import '../document/document.dart';
import '../state/editor_state.dart';
import '../state/extension.dart';

/// Non-widget controller that holds state and dispatches transactions.
class EditorView extends ChangeNotifier {
  EditorView({required EditorState state}) : _state = state;

  EditorState _state;

  EditorState get state => _state;
  Document get document => _state.doc;

  void dispatch(TransactionSpec spec) {
    final tr = _state.update(spec);
    _state = _state.applyTransaction(tr);
    notifyListeners();
  }

  Output facet<Input, Output>(Facet<Input, Output> facet) =>
      _state.facet(facet);

  T field<T>(StateField<T> field) => _state.field(field);
}
