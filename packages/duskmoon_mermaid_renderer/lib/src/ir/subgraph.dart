class Subgraph {
  const Subgraph({
    required this.id,
    required this.label,
    this.nodeIds = const [],
  });

  final String id;
  final String label;
  final List<String> nodeIds;
}
