import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  setUpAll(() => TreeSitterRuntime.ensureInitialized(
      languages: {'java', 'kotlin', 'php', 'ruby', 'erlang', 'swift', 'zig'}));
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
    'php': '<?php function hello() { \$x = 42; return "world"; } // comment',
    'ruby': 'def hello\n  x = 42\n  "world"\nend  # comment',
    'erlang': 'hello() -> 42.  % comment',
    'swift': 'func main() { let x: Int = 42; print("hello") } // comment',
    'zig': 'pub fn main() void { const x: u32 = 42; } // comment',
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
