import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper: apply a [TransactionSpec] to [state] and return the new state.
EditorState apply(EditorState state, TransactionSpec spec) {
  return state.applyTransaction(state.update(spec));
}

void main() {
  // ---------------------------------------------------------------------------
  // deleteLine
  // ---------------------------------------------------------------------------
  group('deleteLine', () {
    test('deletes a middle line (not first, not last)', () {
      // "line1\nline2\nline3" — cursor on line2
      final state = EditorState.create(
        docString: 'line1\nline2\nline3',
        selection: EditorSelection.cursor(6), // inside "line2"
      );
      final spec = EditorCommands.deleteLine(state);
      final next = apply(state, spec);
      expect(next.doc.toString(), 'line1\nline3');
    });

    test('deletes first line', () {
      final state = EditorState.create(
        docString: 'first\nsecond\nthird',
        selection: EditorSelection.cursor(0),
      );
      final spec = EditorCommands.deleteLine(state);
      final next = apply(state, spec);
      expect(next.doc.toString(), 'second\nthird');
    });

    test('deletes last line', () {
      final state = EditorState.create(
        docString: 'first\nsecond\nthird',
        selection: EditorSelection.cursor(13), // inside "third"
      );
      final spec = EditorCommands.deleteLine(state);
      final next = apply(state, spec);
      expect(next.doc.toString(), 'first\nsecond');
    });

    test('deletes only line leaving empty document', () {
      final state = EditorState.create(
        docString: 'only',
        selection: EditorSelection.cursor(2),
      );
      final spec = EditorCommands.deleteLine(state);
      final next = apply(state, spec);
      expect(next.doc.toString(), '');
    });
  });

  // ---------------------------------------------------------------------------
  // duplicateLine
  // ---------------------------------------------------------------------------
  group('duplicateLine', () {
    test('duplicates a middle line', () {
      // "line1\nline2\nline3" — cursor on line2 at col 2
      final state = EditorState.create(
        docString: 'line1\nline2\nline3',
        selection: EditorSelection.cursor(8), // "line2", col 2
      );
      final spec = EditorCommands.duplicateLine(state);
      final next = apply(state, spec);
      expect(next.doc.toString(), 'line1\nline2\nline2\nline3');
      // cursor should be on the duplicated line at col 2
      expect(next.selection.main.head, 14); // "line1\nline2\nli" → offset 14
    });

    test('duplicates last line', () {
      final state = EditorState.create(
        docString: 'first\nlast',
        selection: EditorSelection.cursor(6), // start of "last"
      );
      final spec = EditorCommands.duplicateLine(state);
      final next = apply(state, spec);
      expect(next.doc.toString(), 'first\nlast\nlast');
      // cursor on duplicated "last" at col 0
      expect(next.selection.main.head, 11);
    });

    test('cursor placed at same column on duplicated line', () {
      final state = EditorState.create(
        docString: 'hello\nworld',
        selection: EditorSelection.cursor(3), // "hel|lo"
      );
      final spec = EditorCommands.duplicateLine(state);
      final next = apply(state, spec);
      expect(next.doc.toString(), 'hello\nhello\nworld');
      // duplicated line starts at offset 6; col 3 → offset 9
      expect(next.selection.main.head, 9);
    });
  });

  // ---------------------------------------------------------------------------
  // moveLineUp
  // ---------------------------------------------------------------------------
  group('moveLineUp', () {
    test('swaps current line with line above', () {
      // "line1\nline2\nline3" — cursor on line2
      final state = EditorState.create(
        docString: 'line1\nline2\nline3',
        selection: EditorSelection.cursor(6), // start of "line2"
      );
      final spec = EditorCommands.moveLineUp(state)!;
      final next = apply(state, spec);
      expect(next.doc.toString(), 'line2\nline1\nline3');
    });

    test('cursor stays on the moved line after swap', () {
      final state = EditorState.create(
        docString: 'aaa\nbbb',
        selection: EditorSelection.cursor(4), // start of "bbb"
      );
      final spec = EditorCommands.moveLineUp(state)!;
      final next = apply(state, spec);
      expect(next.doc.toString(), 'bbb\naaa');
      // "bbb" is now on line 1 starting at offset 0; col 0
      expect(next.selection.main.head, 0);
    });

    test('returns null on first line', () {
      final state = EditorState.create(
        docString: 'first\nsecond',
        selection: EditorSelection.cursor(2),
      );
      expect(EditorCommands.moveLineUp(state), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // moveLineDown
  // ---------------------------------------------------------------------------
  group('moveLineDown', () {
    test('swaps current line with line below', () {
      // "line1\nline2\nline3" — cursor on line2
      final state = EditorState.create(
        docString: 'line1\nline2\nline3',
        selection: EditorSelection.cursor(6), // start of "line2"
      );
      final spec = EditorCommands.moveLineDown(state)!;
      final next = apply(state, spec);
      expect(next.doc.toString(), 'line1\nline3\nline2');
    });

    test('cursor stays on the moved line after swap', () {
      final state = EditorState.create(
        docString: 'aaa\nbbb',
        selection: EditorSelection.cursor(0), // start of "aaa"
      );
      final spec = EditorCommands.moveLineDown(state)!;
      final next = apply(state, spec);
      expect(next.doc.toString(), 'bbb\naaa');
      // "aaa" is now on line 2 starting at offset 4; col 0
      expect(next.selection.main.head, 4);
    });

    test('returns null on last line', () {
      final state = EditorState.create(
        docString: 'first\nlast',
        selection: EditorSelection.cursor(6),
      );
      expect(EditorCommands.moveLineDown(state), isNull);
    });
  });
}
