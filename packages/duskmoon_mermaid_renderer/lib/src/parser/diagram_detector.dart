import '../error/mermaid_error.dart';
import '../ir/diagram_kind.dart';

MermaidDiagramKind detectDiagramKind(String source) {
  final firstMeaningfulLine = source
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty && !line.startsWith('%%'))
      .firstOrNull;

  if (firstMeaningfulLine == null) {
    throw const MermaidParseError('Diagram source is empty');
  }

  final lower = firstMeaningfulLine.toLowerCase();
  if (lower.startsWith('flowchart') ||
      lower.startsWith('graph') ||
      _looksLikeFlowchartEdge(firstMeaningfulLine)) {
    return MermaidDiagramKind.flowchart;
  }
  if (lower.startsWith('xychart')) {
    return MermaidDiagramKind.xyChart;
  }
  if (lower.startsWith('pie')) {
    return MermaidDiagramKind.pie;
  }
  if (lower.startsWith('quadrantchart')) {
    return MermaidDiagramKind.quadrant;
  }
  if (lower.startsWith('radar-beta')) {
    return MermaidDiagramKind.radar;
  }
  if (lower.startsWith('packet')) {
    return MermaidDiagramKind.packet;
  }
  if (lower.startsWith('sankey')) {
    return MermaidDiagramKind.sankey;
  }
  if (lower.startsWith('timeline')) {
    return MermaidDiagramKind.timeline;
  }
  if (lower.startsWith('mindmap')) {
    return MermaidDiagramKind.mindmap;
  }
  if (lower.startsWith('kanban')) {
    return MermaidDiagramKind.kanban;
  }
  if (lower.startsWith('treemap-beta')) {
    return MermaidDiagramKind.treemap;
  }
  if (lower.startsWith('sequencediagram')) {
    return MermaidDiagramKind.sequence;
  }
  if (lower.startsWith('statediagram')) {
    return MermaidDiagramKind.state;
  }
  if (lower.startsWith('erdiagram')) {
    return MermaidDiagramKind.er;
  }
  if (lower.startsWith('journey')) {
    return MermaidDiagramKind.journey;
  }
  if (lower.startsWith('gitgraph')) {
    return MermaidDiagramKind.gitGraph;
  }
  if (lower.startsWith('venn-beta')) {
    return MermaidDiagramKind.venn;
  }
  if (lower.startsWith('swimlane-beta')) {
    return MermaidDiagramKind.swimlanes;
  }
  if (lower.startsWith('classdiagram')) {
    return MermaidDiagramKind.classDiagram;
  }
  if (lower.startsWith('gantt')) {
    return MermaidDiagramKind.gantt;
  }
  if (lower.startsWith('requirementdiagram')) {
    return MermaidDiagramKind.requirement;
  }
  if (lower.startsWith('c4context') ||
      lower.startsWith('c4container') ||
      lower.startsWith('c4component') ||
      lower.startsWith('c4dynamic') ||
      lower.startsWith('c4deployment')) {
    return MermaidDiagramKind.c4;
  }
  if (lower.startsWith('zenuml')) {
    return MermaidDiagramKind.zenUml;
  }
  if (lower.startsWith('block-beta')) {
    return MermaidDiagramKind.block;
  }
  if (lower.startsWith('architecture-beta')) {
    return MermaidDiagramKind.architecture;
  }
  if (lower.startsWith('eventmodeling')) {
    return MermaidDiagramKind.eventModeling;
  }
  if (lower.startsWith('ishikawa-beta')) {
    return MermaidDiagramKind.ishikawa;
  }
  if (lower.startsWith('wardley-beta')) {
    return MermaidDiagramKind.wardley;
  }
  if (lower.startsWith('cynefin-beta')) {
    return MermaidDiagramKind.cynefin;
  }
  if (lower.startsWith('treeview-beta')) {
    return MermaidDiagramKind.treeView;
  }

  final unsupported = <String, MermaidDiagramKind>{
    'unsupporteddiagram': MermaidDiagramKind.classDiagram,
  };

  for (final entry in unsupported.entries) {
    if (lower.startsWith(entry.key)) {
      throw UnsupportedDiagramError(entry.value);
    }
  }

  throw MermaidParseError(
      'Unsupported Mermaid diagram header: $firstMeaningfulLine');
}

bool _looksLikeFlowchartEdge(String line) {
  return line.contains('-->') ||
      line.contains('---') ||
      line.contains('-.->') ||
      line.contains('==>') ||
      line.contains('<-->');
}

extension _IterableFirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
