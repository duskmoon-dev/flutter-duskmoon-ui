import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tRoot = NodeType('Root', 1);
  final tExpr = NodeType('Expr', 2);
  final tNum = NodeType('Num', 3);
  final tIdent = NodeType('Ident', 4);

  // Build: Root [ Expr(0..4), Num(5..8) ]
  Tree buildTwoChildTree() {
    final childA = Tree(tExpr, const [], const [], 4);
    final childB = Tree(tNum, const [], const [], 3);
    return Tree(tRoot, [childA, childB], [0, 5], 8);
  }

  group('TreeCursor', () {
    test('starts at root', () {
      final root = buildTwoChildTree();
      final cursor = root.cursor();
      expect(cursor.name, 'Root');
      expect(cursor.from, 0);
      expect(cursor.to, 8);
    });

    test('firstChild moves into first child', () {
      final cursor = buildTwoChildTree().cursor();
      expect(cursor.firstChild(), isTrue);
      expect(cursor.name, 'Expr');
      expect(cursor.from, 0);
      expect(cursor.to, 4);
    });

    test('nextSibling moves to next sibling', () {
      final cursor = buildTwoChildTree().cursor();
      cursor.firstChild();
      expect(cursor.nextSibling(), isTrue);
      expect(cursor.name, 'Num');
      expect(cursor.from, 5);
      expect(cursor.to, 8);
    });

    test('nextSibling returns false at last child', () {
      final cursor = buildTwoChildTree().cursor();
      cursor.firstChild();
      cursor.nextSibling(); // now at Num
      expect(cursor.nextSibling(), isFalse);
      expect(cursor.name, 'Num'); // unchanged
    });

    test('parent returns to root', () {
      final cursor = buildTwoChildTree().cursor();
      cursor.firstChild();
      expect(cursor.parent(), isTrue);
      expect(cursor.name, 'Root');
    });

    test('parent returns false at root', () {
      final cursor = buildTwoChildTree().cursor();
      expect(cursor.parent(), isFalse);
      expect(cursor.name, 'Root');
    });

    test('firstChild returns false for leaf', () {
      final leaf = Tree(tExpr, const [], const [], 5);
      final cursor = leaf.cursor();
      expect(cursor.firstChild(), isFalse);
      expect(cursor.name, 'Expr');
    });

    test('lastChild moves to last child', () {
      final cursor = buildTwoChildTree().cursor();
      expect(cursor.lastChild(), isTrue);
      expect(cursor.name, 'Num');
    });

    test('prevSibling moves to previous sibling', () {
      final cursor = buildTwoChildTree().cursor();
      cursor.lastChild(); // at Num
      expect(cursor.prevSibling(), isTrue);
      expect(cursor.name, 'Expr');
    });

    test('prevSibling returns false at first child', () {
      final cursor = buildTwoChildTree().cursor();
      cursor.firstChild(); // at Expr
      expect(cursor.prevSibling(), isFalse);
      expect(cursor.name, 'Expr');
    });

    test('next() depth-first traversal collects all nodes', () {
      final root = buildTwoChildTree();
      final cursor = root.cursor();
      final names = <String>[cursor.name];
      while (cursor.next()) {
        names.add(cursor.name);
      }
      // depth-first: Root, Expr, Num
      expect(names, ['Root', 'Expr', 'Num']);
    });

    test('node returns SyntaxNode at current position', () {
      final cursor = buildTwoChildTree().cursor();
      cursor.firstChild();
      final node = cursor.node;
      expect(node.name, 'Expr');
      expect(node.from, 0);
      expect(node.to, 4);
    });

    test('deeper tree depth-first traversal', () {
      // Root [ Expr [ Ident(0..2), Num(3..6) ](0..6) ](0..6)
      final ident = Tree(tIdent, const [], const [], 2);
      final num = Tree(tNum, const [], const [], 3);
      final expr = Tree(tExpr, [ident, num], [0, 3], 6);
      final root = Tree(tRoot, [expr], [0], 6);

      final cursor = root.cursor();
      final names = <String>[cursor.name];
      while (cursor.next()) {
        names.add(cursor.name);
      }
      expect(names, ['Root', 'Expr', 'Ident', 'Num']);
    });

    test('next() on single-node tree returns false immediately', () {
      final leaf = Tree(tIdent, const [], const [], 3);
      final cursor = leaf.cursor();
      expect(cursor.next(), isFalse);
    });

    test('lastChild returns false for leaf', () {
      final leaf = Tree(tNum, const [], const [], 4);
      final cursor = leaf.cursor();
      expect(cursor.lastChild(), isFalse);
    });
  });
}
