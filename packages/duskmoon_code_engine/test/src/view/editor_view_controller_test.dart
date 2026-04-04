import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:test/test.dart';

void main() {
  group('EditorViewController', () {
    test('creates with initial text – text getter returns it', () {
      final ctrl = EditorViewController(text: 'hello');
      expect(ctrl.text, 'hello');
      ctrl.dispose();
    });

    test('creates empty by default', () {
      final ctrl = EditorViewController();
      expect(ctrl.text, '');
      ctrl.dispose();
    });

    test('text setter replaces document', () {
      final ctrl = EditorViewController(text: 'old');
      ctrl.text = 'new content';
      expect(ctrl.text, 'new content');
      ctrl.dispose();
    });

    test('state is accessible – state.doc.length matches text length', () {
      const content = 'hello world';
      final ctrl = EditorViewController(text: content);
      expect(ctrl.state.doc.length, content.length);
      ctrl.dispose();
    });

    test('dispatch applies transaction – insert via ChangeSet', () {
      final ctrl = EditorViewController(text: 'hello');
      ctrl.dispatch(
        TransactionSpec(
          changes: ChangeSet.of(
            ctrl.document.length,
            [const ChangeSpec(from: 5, to: 5, insert: ' world')],
          ),
        ),
      );
      expect(ctrl.text, 'hello world');
      ctrl.dispose();
    });

    test('insertText inserts at cursor', () {
      final ctrl = EditorViewController(text: 'helo');
      // Move cursor to position 3 (before the trailing 'o').
      ctrl.setSelection(EditorSelection.cursor(3));
      ctrl.insertText('l');
      expect(ctrl.text, 'hello');
      ctrl.dispose();
    });

    test('replaceRange replaces text range', () {
      final ctrl = EditorViewController(text: 'hello world');
      ctrl.replaceRange(6, 11, 'dart');
      expect(ctrl.text, 'hello dart');
      ctrl.dispose();
    });

    test('setSelection updates selection', () {
      final ctrl = EditorViewController(text: 'hello');
      ctrl.setSelection(EditorSelection.cursor(3));
      expect(ctrl.state.selection.main.head, 3);
      ctrl.dispose();
    });

    test('document getter returns current document', () {
      final ctrl = EditorViewController(text: 'abc');
      expect(ctrl.document, isA<Document>());
      expect(ctrl.document.toString(), 'abc');
      ctrl.dispose();
    });

    test('language setter updates language – syntaxTree is non-null', () {
      final ctrl = EditorViewController(text: '{"key": "value"}');
      ctrl.language = jsonLanguageSupport();
      expect(syntaxTree(ctrl.state), isNotNull);
      ctrl.dispose();
    });
  });
}
