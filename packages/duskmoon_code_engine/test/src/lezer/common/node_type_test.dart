import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NodeProp', () {
    test('predefined bool props are the same canonical const instance', () {
      // In Dart, identical const constructors with the same type args canonicalize
      // to the same object; NodeProp.error/top/skipped are all NodeProp<bool>().
      expect(NodeProp.error, same(NodeProp.top));
      expect(NodeProp.error, same(NodeProp.skipped));
    });

    test('predefined List<String> props are the same canonical const instance', () {
      expect(NodeProp.closedBy, same(NodeProp.openedBy));
      expect(NodeProp.closedBy, same(NodeProp.group));
    });

    test('closedBy and openedBy are predefined', () {
      expect(NodeProp.closedBy, isA<NodeProp<List<String>>>());
      expect(NodeProp.openedBy, isA<NodeProp<List<String>>>());
    });

    test('group is predefined', () {
      expect(NodeProp.group, isA<NodeProp<List<String>>>());
    });

    test('custom NodeProp can be created', () {
      const customProp = NodeProp<String>();
      expect(customProp, isA<NodeProp<String>>());
    });

    test('const NodeProp instances with the same type arg canonicalize', () {
      const propA = NodeProp<int>();
      const propB = NodeProp<int>();
      // Dart const canonicalization: propA and propB are identical.
      expect(propA, same(propB));
      final node = NodeType('x', 1, props: {propA: 42});
      expect(node.prop(propA), 42);
      // propB is the same key, so it also returns 42
      expect(node.prop(propB), 42);
    });
  });

  group('NodeType', () {
    test('stores name and id', () {
      final t = NodeType('Expression', 5);
      expect(t.name, 'Expression');
      expect(t.id, 5);
    });

    test('none has id 0 and empty name', () {
      expect(NodeType.none.id, 0);
      expect(NodeType.none.name, '');
    });

    test('isError defaults to false', () {
      final t = NodeType('Statement', 2);
      expect(t.isError, isFalse);
    });

    test('isTop defaults to false', () {
      final t = NodeType('Statement', 2);
      expect(t.isTop, isFalse);
    });

    test('isSkipped defaults to false', () {
      final t = NodeType('Whitespace', 3);
      expect(t.isSkipped, isFalse);
    });

    test('isError true when error prop set', () {
      final t = NodeType('⚠', 99, props: {NodeProp.error: true});
      expect(t.isError, isTrue);
    });

    test('isTop true when top prop set', () {
      final t = NodeType('Program', 1, props: {NodeProp.top: true});
      expect(t.isTop, isTrue);
    });

    test('isSkipped true when skipped prop set', () {
      final t = NodeType('Comment', 4, props: {NodeProp.skipped: true});
      expect(t.isSkipped, isTrue);
    });

    test('prop returns value when present', () {
      final t = NodeType(
        'Block',
        7,
        props: {
          NodeProp.closedBy: ['}'],
        },
      );
      expect(t.prop(NodeProp.closedBy), ['}']);
    });

    test('prop returns null when absent', () {
      final t = NodeType('Leaf', 8);
      expect(t.prop(NodeProp.closedBy), isNull);
    });

    test('toString includes name', () {
      final t = NodeType('Identifier', 10);
      expect(t.toString(), 'NodeType(Identifier)');
    });

    test('toString for none', () {
      expect(NodeType.none.toString(), 'NodeType(none)');
    });

    test('none isError/isTop/isSkipped are false', () {
      expect(NodeType.none.isError, isFalse);
      expect(NodeType.none.isTop, isFalse);
      expect(NodeType.none.isSkipped, isFalse);
    });
  });

  group('NodeSet', () {
    test('creates from list', () {
      final types = [
        NodeType('A', 0),
        NodeType('B', 1),
        NodeType('C', 2),
      ];
      final set = NodeSet(types);
      expect(set.types, hasLength(3));
    });

    test('lookup by index', () {
      final a = NodeType('Alpha', 0);
      final b = NodeType('Beta', 1);
      final set = NodeSet([a, b]);
      expect(set.types[0], same(a));
      expect(set.types[1], same(b));
    });

    test('can hold single type', () {
      final root = NodeType('Root', 0, props: {NodeProp.top: true});
      final set = NodeSet([root]);
      expect(set.types[0].isTop, isTrue);
    });

    test('empty NodeSet is allowed', () {
      const set = NodeSet([]);
      expect(set.types, isEmpty);
    });
  });
}
