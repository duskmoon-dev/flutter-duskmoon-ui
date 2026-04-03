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
  group('LRParser', () {
    late LRParser parser;

    setUp(() {
      parser = _createJsonParser();
    });

    test('parses empty string → top-level node with 0 children', () {
      final tree = parser.parse('');
      expect(tree.type.name, equals('JsonText'));
      expect(tree.children, isEmpty);
      expect(tree.length, equals(0));
    });

    test('parses number "42" → one Number child', () {
      final tree = parser.parse('42');
      expect(tree.children.length, equals(1));
      final child = tree.children.first as Tree;
      expect(child.type.name, equals('Number'));
      expect(child.length, equals(2));
    });

    test('parses string "hello" → one String child', () {
      final tree = parser.parse('"hello"');
      expect(tree.children.length, equals(1));
      final child = tree.children.first as Tree;
      expect(child.type.name, equals('String'));
      expect(child.length, equals(7));
    });

    test('parses true → Boolean child', () {
      final tree = parser.parse('true');
      expect(tree.children.length, equals(1));
      final child = tree.children.first as Tree;
      expect(child.type.name, equals('Boolean'));
      expect(child.length, equals(4));
    });

    test('parses false → Boolean child', () {
      final tree = parser.parse('false');
      expect(tree.children.length, equals(1));
      final child = tree.children.first as Tree;
      expect(child.type.name, equals('Boolean'));
      expect(child.length, equals(5));
    });

    test('parses null → Null child', () {
      final tree = parser.parse('null');
      expect(tree.children.length, equals(1));
      final child = tree.children.first as Tree;
      expect(child.type.name, equals('Null'));
      expect(child.length, equals(4));
    });

    test('parses with whitespace — whitespace is skipped', () {
      final tree = parser.parse('  42  ');
      expect(tree.children.length, equals(1));
      final child = tree.children.first as Tree;
      expect(child.type.name, equals('Number'));
      // position should be 2 (after two spaces)
      expect(tree.positions.first, equals(2));
    });

    test('parses string with backslash escapes', () {
      final tree = parser.parse(r'"he\"llo"');
      expect(tree.children.length, equals(1));
      final child = tree.children.first as Tree;
      expect(child.type.name, equals('String'));
      // "he\"llo" is 9 chars
      expect(child.length, equals(9));
    });

    test('parses negative number', () {
      final tree = parser.parse('-3');
      expect(tree.children.length, equals(1));
      final child = tree.children.first as Tree;
      expect(child.type.name, equals('Number'));
      expect(child.length, equals(2));
    });

    test('parses float number', () {
      final tree = parser.parse('3.14');
      expect(tree.children.length, equals(1));
      final child = tree.children.first as Tree;
      expect(child.type.name, equals('Number'));
      expect(child.length, equals(4));
    });

    test('parses {} → two punctuation children', () {
      final tree = parser.parse('{}');
      expect(tree.children.length, equals(2));
      final open = tree.children[0] as Tree;
      final close = tree.children[1] as Tree;
      expect(open.type.name, equals('{'));
      expect(close.type.name, equals('}'));
    });

    test('cursor traversal finds named children', () {
      final tree = parser.parse('42');
      final cursor = tree.cursor();
      // Start at top node
      expect(cursor.name, equals('JsonText'));
      // Move into first child
      expect(cursor.firstChild(), isTrue);
      expect(cursor.name, equals('Number'));
    });

    test('topNode has top prop', () {
      final tree = parser.parse('');
      expect(tree.type.isTop, isTrue);
    });

    test('unknown character produces error node', () {
      final tree = parser.parse('@');
      expect(tree.children.length, equals(1));
      final child = tree.children.first as Tree;
      expect(child.type.name, equals('⚠'));
    });

    test('parses mixed content with whitespace', () {
      final tree = parser.parse(' "a" true null ');
      expect(tree.children.length, equals(3));
      expect((tree.children[0] as Tree).type.name, equals('String'));
      expect((tree.children[1] as Tree).type.name, equals('Boolean'));
      expect((tree.children[2] as Tree).type.name, equals('Null'));
    });

    test('stopAt limits parsing', () {
      final tree = parser.parse('42 true', stopAt: 2);
      // Only "42" should be parsed; "true" is beyond stopAt
      expect(tree.children.length, equals(1));
      expect((tree.children.first as Tree).type.name, equals('Number'));
    });
  });
}
