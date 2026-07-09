class SequenceDiagram {
  const SequenceDiagram({
    required this.participants,
    required this.messages,
  });

  final List<SequenceParticipant> participants;
  final List<SequenceMessage> messages;
}

class SequenceParticipant {
  const SequenceParticipant({
    required this.id,
    required this.label,
  });

  final String id;
  final String label;
}

class SequenceMessage {
  const SequenceMessage({
    required this.from,
    required this.to,
    required this.text,
    this.dotted = false,
    this.bidirectional = false,
  });

  final String from;
  final String to;
  final String text;
  final bool dotted;
  final bool bidirectional;
}

class JourneyDiagram {
  const JourneyDiagram({
    this.title,
    required this.sections,
  });

  final String? title;
  final List<JourneySection> sections;
}

class JourneySection {
  JourneySection({
    required this.title,
    List<JourneyTask>? tasks,
  }) : tasks = tasks ?? <JourneyTask>[];

  final String title;
  final List<JourneyTask> tasks;
}

class JourneyTask {
  const JourneyTask({
    required this.name,
    required this.score,
    required this.actors,
  });

  final String name;
  final int score;
  final List<String> actors;
}

class GitGraphDiagram {
  const GitGraphDiagram({
    required this.branches,
    required this.commits,
    required this.merges,
  });

  final List<String> branches;
  final List<GitGraphCommit> commits;
  final List<GitGraphMerge> merges;
}

class GitGraphCommit {
  const GitGraphCommit({
    required this.branch,
    required this.label,
    required this.order,
  });

  final String branch;
  final String label;
  final int order;
}

class GitGraphMerge {
  const GitGraphMerge({
    required this.fromBranch,
    required this.toBranch,
    required this.order,
  });

  final String fromBranch;
  final String toBranch;
  final int order;
}

class VennDiagram {
  const VennDiagram({
    required this.sets,
    required this.unions,
  });

  final List<VennSet> sets;
  final List<VennUnion> unions;
}

class VennSet {
  const VennSet({
    required this.id,
    required this.label,
    this.size = 1,
  });

  final String id;
  final String label;
  final double size;
}

class VennUnion {
  const VennUnion({
    required this.ids,
    required this.label,
    this.size = 1,
  });

  final List<String> ids;
  final String label;
  final double size;
}

class GanttDiagram {
  const GanttDiagram({
    this.title,
    required this.sections,
  });

  final String? title;
  final List<GanttSection> sections;
}

class GanttSection {
  GanttSection({
    required this.title,
    List<GanttTask>? tasks,
  }) : tasks = tasks ?? <GanttTask>[];

  final String title;
  final List<GanttTask> tasks;
}

class GanttTask {
  const GanttTask({
    required this.label,
    this.status,
  });

  final String label;
  final String? status;
}

class WardleyMapDiagram {
  const WardleyMapDiagram({
    this.title,
    required this.components,
    required this.links,
  });

  final String? title;
  final List<WardleyComponent> components;
  final List<WardleyLink> links;
}

class WardleyComponent {
  const WardleyComponent({
    required this.id,
    required this.label,
    required this.evolution,
    required this.visibility,
    this.anchor = false,
  });

  final String id;
  final String label;
  final double evolution;
  final double visibility;
  final bool anchor;
}

class WardleyLink {
  const WardleyLink({
    required this.from,
    required this.to,
  });

  final String from;
  final String to;
}

class CynefinDiagram {
  const CynefinDiagram({
    required this.domains,
  });

  final Map<String, List<String>> domains;
}
