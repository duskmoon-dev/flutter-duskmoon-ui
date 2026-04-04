import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  late Keymap keymap;

  setUp(() {
    keymap = defaultKeymap();
  });

  group('defaultKeymap — cursor movement', () {
    test('has binding for ArrowRight', () {
      final b = keymap.resolve(LogicalKeyboardKey.arrowRight, false, false, false);
      expect(b, isNotNull);
      expect(b!.run, isNotNull);
    });

    test('has binding for ArrowLeft', () {
      final b = keymap.resolve(LogicalKeyboardKey.arrowLeft, false, false, false);
      expect(b, isNotNull);
      expect(b!.run, isNotNull);
    });

    test('has binding for ArrowDown', () {
      final b = keymap.resolve(LogicalKeyboardKey.arrowDown, false, false, false);
      expect(b, isNotNull);
      expect(b!.run, isNotNull);
    });

    test('has binding for ArrowUp', () {
      final b = keymap.resolve(LogicalKeyboardKey.arrowUp, false, false, false);
      expect(b, isNotNull);
      expect(b!.run, isNotNull);
    });

    test('has binding for Home', () {
      final b = keymap.resolve(LogicalKeyboardKey.home, false, false, false);
      expect(b, isNotNull);
      expect(b!.run, isNotNull);
    });

    test('has binding for End', () {
      final b = keymap.resolve(LogicalKeyboardKey.end, false, false, false);
      expect(b, isNotNull);
      expect(b!.run, isNotNull);
    });

    test('has binding for Ctrl-Home (doc start)', () {
      final b = keymap.resolve(LogicalKeyboardKey.home, true, false, false);
      expect(b, isNotNull);
      expect(b!.run, isNotNull);
    });

    test('has binding for Ctrl-End (doc end)', () {
      final b = keymap.resolve(LogicalKeyboardKey.end, true, false, false);
      expect(b, isNotNull);
      expect(b!.run, isNotNull);
    });
  });

  group('defaultKeymap — selection', () {
    test('has binding for Shift-ArrowRight', () {
      final b = keymap.resolve(LogicalKeyboardKey.arrowRight, false, true, false);
      expect(b, isNotNull);
      expect(b!.run, isNotNull);
    });

    test('has binding for Shift-ArrowLeft', () {
      final b = keymap.resolve(LogicalKeyboardKey.arrowLeft, false, true, false);
      expect(b, isNotNull);
      expect(b!.run, isNotNull);
    });

    test('has binding for Ctrl-a (select all)', () {
      final b = keymap.resolve(LogicalKeyboardKey.keyA, true, false, false);
      expect(b, isNotNull);
      expect(b!.run, isNotNull);
    });
  });

  group('defaultKeymap — editing', () {
    test('has binding for Backspace', () {
      final b = keymap.resolve(LogicalKeyboardKey.backspace, false, false, false);
      expect(b, isNotNull);
      expect(b!.run, isNotNull);
    });

    test('has binding for Delete', () {
      final b = keymap.resolve(LogicalKeyboardKey.delete, false, false, false);
      expect(b, isNotNull);
      expect(b!.run, isNotNull);
    });

    test('has binding for Enter', () {
      final b = keymap.resolve(LogicalKeyboardKey.enter, false, false, false);
      expect(b, isNotNull);
      expect(b!.run, isNotNull);
    });

    test('has binding for Tab', () {
      final b = keymap.resolve(LogicalKeyboardKey.tab, false, false, false);
      expect(b, isNotNull);
      expect(b!.run, isNotNull);
    });
  });

  group('defaultKeymap — undo/redo', () {
    test('has binding for Ctrl-z (undo)', () {
      final b = keymap.resolve(LogicalKeyboardKey.keyZ, true, false, false);
      expect(b, isNotNull);
      expect(b!.run, isNotNull);
    });

    test('has binding for Ctrl-Shift-z (redo)', () {
      final b = keymap.resolve(LogicalKeyboardKey.keyZ, true, true, false);
      expect(b, isNotNull);
      expect(b!.run, isNotNull);
    });
  });

  group('defaultKeymap — command execution', () {
    test('ArrowRight command moves cursor and returns true', () {
      final state = EditorState.create(docString: 'hello world');
      final view = EditorView(state: state);
      final binding = keymap.resolve(LogicalKeyboardKey.arrowRight, false, false, false)!;
      final result = binding.run!(view);
      expect(result, isTrue);
      expect(view.state.selection.main.head, 1);
    });

    test('ArrowRight at doc end returns false', () {
      final state = EditorState.create(
        docString: 'hi',
        selection: EditorSelection.cursor(2),
      );
      final view = EditorView(state: state);
      final binding = keymap.resolve(LogicalKeyboardKey.arrowRight, false, false, false)!;
      final result = binding.run!(view);
      expect(result, isFalse);
      expect(view.state.selection.main.head, 2); // unchanged
    });

    test('Enter command inserts newline and returns true', () {
      final state = EditorState.create(docString: 'hello');
      final view = EditorView(state: state);
      final binding = keymap.resolve(LogicalKeyboardKey.enter, false, false, false)!;
      final result = binding.run!(view);
      expect(result, isTrue);
      expect(view.state.doc.toString(), '\nhello');
    });

    test('Ctrl-a selects all and returns true', () {
      final state = EditorState.create(docString: 'hello world');
      final view = EditorView(state: state);
      final binding = keymap.resolve(LogicalKeyboardKey.keyA, true, false, false)!;
      final result = binding.run!(view);
      expect(result, isTrue);
      expect(view.state.selection.main.from, 0);
      expect(view.state.selection.main.to, 11);
    });

    test('Tab command inserts two spaces and returns true', () {
      final state = EditorState.create(docString: 'hello');
      final view = EditorView(state: state);
      final binding = keymap.resolve(LogicalKeyboardKey.tab, false, false, false)!;
      final result = binding.run!(view);
      expect(result, isTrue);
      expect(view.state.doc.toString(), '  hello');
    });
  });
}
