import '../document/change.dart';
import '../document/document.dart';
import 'annotation.dart';
import 'extension.dart';
import 'selection.dart';
import 'state_effect.dart';

part 'transaction.dart';

/// The immutable state of the code editor.
///
/// Holds the current [doc], [selection], resolved facet values, and
/// state-field values. New states are produced by calling [update] to
/// create a [Transaction] and then accessing `transaction.state`.
class EditorState {
  EditorState._({
    required this.doc,
    required this.selection,
    required FacetStore facets,
    required Map<StateField<dynamic>, dynamic> fieldValues,
    required List<Extension> extensions,
  })  : _facets = facets,
        _fieldValues = fieldValues,
        _extensions = extensions;

  /// The current document.
  final Document doc;

  /// The current selection.
  final EditorSelection selection;

  final FacetStore _facets;
  final Map<StateField<dynamic>, dynamic> _fieldValues;
  final List<Extension> _extensions;

  /// Create a new editor state from scratch.
  factory EditorState.create({
    Document? doc,
    String? docString,
    EditorSelection? selection,
    List<Extension> extensions = const [],
  }) {
    final document = doc ??
        (docString != null ? Document.fromString(docString) : Document.empty);
    final sel = selection ?? EditorSelection.cursor(0);
    final facets = FacetStore.resolve(extensions);
    final fields = _collectStateFields(extensions);

    // Build the state so that field.create can reference it.
    final fieldValues = <StateField<dynamic>, dynamic>{};
    final state = EditorState._(
      doc: document,
      selection: sel,
      facets: facets,
      fieldValues: fieldValues,
      extensions: extensions,
    );

    // Initialize each field's value.
    for (final f in fields) {
      fieldValues[f] = f.create(state);
    }

    return state;
  }

  /// Read a resolved facet value.
  Output facet<Input, Output>(Facet<Input, Output> f) => _facets.read(f);

  /// Read a state field value.
  T field<T>(StateField<T> f) {
    if (!_fieldValues.containsKey(f)) {
      throw StateError(
        'StateField not found — was it included in the extensions list?',
      );
    }
    return _fieldValues[f] as T;
  }

  /// Create a [Transaction] from a [TransactionSpec].
  ///
  /// The new state is lazily computed when `transaction.state` is accessed.
  Transaction update(TransactionSpec spec) {
    final changes = spec.changes;

    // Compute the new selection: explicit selection wins, otherwise map
    // the current selection through changes.
    final EditorSelection newSelection;
    if (spec.selection != null) {
      newSelection = spec.selection!;
    } else if (changes != null) {
      newSelection = selection.map(changes);
    } else {
      newSelection = selection;
    }

    return Transaction._(
      startState: this,
      changes: changes,
      selection: newSelection,
      effects: spec.effects,
      annotations: spec.annotations,
      scrollIntoView: spec.scrollIntoView,
    );
  }

  /// Apply a transaction and return the new state (convenience).
  EditorState applyTransaction(Transaction tr) => tr.state;

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  /// Compute the new state from a transaction.
  EditorState _applyTransaction(Transaction tr) {
    final changes = tr.changes;
    final newDoc = changes != null ? doc.replace(changes) : doc;

    // Update field values.
    final newFieldValues = <StateField<dynamic>, dynamic>{};
    for (final entry in _fieldValues.entries) {
      newFieldValues[entry.key] = entry.key.updateDynamic(tr, entry.value);
    }

    return EditorState._(
      doc: newDoc,
      selection: tr.selection,
      facets: _facets, // Facets are static in Phase 1
      fieldValues: newFieldValues,
      extensions: _extensions,
    );
  }

  /// Recursively collect all [StateField]s from the extension list.
  static List<StateField<dynamic>> _collectStateFields(
    List<Extension> extensions,
  ) {
    final fields = <StateField<dynamic>>[];

    void collect(Extension ext) {
      switch (ext) {
        case StateField<dynamic>():
          fields.add(ext);
        case ExtensionGroup():
          for (final child in ext.extensions) {
            collect(child);
          }
        case PrecedenceExtension():
          collect(ext.inner);
        case CompartmentExtension():
          collect(ext.inner);
        default:
          break;
      }
    }

    for (final ext in extensions) {
      collect(ext);
    }

    return fields;
  }
}
