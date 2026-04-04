/// A property that can be attached to a [NodeType].
///
/// Properties are identified by reference identity. Each static
/// field is a distinct instance created with `final` (not `const`)
/// to avoid Dart's const canonicalization merging same-type props.
class NodeProp<T> {
  /// Create a new property. Use `final` (not `const`) for distinct identity.
  NodeProp();

  /// Marks a node as an error (recovery) node.
  static final NodeProp<bool> error = NodeProp<bool>();

  /// Marks a node as top-level (root grammar node).
  static final NodeProp<bool> top = NodeProp<bool>();

  /// Marks a node as skipped (whitespace, comments).
  static final NodeProp<bool> skipped = NodeProp<bool>();

  /// Names of tokens that close this node.
  static final NodeProp<List<String>> closedBy = NodeProp<List<String>>();

  /// Names of tokens that open this node.
  static final NodeProp<List<String>> openedBy = NodeProp<List<String>>();

  /// Group name(s) for highlight tagging.
  static final NodeProp<List<String>> group = NodeProp<List<String>>();
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
