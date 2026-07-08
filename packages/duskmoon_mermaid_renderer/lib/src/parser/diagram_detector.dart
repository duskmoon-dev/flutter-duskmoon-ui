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

  final unsupported = <String, MermaidDiagramKind>{
    'sequencediagram': MermaidDiagramKind.sequence,
    'classdiagram': MermaidDiagramKind.classDiagram,
    'statediagram': MermaidDiagramKind.state,
    'statediagram-v2': MermaidDiagramKind.state,
    'erdiagram': MermaidDiagramKind.er,
    'pie': MermaidDiagramKind.pie,
    'mindmap': MermaidDiagramKind.mindmap,
    'journey': MermaidDiagramKind.journey,
    'timeline': MermaidDiagramKind.timeline,
    'gantt': MermaidDiagramKind.gantt,
    'gitgraph': MermaidDiagramKind.gitGraph,
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
