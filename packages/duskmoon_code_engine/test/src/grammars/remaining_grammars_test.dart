import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  setUp(() => LanguageRegistry.clear());

  final grammars = <String, LanguageSupport Function()>{
    'java': javaLanguageSupport,
    'kotlin': kotlinLanguageSupport,
    'php': phpLanguageSupport,
    'ruby': rubyLanguageSupport,
    'erlang': erlangLanguageSupport,
    'swift': swiftLanguageSupport,
    'zig': zigLanguageSupport,
  };

  const sampleCode = <String, String>{
    'java':
        'public class Main { public static void main(String[] args) { int x = 42; } } // comment',
    'kotlin': 'fun main() { val x: Int = 42; println("hello") } // comment',
    'php': 'function hello() { \$x = 42; return "world"; } // comment',
    'ruby': 'def hello\n  x = 42\n  "world"\nend  # comment',
    'erlang': 'hello() -> 42.  % comment',
    'swift': 'func main() { let x: Int = 42; print("hello") } // comment',
    'zig': 'pub fn main() void { const x: u32 = 42; } // comment',
  };

  for (final entry in grammars.entries) {
    group(entry.key, () {
      test('registers by name', () {
        entry.value();
        expect(LanguageRegistry.byName(entry.key), isNotNull);
      });

      test('parses sample code with tokens', () {
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

      test('has comment tokens defined', () {
        final support = entry.value();
        final ct = support.language.data.commentTokens;
        expect(ct?.line != null || ct?.block != null, true);
      });

      test('cursor traversal finds tokens', () {
        final support = entry.value();
        final state = EditorState.create(
          docString: sampleCode[entry.key]!,
          extensions: [support.extension],
        );
        final tree = syntaxTree(state)!;
        final cursor = tree.cursor();
        final names = <String>{};
        if (cursor.firstChild()) {
          names.add(cursor.name);
          while (cursor.nextSibling()) {
            names.add(cursor.name);
          }
        }
        expect(names, isNotEmpty);
      });
    });
  }

  group('Full language inventory', () {
    test('all 19 languages register successfully', () {
      LanguageRegistry.clear();
      jsonLanguageSupport();
      dartLanguageSupport();
      javascriptLanguageSupport();
      pythonLanguageSupport();
      htmlLanguageSupport();
      cssLanguageSupport();
      markdownLanguageSupport();
      rustLanguageSupport();
      goLanguageSupport();
      yamlLanguageSupport();
      cLanguageSupport();
      elixirLanguageSupport();
      javaLanguageSupport();
      kotlinLanguageSupport();
      phpLanguageSupport();
      rubyLanguageSupport();
      erlangLanguageSupport();
      swiftLanguageSupport();
      zigLanguageSupport();
      expect(LanguageRegistry.names.length, 19);
    });

    test('spot-check file extensions', () {
      LanguageRegistry.clear();
      javaLanguageSupport();
      kotlinLanguageSupport();
      phpLanguageSupport();
      rubyLanguageSupport();
      erlangLanguageSupport();
      swiftLanguageSupport();
      zigLanguageSupport();
      expect(LanguageRegistry.byExtension('java'), isNotNull);
      expect(LanguageRegistry.byExtension('kt'), isNotNull);
      expect(LanguageRegistry.byExtension('php'), isNotNull);
      expect(LanguageRegistry.byExtension('rb'), isNotNull);
      expect(LanguageRegistry.byExtension('erl'), isNotNull);
      expect(LanguageRegistry.byExtension('swift'), isNotNull);
      expect(LanguageRegistry.byExtension('zig'), isNotNull);
    });
  });
}
