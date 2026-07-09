import '../error/mermaid_error.dart';
import '../ir/diagram_kind.dart';
import '../ir/graph.dart';
import '../ir/structured_diagrams.dart';
import 'parser.dart';

ParseOutput parsePacketDiagram(String source) {
  final lines = _meaningfulRawLines(source);
  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }
  if (!lines.first.trim().toLowerCase().startsWith('packet')) {
    throw MermaidParseError('Expected packet header, got: ${lines.first}');
  }

  final fields = <PacketField>[];
  var cursor = 0;
  for (final rawLine in lines.skip(1)) {
    final line = _stripComment(rawLine).trim();
    if (line.isEmpty) continue;
    final separator = line.indexOf(':');
    if (separator <= 0) continue;

    final range = line.substring(0, separator).trim();
    final label = _stripQuotes(line.substring(separator + 1));
    int start;
    int end;
    if (range.startsWith('+')) {
      final count = int.tryParse(range.substring(1).trim());
      if (count == null || count <= 0) {
        throw MermaidParseError('Invalid packet bit count: $range');
      }
      start = cursor;
      end = cursor + count - 1;
    } else if (range.contains('-')) {
      final parts = range.split('-');
      start = int.tryParse(parts.first.trim()) ?? -1;
      end = int.tryParse(parts.last.trim()) ?? -1;
    } else {
      start = int.tryParse(range) ?? -1;
      end = start;
    }
    if (start < 0 || end < start || label.isEmpty) {
      throw MermaidParseError('Invalid packet field: $line');
    }
    fields.add(PacketField(start: start, end: end, label: label));
    cursor = end + 1;
  }

  if (fields.isEmpty) {
    throw const MermaidParseError('packet requires at least one field');
  }

  return ParseOutput(
    graph: Graph(
      kind: MermaidDiagramKind.packet,
      packetDiagram: PacketDiagram(fields: fields),
    ),
  );
}

ParseOutput parseSankeyDiagram(String source) {
  final lines = _meaningfulLines(source);
  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }
  if (!lines.first.toLowerCase().startsWith('sankey')) {
    throw MermaidParseError('Expected sankey header, got: ${lines.first}');
  }

  final links = <SankeyLink>[];
  for (final line in lines.skip(1)) {
    if (!line.contains(',')) continue;
    final columns = _splitCsv(line);
    if (columns.length != 3) {
      throw MermaidParseError('sankey rows require source,target,value: $line');
    }
    final value = double.tryParse(columns[2]);
    if (value == null || value <= 0) {
      throw MermaidParseError('Invalid sankey value: ${columns[2]}');
    }
    links.add(SankeyLink(
      source: columns[0],
      target: columns[1],
      value: value,
    ));
  }

  if (links.isEmpty) {
    throw const MermaidParseError('sankey requires at least one link');
  }

  return ParseOutput(
    graph: Graph(
      kind: MermaidDiagramKind.sankey,
      sankeyDiagram: SankeyDiagram(links: links),
    ),
  );
}

ParseOutput parseTimelineDiagram(String source) {
  final lines = _meaningfulLines(source);
  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }
  final header = lines.first.toLowerCase();
  if (!header.startsWith('timeline')) {
    throw MermaidParseError('Expected timeline header, got: ${lines.first}');
  }

  final direction = header.contains('td')
      ? TimelineDirection.topDown
      : TimelineDirection.leftRight;
  String? title;
  String? section;
  final periods = <TimelinePeriod>[];
  TimelinePeriod? current;

  for (final line in lines.skip(1)) {
    final lower = line.toLowerCase();
    if (lower.startsWith('title')) {
      title = _stripQuotes(line.substring('title'.length));
    } else if (lower.startsWith('section')) {
      section = _stripQuotes(line.substring('section'.length));
    } else if (line.startsWith(':')) {
      final event = _stripQuotes(line.substring(1));
      if (current != null && event.isNotEmpty) {
        current.events.add(event);
      }
    } else if (line.contains(':')) {
      final parts = line.split(':');
      final period = _stripQuotes(parts.first);
      final events = parts.skip(1).map(_stripQuotes).where((event) {
        return event.isNotEmpty;
      }).toList();
      if (period.isEmpty || events.isEmpty) continue;
      current = TimelinePeriod(
        section: section,
        period: period,
        events: events,
      );
      periods.add(current);
    }
  }

  if (periods.isEmpty) {
    throw const MermaidParseError('timeline requires at least one period');
  }

  return ParseOutput(
    graph: Graph(
      kind: MermaidDiagramKind.timeline,
      timelineDiagram: TimelineDiagram(
        title: title,
        direction: direction,
        periods: periods,
      ),
    ),
  );
}

ParseOutput parseMindmapDiagram(String source) {
  final lines = _meaningfulRawLines(source);
  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }
  if (!lines.first.trim().toLowerCase().startsWith('mindmap')) {
    throw MermaidParseError('Expected mindmap header, got: ${lines.first}');
  }

  final root = _parseIndentTree(
    lines: lines.skip(1),
    nodeFactory: (label) => MindmapNode(label: _cleanNodeLabel(label)),
    addChild: (parent, child) => parent.children.add(child),
  );
  if (root == null) {
    throw const MermaidParseError('mindmap requires a root node');
  }

  return ParseOutput(
    graph: Graph(
      kind: MermaidDiagramKind.mindmap,
      mindmapDiagram: MindmapDiagram(root: root),
    ),
  );
}

ParseOutput parseKanbanDiagram(String source) {
  final lines = _meaningfulRawLines(source);
  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }
  if (!lines.first.trim().toLowerCase().startsWith('kanban')) {
    throw MermaidParseError('Expected kanban header, got: ${lines.first}');
  }

  final itemLines = <({String rawLine, ({String id, String label}) item})>[];
  for (final rawLine in lines.skip(1)) {
    final item = _parseBracketItem(rawLine.trim());
    if (item != null) {
      itemLines.add((rawLine: rawLine, item: item));
    }
  }
  final baseIndent = itemLines
      .map((entry) => _indentOf(entry.rawLine))
      .fold<int?>(null, (minIndent, indent) {
    return minIndent == null || indent < minIndent ? indent : minIndent;
  });

  final columns = <KanbanColumn>[];
  KanbanColumn? currentColumn;
  for (final entry in itemLines) {
    final parsed = entry.item;
    final indent = _indentOf(entry.rawLine) - (baseIndent ?? 0);
    if (indent == 0) {
      currentColumn = KanbanColumn(id: parsed.id, title: parsed.label);
      columns.add(currentColumn);
    } else if (currentColumn != null) {
      currentColumn.tasks.add(KanbanTask(
        id: parsed.id,
        title: parsed.label,
      ));
    }
  }

  if (columns.isEmpty) {
    throw const MermaidParseError('kanban requires at least one column');
  }

  return ParseOutput(
    graph: Graph(
      kind: MermaidDiagramKind.kanban,
      kanbanDiagram: KanbanDiagram(columns: columns),
    ),
  );
}

ParseOutput parseTreemapDiagram(String source) {
  final lines = _meaningfulRawLines(source);
  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }
  if (!lines.first.trim().toLowerCase().startsWith('treemap-beta')) {
    throw MermaidParseError(
        'Expected treemap-beta header, got: ${lines.first}');
  }

  final roots = _parseTreemapNodes(lines.skip(1));
  if (roots.isEmpty) {
    throw const MermaidParseError('treemap-beta requires at least one node');
  }

  return ParseOutput(
    graph: Graph(
      kind: MermaidDiagramKind.treemap,
      treemapDiagram: TreemapDiagram(roots: roots),
    ),
  );
}

List<String> _meaningfulLines(String source) {
  return source
      .split('\n')
      .map((line) => _stripComment(line).trim())
      .where((line) => line.isNotEmpty)
      .toList();
}

List<String> _meaningfulRawLines(String source) {
  return source
      .split('\n')
      .map(_stripComment)
      .where((line) => line.trim().isNotEmpty)
      .toList();
}

String _stripComment(String line) {
  final comment = line.indexOf('%%');
  return comment < 0 ? line : line.substring(0, comment);
}

int _indentOf(String line) {
  return line.length - line.trimLeft().length;
}

String _stripQuotes(String value) {
  final trimmed = value.trim();
  if (trimmed.length >= 2 && trimmed.startsWith('"') && trimmed.endsWith('"')) {
    return trimmed.substring(1, trimmed.length - 1);
  }
  return trimmed;
}

List<String> _splitCsv(String line) {
  final values = <String>[];
  final buffer = StringBuffer();
  var inQuotes = false;

  for (var i = 0; i < line.length; i++) {
    final char = line[i];
    if (char == '"') {
      if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
        buffer.write('"');
        i++;
      } else {
        inQuotes = !inQuotes;
      }
    } else if (char == ',' && !inQuotes) {
      values.add(buffer.toString().trim());
      buffer.clear();
    } else {
      buffer.write(char);
    }
  }
  values.add(buffer.toString().trim());
  return values;
}

T? _parseIndentTree<T>({
  required Iterable<String> lines,
  required T Function(String label) nodeFactory,
  required void Function(T parent, T child) addChild,
}) {
  final stack = <({int indent, T node})>[];
  T? root;
  for (final rawLine in lines) {
    final label = rawLine.trim();
    if (label.isEmpty) continue;
    final indent = _indentOf(rawLine);
    final node = nodeFactory(label);

    while (stack.isNotEmpty && stack.last.indent >= indent) {
      stack.removeLast();
    }
    if (stack.isEmpty) {
      root ??= node;
    } else {
      addChild(stack.last.node, node);
    }
    stack.add((indent: indent, node: node));
  }
  return root;
}

String _cleanNodeLabel(String source) {
  var label = _stripQuotes(source.trim());
  label = label.replaceAll(RegExp(r':::[A-Za-z0-9_\s-]+$'), '').trim();
  label = label.replaceAll(RegExp(r'::icon\([^)]*\)$'), '').trim();
  final shaped = RegExp(
    r'^[A-Za-z0-9_-]+(?:\(\((.+)\)\)|\[(.+)\]|\((.+)\)|\{(.+)\})$',
  ).firstMatch(label);
  if (shaped != null) {
    for (var i = 1; i <= 4; i++) {
      final group = shaped.group(i);
      if (group != null) return _stripQuotes(group);
    }
  }
  return label;
}

({String id, String label})? _parseBracketItem(String line) {
  final match = RegExp(r'^([A-Za-z0-9_-]+)\s*\[(.+)\]').firstMatch(line);
  if (match == null) return null;
  return (
    id: match.group(1)!.trim(),
    label: _stripQuotes(match.group(2)!.trim()),
  );
}

List<TreemapNode> _parseTreemapNodes(Iterable<String> lines) {
  final roots = <TreemapNode>[];
  final stack = <({int indent, TreemapNode node})>[];
  for (final rawLine in lines) {
    final line = rawLine.trim();
    if (line.isEmpty) continue;
    final node = _parseTreemapNode(line);
    final indent = _indentOf(rawLine);
    while (stack.isNotEmpty && stack.last.indent >= indent) {
      stack.removeLast();
    }
    if (stack.isEmpty) {
      roots.add(node);
    } else {
      stack.last.node.children.add(node);
    }
    stack.add((indent: indent, node: node));
  }
  return roots;
}

TreemapNode _parseTreemapNode(String line) {
  final classIndex = line.indexOf(':::');
  final clean = classIndex < 0 ? line : line.substring(0, classIndex).trim();
  final separator = clean.lastIndexOf(':');
  if (separator > 0) {
    final label = _stripQuotes(clean.substring(0, separator));
    final value = double.tryParse(clean.substring(separator + 1).trim());
    if (value != null && value > 0) {
      return TreemapNode(label: label, value: value);
    }
  }
  return TreemapNode(label: _stripQuotes(clean));
}
