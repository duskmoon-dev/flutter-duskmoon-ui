import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Helper NodeTypes
  final tRoot = NodeType('Root', 1);
  final tExpr = NodeType('Expr', 2);
  final tIdent = NodeType('Ident', 3);
  final tNum = NodeType('Num', 4);

  group('Tree', () {
    test('empty has length 0', () {
      expect(Tree.empty.length, 0);
      expect(Tree.empty.children, isEmpty);
      expect(Tree.empty.positions, isEmpty);
      expect(Tree.empty.type, same(NodeType.none));
    });

    test('leaf tree', () {
      final leaf = Tree(tIdent, const [], const [], 5);
      expect(leaf.length, 5);
      expect(leaf.type.name, 'Ident');
      expect(leaf.children, isEmpty);
    });

    test('tree with children', () {
      final childA = Tree(tExpr, const [], const [], 3);
      final childB = Tree(tNum, const [], const [], 2);
      final root = Tree(tRoot, [childA, childB], [0, 4], 6);
      expect(root.children.length, 2);
      expect(root.positions, [0, 4]);
    });

    test('child types are correct', () {
      final childA = Tree(tExpr, const [], const [], 3);
      final childB = Tree(tNum, const [], const [], 2);
      final root = Tree(tRoot, [childA, childB], [0, 4], 6);
      expect((root.children[0] as Tree).type.name, 'Expr');
      expect((root.children[1] as Tree).type.name, 'Num');
    });

    test('topNode wraps at offset 0', () {
      final tree = Tree(tRoot, const [], const [], 10);
      final top = tree.topNode;
      expect(top.from, 0);
      expect(top.to, 10);
      expect(top.type.name, 'Root');
    });

    test('toString includes type name and length', () {
      final tree = Tree(tRoot, const [], const [], 7);
      expect(tree.toString(), 'Tree(Root, 7)');
    });
  });

  group('TreeBuffer', () {
    test('creates with flat buffer', () {
      final set = NodeSet([tIdent]);
      // buffer: [typeId, from, to, endIndex]
      final buf = TreeBuffer([3, 0, 5, 4], 5, set);
      expect(buf.buffer, [3, 0, 5, 4]);
      expect(buf.length, 5);
      expect(buf.set, same(set));
    });

    test('stores set reference', () {
      final set = NodeSet([tRoot, tExpr]);
      final buf = TreeBuffer([1, 0, 10, 4], 10, set);
      expect(buf.set.types.length, 2);
    });
  });

  group('SyntaxNode', () {
    test('wraps tree with position', () {
      final tree = Tree(tExpr, const [], const [], 8);
      final node = SyntaxNode(tree, 5, null, -1);
      expect(node.from, 5);
      expect(node.to, 13);
      expect(node.name, 'Expr');
      expect(node.type.name, 'Expr');
      expect(node.parent, isNull);
    });

    test('firstChild/lastChild for leaf returns null', () {
      final leaf = Tree(tIdent, const [], const [], 5);
      final node = leaf.topNode;
      expect(node.firstChild, isNull);
      expect(node.lastChild, isNull);
    });

    test('firstChild returns correct child', () {
      final childA = Tree(tExpr, const [], const [], 3);
      final childB = Tree(tNum, const [], const [], 2);
      final root = Tree(tRoot, [childA, childB], [0, 4], 6);
      final first = root.topNode.firstChild;
      expect(first, isNotNull);
      expect(first!.name, 'Expr');
      expect(first.from, 0);
      expect(first.to, 3);
    });

    test('lastChild returns correct child', () {
      final childA = Tree(tExpr, const [], const [], 3);
      final childB = Tree(tNum, const [], const [], 2);
      final root = Tree(tRoot, [childA, childB], [0, 4], 6);
      final last = root.topNode.lastChild;
      expect(last, isNotNull);
      expect(last!.name, 'Num');
      expect(last.from, 4);
      expect(last.to, 6);
    });

    test('parent is set on child', () {
      final child = Tree(tExpr, const [], const [], 3);
      final root = Tree(tRoot, [child], [0], 3);
      final childNode = root.topNode.firstChild!;
      expect(childNode.parent, isNotNull);
      expect(childNode.parent!.name, 'Root');
    });

    test('nextSibling traversal', () {
      final childA = Tree(tExpr, const [], const [], 3);
      final childB = Tree(tNum, const [], const [], 2);
      final root = Tree(tRoot, [childA, childB], [0, 4], 6);
      final first = root.topNode.firstChild!;
      final next = first.nextSibling;
      expect(next, isNotNull);
      expect(next!.name, 'Num');
      expect(next.nextSibling, isNull);
    });

    test('prevSibling traversal', () {
      final childA = Tree(tExpr, const [], const [], 3);
      final childB = Tree(tNum, const [], const [], 2);
      final root = Tree(tRoot, [childA, childB], [0, 4], 6);
      final last = root.topNode.lastChild!;
      final prev = last.prevSibling;
      expect(prev, isNotNull);
      expect(prev!.name, 'Expr');
      expect(prev.prevSibling, isNull);
    });

    test('nextSibling at root returns null', () {
      final root = Tree(tRoot, const [], const [], 5);
      expect(root.topNode.nextSibling, isNull);
    });

    test('prevSibling at root returns null', () {
      final root = Tree(tRoot, const [], const [], 5);
      expect(root.topNode.prevSibling, isNull);
    });

    test('resolve finds deepest node covering pos', () {
      final leaf1 = Tree(tExpr, const [], const [], 4); // pos 0..4
      final leaf2 = Tree(tNum, const [], const [], 3); // pos 5..8
      final root = Tree(tRoot, [leaf1, leaf2], [0, 5], 8);
      final top = root.topNode;

      final resolved = top.resolve(2);
      expect(resolved.name, 'Expr');

      final resolved2 = top.resolve(6);
      expect(resolved2.name, 'Num');
    });

    test('resolve returns self when pos not in any child', () {
      final child = Tree(tExpr, const [], const [], 3); // pos 1..4
      final root = Tree(tRoot, [child], [1], 10);
      final top = root.topNode;
      // pos 0 is not covered by child (child starts at 1)
      final resolved = top.resolve(0);
      expect(resolved.name, 'Root');
    });

    test('resolve handles nested children', () {
      final inner = Tree(tIdent, const [], const [], 2); // pos 1..3
      final outer = Tree(tExpr, [inner], [1], 4); // pos 0..4
      final root = Tree(tRoot, [outer], [0], 4);
      final resolved = root.topNode.resolve(2);
      expect(resolved.name, 'Ident');
    });
  });
}
