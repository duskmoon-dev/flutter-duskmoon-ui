import 'node_type.dart';

part 'tree_cursor.dart';

/// Immutable syntax tree. Children stored as parallel lists.
class Tree {
  const Tree(this.type, this.children, this.positions, this.length);

  final NodeType type;
  final List<Object> children; // Tree | TreeBuffer
  final List<int> positions; // start positions relative to this tree
  final int length;

  static final Tree empty = Tree(NodeType.none, const [], const [], 0);

  SyntaxNode get topNode => SyntaxNode(this, 0, null, -1);

  TreeCursor cursor() => TreeCursor._(this);

  @override
  String toString() => 'Tree(${type.name}, $length)';
}

/// Compact flat representation for leaf/simple nodes.
/// Buffer: [typeId, from, to, endIndex] per node.
class TreeBuffer {
  const TreeBuffer(this.buffer, this.length, this.set);
  final List<int> buffer;
  final int length;
  final NodeSet set;
}

/// Positioned reference into a syntax tree for navigation.
class SyntaxNode {
  SyntaxNode(this._tree, this._offset, this._parent, this._childIndex);

  final Tree _tree;
  final int _offset;
  final SyntaxNode? _parent;
  final int _childIndex;

  NodeType get type => _tree.type;
  String get name => _tree.type.name;
  int get from => _offset;
  int get to => _offset + _tree.length;
  SyntaxNode? get parent => _parent;

  SyntaxNode? get firstChild {
    for (var i = 0; i < _tree.children.length; i++) {
      final child = _tree.children[i];
      if (child is Tree) {
        return SyntaxNode(child, _offset + _tree.positions[i], this, i);
      }
    }
    return null;
  }

  SyntaxNode? get lastChild {
    for (var i = _tree.children.length - 1; i >= 0; i--) {
      final child = _tree.children[i];
      if (child is Tree) {
        return SyntaxNode(child, _offset + _tree.positions[i], this, i);
      }
    }
    return null;
  }

  SyntaxNode? get nextSibling {
    final p = _parent;
    if (p == null) return null;
    for (var i = _childIndex + 1; i < p._tree.children.length; i++) {
      final child = p._tree.children[i];
      if (child is Tree) {
        return SyntaxNode(child, p._offset + p._tree.positions[i], p, i);
      }
    }
    return null;
  }

  SyntaxNode? get prevSibling {
    final p = _parent;
    if (p == null) return null;
    for (var i = _childIndex - 1; i >= 0; i--) {
      final child = p._tree.children[i];
      if (child is Tree) {
        return SyntaxNode(child, p._offset + p._tree.positions[i], p, i);
      }
    }
    return null;
  }

  /// Find deepest node covering [pos].
  SyntaxNode resolve(int pos) {
    if (pos < from || pos > to) return this;
    for (var i = 0; i < _tree.children.length; i++) {
      final child = _tree.children[i];
      if (child is Tree) {
        final childOffset = _offset + _tree.positions[i];
        final childTo = childOffset + child.length;
        if (pos >= childOffset && pos <= childTo) {
          final childNode = SyntaxNode(child, childOffset, this, i);
          return childNode.resolve(pos);
        }
      }
    }
    return this;
  }
}
