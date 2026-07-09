import '../error/mermaid_error.dart';
import '../ir/diagram_kind.dart';
import '../ir/edge.dart';
import '../ir/graph.dart';
import '../ir/node.dart';
import '../ir/relationship_diagrams.dart';
import '../ir/style.dart';
import '../ir/structured_diagrams.dart';
import 'flowchart_parser.dart';
import 'parser.dart';

ParseOutput parseSequenceDiagram(String source) {
  final lines = _meaningfulLines(source);
  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }
  if (!lines.first.toLowerCase().startsWith('sequencediagram')) {
    throw MermaidParseError(
        'Expected sequenceDiagram header, got: ${lines.first}');
  }

  final participants = <String, SequenceParticipant>{};
  final messages = <SequenceMessage>[];

  void addParticipant(String id, [String? label]) {
    participants.putIfAbsent(
      id,
      () => SequenceParticipant(id: id, label: label ?? id),
    );
  }

  for (final line in lines.skip(1)) {
    final participant = RegExp(
      r'^(?:participant|actor)\s+([A-Za-z0-9_.$-]+)(?:\s+as\s+(.+))?$',
      caseSensitive: false,
    ).firstMatch(line);
    if (participant != null) {
      addParticipant(
        participant.group(1)!,
        _stripQuotes(participant.group(2) ?? participant.group(1)!),
      );
      continue;
    }

    final message = RegExp(
      r'^(.+?)\s*(<<-->>|<<->>|-->>|->>|--x|-x|--\)|-\)|-->|->)\s*(.+?)\s*:\s*(.+)$',
    ).firstMatch(line);
    if (message == null) continue;
    final from = _stripQuotes(message.group(1)!);
    final arrow = message.group(2)!;
    final to = _stripQuotes(message.group(3)!);
    addParticipant(from);
    addParticipant(to);
    messages.add(SequenceMessage(
      from: from,
      to: to,
      text: _stripQuotes(message.group(4)!),
      dotted: arrow.startsWith('--') || arrow == '<<-->>',
      bidirectional: arrow.startsWith('<<'),
    ));
  }

  if (participants.isEmpty || messages.isEmpty) {
    throw const MermaidParseError(
      'sequenceDiagram requires participants and messages',
    );
  }

  return ParseOutput(
    graph: Graph(
      kind: MermaidDiagramKind.sequence,
      sequenceDiagram: SequenceDiagram(
        participants: participants.values.toList(),
        messages: messages,
      ),
    ),
  );
}

ParseOutput parseStateDiagram(String source) {
  final lines = _meaningfulLines(source);
  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }
  final header = lines.first.toLowerCase();
  if (!header.startsWith('statediagram')) {
    throw MermaidParseError(
        'Expected stateDiagram header, got: ${lines.first}');
  }

  final graph = Graph(kind: MermaidDiagramKind.state);
  for (final line in lines.skip(1)) {
    final stateAs = RegExp(
      r'^state\s+"?([^"]+)"?\s+as\s+([A-Za-z0-9_-]+)$',
      caseSensitive: false,
    ).firstMatch(line);
    if (stateAs != null) {
      graph.addNode(Node(
        id: stateAs.group(2)!,
        label: _stripQuotes(stateAs.group(1)!),
        shape: NodeShape.roundRect,
      ));
      continue;
    }

    final state = RegExp(r'^state\s+([A-Za-z0-9_-]+)$', caseSensitive: false)
        .firstMatch(line);
    if (state != null) {
      final id = state.group(1)!;
      graph.addNode(Node(id: id, label: id, shape: NodeShape.roundRect));
      continue;
    }

    if (!line.contains('-->')) {
      final description =
          RegExp(r'^([A-Za-z0-9_-]+)\s*:\s*(.+)$').firstMatch(line);
      if (description != null) {
        graph.addNode(Node(
          id: description.group(1)!,
          label: _stripQuotes(description.group(2)!),
          shape: NodeShape.roundRect,
        ));
      }
      continue;
    }

    final parts = line.split('-->');
    if (parts.length < 2) continue;
    final fromToken = parts.first.trim();
    final right = parts.sublist(1).join('-->');
    final separator = right.indexOf(':');
    final toToken =
        separator < 0 ? right.trim() : right.substring(0, separator).trim();
    final label =
        separator < 0 ? null : _stripQuotes(right.substring(separator + 1));
    final from = _stateNode(fromToken, isStart: true);
    final to = _stateNode(toToken, isStart: false);
    graph
      ..addNode(from)
      ..addNode(to)
      ..addEdge(Edge(from: from.id, to: to.id, label: label));
  }

  if (graph.nodes.isEmpty) {
    throw const MermaidParseError('stateDiagram requires at least one state');
  }

  return ParseOutput(graph: graph);
}

ParseOutput parseErDiagram(String source) {
  final lines = _meaningfulLines(source);
  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }
  if (!lines.first.toLowerCase().startsWith('erdiagram')) {
    throw MermaidParseError('Expected erDiagram header, got: ${lines.first}');
  }

  final graph = Graph(kind: MermaidDiagramKind.er);
  for (final line in lines.skip(1)) {
    final relationship = RegExp(
      r'^([A-Za-z][A-Za-z0-9_-]*)\s+([|o}{]{2})--([|o}{]{2})\s+([A-Za-z][A-Za-z0-9_-]*)(?:\s*:\s*(.+))?$',
    ).firstMatch(line);
    if (relationship == null) continue;
    final from = relationship.group(1)!;
    final left = relationship.group(2)!;
    final right = relationship.group(3)!;
    final to = relationship.group(4)!;
    final relation = _stripQuotes(relationship.group(5) ?? '');
    final label = relation.isEmpty ? '$left $right' : '$left $relation $right';
    graph
      ..addNode(Node(id: from, label: from, shape: NodeShape.rectangle))
      ..addNode(Node(id: to, label: to, shape: NodeShape.rectangle))
      ..addEdge(Edge(
        from: from,
        to: to,
        label: label,
        arrowEnd: false,
      ));
  }

  if (graph.edges.isEmpty) {
    throw const MermaidParseError(
        'erDiagram requires at least one relationship');
  }

  return ParseOutput(graph: graph);
}

ParseOutput parseJourneyDiagram(String source) {
  final lines = _meaningfulLines(source);
  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }
  if (!lines.first.toLowerCase().startsWith('journey')) {
    throw MermaidParseError('Expected journey header, got: ${lines.first}');
  }

  String? title;
  final sections = <JourneySection>[];
  JourneySection? currentSection;

  for (final line in lines.skip(1)) {
    final lower = line.toLowerCase();
    if (lower.startsWith('title')) {
      title = _stripQuotes(line.substring('title'.length));
      continue;
    }
    if (lower.startsWith('section')) {
      currentSection = JourneySection(
        title: _stripQuotes(line.substring('section'.length)),
      );
      sections.add(currentSection);
      continue;
    }

    final parts = line.split(':');
    if (parts.length < 3) continue;
    final score = int.tryParse(parts[1].trim());
    if (score == null || score < 1 || score > 5) {
      throw MermaidParseError('Journey score must be between 1 and 5: $line');
    }
    currentSection ??= JourneySection(title: 'Journey');
    if (!sections.contains(currentSection)) {
      sections.add(currentSection);
    }
    currentSection.tasks.add(JourneyTask(
      name: _stripQuotes(parts.first),
      score: score,
      actors: parts
          .sublist(2)
          .join(':')
          .split(',')
          .map(_stripQuotes)
          .where((actor) => actor.isNotEmpty)
          .toList(),
    ));
  }

  if (sections.every((section) => section.tasks.isEmpty)) {
    throw const MermaidParseError('journey requires at least one task');
  }

  return ParseOutput(
    graph: Graph(
      kind: MermaidDiagramKind.journey,
      journeyDiagram: JourneyDiagram(title: title, sections: sections),
    ),
  );
}

ParseOutput parseGitGraphDiagram(String source) {
  final lines = _meaningfulLines(source);
  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }
  if (!lines.first.toLowerCase().startsWith('gitgraph')) {
    throw MermaidParseError('Expected gitGraph header, got: ${lines.first}');
  }

  final branches = <String>['main'];
  final commits = <GitGraphCommit>[];
  final merges = <GitGraphMerge>[];
  var currentBranch = 'main';
  var order = 0;

  void addBranch(String branch) {
    if (!branches.contains(branch)) {
      branches.add(branch);
    }
  }

  for (final line in lines.skip(1)) {
    final lower = line.toLowerCase();
    if (lower.startsWith('branch ')) {
      currentBranch = _firstToken(line.substring('branch'.length));
      addBranch(currentBranch);
    } else if (lower.startsWith('checkout ') || lower.startsWith('switch ')) {
      currentBranch = _firstToken(line.substring(line.indexOf(' ') + 1));
      addBranch(currentBranch);
    } else if (lower.startsWith('commit')) {
      final id = _optionValue(line, 'id') ?? 'c${commits.length + 1}';
      commits.add(GitGraphCommit(
        branch: currentBranch,
        label: id,
        order: order++,
      ));
    } else if (lower.startsWith('merge ')) {
      final sourceBranch = _firstToken(line.substring('merge'.length));
      addBranch(sourceBranch);
      merges.add(GitGraphMerge(
        fromBranch: sourceBranch,
        toBranch: currentBranch,
        order: order++,
      ));
    }
  }

  if (commits.isEmpty && merges.isEmpty) {
    throw const MermaidParseError('gitGraph requires commits or merges');
  }

  return ParseOutput(
    graph: Graph(
      kind: MermaidDiagramKind.gitGraph,
      gitGraphDiagram: GitGraphDiagram(
        branches: branches,
        commits: commits,
        merges: merges,
      ),
    ),
  );
}

ParseOutput parseVennDiagram(String source) {
  final lines = _meaningfulLines(source);
  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }
  if (!lines.first.toLowerCase().startsWith('venn-beta')) {
    throw MermaidParseError('Expected venn-beta header, got: ${lines.first}');
  }

  final sets = <VennSet>[];
  final unions = <VennUnion>[];
  for (final line in lines.skip(1)) {
    final lower = line.toLowerCase();
    if (lower.startsWith('set ')) {
      final parsed = _parseVennEntry(line.substring('set'.length));
      sets.add(VennSet(
        id: parsed.ids.single,
        label: parsed.label ?? parsed.ids.single,
        size: parsed.size,
      ));
    } else if (lower.startsWith('union ')) {
      final parsed = _parseVennEntry(line.substring('union'.length));
      if (parsed.ids.length < 2) {
        throw MermaidParseError('Venn union needs at least two sets: $line');
      }
      unions.add(VennUnion(
        ids: parsed.ids,
        label: parsed.label ?? parsed.ids.join(' & '),
        size: parsed.size,
      ));
    }
  }

  if (sets.isEmpty) {
    throw const MermaidParseError('venn-beta requires at least one set');
  }

  return ParseOutput(
    graph: Graph(
      kind: MermaidDiagramKind.venn,
      vennDiagram: VennDiagram(sets: sets, unions: unions),
    ),
  );
}

ParseOutput parseSwimlaneDiagram(String source) {
  final lines = _meaningfulLines(source);
  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }
  final header = lines.first.toLowerCase();
  if (!header.startsWith('swimlane-beta')) {
    throw MermaidParseError(
        'Expected swimlane-beta header, got: ${lines.first}');
  }
  final direction =
      lines.first.split(RegExp(r'\s+')).skip(1).firstOrNull ?? 'TD';
  final flowchart = [
    'flowchart $direction',
    for (final line in lines.skip(1))
      if (!_isBlockBoundary(line)) line,
  ].join('\n');
  final output = parseFlowchart(flowchart);
  output.graph.kind = MermaidDiagramKind.swimlanes;
  return output;
}

ParseOutput parseClassDiagram(String source) {
  final lines = _meaningfulLines(source);
  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }
  if (!lines.first.toLowerCase().startsWith('classdiagram')) {
    throw MermaidParseError(
        'Expected classDiagram header, got: ${lines.first}');
  }

  final graph = Graph(kind: MermaidDiagramKind.classDiagram);
  for (final line in lines.skip(1)) {
    final classStart = RegExp(r'^class\s+([A-Za-z_][\w-]*)').firstMatch(line);
    if (classStart != null) {
      final id = classStart.group(1)!;
      graph.addNode(Node(id: id, label: id, shape: NodeShape.subroutine));
      continue;
    }
    final relation = RegExp(
      r'^([A-Za-z_][\w-]*)\s+([<|*o.-]+|--|<\|--)\s+([A-Za-z_][\w-]*)(?:\s*:\s*(.+))?$',
    ).firstMatch(line);
    if (relation == null) continue;
    final from = relation.group(1)!;
    final operator = relation.group(2)!;
    final to = relation.group(3)!;
    final label = _stripQuotes(relation.group(4) ?? operator);
    graph
      ..addNode(Node(id: from, label: from, shape: NodeShape.subroutine))
      ..addNode(Node(id: to, label: to, shape: NodeShape.subroutine))
      ..addEdge(Edge(from: from, to: to, label: label));
  }

  if (graph.nodes.isEmpty) {
    throw const MermaidParseError('classDiagram requires at least one class');
  }
  return ParseOutput(graph: graph);
}

ParseOutput parseGanttDiagram(String source) {
  final lines = _meaningfulLines(source);
  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }
  if (!lines.first.toLowerCase().startsWith('gantt')) {
    throw MermaidParseError('Expected gantt header, got: ${lines.first}');
  }

  String? title;
  final sections = <GanttSection>[];
  GanttSection? currentSection;
  for (final line in lines.skip(1)) {
    final lower = line.toLowerCase();
    if (lower.startsWith('title')) {
      title = _stripQuotes(line.substring('title'.length));
    } else if (lower.startsWith('section')) {
      currentSection = GanttSection(
        title: _stripQuotes(line.substring('section'.length)),
      );
      sections.add(currentSection);
    } else if (lower.startsWith('dateformat') ||
        lower.startsWith('axisformat') ||
        lower.startsWith('excludes') ||
        lower.startsWith('tickinterval')) {
      continue;
    } else if (line.contains(':')) {
      currentSection ??= GanttSection(title: 'Tasks');
      if (!sections.contains(currentSection)) {
        sections.add(currentSection);
      }
      final parts = line.split(':');
      final taskArgs = parts.sublist(1).join(':').split(',');
      currentSection.tasks.add(GanttTask(
        label: _stripQuotes(parts.first),
        status: taskArgs.map((part) => part.trim()).firstWhereOrNull(
              (part) => part == 'done' || part == 'active' || part == 'crit',
            ),
      ));
    }
  }

  if (sections.every((section) => section.tasks.isEmpty)) {
    throw const MermaidParseError('gantt requires at least one task');
  }
  return ParseOutput(
    graph: Graph(
      kind: MermaidDiagramKind.gantt,
      ganttDiagram: GanttDiagram(title: title, sections: sections),
    ),
  );
}

ParseOutput parseRequirementDiagram(String source) {
  final lines = _meaningfulLines(source);
  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }
  if (!lines.first.toLowerCase().startsWith('requirementdiagram')) {
    throw MermaidParseError(
      'Expected requirementDiagram header, got: ${lines.first}',
    );
  }

  final graph = Graph(kind: MermaidDiagramKind.requirement);
  for (final line in lines.skip(1)) {
    final block = RegExp(
            r'^(requirement|functionalRequirement|element)\s+([A-Za-z_][\w-]*)')
        .firstMatch(line);
    if (block != null) {
      final id = block.group(2)!;
      graph.addNode(Node(
        id: id,
        label: id,
        shape: block.group(1) == 'element'
            ? NodeShape.rectangle
            : NodeShape.hexagon,
      ));
      continue;
    }
    final relation = RegExp(
      r'^([A-Za-z_][\w-]*)\s+-\s+([A-Za-z_][\w-]*)\s+->\s+([A-Za-z_][\w-]*)$',
    ).firstMatch(line);
    if (relation == null) continue;
    final from = relation.group(1)!;
    final label = relation.group(2)!;
    final to = relation.group(3)!;
    graph
      ..addNode(Node(id: from, label: from))
      ..addNode(Node(id: to, label: to))
      ..addEdge(Edge(from: from, to: to, label: label));
  }

  if (graph.nodes.isEmpty) {
    throw const MermaidParseError('requirementDiagram requires nodes');
  }
  return ParseOutput(graph: graph);
}

ParseOutput parseC4Diagram(String source) {
  final lines = _meaningfulLines(source);
  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }
  if (!lines.first.toLowerCase().startsWith('c4')) {
    throw MermaidParseError('Expected C4 header, got: ${lines.first}');
  }

  final graph = Graph(kind: MermaidDiagramKind.c4);
  for (final line in lines.skip(1)) {
    final node = RegExp(
      r'^(Person|System|Container|Component|Boundary|System_Boundary)\(([^,]+),\s*"([^"]+)"',
      caseSensitive: false,
    ).firstMatch(line);
    if (node != null) {
      final id = node.group(2)!.trim();
      graph.addNode(Node(
        id: id,
        label: node.group(3)!,
        shape: node.group(1)!.toLowerCase().contains('person')
            ? NodeShape.stadium
            : NodeShape.roundRect,
      ));
      continue;
    }
    final relation = RegExp(
      r'^Rel\(([^,]+),\s*([^,]+),\s*"([^"]+)"',
      caseSensitive: false,
    ).firstMatch(line);
    if (relation == null) continue;
    final from = relation.group(1)!.trim();
    final to = relation.group(2)!.trim();
    graph
      ..addNode(Node(id: from, label: from))
      ..addNode(Node(id: to, label: to))
      ..addEdge(Edge(from: from, to: to, label: relation.group(3)!));
  }

  if (graph.nodes.isEmpty) {
    throw const MermaidParseError('C4 diagram requires people or systems');
  }
  return ParseOutput(graph: graph);
}

ParseOutput parseZenUmlDiagram(String source) {
  final lines = _meaningfulLines(source);
  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }
  if (!lines.first.toLowerCase().startsWith('zenuml')) {
    throw MermaidParseError('Expected zenuml header, got: ${lines.first}');
  }
  final sequenceSource = [
    'sequenceDiagram',
    for (final line in lines.skip(1))
      if (!line.toLowerCase().startsWith('title')) line,
  ].join('\n');
  final output = parseSequenceDiagram(sequenceSource);
  output.graph.kind = MermaidDiagramKind.zenUml;
  return output;
}

ParseOutput parseBlockDiagram(String source) {
  final lines = _meaningfulLines(source);
  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }
  if (!lines.first.toLowerCase().startsWith('block-beta')) {
    throw MermaidParseError('Expected block-beta header, got: ${lines.first}');
  }

  final graph = Graph(kind: MermaidDiagramKind.block);
  for (final line in lines.skip(1)) {
    if (line.toLowerCase().startsWith('columns')) continue;
    final edge = RegExp(r'^([A-Za-z_][\w-]*)\s*-->\s*([A-Za-z_][\w-]*)$')
        .firstMatch(line);
    if (edge != null) {
      final from = edge.group(1)!;
      final to = edge.group(2)!;
      graph
        ..addNode(Node(id: from, label: from, shape: NodeShape.roundRect))
        ..addNode(Node(id: to, label: to, shape: NodeShape.roundRect))
        ..addEdge(Edge(from: from, to: to));
      continue;
    }
    for (final node in _parseBracketNodes(line)) {
      graph.addNode(node);
    }
  }

  if (graph.nodes.isEmpty) {
    throw const MermaidParseError('block-beta requires at least one block');
  }
  return ParseOutput(graph: graph);
}

ParseOutput parseArchitectureDiagram(String source) {
  final lines = _meaningfulLines(source);
  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }
  if (!lines.first.toLowerCase().startsWith('architecture-beta')) {
    throw MermaidParseError(
      'Expected architecture-beta header, got: ${lines.first}',
    );
  }

  final graph = Graph(kind: MermaidDiagramKind.architecture);
  for (final line in lines.skip(1)) {
    final service = RegExp(
      r'^service\s+([A-Za-z_][\w-]*)\([^)]+\)\s*\[([^\]]+)\]',
      caseSensitive: false,
    ).firstMatch(line);
    if (service != null) {
      graph.addNode(Node(
        id: service.group(1)!,
        label: service.group(2)!,
        shape: NodeShape.roundRect,
      ));
      continue;
    }
    final group = RegExp(
      r'^group\s+([A-Za-z_][\w-]*)\([^)]+\)\s*\[([^\]]+)\]',
      caseSensitive: false,
    ).firstMatch(line);
    if (group != null) {
      graph.addNode(Node(
        id: group.group(1)!,
        label: group.group(2)!,
        shape: NodeShape.subroutine,
      ));
      continue;
    }
    final edge = RegExp(r'^([A-Za-z_][\w-]*):\w+\s+--\s+\w+:([A-Za-z_][\w-]*)$')
        .firstMatch(line);
    if (edge == null) continue;
    final from = edge.group(1)!;
    final to = edge.group(2)!;
    graph
      ..addNode(Node(id: from, label: from, shape: NodeShape.roundRect))
      ..addNode(Node(id: to, label: to, shape: NodeShape.roundRect))
      ..addEdge(Edge(from: from, to: to, arrowEnd: false));
  }

  if (graph.nodes.isEmpty) {
    throw const MermaidParseError('architecture-beta requires services');
  }
  return ParseOutput(graph: graph);
}

ParseOutput parseEventModelingDiagram(String source) {
  final lines = _meaningfulLines(source);
  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }
  if (!lines.first.toLowerCase().startsWith('eventmodeling')) {
    throw MermaidParseError(
        'Expected eventmodeling header, got: ${lines.first}');
  }

  final graph = Graph(kind: MermaidDiagramKind.eventModeling);
  String? previous;
  for (final line in lines.skip(1)) {
    final parts = line.split(RegExp(r'\s+'));
    if (parts.length < 4 || parts.first.toLowerCase() != 'tf') continue;
    final id = '${parts[2]}-${parts[1]}';
    final label = parts.sublist(3).join(' ');
    final shape = switch (parts[2].toLowerCase()) {
      'cmd' => NodeShape.hexagon,
      'evt' => NodeShape.stadium,
      'ui' => NodeShape.roundRect,
      _ => NodeShape.rectangle,
    };
    graph.addNode(Node(id: id, label: label, shape: shape));
    if (previous != null) {
      graph.addEdge(Edge(from: previous, to: id));
    }
    previous = id;
  }

  if (graph.nodes.isEmpty) {
    throw const MermaidParseError('eventmodeling requires timeline facts');
  }
  return ParseOutput(graph: graph);
}

ParseOutput parseIshikawaDiagram(String source) {
  final root = _parseSimpleTree(
    source: source,
    header: 'ishikawa-beta',
    errorName: 'ishikawa-beta',
  );
  return ParseOutput(
    graph: Graph(
      kind: MermaidDiagramKind.ishikawa,
      ishikawaDiagram: MindmapDiagram(root: root),
    ),
  );
}

ParseOutput parseWardleyDiagram(String source) {
  final lines = _meaningfulLines(source);
  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }
  if (!lines.first.toLowerCase().startsWith('wardley-beta')) {
    throw MermaidParseError(
        'Expected wardley-beta header, got: ${lines.first}');
  }

  String? title;
  final components = <WardleyComponent>[];
  final links = <WardleyLink>[];
  for (final line in lines.skip(1)) {
    final lower = line.toLowerCase();
    if (lower.startsWith('title')) {
      title = _stripQuotes(line.substring('title'.length));
    } else if (lower.startsWith('component ') || lower.startsWith('anchor ')) {
      final match = RegExp(
        r'^(component|anchor)\s+([^\[]+)\[([0-9.]+)\s*,\s*([0-9.]+)\]',
        caseSensitive: false,
      ).firstMatch(line);
      if (match == null) continue;
      final label = _stripQuotes(match.group(2)!);
      final id = _slug(label);
      components.add(WardleyComponent(
        id: id,
        label: label,
        evolution: double.parse(match.group(3)!),
        visibility: double.parse(match.group(4)!),
        anchor: match.group(1)!.toLowerCase() == 'anchor',
      ));
    } else if (line.contains('->')) {
      final parts = line.split('->');
      links.add(WardleyLink(from: _slug(parts.first), to: _slug(parts.last)));
    }
  }

  if (components.isEmpty) {
    throw const MermaidParseError('wardley-beta requires components');
  }
  return ParseOutput(
    graph: Graph(
      kind: MermaidDiagramKind.wardley,
      wardleyMapDiagram: WardleyMapDiagram(
        title: title,
        components: components,
        links: links,
      ),
    ),
  );
}

ParseOutput parseCynefinDiagram(String source) {
  final lines = _meaningfulLines(source);
  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }
  if (!lines.first.toLowerCase().startsWith('cynefin-beta')) {
    throw MermaidParseError(
        'Expected cynefin-beta header, got: ${lines.first}');
  }

  final domains = <String, List<String>>{};
  String? currentDomain;
  const knownDomains = {
    'clear',
    'complicated',
    'complex',
    'chaotic',
    'disorder',
    'confusion',
  };
  for (final line in lines.skip(1)) {
    final lower = line.toLowerCase();
    if (lower.startsWith('title')) {
      continue;
    }
    if (knownDomains.contains(lower)) {
      currentDomain = lower == 'confusion' ? 'disorder' : lower;
      domains.putIfAbsent(currentDomain, () => <String>[]);
    } else {
      currentDomain ??= 'disorder';
      domains.putIfAbsent(currentDomain, () => <String>[]);
      domains[currentDomain]!.add(_stripQuotes(line));
    }
  }

  if (domains.values.every((items) => items.isEmpty)) {
    throw const MermaidParseError('cynefin-beta requires domain items');
  }
  return ParseOutput(
    graph: Graph(
      kind: MermaidDiagramKind.cynefin,
      cynefinDiagram: CynefinDiagram(domains: domains),
    ),
  );
}

ParseOutput parseTreeViewDiagram(String source) {
  final root = _parseSimpleTree(
    source: source,
    header: 'treeview-beta',
    errorName: 'treeView-beta',
  );
  return ParseOutput(
    graph: Graph(
      kind: MermaidDiagramKind.treeView,
      treeViewDiagram: MindmapDiagram(root: root),
    ),
  );
}

List<String> _meaningfulLines(String source) {
  return source
      .split('\n')
      .map((line) {
        final comment = line.indexOf('%%');
        return comment < 0 ? line.trim() : line.substring(0, comment).trim();
      })
      .where((line) => line.isNotEmpty)
      .toList();
}

List<String> _meaningfulRawLines(String source) {
  return source
      .split('\n')
      .map((line) {
        final comment = line.indexOf('%%');
        return comment < 0 ? line : line.substring(0, comment);
      })
      .where((line) => line.trim().isNotEmpty)
      .toList();
}

bool _isBlockBoundary(String line) {
  final lower = line.toLowerCase();
  return lower.startsWith('subgraph') || lower == 'end';
}

String _stripQuotes(String value) {
  final trimmed = value.trim();
  if (trimmed.length >= 2 && trimmed.startsWith('"') && trimmed.endsWith('"')) {
    return trimmed.substring(1, trimmed.length - 1);
  }
  return trimmed;
}

int _indentOf(String line) {
  return line.length - line.trimLeft().length;
}

Node _stateNode(String token, {required bool isStart}) {
  final id = token == '[*]'
      ? isStart
          ? '__state_start'
          : '__state_end'
      : _stripQuotes(token);
  if (token == '[*]') {
    return Node(
      id: id,
      label: isStart ? 'Start' : 'End',
      shape: isStart ? NodeShape.circle : NodeShape.doubleCircle,
    );
  }
  return Node(id: id, label: id, shape: NodeShape.roundRect);
}

List<Node> _parseBracketNodes(String line) {
  final nodes = <Node>[];
  final matches = RegExp(r'([A-Za-z_][\w-]*)\s*\[([^\]]+)\]').allMatches(line);
  for (final match in matches) {
    nodes.add(Node(
      id: match.group(1)!,
      label: _stripQuotes(match.group(2)!),
      shape: NodeShape.roundRect,
    ));
  }
  return nodes;
}

MindmapNode _parseSimpleTree({
  required String source,
  required String header,
  required String errorName,
}) {
  final lines = _meaningfulRawLines(source);
  if (lines.isEmpty) {
    throw const MermaidParseError('Diagram source is empty');
  }
  if (!lines.first.trim().toLowerCase().startsWith(header)) {
    throw MermaidParseError('Expected $errorName header, got: ${lines.first}');
  }

  final stack = <({int indent, MindmapNode node})>[];
  MindmapNode? root;
  for (final rawLine in lines.skip(1)) {
    final line = rawLine.trim();
    if (line.isEmpty) continue;
    final indent = _indentOf(rawLine);
    final node = MindmapNode(label: _cleanTreeLabel(line));
    while (stack.isNotEmpty && stack.last.indent >= indent) {
      stack.removeLast();
    }
    if (stack.isEmpty) {
      root ??= node;
    } else {
      stack.last.node.children.add(node);
    }
    stack.add((indent: indent, node: node));
  }

  if (root == null) {
    throw MermaidParseError('$errorName requires a root node');
  }
  return root;
}

String _cleanTreeLabel(String line) {
  var label = _stripQuotes(line);
  label = label.replaceAll(RegExp(r':::[A-Za-z0-9_\s-]+$'), '').trim();
  if (label.endsWith('/')) {
    label = label.substring(0, label.length - 1);
  }
  return label;
}

String _firstToken(String source) {
  final trimmed = _stripQuotes(source.trim());
  final space = trimmed.indexOf(' ');
  return space < 0 ? trimmed : trimmed.substring(0, space);
}

String? _optionValue(String line, String option) {
  final quoted = RegExp('$option:\\s*"([^"]+)"').firstMatch(line);
  if (quoted != null) return quoted.group(1);
  final bare = RegExp('$option:\\s*([^\\s]+)').firstMatch(line);
  return bare?.group(1);
}

String _slug(String source) {
  final value = _stripQuotes(source.trim());
  return value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');
}

({List<String> ids, String? label, double size}) _parseVennEntry(
    String source) {
  var body = source.trim();
  var size = 1.0;
  final sizeMatch = RegExp(r':\s*([0-9]+(?:\.[0-9]+)?)\s*$').firstMatch(body);
  if (sizeMatch != null) {
    size = double.parse(sizeMatch.group(1)!);
    body = body.substring(0, sizeMatch.start).trim();
  }

  String? label;
  final labelMatch = RegExp(r'\[(.+)\]\s*$').firstMatch(body);
  if (labelMatch != null) {
    label = _stripQuotes(labelMatch.group(1)!);
    body = body.substring(0, labelMatch.start).trim();
  }

  final ids = _splitWords(body).map(_stripQuotes).where((id) {
    return id.isNotEmpty;
  }).toList();
  if (ids.isEmpty) {
    throw MermaidParseError('Missing Venn set id: $source');
  }
  return (ids: ids, label: label, size: size);
}

List<String> _splitWords(String source) {
  final words = <String>[];
  final buffer = StringBuffer();
  var inQuotes = false;
  for (var i = 0; i < source.length; i++) {
    final char = source[i];
    if (char == '"') {
      inQuotes = !inQuotes;
      buffer.write(char);
    } else if (char.trim().isEmpty && !inQuotes) {
      if (buffer.isNotEmpty) {
        words.add(buffer.toString());
        buffer.clear();
      }
    } else {
      buffer.write(char);
    }
  }
  if (buffer.isNotEmpty) {
    words.add(buffer.toString());
  }
  return words;
}

extension _IterableFirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }

  T? firstWhereOrNull(bool Function(T value) test) {
    for (final value in this) {
      if (test(value)) return value;
    }
    return null;
  }
}
