import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper: apply a [TransactionSpec] to [state] and return the new state.
EditorState apply(EditorState state, TransactionSpec spec) {
  return state.applyTransaction(state.update(spec));
}

void main() {
  // ---------------------------------------------------------------------------
  // cursorWordRight
  // ---------------------------------------------------------------------------
  group('cursorWordRight', () {
    test('moves to end of word from within word', () {
      // "hello world" cursor at 0 → should land at 5 (end of "hello")
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.cursor(0),
      );
      final spec = EditorCommands.cursorWordRight(state)!;
      final next = apply(state, spec);
      expect(next.selection.main.head, 5);
    });

    test('skips whitespace after word to reach start of next word', () {
      // "hello world" cursor at 5 (space) → skips space and stops at end
      // of "world" which is 11.
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.cursor(5),
      );
      final spec = EditorCommands.cursorWordRight(state)!;
      final next = apply(state, spec);
      expect(next.selection.main.head, 11);
    });

    test('handles punctuation as boundary', () {
      // "foo.bar" cursor at 0 → "foo" ends at 3, then "." is non-word so
      // scanning stops at 4 (start of "bar").
      final state = EditorState.create(
        docString: 'foo.bar',
        selection: EditorSelection.cursor(0),
      );
      final spec = EditorCommands.cursorWordRight(state)!;
      final next = apply(state, spec);
      expect(next.selection.main.head, 4);
    });

    test('returns null at end of document', () {
      final state = EditorState.create(
        docString: 'hi',
        selection: EditorSelection.cursor(2),
      );
      expect(EditorCommands.cursorWordRight(state), isNull);
    });

    test('works across lines', () {
      // "abc\ndef" cursor at 0 → "abc" ends at 3, then "\n" is non-word,
      // then "def" starts so boundary is at 7 (end of "def").
      final state = EditorState.create(
        docString: 'abc\ndef',
        selection: EditorSelection.cursor(0),
      );
      final spec = EditorCommands.cursorWordRight(state)!;
      final next = apply(state, spec);
      expect(next.selection.main.head, 7);
    });
  });

  // ---------------------------------------------------------------------------
  // cursorWordLeft
  // ---------------------------------------------------------------------------
  group('cursorWordLeft', () {
    test('moves to start of current word', () {
      // "hello world" cursor at 10 (inside "world") → should land at 6
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.cursor(10),
      );
      final spec = EditorCommands.cursorWordLeft(state)!;
      final next = apply(state, spec);
      expect(next.selection.main.head, 6);
    });

    test('skips whitespace and moves to end of previous word', () {
      // "hello world" cursor at 6 (start of "world") → skip space at 5,
      // then word chars "hello" → should land at 0
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.cursor(6),
      );
      final spec = EditorCommands.cursorWordLeft(state)!;
      final next = apply(state, spec);
      expect(next.selection.main.head, 0);
    });

    test('returns null at start of document', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(0),
      );
      expect(EditorCommands.cursorWordLeft(state), isNull);
    });

    test('moves to start of word from end of word', () {
      // "hello" cursor at 5 → should land at 0
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(5),
      );
      final spec = EditorCommands.cursorWordLeft(state)!;
      final next = apply(state, spec);
      expect(next.selection.main.head, 0);
    });
  });

  // ---------------------------------------------------------------------------
  // selectWordRight
  // ---------------------------------------------------------------------------
  group('selectWordRight', () {
    test('extends selection to word boundary right', () {
      // "hello world" anchor=2, head=2 → select "llo" to reach 5
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.cursor(2),
      );
      final spec = EditorCommands.selectWordRight(state)!;
      final next = apply(state, spec);
      expect(next.selection.main.anchor, 2);
      expect(next.selection.main.head, 5);
    });

    test('keeps anchor fixed while extending head', () {
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.single(anchor: 0, head: 0),
      );
      final spec = EditorCommands.selectWordRight(state)!;
      final next = apply(state, spec);
      expect(next.selection.main.anchor, 0);
      expect(next.selection.main.head, 5);
    });

    test('returns null at end of document', () {
      final state = EditorState.create(
        docString: 'hi',
        selection: EditorSelection.cursor(2),
      );
      expect(EditorCommands.selectWordRight(state), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // selectWordLeft
  // ---------------------------------------------------------------------------
  group('selectWordLeft', () {
    test('extends selection to word boundary left', () {
      // "hello world" cursor at 11 → extends anchor at 11, head to 6
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.cursor(11),
      );
      final spec = EditorCommands.selectWordLeft(state)!;
      final next = apply(state, spec);
      expect(next.selection.main.anchor, 11);
      expect(next.selection.main.head, 6);
    });

    test('keeps anchor fixed while moving head left', () {
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.single(anchor: 11, head: 6),
      );
      final spec = EditorCommands.selectWordLeft(state)!;
      final next = apply(state, spec);
      expect(next.selection.main.anchor, 11);
      expect(next.selection.main.head, 0);
    });

    test('returns null at start of document', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(0),
      );
      expect(EditorCommands.selectWordLeft(state), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // deleteWordBackward
  // ---------------------------------------------------------------------------
  group('deleteWordBackward', () {
    test('deletes word before cursor', () {
      // "hello world" cursor at 11 → deletes "world" → "hello "
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.cursor(11),
      );
      final spec = EditorCommands.deleteWordBackward(state)!;
      final next = apply(state, spec);
      expect(next.doc.toString(), 'hello ');
      expect(next.selection.main.head, 6);
    });

    test('deletes word and preceding whitespace when cursor is at word start',
        () {
      // "hello world" cursor at 6 (start of "world") → deletes " hello"? No:
      // boundary scans left from 6: skip non-word (' ') → pos 5,
      // then skip word chars "hello" → pos 0. Deletes "hello " (indices 0..6).
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.cursor(6),
      );
      final spec = EditorCommands.deleteWordBackward(state)!;
      final next = apply(state, spec);
      expect(next.doc.toString(), 'world');
      expect(next.selection.main.head, 0);
    });

    test('returns null at start of document', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(0),
      );
      expect(EditorCommands.deleteWordBackward(state), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // deleteWordForward
  // ---------------------------------------------------------------------------
  group('deleteWordForward', () {
    test('deletes word after cursor', () {
      // "hello world" cursor at 0 → deletes "hello " → "world"
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.cursor(0),
      );
      final spec = EditorCommands.deleteWordForward(state)!;
      final next = apply(state, spec);
      expect(next.doc.toString(), ' world');
      expect(next.selection.main.head, 0);
    });

    test('deletes trailing whitespace and next word when at word boundary', () {
      // "hello world" cursor at 5 (end of "hello") → boundary right from 5:
      // skip non-word " " → 6, then "world" → 11. Deletes " world".
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.cursor(5),
      );
      final spec = EditorCommands.deleteWordForward(state)!;
      final next = apply(state, spec);
      expect(next.doc.toString(), 'hello');
      expect(next.selection.main.head, 5);
    });

    test('returns null at end of document', () {
      final state = EditorState.create(
        docString: 'hi',
        selection: EditorSelection.cursor(2),
      );
      expect(EditorCommands.deleteWordForward(state), isNull);
    });
  });
}
