import '../ir/diagram_kind.dart';
import 'layout_types.dart';

class MermaidLayout {
  const MermaidLayout({
    required this.kind,
    required this.width,
    required this.height,
    required this.nodes,
    required this.edges,
  });

  final MermaidDiagramKind kind;
  final double width;
  final double height;
  final Map<String, NodeLayout> nodes;
  final List<EdgeLayout> edges;
}
