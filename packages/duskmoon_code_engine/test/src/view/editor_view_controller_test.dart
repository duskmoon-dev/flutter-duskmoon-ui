import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:test/test.dart';

void main() {
  setUpAll(() => TreeSitterRuntime.ensureInitialized(
      languages: {'json', 'javascript', 'python'}));
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

    test('language switching preserves listeners, history, text and selection',
        () async {
      final ctrl = EditorViewController(
          text: '{"key": 1}',
          language: jsonLanguageSupport(),
          extensions: [historyExtension()]);
      addTearDown(ctrl.dispose);
      final view = ctrl.view;
      var notifications = 0;
      view.addListener(() => notifications++);
      ctrl.setSelection(EditorSelection.cursor(ctrl.text.length));
      ctrl.insertText(' ');
      final old = syntaxTree(ctrl.state)!;
      final text = ctrl.text;
      final selection = ctrl.state.selection;
      ctrl.language = javascriptLanguageSupport();
      await ctrl.ready;
      expect(ctrl.view, same(view));
      expect(ctrl.text, text);
      expect(ctrl.state.selection, same(selection));
      expect(syntaxTree(ctrl.state)!.language, 'javascript');
      expect(old.language, 'json');
      expect(old.source, text);
      final undo = EditorCommands.undo(ctrl.state);
      expect(undo, isNotNull);
      ctrl.dispatch(undo!);
      expect(ctrl.text, '{"key": 1}');
      expect(notifications, greaterThanOrEqualTo(4));
    });

    test('language switching installs support facets and retains base fields',
        () {
      final facet = Facet<int, int>(
          combine: (values) => values.isEmpty ? 0 : values.last);
      final controller =
          EditorViewController(text: '42', extensions: [historyExtension()]);
      addTearDown(controller.dispose);
      controller.language = LanguageSupport(
          language: jsonLanguageSupport().language, support: [facet.of(42)]);
      expect(controller.state.facet(facet), 42);
      controller.text = '43';
      controller.language = null;
      expect(controller.state.facet(facet), 0);
      controller.dispatch(EditorCommands.undo(controller.state)!);
      expect(controller.text, '42');
      expect(syntaxTree(controller.state), isNull);
    });

    test('clearing a constructor language removes syntax without a fallback',
        () async {
      final ctrl =
          EditorViewController(text: '42', language: jsonLanguageSupport());
      addTearDown(ctrl.dispose);
      await ctrl.ready;
      expect(syntaxTree(ctrl.state)!.language, 'json');
      final document = ctrl.document;

      ctrl.language = null;
      await ctrl.ready;

      expect(ctrl.document, same(document));
      expect(syntaxTree(ctrl.state), isNull);
      ctrl.insertText(' ');
      expect(syntaxTree(ctrl.state), isNull);
    });

    test('clearing a constructor language restores its extension fallback',
        () async {
      final ctrl = EditorViewController(
          text: '42',
          language: jsonLanguageSupport(),
          extensions: [pythonLanguageSupport().extension]);
      addTearDown(ctrl.dispose);
      await ctrl.ready;
      expect(syntaxTree(ctrl.state)!.language, 'json');
      final document = ctrl.document;

      ctrl.language = null;
      await ctrl.ready;

      expect(ctrl.document, same(document));
      expect(syntaxTree(ctrl.state)!.language, 'python');
      expect(syntaxTree(ctrl.state)!.source, '42');
      ctrl.insertText(' ');
      expect(syntaxTree(ctrl.state)!.language, 'python');
      expect(syntaxTree(ctrl.state)!.source, ctrl.text);
    });

    test('rapid language changes and disposal are safe during initialization',
        () async {
      final ctrl =
          EditorViewController(text: '42', language: jsonLanguageSupport());
      ctrl.language = pythonLanguageSupport();
      final obsolete = ctrl.ready;
      ctrl.language = javascriptLanguageSupport();
      final current = ctrl.ready;
      ctrl.dispose();
      await Future.wait([obsolete, current]);
    });
  });
}
