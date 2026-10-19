import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() => TreeSitterRuntime.ensureInitialized(languages: {
        'javascript',
        'typescript',
        'tsx',
        'c',
        'cpp',
        'bash',
        'sql',
        'nix',
      }));

  final examples = <String, (LanguageSupport Function(), String)>{
    'typescript': (
      typescriptLanguageSupport,
      'type Point = { x: number }; const p: Point = {x: 1};'
    ),
    'tsx': (
      tsxLanguageSupport,
      'const view = <div className="hello">Hello</div>;'
    ),
    'javascript': (jsxLanguageSupport, 'const view = <div>Hello</div>;'),
    'cpp': (
      cppLanguageSupport,
      'template <typename T> T identity(T x) { return x; }'
    ),
    'c': (cLanguageSupport, 'int square(int n) { return n * n; }'),
  };
  for (final entry in examples.entries) {
    test('${entry.key} preserves genuine grammar variants', () {
      final controller = EditorViewController(
          text: entry.value.$2, language: entry.value.$1());
      addTearDown(controller.dispose);
      final tree = syntaxTree(controller.state)!;
      expect(tree.language, entry.key);
      expect(tree.rootNode.hasError, isFalse);
      expect(tree.captures, isNotEmpty);
    });
  }

  test('generic registry exposes bundled Bash, SQL and Nix grammars', () {
    const examples = {
      'bash': 'echo "hello"',
      'sql': 'SELECT name FROM users WHERE id = 42;',
      'nix': '{ pkgs }: { hello = pkgs.hello; }',
    };
    for (final entry in examples.entries) {
      final language = LanguageRegistry.byName(entry.key.toUpperCase());
      expect(language, isNotNull);
      final controller =
          EditorViewController(text: entry.value, language: language);
      addTearDown(controller.dispose);
      expect(syntaxTree(controller.state)!.language, entry.key);
      expect(syntaxTree(controller.state)!.rootNode.hasError, isFalse);
      expect(syntaxTree(controller.state)!.captures, isNotEmpty);
    }
  });
}
