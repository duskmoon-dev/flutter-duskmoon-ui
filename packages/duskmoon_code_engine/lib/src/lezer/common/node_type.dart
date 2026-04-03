/// A property that can be attached to a [NodeType].
class NodeProp<T> {
  const NodeProp();

  static const NodeProp<bool> error = NodeProp<bool>();
  static const NodeProp<bool> top = NodeProp<bool>();
  static const NodeProp<bool> skipped = NodeProp<bool>();
  static const NodeProp<List<String>> closedBy = NodeProp<List<String>>();
  static const NodeProp<List<String>> openedBy = NodeProp<List<String>>();
  static const NodeProp<List<String>> group = NodeProp<List<String>>();
}

/// Describes the type of a syntax tree node.
class NodeType {
  NodeType(this.name, this.id, {Map<NodeProp<dynamic>, dynamic>? props})
      : _props = props ?? const {};

  final String name;
  final int id;
  final Map<NodeProp<dynamic>, dynamic> _props;

  static final NodeType none = NodeType('', 0);

  bool get isError => prop(NodeProp.error) == true;
  bool get isTop => prop(NodeProp.top) == true;
  bool get isSkipped => prop(NodeProp.skipped) == true;

  T? prop<T>(NodeProp<T> prop) => _props[prop] as T?;

  @override
  String toString() => name.isEmpty ? 'NodeType(none)' : 'NodeType($name)';
}

/// An indexed collection of [NodeType]s.
class NodeSet {
  const NodeSet(this.types);
  final List<NodeType> types;
}
