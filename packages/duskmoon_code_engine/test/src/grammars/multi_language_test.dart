import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
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
    group(entry.key, () {
      test('registers by name', () {
        entry.value();
        expect(LanguageRegistry.byName(entry.key), isNotNull);
      });

      test('parses sample code', () {
        final support = entry.value();
        final state = EditorState.create(
          docString: sampleCode[entry.key]!,
          extensions: [support.extension],
        );
        final tree = syntaxTree(state);
        expect(tree, isNotNull);
        expect(tree!.type.isTop, true);
        expect(tree.children, isNotEmpty);
      });

      test('has comment tokens', () {
        final support = entry.value();
        final ct = support.language.data.commentTokens;
        if (entry.key == 'markdown') {
          // Markdown may not have comment tokens
          return;
        }
        expect(ct?.line != null || ct?.block != null, true,
            reason: '${entry.key} needs comment tokens');
      });
    });
  }
}
