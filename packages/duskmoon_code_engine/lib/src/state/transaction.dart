part of 'editor_state.dart';

/// Specification for creating a [Transaction].
class TransactionSpec {
  const TransactionSpec({
    this.changes,
    this.selection,
    this.effects = const [],
    this.annotations = const [],
    this.scrollIntoView = false,
  });

  final ChangeSet? changes;
  final EditorSelection? selection;
  final List<StateEffect<dynamic>> effects;
  final List<Annotation<dynamic>> annotations;
  final bool scrollIntoView;
}

/// An immutable representation of a state change.
///
/// Created by `EditorState.update()` and carries the changes, selection,
/// effects, and annotations that describe the transition. The new state is
/// lazily computed on first access of [state].
class Transaction {
  Transaction._({
    required this.startState,
    required this.changes,
    required this.selection,
    required this.effects,
    required this.annotations,
    required this.scrollIntoView,
  });

  /// The state before this transaction was applied.
  final EditorState startState;

  /// Document changes, if any.
  final ChangeSet? changes;

  /// The new selection after this transaction.
  final EditorSelection selection;

  /// Side-effect descriptors.
  final List<StateEffect<dynamic>> effects;

  /// Metadata annotations.
  final List<Annotation<dynamic>> annotations;

  /// Whether the view should scroll the selection into view.
  final bool scrollIntoView;

  EditorState? _state;

  /// The new editor state after applying this transaction.
  EditorState get state => _state ??= startState._applyTransaction(this);

  /// Whether the document was modified.
  bool get docChanged => changes != null && changes!.docChanged;

  /// Whether the selection changed from the start state's selection.
  bool get selectionChanged => selection != startState.selection;

  /// Look up an annotation by its type. Returns `null` if not present.
  T? annotation<T>(AnnotationType<T> type) {
    for (final ann in annotations) {
      if (ann.type == type) return ann.value as T;
    }
    return null;
  }
}
