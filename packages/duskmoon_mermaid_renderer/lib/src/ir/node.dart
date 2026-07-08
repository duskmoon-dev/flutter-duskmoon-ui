import 'style.dart';

class Node {
  const Node({
    required this.id,
    required this.label,
    this.shape = NodeShape.rectangle,
  });

  final String id;
  final String label;
  final NodeShape shape;

  Node merge(Node other) {
    if (other.label == other.id && other.shape == NodeShape.rectangle) {
      return this;
    }
    return other;
  }
}
