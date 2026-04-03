import '../common/node_type.dart';
import '../common/tree.dart';

class StackFrame {
  StackFrame(this.state, this.tree, this.start, this.parent);
  final int state;
  final Tree? tree;
  final int start;
  final StackFrame? parent;
}

class TreeBuilder {
  final List<Object> children = [];
  final List<int> positions = [];

  void addChild(Tree tree, int pos) {
    children.add(tree);
    positions.add(pos);
  }

  Tree build(NodeType type, int length) {
    return Tree(type, List.of(children), List.of(positions), length);
  }

  void clear() {
    children.clear();
    positions.clear();
  }
}
