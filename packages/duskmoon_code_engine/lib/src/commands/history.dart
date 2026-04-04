import '../document/change.dart';
import '../document/rope.dart';
import '../state/annotation.dart';
import '../state/editor_state.dart';
import '../state/extension.dart';
import '../state/selection.dart';
import '../state/state_effect.dart';

/// A single undo/redo entry: an inverse [ChangeSet] and the [EditorSelection]
/// to restore when this entry is applied.
class HistoryEntry {
  const HistoryEntry(this.changes, this.selection);

  /// The inverse changeset that, when applied, reverts the corresponding edit.
  final ChangeSet changes;

  /// The selection to restore after applying [changes].
  final EditorSelection selection;
}

/// Immutable snapshot of the undo/redo stacks.
class HistoryState {
  const HistoryState({this.undoStack = const [], this.redoStack = const []});

  /// Stack of entries that can be undone (top = most recent).
  final List<HistoryEntry> undoStack;

  /// Stack of entries that can be redone (top = most recently undone).
  final List<HistoryEntry> redoStack;
}

/// Effect type used to mark a transaction as an undo operation.
///
/// Must be a non-const (runtime-allocated) instance so that [undoEffect] and
/// [redoEffect] are distinct objects. Dart canonicalises const objects of the
/// same type, which would make the two types indistinguishable via `==`.
// ignore: prefer_const_constructors
final undoEffect = StateEffectType<bool>();

/// Effect type used to mark a transaction as a redo operation.
// ignore: prefer_const_constructors
final redoEffect = StateEffectType<bool>();

// ---------------------------------------------------------------------------
// historyField
// ---------------------------------------------------------------------------

StateField<HistoryState>? _historyField;

/// The [StateField] that tracks the undo/redo stacks.
///
/// Lazily created on first access so that [undoEffect] / [redoEffect] are
/// always initialized before the field is constructed.
StateField<HistoryState> get historyField {
  return _historyField ??= StateField<HistoryState>(
    create: (_) => const HistoryState(),
    update: (dynamic tr, HistoryState value) {
      final transaction = tr as Transaction;

      final hasUndo = transaction.effects.any((e) => e.type == undoEffect);
      final hasRedo = transaction.effects.any((e) => e.type == redoEffect);

      if (hasUndo) {
        // Pop from undoStack; push inverse to redoStack.
        if (value.undoStack.isEmpty) return value;
        final entry = value.undoStack.last;
        if (transaction.changes == null) return value;

        // Compute the inverse of the undo changeset (to put on the redo stack).
        // The undo was applied to the "post-edit" doc; its inverse needs the
        // pre-undo doc, which is transaction.startState.doc.
        final originalRope = Rope.fromString(
          transaction.startState.doc.toString(),
        );
        final inverseOfUndo = entry.changes.invert(originalRope);

        final newUndo = value.undoStack.sublist(0, value.undoStack.length - 1);
        final newRedo = [
          ...value.redoStack,
          HistoryEntry(inverseOfUndo, transaction.startState.selection),
        ];
        return HistoryState(undoStack: newUndo, redoStack: newRedo);
      }

      if (hasRedo) {
        // Pop from redoStack; push inverse to undoStack.
        if (value.redoStack.isEmpty) return value;
        final entry = value.redoStack.last;
        if (transaction.changes == null) return value;

        final originalRope = Rope.fromString(
          transaction.startState.doc.toString(),
        );
        final inverseOfRedo = entry.changes.invert(originalRope);

        final newRedo = value.redoStack.sublist(0, value.redoStack.length - 1);
        final newUndo = [
          ...value.undoStack,
          HistoryEntry(inverseOfRedo, transaction.startState.selection),
        ];
        return HistoryState(undoStack: newUndo, redoStack: newRedo);
      }

      // Respect the addToHistory annotation for normal edits: if explicitly
      // false, skip adding to history (used by undo/redo transactions).
      final addToHistory = transaction.annotation(Annotations.addToHistory);
      if (addToHistory == false) return value;

      // Normal edit: push inverse changeset to undoStack, clear redoStack.
      if (!transaction.docChanged) return value;

      final changes = transaction.changes!;
      final originalRope = Rope.fromString(
        transaction.startState.doc.toString(),
      );
      final inverse = changes.invert(originalRope);

      final newUndo = [
        ...value.undoStack,
        HistoryEntry(inverse, transaction.startState.selection),
      ];
      return HistoryState(undoStack: newUndo);
    },
  );
}

/// Returns the [historyField] as an [Extension] to include in
/// [EditorState.create].
Extension historyExtension() => historyField;
