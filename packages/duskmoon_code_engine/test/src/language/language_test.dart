import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

LRParser _createJsonParser() {
  return LRParser.deserialize(
    nodeNames: [
      '',
      'JsonText',
      'Number',
      'String',
      'Boolean',
      'Null',
      '{',
      '}',
      '[',
      ']',
      ',',
      ':',
      '⚠',
    ],
    states: [0],
    stateData: [0],
    gotoTable: [0],
    tokenData: [0],
    topRuleIndex: 1,
    nodeProps: {
      1: {NodeProp.top: true},
      12: {NodeProp.error: true},
    },
  );
}

void main() {
  group('Language', () {
    test('has name and parser', () {
      final parser = _createJsonParser();
      final language = Language(name: 'json', parser: parser);
      expect(language.name, equals('json'));
      expect(language.parser, same(parser));
      expect(language.data, isA<LanguageData>());
    });

    test('accepts custom LanguageData', () {
      final parser = _createJsonParser();
      const data = LanguageData(
        commentTokens: CommentTokens(line: '//'),
        indentOnInput: r'\}',
      );
      final language = Language(name: 'js', parser: parser, data: data);
      expect(language.data.commentTokens?.line, equals('//'));
      expect(language.data.indentOnInput, equals(r'\}'));
    });
  });

  group('LanguageSupport', () {
    test('provides Extension', () {
      final parser = _createJsonParser();
      final language = Language(name: 'json', parser: parser);
      final support = LanguageSupport(language: language);
      final ext = support.extension;
      expect(ext, isA<Extension>());
    });

    test('wraps support extensions in ExtensionGroup when non-empty', () {
      final parser = _createJsonParser();
      final language = Language(name: 'json', parser: parser);
      final extraFacet = Facet<int, int>(
        combine: (values) => values.isEmpty ? 0 : values.last,
      );
      final support = LanguageSupport(
        language: language,
        support: [extraFacet.of(42)],
      );
      final ext = support.extension;
      expect(ext, isA<ExtensionGroup>());
    });
  });

  group('syntaxTree', () {
    test('returns tree after state creation with language extension', () {
      final parser = _createJsonParser();
      final language = Language(name: 'json', parser: parser);
      final support = LanguageSupport(language: language);
      final ext = support.extension;

      final state = EditorState.create(
        docString: '42',
        extensions: [ext],
      );

      final tree = syntaxTree(state);
      expect(tree, isNotNull);
      expect(tree!.type.name, equals('JsonText'));
    });

    test('syntaxTree has correct children for string input', () {
      final parser = _createJsonParser();
      final language = Language(name: 'json', parser: parser);
      final support = LanguageSupport(language: language);
      final ext = support.extension;

      final state = EditorState.create(
        docString: '"hello"',
        extensions: [ext],
      );

      final tree = syntaxTree(state);
      expect(tree, isNotNull);
      expect(tree!.children.length, equals(1));
      final child = tree.children.first as Tree;
      expect(child.type.name, equals('String'));
    });

    test('syntaxTree updates after transaction (change doc content)', () {
      final parser = _createJsonParser();
      final language = Language(name: 'json', parser: parser);
      final support = LanguageSupport(language: language);
      final ext = support.extension;

      final state = EditorState.create(
        docString: '42',
        extensions: [ext],
      );

      // Replace "42" (length 2) with "true" (length 4)
      final tr = state.update(
        TransactionSpec(
          changes: ChangeSet.of(2, [const ChangeSpec(from: 0, to: 2, insert: 'true')]),
        ),
      );
      final newState = state.applyTransaction(tr);

      final tree = syntaxTree(newState);
      expect(tree, isNotNull);
      expect(tree!.children.length, equals(1));
      final child = tree.children.first as Tree;
      expect(child.type.name, equals('Boolean'));
    });

    test('syntaxTreeAvailable returns true', () {
      final parser = _createJsonParser();
      final language = Language(name: 'json', parser: parser);
      final support = LanguageSupport(language: language);
      final ext = support.extension;

      final state = EditorState.create(
        docString: 'null',
        extensions: [ext],
      );

      expect(syntaxTreeAvailable(state), isTrue);
    });

    test('syntaxTree returns null without language extension', () {
      // Create state with no language extension
      final state = EditorState.create(docString: '42');

      // syntaxTree accessor was set by a previous LanguageSupport.extension call,
      // but the state has no language field, so it should return null.
      final parser = _createJsonParser();
      final language = Language(name: 'json', parser: parser);
      final support = LanguageSupport(language: language);
      // Get extension to register accessor, but don't use it for this state
      support.extension;

      final result = syntaxTree(state);
      expect(result, isNull);
    });
  });
}
