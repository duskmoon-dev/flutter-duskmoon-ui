import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper: apply a [TransactionSpec] to [state] and return the new state.
EditorState apply(EditorState state, TransactionSpec spec) {
  return state.applyTransaction(state.update(spec));
}

void main() {
  group('cursorCharRight', () {
    test('moves cursor one position right', () {
      final state = EditorState.create(docString: 'hello');
      final spec = EditorCommands.cursorCharRight(state);
      expect(spec, isNotNull);
      final next = apply(state, spec!);
      expect(next.selection.main.head, 1);
    });

    test('returns null at document end', () {
      final state = EditorState.create(
        docString: 'hi',
        selection: EditorSelection.cursor(2),
      );
      expect(EditorCommands.cursorCharRight(state), isNull);
    });

    test('moves from middle of document', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(3),
      );
      final spec = EditorCommands.cursorCharRight(state)!;
      expect(apply(state, spec).selection.main.head, 4);
    });
  });

  group('cursorCharLeft', () {
    test('moves cursor one position left', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(3),
      );
      final spec = EditorCommands.cursorCharLeft(state);
      expect(spec, isNotNull);
      expect(apply(state, spec!).selection.main.head, 2);
    });

    test('returns null at document start', () {
      final state = EditorState.create(docString: 'hello');
      expect(EditorCommands.cursorCharLeft(state), isNull);
    });
  });

  group('cursorLineDown', () {
    test('moves to next line same column', () {
      // "abc\ndef" — cursor at col 1 on line 1.
      final state = EditorState.create(
        docString: 'abc\ndef',
        selection: EditorSelection.cursor(1),
      );
      final spec = EditorCommands.cursorLineDown(state)!;
      final next = apply(state, spec);
      // Line 2 starts at offset 4; col 1 → offset 5.
      expect(next.selection.main.head, 5);
    });

    test('clamps column to line length on shorter next line', () {
      // "hello\nhi" — cursor at col 4 on line 1.
      final state = EditorState.create(
        docString: 'hello\nhi',
        selection: EditorSelection.cursor(4),
      );
      final spec = EditorCommands.cursorLineDown(state)!;
      final next = apply(state, spec);
      // Line 2 "hi" has length 2; col 4 clamps to 2 → offset 6+2=8.
      expect(next.selection.main.head, 8);
    });

    test('returns null on last line', () {
      final state = EditorState.create(
        docString: 'only one line',
        selection: EditorSelection.cursor(0),
      );
      expect(EditorCommands.cursorLineDown(state), isNull);
    });
  });

  group('cursorLineUp', () {
    test('moves to previous line same column', () {
      // "abc\ndef" — cursor at offset 5 (line 2, col 1).
      final state = EditorState.create(
        docString: 'abc\ndef',
        selection: EditorSelection.cursor(5),
      );
      final spec = EditorCommands.cursorLineUp(state)!;
      final next = apply(state, spec);
      // Line 1 "abc" starts at 0; col 1 → offset 1.
      expect(next.selection.main.head, 1);
    });

    test('returns null on first line', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(2),
      );
      expect(EditorCommands.cursorLineUp(state), isNull);
    });

    test('clamps column to previous line length', () {
      // "hi\nhello" — cursor at col 4 on line 2.
      final state = EditorState.create(
        docString: 'hi\nhello',
        selection: EditorSelection.cursor(7), // line 2 "hello", col 4
      );
      final spec = EditorCommands.cursorLineUp(state)!;
      final next = apply(state, spec);
      // Line 1 "hi" has length 2; col 4 clamps to 2 → offset 2.
      expect(next.selection.main.head, 2);
    });
  });

  group('cursorLineStart', () {
    test('moves to start of current line', () {
      final state = EditorState.create(
        docString: 'abc\ndef',
        selection: EditorSelection.cursor(6), // inside "def"
      );
      final spec = EditorCommands.cursorLineStart(state);
      expect(apply(state, spec).selection.main.head, 4); // "def" starts at 4
    });

    test('stays at start if already at line start', () {
      final state = EditorState.create(
        docString: 'abc\ndef',
        selection: EditorSelection.cursor(4),
      );
      final spec = EditorCommands.cursorLineStart(state);
      expect(apply(state, spec).selection.main.head, 4);
    });
  });

  group('cursorLineEnd', () {
    test('moves to end of current line', () {
      final state = EditorState.create(
        docString: 'abc\ndef',
        selection: EditorSelection.cursor(1), // inside "abc"
      );
      final spec = EditorCommands.cursorLineEnd(state);
      expect(apply(state, spec).selection.main.head, 3); // "abc" ends at 3
    });

    test('works on last line without trailing newline', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(0),
      );
      final spec = EditorCommands.cursorLineEnd(state);
      expect(apply(state, spec).selection.main.head, 5);
    });
  });

  group('cursorDocStart', () {
    test('moves to offset 0', () {
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.cursor(6),
      );
      final spec = EditorCommands.cursorDocStart(state);
      expect(apply(state, spec).selection.main.head, 0);
    });
  });

  group('cursorDocEnd', () {
    test('moves to document length', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(0),
      );
      final spec = EditorCommands.cursorDocEnd(state);
      expect(apply(state, spec).selection.main.head, 5);
    });
  });

  group('selectCharRight', () {
    test('extends selection to the right', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(2),
      );
      final spec = EditorCommands.selectCharRight(state)!;
      final next = apply(state, spec);
      expect(next.selection.main.anchor, 2);
      expect(next.selection.main.head, 3);
    });

    test('returns null at document end', () {
      final state = EditorState.create(
        docString: 'hi',
        selection: EditorSelection.cursor(2),
      );
      expect(EditorCommands.selectCharRight(state), isNull);
    });

    test('extends existing selection further right', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.single(anchor: 1, head: 3),
      );
      final spec = EditorCommands.selectCharRight(state)!;
      final next = apply(state, spec);
      expect(next.selection.main.anchor, 1);
      expect(next.selection.main.head, 4);
    });
  });

  group('selectCharLeft', () {
    test('extends selection to the left', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.single(anchor: 3, head: 3),
      );
      final spec = EditorCommands.selectCharLeft(state)!;
      final next = apply(state, spec);
      expect(next.selection.main.anchor, 3);
      expect(next.selection.main.head, 2);
    });

    test('returns null at document start', () {
      final state = EditorState.create(docString: 'hello');
      expect(EditorCommands.selectCharLeft(state), isNull);
    });
  });

  group('selectAll', () {
    test('selects entire document', () {
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.cursor(3),
      );
      final spec = EditorCommands.selectAll(state);
      final next = apply(state, spec);
      expect(next.selection.main.anchor, 0);
      expect(next.selection.main.head, 11);
    });

    test('works on empty document', () {
      final state = EditorState.create();
      final spec = EditorCommands.selectAll(state);
      final next = apply(state, spec);
      expect(next.selection.main.anchor, 0);
      expect(next.selection.main.head, 0);
    });
  });

  group('insertText', () {
    test('inserts at cursor position', () {
      final state = EditorState.create(
        docString: 'helo',
        selection: EditorSelection.cursor(3),
      );
      final spec = EditorCommands.insertText(state, 'l');
      final next = apply(state, spec);
      expect(next.doc.toString(), 'hello');
      expect(next.selection.main.head, 4);
    });

    test('replaces selection with text', () {
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.single(anchor: 6, head: 11),
      );
      final spec = EditorCommands.insertText(state, 'dart');
      final next = apply(state, spec);
      expect(next.doc.toString(), 'hello dart');
      expect(next.selection.main.head, 10);
    });

    test('cursor placed after inserted text', () {
      final state = EditorState.create(
        docString: 'ab',
        selection: EditorSelection.cursor(1),
      );
      final spec = EditorCommands.insertText(state, 'XYZ');
      final next = apply(state, spec);
      expect(next.doc.toString(), 'aXYZb');
      expect(next.selection.main.head, 4);
    });
  });

  group('insertNewline', () {
    test('inserts newline character', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(5),
      );
      final spec = EditorCommands.insertNewline(state);
      final next = apply(state, spec);
      expect(next.doc.toString(), 'hello\n');
      expect(next.selection.main.head, 6);
    });
  });

  group('insertTab', () {
    test('inserts two spaces', () {
      final state = EditorState.create(
        docString: 'x',
        selection: EditorSelection.cursor(0),
      );
      final spec = EditorCommands.insertTab(state);
      final next = apply(state, spec);
      expect(next.doc.toString(), '  x');
      expect(next.selection.main.head, 2);
    });
  });

  group('deleteCharBackward', () {
    test('deletes character before cursor', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(3),
      );
      final spec = EditorCommands.deleteCharBackward(state)!;
      final next = apply(state, spec);
      expect(next.doc.toString(), 'helo');
      expect(next.selection.main.head, 2);
    });

    test('returns null at document start', () {
      final state = EditorState.create(docString: 'hello');
      expect(EditorCommands.deleteCharBackward(state), isNull);
    });

    test('deletes selection if active', () {
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.single(anchor: 5, head: 11),
      );
      final spec = EditorCommands.deleteCharBackward(state)!;
      final next = apply(state, spec);
      expect(next.doc.toString(), 'hello');
      expect(next.selection.main.head, 5);
    });
  });

  group('deleteCharForward', () {
    test('deletes character after cursor', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(2),
      );
      final spec = EditorCommands.deleteCharForward(state)!;
      final next = apply(state, spec);
      expect(next.doc.toString(), 'helo');
      expect(next.selection.main.head, 2);
    });

    test('returns null at document end', () {
      final state = EditorState.create(
        docString: 'hi',
        selection: EditorSelection.cursor(2),
      );
      expect(EditorCommands.deleteCharForward(state), isNull);
    });

    test('deletes selection if active', () {
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.single(anchor: 0, head: 6),
      );
      final spec = EditorCommands.deleteCharForward(state)!;
      final next = apply(state, spec);
      expect(next.doc.toString(), 'world');
    });
  });

  group('deleteSelection', () {
    test('deletes selected range', () {
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.single(anchor: 5, head: 11),
      );
      final spec = EditorCommands.deleteSelection(state)!;
      final next = apply(state, spec);
      expect(next.doc.toString(), 'hello');
      expect(next.selection.main.head, 5);
    });

    test('returns null for empty selection', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(3),
      );
      expect(EditorCommands.deleteSelection(state), isNull);
    });

    test('cursor placed at start of deleted range', () {
      final state = EditorState.create(
        docString: 'abcde',
        selection: EditorSelection.single(anchor: 1, head: 4),
      );
      final spec = EditorCommands.deleteSelection(state)!;
      final next = apply(state, spec);
      expect(next.doc.toString(), 'ae');
      expect(next.selection.main.head, 1);
    });
  });
}
