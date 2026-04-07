import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

EditorState _apply(EditorState state, TransactionSpec spec) =>
    state.applyTransaction(state.update(spec));

void main() {
  // ---------------------------------------------------------------------------
  // getSelectedText
  // ---------------------------------------------------------------------------
  group('ClipboardCommands.getSelectedText', () {
    test('returns selected text when selection is non-empty', () {
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.single(anchor: 0, head: 5),
      );
      expect(ClipboardCommands.getSelectedText(state), 'hello');
    });

    test('returns empty string when selection is a cursor', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(3),
      );
      expect(ClipboardCommands.getSelectedText(state), '');
    });

    test('works with reversed selection (head < anchor)', () {
      // anchor=5, head=0 → from=0, to=5
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.single(anchor: 5, head: 0),
      );
      expect(ClipboardCommands.getSelectedText(state), 'hello');
    });
  });

  // ---------------------------------------------------------------------------
  // cutSpec
  // ---------------------------------------------------------------------------
  group('ClipboardCommands.cutSpec', () {
    test('returns null when selection is a cursor', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(3),
      );
      expect(ClipboardCommands.cutSpec(state), isNull);
    });

    test('deletes the selected range', () {
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.single(anchor: 0, head: 5),
      );
      final spec = ClipboardCommands.cutSpec(state);
      expect(spec, isNotNull);
      final next = _apply(state, spec!);
      expect(next.doc.toString(), ' world');
    });

    test('places cursor at start of deleted range', () {
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.single(anchor: 0, head: 5),
      );
      final spec = ClipboardCommands.cutSpec(state);
      expect(spec, isNotNull);
      final next = _apply(state, spec!);
      expect(next.selection.main.head, 0);
      expect(next.selection.main.isEmpty, isTrue);
    });

    test('deletes selection with reversed anchor/head', () {
      // anchor=7, head=2 → from=2, to=7, deletes "llo w" → "he" + "orld"
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.single(anchor: 7, head: 2),
      );
      final spec = ClipboardCommands.cutSpec(state);
      expect(spec, isNotNull);
      final next = _apply(state, spec!);
      expect(next.doc.toString(), 'heorld');
    });
  });

  // ---------------------------------------------------------------------------
  // pasteSpec
  // ---------------------------------------------------------------------------
  group('ClipboardCommands.pasteSpec', () {
    test('inserts text at cursor position', () {
      final state = EditorState.create(
        docString: 'helo',
        selection: EditorSelection.cursor(3),
      );
      final spec = ClipboardCommands.pasteSpec(state, 'l');
      final next = _apply(state, spec);
      expect(next.doc.toString(), 'hello');
    });

    test('places cursor after inserted text', () {
      final state = EditorState.create(
        docString: 'helo',
        selection: EditorSelection.cursor(3),
      );
      final spec = ClipboardCommands.pasteSpec(state, 'l');
      final next = _apply(state, spec);
      expect(next.selection.main.head, 4);
      expect(next.selection.main.isEmpty, isTrue);
    });

    test('replaces selected text with pasted content', () {
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.single(anchor: 6, head: 11),
      );
      final spec = ClipboardCommands.pasteSpec(state, 'dart');
      final next = _apply(state, spec);
      expect(next.doc.toString(), 'hello dart');
    });

    test('cursor placed after replacement', () {
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.single(anchor: 6, head: 11),
      );
      final spec = ClipboardCommands.pasteSpec(state, 'dart');
      final next = _apply(state, spec);
      expect(next.selection.main.head, 10); // 'hello ' (6) + 'dart' (4)
    });

    test('inserts multi-line text', () {
      final state = EditorState.create(
        docString: 'ab',
        selection: EditorSelection.cursor(1),
      );
      final spec = ClipboardCommands.pasteSpec(state, 'X\nY');
      final next = _apply(state, spec);
      expect(next.doc.toString(), 'aX\nYb');
    });
  });
}
