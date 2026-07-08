import '../error/mermaid_error.dart';
import '../ir/direction.dart';
import '../ir/edge.dart';
import '../ir/graph.dart';
import '../ir/node.dart';
import '../ir/style.dart';
import 'parser.dart';

ParseOutput parseFlowchart(String source) {
  final graph = Graph();
  final diagnostics = <MermaidDiagnostic>[];
  var hasHeader = false;

  final lines = source.split('\n');
  for (var index = 0; index < lines.length; index++) {
    final lineNumber = index + 1;
    var line = lines[index].trim();
    if (line.isEmpty) continue;

    if (line.startsWith('%%{')) {
      if (!line.endsWith('}%%')) {
        throw MermaidParseError(
          'Invalid init directive',
          line: lineNumber,
          column: 1,
        );
      }
      diagnostics.add(MermaidDiagnostic(
        'Init directive ignored',
        line: lineNumber,
        column: 1,
      ));
      continue;
    }

    if (line.startsWith('%%')) continue;
    line = _stripLineEnding(line);
    if (line.isEmpty) continue;

    final header = _parseHeader(line);
    if (header != null) {
      graph.direction = header;
      hasHeader = true;
      continue;
    }

    final edge = _parseEdge(line, lineNumber);
    if (edge != null) {
      graph
        ..addNode(edge.fromNode)
        ..addNode(edge.toNode)
        ..addEdge(edge.edge);
      continue;
    }

    final node = _parseNode(line);
    if (node != null) {
      graph.addNode(node);
      continue;
    }

    if (!hasHeader) {
      throw MermaidParseError(
        'Expected a flowchart statement',
        line: lineNumber,
        column: 1,
      );
    }

    throw MermaidParseError(
      'Unsupported flowchart statement: $line',
      line: lineNumber,
      column: 1,
    );
  }

  if (graph.nodes.isEmpty && graph.edges.isEmpty) {
    throw const MermaidParseError('Flowchart has no nodes or edges');
  }

  return ParseOutput(graph: graph, diagnostics: diagnostics);
}

MermaidDirection? _parseHeader(String line) {
  final match =
      RegExp(r'^(flowchart|graph)\s+([A-Za-z]{2})\s*$').firstMatch(line);
  if (match == null) return null;
  return directionFromToken(match.group(2)!);
}

_ParsedEdge? _parseEdge(String line, int lineNumber) {
  final spacedLabel =
      RegExp(r'^(.+?)\s+--\s+(.+?)\s+-->\s+(.+)$').firstMatch(line);
  if (spacedLabel != null) {
    return _buildEdge(
      spacedLabel.group(1)!,
      spacedLabel.group(3)!,
      lineNumber,
      style: EdgeStyle.solid,
      label: spacedLabel.group(2)!.trim(),
      arrowEnd: true,
    );
  }

  final pipeLabel =
      RegExp(r'^(.+?)\s*(<-->|-\.\->|==>|-->|---)\|([^|]+)\|\s*(.+)$')
          .firstMatch(line);
  if (pipeLabel != null) {
    final operator = pipeLabel.group(2)!;
    return _buildEdge(
      pipeLabel.group(1)!,
      pipeLabel.group(4)!,
      lineNumber,
      style: _edgeStyle(operator),
      label: pipeLabel.group(3)!.trim(),
      arrowStart: operator == '<-->',
      arrowEnd: operator != '---',
    );
  }

  final plain =
      RegExp(r'^(.+?)\s*(<-->|-\.\->|==>|-->|---)\s*(.+)$').firstMatch(line);
  if (plain == null) return null;

  final operator = plain.group(2)!;
  return _buildEdge(
    plain.group(1)!,
    plain.group(3)!,
    lineNumber,
    style: _edgeStyle(operator),
    arrowStart: operator == '<-->',
    arrowEnd: operator != '---',
  );
}

_ParsedEdge _buildEdge(
  String fromSource,
  String toSource,
  int lineNumber, {
  required EdgeStyle style,
  String? label,
  bool arrowStart = false,
  bool arrowEnd = true,
}) {
  final fromNode = _parseNode(fromSource);
  final toNode = _parseNode(toSource);
  if (fromNode == null || toNode == null) {
    throw MermaidParseError(
      'Invalid edge endpoint',
      line: lineNumber,
      column: 1,
    );
  }
  return _ParsedEdge(
    fromNode: fromNode,
    toNode: toNode,
    edge: Edge(
      from: fromNode.id,
      to: toNode.id,
      label: label?.isEmpty ?? true ? null : label,
      style: style,
      arrowStart: arrowStart,
      arrowEnd: arrowEnd,
    ),
  );
}

EdgeStyle _edgeStyle(String operator) {
  return switch (operator) {
    '-.->' => EdgeStyle.dotted,
    '==>' => EdgeStyle.thick,
    _ => EdgeStyle.solid,
  };
}

Node? _parseNode(String source) {
  final value = _stripLineEnding(source.trim());
  if (value.isEmpty) return null;

  final idMatch = RegExp(r'^([A-Za-z_][\w-]*)(.*)$').firstMatch(value);
  if (idMatch == null) return null;

  final id = idMatch.group(1)!;
  final shapeSource = idMatch.group(2)!.trim();
  if (shapeSource.isEmpty) {
    return Node(id: id, label: id);
  }

  final parsedShape = _parseShape(shapeSource);
  if (parsedShape == null) return null;
  return Node(id: id, label: parsedShape.label, shape: parsedShape.shape);
}

_ParsedShape? _parseShape(String source) {
  const slash = '/';
  const backslash = r'\';

  if (source.startsWith('(((') && source.endsWith(')))')) {
    return _ParsedShape(
      _inner(source, 3, 3),
      NodeShape.doubleCircle,
    );
  }
  if (source.startsWith('((') && source.endsWith('))')) {
    return _ParsedShape(_inner(source, 2, 2), NodeShape.circle);
  }
  if (source.startsWith('([') && source.endsWith('])')) {
    return _ParsedShape(_inner(source, 2, 2), NodeShape.stadium);
  }
  if (source.startsWith('[[') && source.endsWith(']]')) {
    return _ParsedShape(_inner(source, 2, 2), NodeShape.subroutine);
  }
  if (source.startsWith('[(') && source.endsWith(')]')) {
    return _ParsedShape(_inner(source, 2, 2), NodeShape.cylinder);
  }
  if (source.startsWith('{{') && source.endsWith('}}')) {
    return _ParsedShape(_inner(source, 2, 2), NodeShape.hexagon);
  }
  if (source.startsWith('{') && source.endsWith('}')) {
    return _ParsedShape(_inner(source, 1, 1), NodeShape.diamond);
  }
  if (source.startsWith('[$slash') && source.endsWith('$slash]')) {
    return _ParsedShape(_inner(source, 2, 2), NodeShape.parallelogram);
  }
  if (source.startsWith('[$backslash') && source.endsWith('$backslash]')) {
    return _ParsedShape(_inner(source, 2, 2), NodeShape.parallelogramAlt);
  }
  if (source.startsWith('[$slash') && source.endsWith('$backslash]')) {
    return _ParsedShape(_inner(source, 2, 2), NodeShape.trapezoid);
  }
  if (source.startsWith('[$backslash') && source.endsWith('$slash]')) {
    return _ParsedShape(_inner(source, 2, 2), NodeShape.trapezoidAlt);
  }
  if (source.startsWith('[') && source.endsWith(']')) {
    return _ParsedShape(_inner(source, 1, 1), NodeShape.rectangle);
  }
  if (source.startsWith('(') && source.endsWith(')')) {
    return _ParsedShape(_inner(source, 1, 1), NodeShape.roundRect);
  }
  return null;
}

String _inner(String source, int startTrim, int endTrim) {
  return source.substring(startTrim, source.length - endTrim).trim();
}

String _stripLineEnding(String line) {
  return line.endsWith(';')
      ? line.substring(0, line.length - 1).trimRight()
      : line;
}

class _ParsedEdge {
  const _ParsedEdge({
    required this.fromNode,
    required this.toNode,
    required this.edge,
  });

  final Node fromNode;
  final Node toNode;
  final Edge edge;
}

class _ParsedShape {
  const _ParsedShape(this.label, this.shape);

  final String label;
  final NodeShape shape;
}
