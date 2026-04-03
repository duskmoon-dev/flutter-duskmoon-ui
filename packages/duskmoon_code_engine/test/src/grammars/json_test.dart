import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  setUp(() {
    LanguageRegistry.clear();
  });

  group('JSON grammar', () {
    test('jsonLanguage is registered by name', () {
      jsonLanguageSupport(); // trigger registration
      expect(LanguageRegistry.byName('json'), isNotNull);
    });

    test('registered by extension', () {
      jsonLanguageSupport();
      expect(LanguageRegistry.byExtension('json'), isNotNull);
    });

    test('registered by MIME type', () {
      jsonLanguageSupport();
      expect(LanguageRegistry.byMimeType('application/json'), isNotNull);
    });

    test('parses simple object', () {
      final state = EditorState.create(
        docString: '{"key": 42}',
        extensions: [jsonLanguageSupport().extension],
      );
      final tree = syntaxTree(state);
      expect(tree, isNotNull);
      expect(tree!.type.name, 'JsonText');
      expect(tree.children.length, greaterThanOrEqualTo(4));
    });

    test('parses array', () {
      final state = EditorState.create(
        docString: '[1, 2, 3]',
        extensions: [jsonLanguageSupport().extension],
      );
      final tree = syntaxTree(state);
      expect(tree, isNotNull);
      expect(tree!.children.length, greaterThanOrEqualTo(5));
    });

    test('cursor traversal finds all token types', () {
      final state = EditorState.create(
        docString: '{"name": "test", "count": 42, "active": true}',
        extensions: [jsonLanguageSupport().extension],
      );
      final tree = syntaxTree(state)!;
      final cursor = tree.cursor();
      final typeNames = <String>{cursor.name};
      while (cursor.next()) {
        typeNames.add(cursor.name);
      }
      expect(typeNames, containsAll(['String', 'Number', 'Boolean']));
    });

    test('tree updates when document changes', () {
      final support = jsonLanguageSupport();
      final state = EditorState.create(
        docString: '42',
        extensions: [support.extension],
      );
      final tree1 = syntaxTree(state)!;
      expect((tree1.children[0] as Tree).type.name, 'Number');

      final tr = state.update(
        TransactionSpec(
          changes: ChangeSet.of(2, [const ChangeSpec(from: 0, to: 2, insert: '"hi"')]),
        ),
      );
      final state2 = state.applyTransaction(tr);
      final tree2 = syntaxTree(state2)!;
      expect((tree2.children[0] as Tree).type.name, 'String');
    });

    test('highlight tags are mapped for JSON nodes', () {
      final mapping = jsonHighlightMapping();
      expect(mapping['String'], Tag.string);
      expect(mapping['Number'], Tag.number);
      expect(mapping['Boolean'], Tag.bool_);
      expect(mapping['Null'], Tag.null_);
    });
  });
}
