import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('InputHandler', () {
    test('currentTextEditingValue reflects initial state', () {
      final state = EditorState.create(docString: 'hello world');
      final view = EditorView(state: state);
      final handler = InputHandler(view);

      final value = handler.currentTextEditingValue!;
      expect(value.text, 'hello world');
      expect(value.selection.baseOffset, 0);
      expect(value.selection.extentOffset, 0);
    });

    test('currentTextEditingValue reflects cursor position', () {
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.cursor(5),
      );
      final view = EditorView(state: state);
      final handler = InputHandler(view);

      final value = handler.currentTextEditingValue!;
      expect(value.selection.baseOffset, 5);
      expect(value.selection.extentOffset, 5);
    });

    group('updateEditingValue — insertion', () {
      test('typing X at position 5 inserts into doc', () {
        final state = EditorState.create(
          docString: 'hello world',
          selection: EditorSelection.cursor(5),
        );
        final view = EditorView(state: state);
        final handler = InputHandler(view);

        // Simulate typing 'X' at position 5: 'hello' + 'X' + ' world'
        const newValue = TextEditingValue(
          text: 'helloX world',
          selection: TextSelection.collapsed(offset: 6),
        );
        handler.updateEditingValue(newValue);

        expect(view.state.doc.toString(), 'helloX world');
        expect(view.state.selection.main.head, 6);
      });

      test('inserting at the start of the document', () {
        final state = EditorState.create(docString: 'hello');
        final view = EditorView(state: state);
        final handler = InputHandler(view);

        const newValue = TextEditingValue(
          text: 'Ahello',
          selection: TextSelection.collapsed(offset: 1),
        );
        handler.updateEditingValue(newValue);

        expect(view.state.doc.toString(), 'Ahello');
      });
    });

    group('updateEditingValue — deletion', () {
      test('deleting character at position 4 (backspace)', () {
        final state = EditorState.create(
          docString: 'hello world',
          selection: EditorSelection.cursor(5),
        );
        final view = EditorView(state: state);
        final handler = InputHandler(view);

        // Remove 'o' (index 4): 'hell world'
        const newValue = TextEditingValue(
          text: 'hell world',
          selection: TextSelection.collapsed(offset: 4),
        );
        handler.updateEditingValue(newValue);

        expect(view.state.doc.toString(), 'hell world');
        expect(view.state.selection.main.head, 4);
      });

      test('deleting last character', () {
        final state = EditorState.create(
          docString: 'hello',
          selection: EditorSelection.cursor(5),
        );
        final view = EditorView(state: state);
        final handler = InputHandler(view);

        const newValue = TextEditingValue(
          text: 'hell',
          selection: TextSelection.collapsed(offset: 4),
        );
        handler.updateEditingValue(newValue);

        expect(view.state.doc.toString(), 'hell');
      });
    });

    group('updateEditingValue — replacement', () {
      test('select and replace a range', () {
        final state = EditorState.create(
          docString: 'hello world',
          selection: EditorSelection.single(anchor: 6, head: 11),
        );
        final view = EditorView(state: state);
        final handler = InputHandler(view);

        // Replace 'world' with 'Dart'
        const newValue = TextEditingValue(
          text: 'hello Dart',
          selection: TextSelection.collapsed(offset: 10),
        );
        handler.updateEditingValue(newValue);

        expect(view.state.doc.toString(), 'hello Dart');
        expect(view.state.selection.main.head, 10);
      });

      test('replace entire document', () {
        final state = EditorState.create(
          docString: 'old text',
          selection: EditorSelection.single(anchor: 0, head: 8),
        );
        final view = EditorView(state: state);
        final handler = InputHandler(view);

        const newValue = TextEditingValue(
          text: 'new',
          selection: TextSelection.collapsed(offset: 3),
        );
        handler.updateEditingValue(newValue);

        expect(view.state.doc.toString(), 'new');
      });
    });

    group('updateEditingValue — selection only', () {
      test('same text, different selection updates cursor', () {
        final state = EditorState.create(
          docString: 'hello world',
          selection: EditorSelection.cursor(0),
        );
        final view = EditorView(state: state);
        final handler = InputHandler(view);

        const newValue = TextEditingValue(
          text: 'hello world',
          selection: TextSelection.collapsed(offset: 5),
        );
        handler.updateEditingValue(newValue);

        expect(view.state.doc.toString(), 'hello world'); // unchanged
        expect(view.state.selection.main.head, 5);
      });
    });

    test('detached handlers reject queued text and selection updates', () {
      final view = EditorView(state: EditorState.create(docString: 'snapshot'));
      addTearDown(view.dispose);
      final handler = InputHandler(view);
      handler.detach();
      handler.updateEditingValue(const TextEditingValue(
        text: 'queued',
        selection: TextSelection.collapsed(offset: 6),
      ));
      expect(view.state.doc.toString(), 'snapshot');
      handler.updateEditingValue(const TextEditingValue(
        text: 'snapshot',
        selection: TextSelection.collapsed(offset: 5),
      ));
      expect(view.state.doc.toString(), 'snapshot');
      expect(view.state.selection.main.head, 0);
    });

    test('closed handlers reject queued edits', () {
      final view = EditorView(state: EditorState.create(docString: 'snapshot'));
      addTearDown(view.dispose);
      final handler = InputHandler(view);
      handler.connectionClosed();
      handler.updateEditingValue(const TextEditingValue(text: 'queued'));
      expect(view.state.doc.toString(), 'snapshot');
    });

    testWidgets('attach reuses the connection and can resume after detach',
        (tester) async {
      final view = EditorView(state: EditorState.create(docString: 'snapshot'));
      final handler = InputHandler(view);
      addTearDown(() {
        handler.detach();
        view.dispose();
      });
      handler.attach();
      await tester.pump();
      expect(tester.testTextInput.isVisible, isTrue);
      tester.testTextInput.hide();
      handler.attach();
      await tester.pump();
      expect(tester.testTextInput.isVisible, isTrue);
      expect(
          tester.testTextInput.log
              .where((call) => call.method == 'TextInput.setClient'),
          hasLength(1));
      handler.detach();
      await tester.pump();
      handler.attach();
      tester.testTextInput.enterText('resumed');
      await tester.pump();
      expect(view.state.doc.toString(), 'resumed');
    });

    test('connectionClosed does not throw', () {
      final state = EditorState.create(docString: 'hello');
      final view = EditorView(state: state);
      final handler = InputHandler(view);

      // Should not throw even without attach() being called first.
      expect(() => handler.connectionClosed(), returnsNormally);
    });

    test('performAction does not throw', () {
      final state = EditorState.create(docString: 'hello');
      final view = EditorView(state: state);
      final handler = InputHandler(view);

      expect(
        () => handler.performAction(TextInputAction.newline),
        returnsNormally,
      );
    });
  });
}
