import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

Iterable<SyntaxNode> descendants(SyntaxNode node) sync* {
  yield node;
  for (final child in node.children) {
    yield* descendants(child);
  }
}

void main() {
  setUpAll(() => TreeSitterRuntime.ensureInitialized(languages: {'json'}));
  test('JSON builds genuine nested arrays/objects and recovers from errors',
      () {
    final controller = EditorViewController(
        text: '{"items": [{"id": 42}]}', language: jsonLanguageSupport());
    addTearDown(controller.dispose);
    final tree = syntaxTree(controller.state)!;
    expect(tree.rootNode.type, 'document');
    expect(
        descendants(tree.rootNode).where((n) => n.type == 'object').length, 2);
    expect(
        descendants(tree.rootNode).where((n) => n.type == 'array').length, 1);
    expect(tree.rootNode.hasError, isFalse);
    controller.text = '{"items": [}';
    expect(syntaxTree(controller.state)!.rootNode.hasError, isTrue);
    controller.text = '{"items": [42]}';
    expect(syntaxTree(controller.state)!.rootNode.hasError, isFalse);
    expect(syntaxTree(controller.state)!.incremental, isTrue);
  });
}
