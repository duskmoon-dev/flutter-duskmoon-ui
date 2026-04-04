import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  setUp(() => LanguageRegistry.clear());

  group('Dart grammar', () {
    test('registers by name', () {
      dartLanguageSupport();
      expect(LanguageRegistry.byName('dart'), isNotNull);
    });

    test('registers by extension', () {
      dartLanguageSupport();
      expect(LanguageRegistry.byExtension('dart'), isNotNull);
    });

    test('registers by MIME type', () {
      dartLanguageSupport();
      expect(LanguageRegistry.byMimeType('application/dart'), isNotNull);
      expect(LanguageRegistry.byMimeType('text/x-dart'), isNotNull);
    });

    test('highlights keywords', () {
      final support = dartLanguageSupport();
      final state = EditorState.create(
        docString: 'class Foo extends Bar implements Baz {}',
        extensions: [support.extension],
      );
      final tree = syntaxTree(state)!;
      final cursor = tree.cursor();
      final typeNames = <String>{cursor.name};
      while (cursor.next()) {
        typeNames.add(cursor.name);
      }
      expect(typeNames, contains('Keyword'));
    });

    test('highlights string literals', () {
      final support = dartLanguageSupport();
      final state = EditorState.create(
        docString: "var s = 'hello world';",
        extensions: [support.extension],
      );
      final tree = syntaxTree(state)!;
      final cursor = tree.cursor();
      final typeNames = <String>{cursor.name};
      while (cursor.next()) {
        typeNames.add(cursor.name);
      }
      expect(typeNames, contains('String'));
    });

    test('highlights line comments', () {
      final support = dartLanguageSupport();
      final state = EditorState.create(
        docString: '// This is a comment\nvar x = 1;',
        extensions: [support.extension],
      );
      final tree = syntaxTree(state)!;
      final cursor = tree.cursor();
      final typeNames = <String>{cursor.name};
      while (cursor.next()) {
        typeNames.add(cursor.name);
      }
      expect(typeNames, contains('Comment'));
    });

    test('highlights doc comments', () {
      final support = dartLanguageSupport();
      final state = EditorState.create(
        docString: '/// Doc comment\nclass Foo {}',
        extensions: [support.extension],
      );
      final tree = syntaxTree(state)!;
      final cursor = tree.cursor();
      final typeNames = <String>{cursor.name};
      while (cursor.next()) {
        typeNames.add(cursor.name);
      }
      expect(typeNames, contains('Comment'));
    });

    test('highlights numbers', () {
      final support = dartLanguageSupport();
      final state = EditorState.create(
        docString: 'var n = 42; var h = 0xFF; var f = 3.14;',
        extensions: [support.extension],
      );
      final tree = syntaxTree(state)!;
      final cursor = tree.cursor();
      final typeNames = <String>{cursor.name};
      while (cursor.next()) {
        typeNames.add(cursor.name);
      }
      expect(typeNames, contains('Number'));
    });

    test('highlights annotations', () {
      final support = dartLanguageSupport();
      final state = EditorState.create(
        docString: '@override\nvoid doSomething() {}',
        extensions: [support.extension],
      );
      final tree = syntaxTree(state)!;
      final cursor = tree.cursor();
      final typeNames = <String>{cursor.name};
      while (cursor.next()) {
        typeNames.add(cursor.name);
      }
      expect(typeNames, contains('Annotation'));
    });

    test('has comment tokens defined', () {
      final support = dartLanguageSupport();
      final ct = support.language.data.commentTokens;
      expect(ct, isNotNull);
      expect(ct!.line, equals('//'));
      expect(ct.block, isNotNull);
      expect(ct.block!.open, equals('/*'));
      expect(ct.block!.close, equals('*/'));
    });

    test('tree type is top-level dart node', () {
      final support = dartLanguageSupport();
      final state = EditorState.create(
        docString: 'void main() {}',
        extensions: [support.extension],
      );
      final tree = syntaxTree(state)!;
      expect(tree.type.isTop, true);
      expect(tree.children, isNotEmpty);
    });
  });
}
