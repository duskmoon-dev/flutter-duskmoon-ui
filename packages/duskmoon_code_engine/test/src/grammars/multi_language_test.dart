import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  setUpAll(() => TreeSitterRuntime.ensureInitialized(languages: {
        'javascript',
        'python',
        'html',
        'css',
        'markdown',
        'rust',
        'go',
        'yaml',
        'c',
        'elixir'
      }));
  setUp(() => LanguageRegistry.clear());

  final grammars = <String, LanguageSupport Function()>{
    'javascript': javascriptLanguageSupport,
    'python': pythonLanguageSupport,
    'html': htmlLanguageSupport,
    'css': cssLanguageSupport,
    'markdown': markdownLanguageSupport,
    'rust': rustLanguageSupport,
    'go': goLanguageSupport,
    'yaml': yamlLanguageSupport,
    'c': cLanguageSupport,
    'elixir': elixirLanguageSupport,
  };

  const sampleCode = <String, String>{
    'javascript': 'function hello() { return "world"; } // comment',
    'python': 'def hello():\n    return "world"  # comment',
    'html': '<div class="hello">world</div>',
    'css': '.hello { color: red; } /* comment */',
    'markdown': '# Hello\n\nSome **bold** text',
    'rust': 'fn main() { let x: i32 = 42; } // comment',
    'go': 'func main() { x := 42 } // comment',
    'yaml': 'key: value\nlist:\n  - item  # comment',
    'c': 'int main() { int x = 42; return 0; } // comment',
    'elixir': 'defmodule Foo do\n  def bar, do: "hello"\nend  # comment',
  };

  for (final entry in grammars.entries) {
    test('${entry.key} uses its real grammar and query captures', () {
      final controller = EditorViewController(
          text: sampleCode[entry.key], language: entry.value());
      addTearDown(controller.dispose);
      final tree = syntaxTree(controller.state)!;
      expect(tree.language, entry.key);
      expect(tree.rootNode.children, isNotEmpty);
      expect(tree.rootNode.to, controller.text.length);
      expect(tree.captures, isNotEmpty);
    });
    test('${entry.key} preserves comment metadata', () {
      final ct = entry.value().language.data.commentTokens;
      if (entry.key == 'markdown') return;
      expect(ct?.line != null || ct?.block != null, isTrue);
    });
  }
}
