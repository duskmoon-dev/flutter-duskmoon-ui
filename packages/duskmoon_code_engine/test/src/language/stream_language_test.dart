import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

/// Small test language used across all tests.
final _lang = StreamLanguage(
  name: 'test',
  rules: [
    TokenRule(RegExp(r'\b\d+\b'), 'Number'),
    TokenRule(RegExp(r'"[^"]*"'), 'String'),
    TokenRule(RegExp(r'\b(if|else|return)\b'), 'Keyword'),
    TokenRule(RegExp(r'//.*'), 'Comment'),
    TokenRule(RegExp(r'[a-zA-Z_]\w*'), 'Identifier'),
  ],
);

void main() {
  group('StreamLanguage', () {
    group('TokenRule', () {
      test('stores pattern and nodeName', () {
        final rule = TokenRule(RegExp(r'\d+'), 'Number');
        expect(rule.nodeName, equals('Number'));
        expect(rule.pattern.pattern, equals(r'\d+'));
      });
    });

    group('parse – empty input', () {
      test('returns top node with no children', () {
        final tree = _lang.parser.parse('');
        expect(tree.type.name, equals('test'));
        expect(tree.type.isTop, isTrue);
        expect(tree.children, isEmpty);
        expect(tree.length, equals(0));
      });
    });

    group('parse – single tokens', () {
      test('parses a number', () {
        final tree = _lang.parser.parse('42');
        expect(tree.children.length, equals(1));
        final child = tree.children.first as Tree;
        expect(child.type.name, equals('Number'));
        expect(child.length, equals(2));
        expect(tree.positions.first, equals(0));
      });

      test('parses a string literal', () {
        final tree = _lang.parser.parse('"hello"');
        expect(tree.children.length, equals(1));
        final child = tree.children.first as Tree;
        expect(child.type.name, equals('String'));
        expect(child.length, equals(7));
      });

      test('parses a keyword', () {
        final tree = _lang.parser.parse('if');
        expect(tree.children.length, equals(1));
        final child = tree.children.first as Tree;
        expect(child.type.name, equals('Keyword'));
      });

      test('parses a comment', () {
        final tree = _lang.parser.parse('// a comment');
        expect(tree.children.length, equals(1));
        final child = tree.children.first as Tree;
        expect(child.type.name, equals('Comment'));
        expect(child.length, equals(12));
      });

      test('parses an identifier', () {
        final tree = _lang.parser.parse('myVar');
        expect(tree.children.length, equals(1));
        final child = tree.children.first as Tree;
        expect(child.type.name, equals('Identifier'));
      });
    });

    group('parse – mixed tokens', () {
      test('produces multiple children of different types', () {
        const src = 'if x 42 "hi"';
        final tree = _lang.parser.parse(src);
        expect(tree.children.length, equals(4));
        final names = tree.children.map((c) => (c as Tree).type.name).toList();
        expect(names, equals(['Keyword', 'Identifier', 'Number', 'String']));
      });

      test('records correct start positions', () {
        const src = 'if x';
        final tree = _lang.parser.parse(src);
        expect(tree.positions[0], equals(0)); // "if"
        expect(tree.positions[1], equals(3)); // "x"
      });
    });

    group('parse – whitespace', () {
      test('skips spaces without creating whitespace nodes', () {
        final tree = _lang.parser.parse('   42   ');
        expect(tree.children.length, equals(1));
        final child = tree.children.first as Tree;
        expect(child.type.name, equals('Number'));
      });

      test('skips tabs and newlines', () {
        final tree = _lang.parser.parse('\t42\n');
        expect(tree.children.length, equals(1));
      });
    });

    group('parse – multi-line', () {
      test('handles multi-line input', () {
        const src = 'if x\n  return 0\n';
        final tree = _lang.parser.parse(src);
        // Tokens: if, x, return, 0
        expect(tree.children.length, equals(4));
        final names = tree.children.map((c) => (c as Tree).type.name).toList();
        expect(names, equals(['Keyword', 'Identifier', 'Keyword', 'Number']));
      });
    });

    group('parse – unrecognized characters', () {
      test('silently skips unrecognized chars', () {
        // '(' and ')' do not match any rule
        final tree = _lang.parser.parse('(42)');
        expect(tree.children.length, equals(1));
        final child = tree.children.first as Tree;
        expect(child.type.name, equals('Number'));
      });
    });

    group('parse – rule precedence (first match wins)', () {
      test('"if" matches Keyword before Identifier', () {
        final tree = _lang.parser.parse('if');
        expect(tree.children.length, equals(1));
        final child = tree.children.first as Tree;
        expect(child.type.name, equals('Keyword'));
      });

      test('"ifelse" is matched as Identifier (no word boundary)', () {
        final tree = _lang.parser.parse('ifelse');
        expect(tree.children.length, equals(1));
        final child = tree.children.first as Tree;
        // \b\d+\b and keyword regex won't match; identifier will
        expect(child.type.name, equals('Identifier'));
      });
    });

    group('top node properties', () {
      test('top node type has isTop == true', () {
        final tree = _lang.parser.parse('42');
        expect(tree.type.isTop, isTrue);
      });

      test('top node name equals language name', () {
        final tree = _lang.parser.parse('42');
        expect(tree.type.name, equals('test'));
      });

      test('tree length equals input length', () {
        const src = 'if x 42';
        final tree = _lang.parser.parse(src);
        expect(tree.length, equals(src.length));
      });
    });

    group('languageSupport', () {
      setUp(() => LanguageRegistry.clear());

      test('returns a LanguageSupport wrapping the correct Language', () {
        final support = _lang.languageSupport();
        expect(support.language.name, equals('test'));
        expect(support.language.parser, same(_lang.parser));
      });

      test('registers in LanguageRegistry by name', () {
        _lang.languageSupport();
        expect(LanguageRegistry.byName('test'), isNotNull);
      });

      test('registers extensions and mimeTypes', () {
        _lang.languageSupport(
          extensions: ['.tst'],
          mimeTypes: ['text/x-test'],
        );
        expect(LanguageRegistry.byExtension('.tst'), isNotNull);
        expect(LanguageRegistry.byMimeType('text/x-test'), isNotNull);
      });
    });

    group('integration with EditorState', () {
      setUp(() => LanguageRegistry.clear());

      test('syntaxTree returns non-null after attaching languageSupport', () {
        final support = _lang.languageSupport();
        final state = EditorState.create(
          docString: 'if x 42',
          extensions: [support.extension],
        );
        final tree = syntaxTree(state);
        expect(tree, isNotNull);
        expect(tree!.type.isTop, isTrue);
      });

      test('syntaxTree has correct token count', () {
        final support = _lang.languageSupport();
        final state = EditorState.create(
          docString: 'if x 42',
          extensions: [support.extension],
        );
        final tree = syntaxTree(state);
        expect(tree!.children.length, equals(3)); // if, x, 42
      });
    });
  });
}
