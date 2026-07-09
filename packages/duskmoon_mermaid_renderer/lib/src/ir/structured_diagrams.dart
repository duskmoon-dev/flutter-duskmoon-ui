class PacketDiagram {
  const PacketDiagram({required this.fields});

  final List<PacketField> fields;
}

class PacketField {
  const PacketField({
    required this.start,
    required this.end,
    required this.label,
  });

  final int start;
  final int end;
  final String label;

  int get bitCount => end - start + 1;
}

class SankeyDiagram {
  const SankeyDiagram({required this.links});

  final List<SankeyLink> links;
}

class SankeyLink {
  const SankeyLink({
    required this.source,
    required this.target,
    required this.value,
  });

  final String source;
  final String target;
  final double value;
}

class TimelineDiagram {
  const TimelineDiagram({
    required this.periods,
    this.title,
    this.direction = TimelineDirection.leftRight,
  });

  final String? title;
  final TimelineDirection direction;
  final List<TimelinePeriod> periods;
}

enum TimelineDirection {
  leftRight,
  topDown,
}

class TimelinePeriod {
  const TimelinePeriod({
    required this.period,
    required this.events,
    this.section,
  });

  final String? section;
  final String period;
  final List<String> events;
}

class MindmapDiagram {
  const MindmapDiagram({required this.root});

  final MindmapNode root;
}

class MindmapNode {
  MindmapNode({
    required this.label,
    List<MindmapNode>? children,
  }) : children = children ?? <MindmapNode>[];

  final String label;
  final List<MindmapNode> children;
}

class KanbanDiagram {
  const KanbanDiagram({required this.columns});

  final List<KanbanColumn> columns;
}

class KanbanColumn {
  KanbanColumn({
    required this.id,
    required this.title,
    List<KanbanTask>? tasks,
  }) : tasks = tasks ?? <KanbanTask>[];

  final String id;
  final String title;
  final List<KanbanTask> tasks;
}

class KanbanTask {
  const KanbanTask({
    required this.id,
    required this.title,
  });

  final String id;
  final String title;
}

class TreemapDiagram {
  const TreemapDiagram({required this.roots});

  final List<TreemapNode> roots;
}

class TreemapNode {
  TreemapNode({
    required this.label,
    this.value,
    List<TreemapNode>? children,
  }) : children = children ?? <TreemapNode>[];

  final String label;
  final double? value;
  final List<TreemapNode> children;

  double get totalValue {
    if (value != null) return value!;
    final total = children.fold<double>(
      0,
      (sum, child) => sum + child.totalValue,
    );
    return total == 0 ? 1 : total;
  }
}
