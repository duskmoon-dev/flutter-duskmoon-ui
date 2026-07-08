import '../error/mermaid_error.dart';
import '../ir/graph.dart';
import 'diagram_detector.dart';
import 'flowchart_parser.dart';

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
    _ => parseFlowchart(source),
  };
}
