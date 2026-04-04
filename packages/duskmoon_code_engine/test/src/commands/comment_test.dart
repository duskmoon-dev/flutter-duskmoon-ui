import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

/// Apply a [TransactionSpec] to [state] and return the resulting state.
EditorState _apply(EditorState state, TransactionSpec spec) {
  return state.applyTransaction(state.update(spec));
}

void main() {
  group('CommentCommands.toggleLineComment', () {
    test('adds comment to uncommented line', () {
      final state = EditorState.create(docString: 'hello');
      final spec = CommentCommands.toggleLineComment(state, '//');
      expect(spec, isNotNull);
      final next = _apply(state, spec!);
      expect(next.doc.toString(), '// hello');
    });

    test('removes comment from commented line (with space)', () {
      final state = EditorState.create(docString: '// hello');
      final spec = CommentCommands.toggleLineComment(state, '//');
      expect(spec, isNotNull);
      final next = _apply(state, spec!);
      expect(next.doc.toString(), 'hello');
    });

    test('removes comment without trailing space', () {
      final state = EditorState.create(docString: '//hello');
      final spec = CommentCommands.toggleLineComment(state, '//');
      expect(spec, isNotNull);
      final next = _apply(state, spec!);
      expect(next.doc.toString(), 'hello');
    });

    test('commenting empty line adds "// "', () {
      final state = EditorState.create(docString: '');
      final spec = CommentCommands.toggleLineComment(state, '//');
      expect(spec, isNotNull);
      final next = _apply(state, spec!);
      expect(next.doc.toString(), '// ');
    });

    test('preserves leading whitespace when adding comment', () {
      final state = EditorState.create(docString: '  hello');
      final spec = CommentCommands.toggleLineComment(state, '//');
      expect(spec, isNotNull);
      final next = _apply(state, spec!);
      expect(next.doc.toString(), '  // hello');
    });

    test('preserves leading whitespace when removing comment', () {
      final state = EditorState.create(docString: '  // hello');
      final spec = CommentCommands.toggleLineComment(state, '//');
      expect(spec, isNotNull);
      final next = _apply(state, spec!);
      expect(next.doc.toString(), '  hello');
    });

    test('works with # prefix (Python style)', () {
      final state = EditorState.create(docString: 'print("hi")');
      final spec = CommentCommands.toggleLineComment(state, '#');
      expect(spec, isNotNull);
      final next = _apply(state, spec!);
      expect(next.doc.toString(), '# print("hi")');
    });

    test('removes # prefix (Python style)', () {
      final state = EditorState.create(docString: '# print("hi")');
      final spec = CommentCommands.toggleLineComment(state, '#');
      expect(spec, isNotNull);
      final next = _apply(state, spec!);
      expect(next.doc.toString(), 'print("hi")');
    });

    test('returns null when lineCommentToken is null', () {
      final state = EditorState.create(docString: 'hello');
      expect(CommentCommands.toggleLineComment(state, null), isNull);
    });

    test('cursor position advances after adding comment', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(3),
      );
      final spec = CommentCommands.toggleLineComment(state, '//');
      expect(spec, isNotNull);
      final next = _apply(state, spec!);
      // '// ' is 3 chars → cursor moves from 3 to 6
      expect(next.selection.main.head, 6);
    });

    test('cursor position retreats after removing comment', () {
      final state = EditorState.create(
        docString: '// hello',
        selection: EditorSelection.cursor(6),
      );
      final spec = CommentCommands.toggleLineComment(state, '//');
      expect(spec, isNotNull);
      final next = _apply(state, spec!);
      // '// ' removed (3 chars) → cursor moves from 6 to 3
      expect(next.selection.main.head, 3);
    });
  });
}
