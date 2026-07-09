import 'diagram_kind.dart';
import 'direction.dart';
import 'edge.dart';
import 'charts.dart';
import 'node.dart';
import 'relationship_diagrams.dart';
import 'structured_diagrams.dart';
import 'subgraph.dart';
import 'xy_chart.dart';

class Graph {
  Graph({
    this.kind = MermaidDiagramKind.flowchart,
    this.direction = MermaidDirection.topDown,
    this.pieChart,
    this.quadrantChart,
    this.radarChart,
    this.packetDiagram,
    this.sankeyDiagram,
    this.timelineDiagram,
    this.mindmapDiagram,
    this.kanbanDiagram,
    this.treemapDiagram,
    this.sequenceDiagram,
    this.journeyDiagram,
    this.gitGraphDiagram,
    this.vennDiagram,
    this.ganttDiagram,
    this.ishikawaDiagram,
    this.wardleyMapDiagram,
    this.cynefinDiagram,
    this.treeViewDiagram,
    this.xyChart,
    Map<String, Node>? nodes,
    List<Edge>? edges,
    List<Subgraph>? subgraphs,
  })  : nodes = nodes ?? <String, Node>{},
        edges = edges ?? <Edge>[],
        subgraphs = subgraphs ?? <Subgraph>[];

  MermaidDiagramKind kind;
  MermaidDirection direction;
  PieChart? pieChart;
  QuadrantChart? quadrantChart;
  RadarChart? radarChart;
  PacketDiagram? packetDiagram;
  SankeyDiagram? sankeyDiagram;
  TimelineDiagram? timelineDiagram;
  MindmapDiagram? mindmapDiagram;
  KanbanDiagram? kanbanDiagram;
  TreemapDiagram? treemapDiagram;
  SequenceDiagram? sequenceDiagram;
  JourneyDiagram? journeyDiagram;
  GitGraphDiagram? gitGraphDiagram;
  VennDiagram? vennDiagram;
  GanttDiagram? ganttDiagram;
  MindmapDiagram? ishikawaDiagram;
  WardleyMapDiagram? wardleyMapDiagram;
  CynefinDiagram? cynefinDiagram;
  MindmapDiagram? treeViewDiagram;
  XyChart? xyChart;
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
