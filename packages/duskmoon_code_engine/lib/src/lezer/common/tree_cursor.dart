part of 'tree.dart';

class _Frame {
  _Frame(this.tree, this.offset, this.childIndex);
  final Tree tree;
  final int offset;
  final int childIndex; // index of this frame in parent's children; -1 for root
}

/// Efficient stateful cursor for tree traversal. Uses a stack internally.
class TreeCursor {
  TreeCursor._(Tree root) {
    _stack.add(_Frame(root, 0, -1));
  }

  final List<_Frame> _stack = [];

  _Frame get _current => _stack.last;

  NodeType get type => _current.tree.type;
  String get name => type.name;
  int get from => _current.offset;
  int get to => _current.offset + _current.tree.length;

  bool firstChild() {
    final cur = _current;
    for (var i = 0; i < cur.tree.children.length; i++) {
      final child = cur.tree.children[i];
      if (child is Tree) {
        _stack.add(_Frame(child, cur.offset + cur.tree.positions[i], i));
        return true;
      }
    }
    return false;
  }

  bool lastChild() {
    final cur = _current;
    for (var i = cur.tree.children.length - 1; i >= 0; i--) {
      final child = cur.tree.children[i];
      if (child is Tree) {
        _stack.add(_Frame(child, cur.offset + cur.tree.positions[i], i));
        return true;
      }
    }
    return false;
  }

  bool nextSibling() {
    if (_stack.length < 2) return false;
    final parentFrame = _stack[_stack.length - 2];
    final currentIndex = _current.childIndex;
    for (var i = currentIndex + 1; i < parentFrame.tree.children.length; i++) {
      final child = parentFrame.tree.children[i];
      if (child is Tree) {
        _stack[_stack.length - 1] =
            _Frame(child, parentFrame.offset + parentFrame.tree.positions[i], i);
        return true;
      }
    }
    return false;
  }

  bool prevSibling() {
    if (_stack.length < 2) return false;
    final parentFrame = _stack[_stack.length - 2];
    final currentIndex = _current.childIndex;
    for (var i = currentIndex - 1; i >= 0; i--) {
      final child = parentFrame.tree.children[i];
      if (child is Tree) {
        _stack[_stack.length - 1] =
            _Frame(child, parentFrame.offset + parentFrame.tree.positions[i], i);
        return true;
      }
    }
    return false;
  }

  bool parent() {
    if (_stack.length <= 1) return false;
    _stack.removeLast();
    return true;
  }

  /// Depth-first traversal: try firstChild, then nextSibling,
  /// then walk up ancestors to find a nextSibling.
  bool next() {
    if (firstChild()) return true;
    while (_stack.length > 1) {
      if (nextSibling()) return true;
      _stack.removeLast();
    }
    return false;
  }

  /// Build a [SyntaxNode] from the current cursor position.
  SyntaxNode get node {
    // Build parent chain from the stack.
    SyntaxNode? parentNode;
    for (var i = 0; i < _stack.length - 1; i++) {
      final frame = _stack[i];
      parentNode = SyntaxNode(frame.tree, frame.offset, parentNode,
          i == 0 ? -1 : _stack[i].childIndex);
    }
    final cur = _current;
    return SyntaxNode(cur.tree, cur.offset, parentNode, cur.childIndex);
  }
}
