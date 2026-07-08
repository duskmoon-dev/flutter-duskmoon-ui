import 'diagram_kind.dart';
import 'direction.dart';
import 'edge.dart';
import 'node.dart';
import 'subgraph.dart';

class Graph {
  Graph({
    this.kind = MermaidDiagramKind.flowchart,
    this.direction = MermaidDirection.topDown,
    Map<String, Node>? nodes,
    List<Edge>? edges,
    List<Subgraph>? subgraphs,
  })  : nodes = nodes ?? <String, Node>{},
        edges = edges ?? <Edge>[],
        subgraphs = subgraphs ?? <Subgraph>[];

  MermaidDiagramKind kind;
  MermaidDirection direction;
  final Map<String, Node> nodes;
  final List<Edge> edges;
  final List<Subgraph> subgraphs;

  void addNode(Node node) {
    nodes.update(node.id, (existing) => existing.merge(node), ifAbsent: () {
      return node;
    });
  }

  void addEdge(Edge edge) {
    edges.add(edge);
  }
}
