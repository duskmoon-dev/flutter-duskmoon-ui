import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('edits made during parser initialization retain history and selection',
      () async {
    final controller = EditorViewController(
        text: '{"value": 1}',
        language: jsonLanguageSupport(),
        extensions: [historyExtension()]);
    addTearDown(controller.dispose);
    final view = controller.view;
    controller.replaceRange(10, 11, '2');
    controller.setSelection(EditorSelection.cursor(4));
    await controller.ready;
    expect(controller.view, same(view));
    expect(controller.text, '{"value": 2}');
    expect(controller.state.selection.main.head, 4);
    expect(syntaxTree(controller.state)!.source, '{"value": 2}');
    expect(syntaxTree(controller.state)!.rootNode.hasError, isFalse);
    controller.dispatch(EditorCommands.undo(controller.state)!);
    expect(controller.text, '{"value": 1}');
  });

  test('language supplied through extensions initializes automatically',
      () async {
    final controller = EditorViewController(
        text: '42', extensions: [jsonLanguageSupport().extension]);
    addTearDown(controller.dispose);
    await controller.ready;
    expect(syntaxTree(controller.state)!.language, 'json');
    expect(syntaxTree(controller.state)!.source, '42');
  });

  test('cold language switches cannot restore stale parser results', () async {
    final controller =
        EditorViewController(text: '42', language: jsonLanguageSupport());
    addTearDown(controller.dispose);
    final first = controller.ready;
    controller.language = pythonLanguageSupport();
    final second = controller.ready;
    controller.language = javascriptLanguageSupport();
    controller.text = 'const value = 42;';
    await Future.wait([first, second, controller.ready]);
    expect(controller.text, 'const value = 42;');
    expect(syntaxTree(controller.state)!.language, 'javascript');
    expect(syntaxTree(controller.state)!.rootNode.hasError, isFalse);
  });

  test(
      'disposing while initialization is pending suppresses completion notifications',
      () async {
    final controller =
        EditorViewController(text: '42', language: jsonLanguageSupport());
    var notifications = 0;
    controller.view.addListener(() => notifications++);
    final ready = controller.ready;
    controller.dispose();
    await ready;
    expect(notifications, 0);
  });
}
