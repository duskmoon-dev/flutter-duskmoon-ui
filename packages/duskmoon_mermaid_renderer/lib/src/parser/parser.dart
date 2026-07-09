import '../error/mermaid_error.dart';
import '../ir/graph.dart';
import '../ir/diagram_kind.dart';
import 'diagram_detector.dart';
import 'flowchart_parser.dart';
import 'pie_chart_parser.dart';
import 'quadrant_chart_parser.dart';
import 'radar_chart_parser.dart';
import 'relationship_diagram_parsers.dart';
import 'structured_diagram_parsers.dart';
import 'xy_chart_parser.dart';

class ParseOutput {
  const ParseOutput({
    required this.graph,
    this.diagnostics = const [],
  });

  final Graph graph;
  final List<MermaidDiagnostic> diagnostics;
}

ParseOutput parseMermaid(String source) {
  final kind = detectDiagramKind(source);
  return switch (kind) {
    MermaidDiagramKind.flowchart => parseFlowchart(source),
    MermaidDiagramKind.pie => parsePieChart(source),
    MermaidDiagramKind.quadrant => parseQuadrantChart(source),
    MermaidDiagramKind.radar => parseRadarChart(source),
    MermaidDiagramKind.packet => parsePacketDiagram(source),
    MermaidDiagramKind.sankey => parseSankeyDiagram(source),
    MermaidDiagramKind.timeline => parseTimelineDiagram(source),
    MermaidDiagramKind.mindmap => parseMindmapDiagram(source),
    MermaidDiagramKind.kanban => parseKanbanDiagram(source),
    MermaidDiagramKind.treemap => parseTreemapDiagram(source),
    MermaidDiagramKind.sequence => parseSequenceDiagram(source),
    MermaidDiagramKind.state => parseStateDiagram(source),
    MermaidDiagramKind.er => parseErDiagram(source),
    MermaidDiagramKind.journey => parseJourneyDiagram(source),
    MermaidDiagramKind.gitGraph => parseGitGraphDiagram(source),
    MermaidDiagramKind.venn => parseVennDiagram(source),
    MermaidDiagramKind.swimlanes => parseSwimlaneDiagram(source),
    MermaidDiagramKind.classDiagram => parseClassDiagram(source),
    MermaidDiagramKind.gantt => parseGanttDiagram(source),
    MermaidDiagramKind.requirement => parseRequirementDiagram(source),
    MermaidDiagramKind.c4 => parseC4Diagram(source),
    MermaidDiagramKind.zenUml => parseZenUmlDiagram(source),
    MermaidDiagramKind.block => parseBlockDiagram(source),
    MermaidDiagramKind.architecture => parseArchitectureDiagram(source),
    MermaidDiagramKind.eventModeling => parseEventModelingDiagram(source),
    MermaidDiagramKind.ishikawa => parseIshikawaDiagram(source),
    MermaidDiagramKind.wardley => parseWardleyDiagram(source),
    MermaidDiagramKind.cynefin => parseCynefinDiagram(source),
    MermaidDiagramKind.treeView => parseTreeViewDiagram(source),
    MermaidDiagramKind.xyChart => parseXyChart(source),
  };
}
