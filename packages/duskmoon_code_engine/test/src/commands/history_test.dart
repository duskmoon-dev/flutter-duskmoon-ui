import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper: apply a [TransactionSpec] to [state] and return the new state.
EditorState apply(EditorState state, TransactionSpec spec) {
  return state.applyTransaction(state.update(spec));
}

void main() {
  group('History', () {
    test('undo reverts last change', () {
      var state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(5),
        extensions: [historyExtension()],
      );

      // Insert ' world' at the end.
      final insertSpec = EditorCommands.insertText(state, ' world');
      state = apply(state, insertSpec);
      expect(state.doc.toString(), 'hello world');

      // Undo should revert to 'hello'.
      final undoSpec = EditorCommands.undo(state);
      expect(undoSpec, isNotNull);
      state = apply(state, undoSpec!);
      expect(state.doc.toString(), 'hello');
    });

    test('redo reapplies undone change', () {
      var state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(5),
        extensions: [historyExtension()],
      );

      // Insert ' world'.
      state = apply(state, EditorCommands.insertText(state, ' world'));
      expect(state.doc.toString(), 'hello world');

      // Undo.
      state = apply(state, EditorCommands.undo(state)!);
      expect(state.doc.toString(), 'hello');

      // Redo.
      final redoSpec = EditorCommands.redo(state);
      expect(redoSpec, isNotNull);
      state = apply(state, redoSpec!);
      expect(state.doc.toString(), 'hello world');
    });

    test('undo returns null when nothing to undo', () {
      final state = EditorState.create(
        docString: 'hello',
        extensions: [historyExtension()],
      );
      expect(EditorCommands.undo(state), isNull);
    });

    test('redo returns null when nothing to redo', () {
      final state = EditorState.create(
        docString: 'hello',
        extensions: [historyExtension()],
      );
      expect(EditorCommands.redo(state), isNull);
    });

    test('new edit after undo clears redo stack', () {
      var state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(5),
        extensions: [historyExtension()],
      );

      // Insert ' world'.
      state = apply(state, EditorCommands.insertText(state, ' world'));
      expect(state.doc.toString(), 'hello world');

      // Undo → 'hello', redo stack has one entry.
      state = apply(state, EditorCommands.undo(state)!);
      expect(EditorCommands.redo(state), isNotNull);

      // Make a new edit — redo stack should be cleared.
      state = apply(state, EditorCommands.insertText(state, '!'));
      expect(EditorCommands.redo(state), isNull);
    });

    test('multiple undo steps', () {
      var state = EditorState.create(
        docString: '',
        extensions: [historyExtension()],
      );

      // Three separate insertions.
      state = apply(state, EditorCommands.insertText(state, 'a'));
      state = apply(state, EditorCommands.insertText(state, 'b'));
      state = apply(state, EditorCommands.insertText(state, 'c'));
      expect(state.doc.toString(), 'abc');

      // Undo three times.
      state = apply(state, EditorCommands.undo(state)!);
      expect(state.doc.toString(), 'ab');

      state = apply(state, EditorCommands.undo(state)!);
      expect(state.doc.toString(), 'a');

      state = apply(state, EditorCommands.undo(state)!);
      expect(state.doc.toString(), '');

      // Nothing left to undo.
      expect(EditorCommands.undo(state), isNull);
    });
  });
}
