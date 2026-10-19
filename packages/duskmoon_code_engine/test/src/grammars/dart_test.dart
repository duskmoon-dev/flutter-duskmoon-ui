import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() => TreeSitterRuntime.ensureInitialized(languages: {'dart'}));
  test('Dart query captures keywords, function declarations and class types',
      () {
    const source = 'class Greeter { String greet() { return "hello"; } }';
    final controller =
        EditorViewController(text: source, language: dartLanguageSupport());
    addTearDown(controller.dispose);
    final tree = syntaxTree(controller.state)!;
    expect(tree.rootNode.hasError, isFalse);
    final captures = tree.captures;
    expect(
        captures.any((c) =>
            c.name.startsWith('keyword') &&
            source.substring(c.from, c.to) == 'class'),
        isTrue);
    expect(
        captures.any((c) =>
            c.name.startsWith('function') &&
            source.substring(c.from, c.to) == 'greet'),
        isTrue);
    expect(
        captures.any((c) =>
            c.name.startsWith('type') &&
            source.substring(c.from, c.to) == 'Greeter'),
        isTrue);
  });

  test('Dart registration retains extension and MIME metadata', () {
    dartLanguageSupport();
    expect(LanguageRegistry.byExtension('dart')?.language.name, 'dart');
    expect(
        LanguageRegistry.byMimeType('application/dart')?.language.name, 'dart');
  });
}
