import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../config/layout_config.dart';
import '../ir/relationship_diagrams.dart';
import '../ir/structured_diagrams.dart';
import '../ir/style.dart';
import '../layout/layout_types.dart';
import '../theme/theme.dart';
import 'mermaid_scene.dart';
import 'scene_edge.dart';
import 'scene_label.dart';
import 'scene_node.dart';
import 'scene_path.dart';

MermaidScene buildPacketDiagramScene(
  PacketDiagram diagram,
  MermaidLayoutConfig config,
  MermaidTheme theme,
  MermaidTextMeasurer textMeasurer,
) {
  const bitsPerRow = 32;
  const width = 620.0;
  const rowHeight = 72.0;
  final maxBit = diagram.fields.map((field) => field.end).reduce(math.max);
  final rows = maxBit ~/ bitsPerRow + 1;
  final height = 52 + rows * rowHeight;
  final plot = Rect.fromLTWH(40, 34, 540, rows * rowHeight);
  final bitWidth = plot.width / bitsPerRow;
  final nodes = <SceneNode>[];
  final labels = <SceneLabel>[];
  final edges = <SceneEdge>[];
  final style = _textStyle(config);

  for (var row = 0; row < rows; row++) {
    labels.add(_measuredLabel(
      '${row * bitsPerRow}',
      Rect.fromLTWH(plot.left - 28, plot.top + row * rowHeight + 2, 28, 18),
      theme.textColor,
      style,
      textMeasurer,
    ));
  }

  for (var i = 0; i < diagram.fields.length; i++) {
    final field = diagram.fields[i];
    final firstRow = field.start ~/ bitsPerRow;
    final lastRow = field.end ~/ bitsPerRow;
    for (var row = firstRow; row <= lastRow; row++) {
      final rowStart = row * bitsPerRow;
      final start = math.max(field.start, rowStart);
      final end = math.min(field.end, rowStart + bitsPerRow - 1);
      final rect = Rect.fromLTWH(
        plot.left + (start - rowStart) * bitWidth,
        plot.top + row * rowHeight,
        (end - start + 1) * bitWidth,
        46,
      );
      _addNode(
        nodes: nodes,
        labels: labels,
        id: 'packet-$i-$row',
        label: field.label,
        rect: rect,
        shape: NodeShape.rectangle,
        fill: _seriesColor(theme, i).withAlpha(70),
        stroke: _seriesColor(theme, i),
        textColor: theme.textColor,
      );
      labels.add(_measuredLabel(
        '${field.start}-${field.end}',
        Rect.fromCenter(
          center: Offset(rect.center.dx, rect.bottom + 14),
          width: rect.width,
          height: 18,
        ),
        theme.textColor.withAlpha(180),
        style,
        textMeasurer,
      ));
    }
  }

  return MermaidScene(
    size: Size(width, height),
    nodes: nodes,
    edges: edges,
    labels: labels,
  );
}

MermaidScene buildSankeyDiagramScene(
  SankeyDiagram diagram,
  MermaidLayoutConfig config,
  MermaidTheme theme,
  MermaidTextMeasurer textMeasurer,
) {
  final nodes = <SceneNode>[];
  final labels = <SceneLabel>[];
  final edges = <SceneEdge>[];
  final style = _textStyle(config);
  final depths = <String, int>{};
  for (final link in diagram.links) {
    depths.putIfAbsent(link.source, () => 0);
    depths.putIfAbsent(link.target, () => 0);
  }
  for (var pass = 0; pass < diagram.links.length + 1; pass++) {
    for (final link in diagram.links) {
      depths[link.target] = math.max(
        depths[link.target] ?? 0,
        (depths[link.source] ?? 0) + 1,
      );
    }
  }

  final byDepth = <int, List<String>>{};
  for (final entry in depths.entries) {
    byDepth.putIfAbsent(entry.value, () => <String>[]).add(entry.key);
  }
  final maxDepth = byDepth.keys.reduce(math.max);
  final maxRows = byDepth.values.map((items) => items.length).reduce(math.max);
  final width = math.max(560.0, 150.0 + maxDepth * 170.0);
  final height = math.max(280.0, 90.0 + maxRows * 70.0);
  final rects = <String, Rect>{};

  for (final entry in byDepth.entries) {
    final depth = entry.key;
    final names = entry.value..sort();
    final spacing = height / (names.length + 1);
    for (var i = 0; i < names.length; i++) {
      final x = 36 + depth * 170.0;
      final y = spacing * (i + 1) - 20;
      final rect = Rect.fromLTWH(x, y, 112, 40);
      rects[names[i]] = rect;
      _addNode(
        nodes: nodes,
        labels: labels,
        id: 'sankey-${names[i]}',
        label: names[i],
        rect: rect,
        shape: NodeShape.roundRect,
        fill: theme.nodeFill,
        stroke: _seriesColor(theme, depth),
        textColor: theme.textColor,
      );
    }
  }

  for (var i = 0; i < diagram.links.length; i++) {
    final link = diagram.links[i];
    final from = rects[link.source]!;
    final to = rects[link.target]!;
    final color = _seriesColor(theme, i);
    final label = _measuredLabel(
      _formatNumber(link.value),
      Rect.fromCenter(
        center: Offset((from.right + to.left) / 2,
            (from.center.dy + to.center.dy) / 2 - 12),
        width: 52,
        height: 20,
      ),
      color,
      style,
      textMeasurer,
    );
    labels.add(label);
    edges.add(SceneEdge(
      points: [
        from.centerRight,
        Offset((from.right + to.left) / 2, from.center.dy),
        Offset((from.right + to.left) / 2, to.center.dy),
        to.centerLeft,
      ],
      style: EdgeStyle.thick,
      color: color,
      arrowStart: false,
      arrowEnd: true,
      label: label,
    ));
  }

  return MermaidScene(
    size: Size(width, height),
    nodes: nodes,
    edges: edges,
    labels: labels,
  );
}

MermaidScene buildTimelineDiagramScene(
  TimelineDiagram diagram,
  MermaidLayoutConfig config,
  MermaidTheme theme,
  MermaidTextMeasurer textMeasurer,
) {
  return diagram.direction == TimelineDirection.topDown
      ? _buildTopDownTimeline(diagram, config, theme, textMeasurer)
      : _buildLeftRightTimeline(diagram, config, theme, textMeasurer);
}

MermaidScene buildMindmapDiagramScene(
  MindmapDiagram diagram,
  MermaidLayoutConfig config,
  MermaidTheme theme,
  MermaidTextMeasurer textMeasurer,
) {
  final nodes = <SceneNode>[];
  final labels = <SceneLabel>[];
  final edges = <SceneEdge>[];
  final positions = <MindmapNode, Offset>{};
  final depths = <MindmapNode, int>{};
  var leafCursor = 0;

  double layout(MindmapNode node, int depth) {
    depths[node] = depth;
    if (node.children.isEmpty) {
      final y = 48 + leafCursor * 72.0;
      leafCursor++;
      positions[node] = Offset(40 + depth * 150.0, y);
      return y;
    }
    final childYs = [
      for (final child in node.children) layout(child, depth + 1)
    ];
    final y = childYs.reduce((a, b) => a + b) / childYs.length;
    positions[node] = Offset(40 + depth * 150.0, y);
    return y;
  }

  layout(diagram.root, 0);
  final maxDepth = depths.values.reduce(math.max);
  final width = math.max(360.0, 210.0 + maxDepth * 150.0);
  final height = math.max(220.0, 96.0 + math.max(1, leafCursor) * 72.0);

  void add(MindmapNode node) {
    final origin = positions[node]!;
    final depth = depths[node]!;
    final rect = Rect.fromLTWH(origin.dx, origin.dy, 116, 42);
    _addNode(
      nodes: nodes,
      labels: labels,
      id: 'mindmap-${nodes.length}',
      label: node.label,
      rect: rect,
      shape: depth == 0 ? NodeShape.stadium : NodeShape.roundRect,
      fill: depth == 0 ? theme.edgeStroke.withAlpha(70) : theme.nodeFill,
      stroke: _seriesColor(theme, depth),
      textColor: theme.textColor,
    );
    for (final child in node.children) {
      final childRect =
          Rect.fromLTWH(positions[child]!.dx, positions[child]!.dy, 116, 42);
      edges.add(_line(
          rect.centerRight, childRect.centerLeft, _seriesColor(theme, depth)));
      add(child);
    }
  }

  add(diagram.root);
  return MermaidScene(
    size: Size(width, height),
    nodes: nodes,
    edges: edges,
    labels: labels,
  );
}

MermaidScene buildKanbanDiagramScene(
  KanbanDiagram diagram,
  MermaidLayoutConfig config,
  MermaidTheme theme,
  MermaidTextMeasurer textMeasurer,
) {
  final nodes = <SceneNode>[];
  final labels = <SceneLabel>[];
  final paths = <ScenePath>[];
  const columnWidth = 170.0;
  final height = math.max(
    240.0,
    92.0 +
        diagram.columns
                .map((column) => column.tasks.length)
                .fold<int>(0, math.max) *
            58.0,
  );
  final width = 36.0 + diagram.columns.length * (columnWidth + 16);

  for (var columnIndex = 0;
      columnIndex < diagram.columns.length;
      columnIndex++) {
    final column = diagram.columns[columnIndex];
    final x = 24 + columnIndex * (columnWidth + 16);
    final background = Rect.fromLTWH(x, 24, columnWidth, height - 48);
    paths.add(ScenePath(
      path: Path()
        ..addRRect(
            RRect.fromRectAndRadius(background, const Radius.circular(8))),
      fillColor: theme.nodeFill.withAlpha(80),
      strokeColor: theme.nodeStroke.withAlpha(90),
    ));
    _addNode(
      nodes: nodes,
      labels: labels,
      id: 'kanban-column-${column.id}',
      label: column.title,
      rect: Rect.fromLTWH(x + 10, 36, columnWidth - 20, 36),
      shape: NodeShape.roundRect,
      fill: _seriesColor(theme, columnIndex).withAlpha(80),
      stroke: _seriesColor(theme, columnIndex),
      textColor: theme.textColor,
    );
    for (var taskIndex = 0; taskIndex < column.tasks.length; taskIndex++) {
      final task = column.tasks[taskIndex];
      _addNode(
        nodes: nodes,
        labels: labels,
        id: 'kanban-task-${task.id}',
        label: task.title,
        rect: Rect.fromLTWH(
          x + 12,
          88 + taskIndex * 58.0,
          columnWidth - 24,
          42,
        ),
        shape: NodeShape.roundRect,
        fill: theme.background.withAlpha(130),
        stroke: theme.nodeStroke.withAlpha(150),
        textColor: theme.textColor,
      );
    }
  }

  return MermaidScene(
    size: Size(width, height),
    nodes: nodes,
    edges: const [],
    labels: labels,
    paths: paths,
  );
}

MermaidScene buildTreemapDiagramScene(
  TreemapDiagram diagram,
  MermaidLayoutConfig config,
  MermaidTheme theme,
  MermaidTextMeasurer textMeasurer,
) {
  final nodes = <SceneNode>[];
  final labels = <SceneLabel>[];
  const size = Size(560, 360);
  final rootRect = Rect.fromLTWH(24, 24, size.width - 48, size.height - 48);
  _layoutTreemap(
    diagram.roots,
    rootRect,
    depth: 0,
    nodes: nodes,
    labels: labels,
    theme: theme,
  );
  return MermaidScene(
    size: size,
    nodes: nodes,
    edges: const [],
    labels: labels,
  );
}

MermaidScene buildSequenceDiagramScene(
  SequenceDiagram diagram,
  MermaidLayoutConfig config,
  MermaidTheme theme,
  MermaidTextMeasurer textMeasurer,
) {
  final nodes = <SceneNode>[];
  final labels = <SceneLabel>[];
  final edges = <SceneEdge>[];
  final style = _textStyle(config);
  const left = 70.0;
  const laneSpacing = 150.0;
  final width = math.max(
    360.0,
    left * 2 + (diagram.participants.length - 1) * laneSpacing,
  );
  final height = math.max(220.0, 116.0 + diagram.messages.length * 56.0);
  final xById = <String, double>{};

  for (var i = 0; i < diagram.participants.length; i++) {
    final participant = diagram.participants[i];
    final x = left + i * laneSpacing;
    xById[participant.id] = x;
    _addNode(
      nodes: nodes,
      labels: labels,
      id: 'sequence-participant-${participant.id}',
      label: participant.label,
      rect: Rect.fromCenter(center: Offset(x, 36), width: 112, height: 36),
      shape: NodeShape.roundRect,
      fill: theme.nodeFill,
      stroke: _seriesColor(theme, i),
      textColor: theme.textColor,
    );
    edges.add(SceneEdge(
      points: [Offset(x, 58), Offset(x, height - 30)],
      style: EdgeStyle.dotted,
      color: theme.nodeStroke.withAlpha(130),
      arrowStart: false,
      arrowEnd: false,
    ));
  }

  for (var i = 0; i < diagram.messages.length; i++) {
    final message = diagram.messages[i];
    final fromX = xById[message.from] ?? left;
    final toX = xById[message.to] ?? fromX;
    final y = 92 + i * 56.0;
    if (fromX == toX) {
      edges.add(SceneEdge(
        points: [
          Offset(fromX, y),
          Offset(fromX + 46, y),
          Offset(fromX + 46, y + 24),
          Offset(fromX, y + 24),
        ],
        style: message.dotted ? EdgeStyle.dotted : EdgeStyle.solid,
        color: _seriesColor(theme, i),
        arrowStart: false,
        arrowEnd: true,
      ));
    } else {
      edges.add(SceneEdge(
        points: [Offset(fromX, y), Offset(toX, y)],
        style: message.dotted ? EdgeStyle.dotted : EdgeStyle.solid,
        color: _seriesColor(theme, i),
        arrowStart: message.bidirectional,
        arrowEnd: true,
      ));
    }
    labels.add(_measuredLabel(
      message.text,
      Rect.fromCenter(
        center: Offset((fromX + toX) / 2, y - 14),
        width: math.max(96, (toX - fromX).abs() - 12),
        height: 20,
      ),
      theme.textColor,
      style,
      textMeasurer,
    ));
  }

  return MermaidScene(
    size: Size(width, height),
    nodes: nodes,
    edges: edges,
    labels: labels,
  );
}

MermaidScene buildJourneyDiagramScene(
  JourneyDiagram diagram,
  MermaidLayoutConfig config,
  MermaidTheme theme,
  MermaidTextMeasurer textMeasurer,
) {
  final nodes = <SceneNode>[];
  final labels = <SceneLabel>[];
  final paths = <ScenePath>[];
  final style = _textStyle(config);
  const width = 620.0;
  final taskCount = diagram.sections.fold<int>(
    0,
    (sum, section) => sum + section.tasks.length,
  );
  final height = math.max(
    220.0,
    64.0 + (diagram.title == null ? 0.0 : 34.0) + taskCount * 54.0,
  );
  var y = 24.0;
  if (diagram.title != null) {
    labels.add(_measuredLabel(
      diagram.title!,
      const Rect.fromLTWH(24, 16, width - 48, 28),
      theme.textColor,
      style,
      textMeasurer,
    ));
    y += 36;
  }

  for (var sectionIndex = 0;
      sectionIndex < diagram.sections.length;
      sectionIndex++) {
    final section = diagram.sections[sectionIndex];
    final sectionHeight = math.max(48.0, 36.0 + section.tasks.length * 54.0);
    final sectionRect = Rect.fromLTWH(20, y, width - 40, sectionHeight);
    paths.add(ScenePath(
      path: Path()
        ..addRRect(
          RRect.fromRectAndRadius(sectionRect, const Radius.circular(8)),
        ),
      fillColor: theme.nodeFill.withAlpha(70),
      strokeColor: theme.nodeStroke.withAlpha(90),
    ));
    labels.add(_measuredLabel(
      section.title,
      Rect.fromLTWH(36, y + 8, width - 72, 24),
      _seriesColor(theme, sectionIndex),
      style,
      textMeasurer,
    ));
    for (var taskIndex = 0; taskIndex < section.tasks.length; taskIndex++) {
      final task = section.tasks[taskIndex];
      final taskY = y + 38 + taskIndex * 54.0;
      _addNode(
        nodes: nodes,
        labels: labels,
        id: 'journey-task-$sectionIndex-$taskIndex',
        label: task.name,
        rect: Rect.fromLTWH(36, taskY, 260, 38),
        shape: NodeShape.roundRect,
        fill: theme.background.withAlpha(150),
        stroke: theme.nodeStroke.withAlpha(150),
        textColor: theme.textColor,
      );
      _addNode(
        nodes: nodes,
        labels: labels,
        id: 'journey-score-$sectionIndex-$taskIndex',
        label: '${task.score}/5',
        rect: Rect.fromLTWH(316, taskY + 3, 58, 32),
        shape: NodeShape.stadium,
        fill: _journeyScoreColor(theme, task.score).withAlpha(90),
        stroke: _journeyScoreColor(theme, task.score),
        textColor: theme.textColor,
      );
      labels.add(_measuredLabel(
        task.actors.join(', '),
        Rect.fromLTWH(396, taskY + 7, 184, 24),
        theme.textColor.withAlpha(190),
        style,
        textMeasurer,
      ));
    }
    y += sectionHeight + 12;
  }

  return MermaidScene(
    size: Size(width, height),
    nodes: nodes,
    edges: const [],
    labels: labels,
    paths: paths,
  );
}

MermaidScene buildGitGraphDiagramScene(
  GitGraphDiagram diagram,
  MermaidLayoutConfig config,
  MermaidTheme theme,
  MermaidTextMeasurer textMeasurer,
) {
  final nodes = <SceneNode>[];
  final labels = <SceneLabel>[];
  final edges = <SceneEdge>[];
  final style = _textStyle(config);
  final eventCount = math.max(
    1,
    diagram.commits.length + diagram.merges.length,
  );
  final width = math.max(500.0, 140.0 + eventCount * 88.0);
  final height = math.max(180.0, 74.0 + diagram.branches.length * 64.0);
  final branchY = <String, double>{};

  for (var i = 0; i < diagram.branches.length; i++) {
    final branch = diagram.branches[i];
    final y = 62 + i * 64.0;
    branchY[branch] = y;
    edges.add(_line(Offset(72, y), Offset(width - 40, y),
        _seriesColor(theme, i).withAlpha(150)));
    labels.add(_measuredLabel(
      branch,
      Rect.fromLTWH(16, y - 12, 52, 24),
      _seriesColor(theme, i),
      style,
      textMeasurer,
    ));
  }

  for (final commit in diagram.commits) {
    final y = branchY[commit.branch] ?? 62;
    final x = 98 + commit.order * 88.0;
    _addNode(
      nodes: nodes,
      labels: labels,
      id: 'git-commit-${commit.order}',
      label: commit.label,
      rect: Rect.fromCenter(center: Offset(x, y), width: 54, height: 34),
      shape: NodeShape.circle,
      fill: theme.background,
      stroke: _seriesColor(theme, diagram.branches.indexOf(commit.branch)),
      textColor: theme.textColor,
    );
  }

  for (final merge in diagram.merges) {
    final fromY = branchY[merge.fromBranch] ?? 62;
    final toY = branchY[merge.toBranch] ?? 62;
    final x = 98 + merge.order * 88.0;
    edges.add(SceneEdge(
      points: [Offset(x - 54, fromY), Offset(x, toY)],
      style: EdgeStyle.solid,
      color: theme.edgeStroke,
      arrowStart: false,
      arrowEnd: true,
    ));
    _addNode(
      nodes: nodes,
      labels: labels,
      id: 'git-merge-${merge.order}',
      label: 'merge',
      rect: Rect.fromCenter(center: Offset(x, toY), width: 58, height: 30),
      shape: NodeShape.diamond,
      fill: theme.nodeFill,
      stroke: theme.edgeStroke,
      textColor: theme.textColor,
    );
  }

  return MermaidScene(
    size: Size(width, height),
    nodes: nodes,
    edges: edges,
    labels: labels,
  );
}

MermaidScene buildVennDiagramScene(
  VennDiagram diagram,
  MermaidLayoutConfig config,
  MermaidTheme theme,
  MermaidTextMeasurer textMeasurer,
) {
  final labels = <SceneLabel>[];
  final paths = <ScenePath>[];
  final style = _textStyle(config);
  const size = Size(520, 320);
  final centers = _vennCenters(diagram.sets.length, size);
  final centerById = <String, Offset>{};

  for (var i = 0; i < diagram.sets.length; i++) {
    final set = diagram.sets[i];
    final center = centers[i];
    centerById[set.id] = center;
    final radius = (78 * math.sqrt(set.size)).clamp(58.0, 108.0).toDouble();
    final color = _seriesColor(theme, i);
    paths.add(ScenePath(
      path: Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
      fillColor: color.withAlpha(58),
      strokeColor: color,
      strokeWidth: 2,
    ));
    labels.add(_measuredLabel(
      set.label,
      Rect.fromCenter(center: center, width: radius * 1.4, height: 28),
      theme.textColor,
      style,
      textMeasurer,
    ));
  }

  for (final union in diagram.unions) {
    final points = [
      for (final id in union.ids)
        if (centerById[id] != null) centerById[id]!,
    ];
    if (points.length < 2) continue;
    final center = points.reduce((a, b) => a + b) / points.length.toDouble();
    labels.add(_measuredLabel(
      union.label,
      Rect.fromCenter(center: center.translate(0, 34), width: 150, height: 24),
      theme.textColor.withAlpha(210),
      style,
      textMeasurer,
    ));
  }

  return MermaidScene(
    size: size,
    nodes: const [],
    edges: const [],
    labels: labels,
    paths: paths,
  );
}

MermaidScene buildGanttDiagramScene(
  GanttDiagram diagram,
  MermaidLayoutConfig config,
  MermaidTheme theme,
  MermaidTextMeasurer textMeasurer,
) {
  final nodes = <SceneNode>[];
  final labels = <SceneLabel>[];
  final paths = <ScenePath>[];
  final style = _textStyle(config);
  const width = 640.0;
  final taskCount = diagram.sections.fold<int>(
    0,
    (sum, section) => sum + section.tasks.length,
  );
  final height = math.max(
    240.0,
    72.0 + (diagram.title == null ? 0.0 : 34.0) + taskCount * 44.0,
  );
  var y = 24.0;
  if (diagram.title != null) {
    labels.add(_measuredLabel(
      diagram.title!,
      const Rect.fromLTWH(24, 14, width - 48, 28),
      theme.textColor,
      style,
      textMeasurer,
    ));
    y += 36;
  }

  for (var sectionIndex = 0;
      sectionIndex < diagram.sections.length;
      sectionIndex++) {
    final section = diagram.sections[sectionIndex];
    labels.add(_measuredLabel(
      section.title,
      Rect.fromLTWH(28, y, 132, 24),
      _seriesColor(theme, sectionIndex),
      style,
      textMeasurer,
    ));
    y += 28;
    for (var taskIndex = 0; taskIndex < section.tasks.length; taskIndex++) {
      final task = section.tasks[taskIndex];
      final rowY = y + taskIndex * 44.0;
      labels.add(_measuredLabel(
        task.label,
        Rect.fromLTWH(28, rowY + 4, 160, 26),
        theme.textColor,
        style,
        textMeasurer,
      ));
      final start = 210.0 + (taskIndex % 3) * 32.0;
      final barWidth = 150.0 + ((taskIndex + sectionIndex) % 3) * 42.0;
      final barRect = Rect.fromLTWH(start, rowY + 6, barWidth, 24);
      paths.add(ScenePath(
        path: Path()
          ..addRRect(
            RRect.fromRectAndRadius(barRect, const Radius.circular(6)),
          ),
        fillColor: _ganttStatusColor(theme, task.status).withAlpha(90),
        strokeColor: _ganttStatusColor(theme, task.status),
      ));
      if (task.status != null) {
        labels.add(_measuredLabel(
          task.status!,
          Rect.fromLTWH(barRect.right + 8, rowY + 6, 58, 22),
          theme.textColor.withAlpha(190),
          style,
          textMeasurer,
        ));
      }
    }
    y += section.tasks.length * 44.0 + 8;
  }

  return MermaidScene(
    size: Size(width, height),
    nodes: nodes,
    edges: const [],
    labels: labels,
    paths: paths,
  );
}

MermaidScene buildIshikawaDiagramScene(
  MindmapDiagram diagram,
  MermaidLayoutConfig config,
  MermaidTheme theme,
  MermaidTextMeasurer textMeasurer,
) {
  return buildMindmapDiagramScene(diagram, config, theme, textMeasurer);
}

MermaidScene buildWardleyMapScene(
  WardleyMapDiagram diagram,
  MermaidLayoutConfig config,
  MermaidTheme theme,
  MermaidTextMeasurer textMeasurer,
) {
  final nodes = <SceneNode>[];
  final labels = <SceneLabel>[];
  final edges = <SceneEdge>[];
  final style = _textStyle(config);
  const width = 620.0;
  const height = 380.0;
  const plot = Rect.fromLTWH(64, 54, 500, 270);
  final centers = <String, Offset>{};

  if (diagram.title != null) {
    labels.add(_measuredLabel(
      diagram.title!,
      const Rect.fromLTWH(24, 16, width - 48, 26),
      theme.textColor,
      style,
      textMeasurer,
    ));
  }
  edges
    ..add(_line(plot.bottomLeft, plot.bottomRight, theme.nodeStroke))
    ..add(_line(plot.bottomLeft, plot.topLeft, theme.nodeStroke));
  labels
    ..add(_measuredLabel(
      'Genesis',
      Rect.fromLTWH(plot.left - 8, plot.bottom + 12, 72, 20),
      theme.textColor.withAlpha(170),
      style,
      textMeasurer,
    ))
    ..add(_measuredLabel(
      'Commodity',
      Rect.fromLTWH(plot.right - 76, plot.bottom + 12, 84, 20),
      theme.textColor.withAlpha(170),
      style,
      textMeasurer,
    ))
    ..add(_measuredLabel(
      'Visible',
      Rect.fromLTWH(plot.left - 58, plot.top - 4, 54, 20),
      theme.textColor.withAlpha(170),
      style,
      textMeasurer,
    ));

  for (var i = 0; i < diagram.components.length; i++) {
    final component = diagram.components[i];
    final center = Offset(
      plot.left + component.evolution.clamp(0.0, 1.0) * plot.width,
      plot.bottom - component.visibility.clamp(0.0, 1.0) * plot.height,
    );
    centers[component.id] = center;
    _addNode(
      nodes: nodes,
      labels: labels,
      id: 'wardley-${component.id}',
      label: component.label,
      rect: Rect.fromCenter(
        center: center,
        width: component.anchor ? 90 : 104,
        height: component.anchor ? 34 : 38,
      ),
      shape: component.anchor ? NodeShape.stadium : NodeShape.roundRect,
      fill: theme.nodeFill,
      stroke: _seriesColor(theme, i),
      textColor: theme.textColor,
    );
  }

  for (final link in diagram.links) {
    final from = centers[link.from];
    final to = centers[link.to];
    if (from == null || to == null) continue;
    edges.add(SceneEdge(
      points: [from, to],
      style: EdgeStyle.solid,
      color: theme.edgeStroke.withAlpha(150),
      arrowStart: false,
      arrowEnd: true,
    ));
  }

  return MermaidScene(
    size: const Size(width, height),
    nodes: nodes,
    edges: edges,
    labels: labels,
  );
}

MermaidScene buildCynefinDiagramScene(
  CynefinDiagram diagram,
  MermaidLayoutConfig config,
  MermaidTheme theme,
  MermaidTextMeasurer textMeasurer,
) {
  final nodes = <SceneNode>[];
  final labels = <SceneLabel>[];
  final paths = <ScenePath>[];
  final style = _textStyle(config);
  const size = Size(560, 360);
  final rects = <String, Rect>{
    'clear': const Rect.fromLTWH(300, 196, 216, 116),
    'complicated': const Rect.fromLTWH(44, 196, 216, 116),
    'complex': const Rect.fromLTWH(44, 48, 216, 116),
    'chaotic': const Rect.fromLTWH(300, 48, 216, 116),
    'disorder': const Rect.fromLTWH(216, 146, 128, 68),
  };
  var index = 0;
  for (final entry in rects.entries) {
    final rect = entry.value;
    final color = _seriesColor(theme, index++);
    paths.add(ScenePath(
      path: Path()
        ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8))),
      fillColor: color.withAlpha(42),
      strokeColor: color.withAlpha(180),
    ));
    labels.add(_measuredLabel(
      _titleCase(entry.key),
      Rect.fromLTWH(rect.left + 8, rect.top + 8, rect.width - 16, 24),
      color,
      style,
      textMeasurer,
    ));
    final items = diagram.domains[entry.key] ?? const <String>[];
    for (var i = 0; i < items.length; i++) {
      _addNode(
        nodes: nodes,
        labels: labels,
        id: 'cynefin-${entry.key}-$i',
        label: items[i],
        rect: Rect.fromLTWH(
            rect.left + 18, rect.top + 40 + i * 30, rect.width - 36, 24),
        shape: NodeShape.roundRect,
        fill: theme.background.withAlpha(140),
        stroke: color.withAlpha(180),
        textColor: theme.textColor,
      );
    }
  }

  return MermaidScene(
    size: size,
    nodes: nodes,
    edges: const [],
    labels: labels,
    paths: paths,
  );
}

MermaidScene buildTreeViewDiagramScene(
  MindmapDiagram diagram,
  MermaidLayoutConfig config,
  MermaidTheme theme,
  MermaidTextMeasurer textMeasurer,
) {
  return buildMindmapDiagramScene(diagram, config, theme, textMeasurer);
}

MermaidScene _buildLeftRightTimeline(
  TimelineDiagram diagram,
  MermaidLayoutConfig config,
  MermaidTheme theme,
  MermaidTextMeasurer textMeasurer,
) {
  final style = _textStyle(config);
  final nodes = <SceneNode>[];
  final labels = <SceneLabel>[];
  final edges = <SceneEdge>[];
  final titleHeight = diagram.title == null ? 0.0 : 36.0;
  final width = math.max(560.0, 120.0 + diagram.periods.length * 150.0);
  const height = 360.0;
  final axisY = titleHeight + 150;
  const startX = 54.0;
  final endX = width - 54;

  if (diagram.title != null) {
    labels.add(_measuredLabel(
      diagram.title!,
      Rect.fromLTWH(24, 18, width - 48, 28),
      theme.textColor,
      style,
      textMeasurer,
    ));
  }
  edges
      .add(_line(Offset(startX, axisY), Offset(endX, axisY), theme.nodeStroke));

  for (var i = 0; i < diagram.periods.length; i++) {
    final period = diagram.periods[i];
    final x = diagram.periods.length == 1
        ? width / 2
        : startX + (endX - startX) * i / (diagram.periods.length - 1);
    _addNode(
      nodes: nodes,
      labels: labels,
      id: 'timeline-period-$i',
      label: period.period,
      rect: Rect.fromCenter(center: Offset(x, axisY), width: 96, height: 32),
      shape: NodeShape.stadium,
      fill: _seriesColor(theme, i).withAlpha(82),
      stroke: _seriesColor(theme, i),
      textColor: theme.textColor,
    );
    for (var eventIndex = 0; eventIndex < period.events.length; eventIndex++) {
      final above = eventIndex.isEven;
      final eventY = axisY +
          (above ? -82.0 : 64.0) +
          (above ? -1 : 1) * (eventIndex ~/ 2) * 44.0;
      _addNode(
        nodes: nodes,
        labels: labels,
        id: 'timeline-event-$i-$eventIndex',
        label: period.events[eventIndex],
        rect: Rect.fromCenter(
          center: Offset(x, eventY),
          width: 126,
          height: 38,
        ),
        shape: NodeShape.roundRect,
        fill: theme.nodeFill,
        stroke: _seriesColor(theme, i).withAlpha(180),
        textColor: theme.textColor,
      );
    }
  }

  return MermaidScene(
    size: Size(width, height),
    nodes: nodes,
    edges: edges,
    labels: labels,
  );
}

MermaidScene _buildTopDownTimeline(
  TimelineDiagram diagram,
  MermaidLayoutConfig config,
  MermaidTheme theme,
  MermaidTextMeasurer textMeasurer,
) {
  final style = _textStyle(config);
  final nodes = <SceneNode>[];
  final labels = <SceneLabel>[];
  final edges = <SceneEdge>[];
  final titleHeight = diagram.title == null ? 0.0 : 36.0;
  const width = 520.0;
  final height =
      math.max(280.0, titleHeight + 88 + diagram.periods.length * 86.0);
  const axisX = 120.0;

  if (diagram.title != null) {
    labels.add(_measuredLabel(
      diagram.title!,
      const Rect.fromLTWH(24, 18, width - 48, 28),
      theme.textColor,
      style,
      textMeasurer,
    ));
  }
  edges.add(_line(Offset(axisX, titleHeight + 42), Offset(axisX, height - 42),
      theme.nodeStroke));
  for (var i = 0; i < diagram.periods.length; i++) {
    final period = diagram.periods[i];
    final y = titleHeight + 72 + i * 86.0;
    _addNode(
      nodes: nodes,
      labels: labels,
      id: 'timeline-period-$i',
      label: period.period,
      rect: Rect.fromCenter(center: Offset(axisX, y), width: 100, height: 32),
      shape: NodeShape.stadium,
      fill: _seriesColor(theme, i).withAlpha(82),
      stroke: _seriesColor(theme, i),
      textColor: theme.textColor,
    );
    _addNode(
      nodes: nodes,
      labels: labels,
      id: 'timeline-event-$i',
      label: period.events.join(' / '),
      rect: Rect.fromLTWH(200, y - 24, 250, 48),
      shape: NodeShape.roundRect,
      fill: theme.nodeFill,
      stroke: _seriesColor(theme, i).withAlpha(180),
      textColor: theme.textColor,
    );
  }
  return MermaidScene(
    size: Size(width, height),
    nodes: nodes,
    edges: edges,
    labels: labels,
  );
}

void _layoutTreemap(
  List<TreemapNode> items,
  Rect rect, {
  required int depth,
  required List<SceneNode> nodes,
  required List<SceneLabel> labels,
  required MermaidTheme theme,
}) {
  if (items.isEmpty || rect.width <= 8 || rect.height <= 8) return;
  final total = items.fold<double>(0, (sum, node) => sum + node.totalValue);
  var cursor = rect.topLeft;
  final horizontal = rect.width >= rect.height;
  for (var i = 0; i < items.length; i++) {
    final item = items[i];
    final fraction = item.totalValue / total;
    final itemRect = horizontal
        ? Rect.fromLTWH(
            cursor.dx,
            rect.top,
            i == items.length - 1
                ? rect.right - cursor.dx
                : rect.width * fraction,
            rect.height,
          )
        : Rect.fromLTWH(
            rect.left,
            cursor.dy,
            rect.width,
            i == items.length - 1
                ? rect.bottom - cursor.dy
                : rect.height * fraction,
          );
    final color = _seriesColor(theme, depth + i);
    _addNode(
      nodes: nodes,
      labels: labels,
      id: 'treemap-${nodes.length}',
      label: item.value == null
          ? item.label
          : '${item.label} ${_formatNumber(item.value!)}',
      rect: itemRect.deflate(3),
      shape: NodeShape.rectangle,
      fill: color.withAlpha(45 + (depth * 28).clamp(0, 90)),
      stroke: color,
      textColor: theme.textColor,
    );
    if (item.children.isNotEmpty) {
      _layoutTreemap(
        item.children,
        itemRect.deflate(18),
        depth: depth + 1,
        nodes: nodes,
        labels: labels,
        theme: theme,
      );
    }
    cursor = horizontal
        ? Offset(itemRect.right, cursor.dy)
        : Offset(cursor.dx, itemRect.bottom);
  }
}

void _addNode({
  required List<SceneNode> nodes,
  required List<SceneLabel> labels,
  required String id,
  required String label,
  required Rect rect,
  required NodeShape shape,
  required Color fill,
  required Color stroke,
  required Color textColor,
}) {
  final sceneLabel = SceneLabel(
    text: label,
    bounds: rect.deflate(4),
    textColor: textColor,
  );
  labels.add(sceneLabel);
  nodes.add(SceneNode(
    id: id,
    shape: shape,
    bounds: rect,
    fillColor: fill,
    strokeColor: stroke,
    label: sceneLabel,
  ));
}

SceneEdge _line(Offset from, Offset to, Color color) {
  return SceneEdge(
    points: [from, to],
    style: EdgeStyle.solid,
    color: color,
    arrowStart: false,
    arrowEnd: false,
  );
}

SceneLabel _measuredLabel(
  String text,
  Rect preferredBounds,
  Color color,
  MermaidTextStyle textStyle,
  MermaidTextMeasurer textMeasurer,
) {
  final measured = textMeasurer.measure(text, textStyle);
  return SceneLabel(
    text: text,
    bounds: Rect.fromCenter(
      center: preferredBounds.center,
      width: math.max(preferredBounds.width, measured.width + 8),
      height: math.max(preferredBounds.height, measured.height + 4),
    ),
    textColor: color,
  );
}

MermaidTextStyle _textStyle(MermaidLayoutConfig config) {
  return MermaidTextStyle(
    fontSize: config.fontSize,
    lineHeight: config.lineHeight,
  );
}

String _formatNumber(double value) {
  if (value == value.roundToDouble()) return value.round().toString();
  return value.toStringAsFixed(1);
}

Color _seriesColor(MermaidTheme theme, int index) {
  final palette = [
    theme.edgeStroke,
    const Color(0xFF22C55E),
    theme.errorStroke,
    const Color(0xFF8B5CF6),
    theme.nodeStroke,
    const Color(0xFFF59E0B),
  ];
  return palette[index % palette.length];
}

Color _journeyScoreColor(MermaidTheme theme, int score) {
  if (score >= 4) return const Color(0xFF22C55E);
  if (score == 3) return const Color(0xFFF59E0B);
  if (score >= 1) return theme.errorStroke;
  return theme.nodeStroke;
}

Color _ganttStatusColor(MermaidTheme theme, String? status) {
  return switch (status) {
    'done' => const Color(0xFF22C55E),
    'active' => theme.edgeStroke,
    'crit' => theme.errorStroke,
    _ => theme.nodeStroke,
  };
}

String _titleCase(String value) {
  if (value.isEmpty) return value;
  return value.substring(0, 1).toUpperCase() + value.substring(1);
}

List<Offset> _vennCenters(int count, Size size) {
  final center = Offset(size.width / 2, size.height / 2);
  return switch (count) {
    0 => <Offset>[],
    1 => <Offset>[center],
    2 => <Offset>[
        center.translate(-58, 0),
        center.translate(58, 0),
      ],
    3 => <Offset>[
        center.translate(-62, 24),
        center.translate(62, 24),
        center.translate(0, -54),
      ],
    _ => <Offset>[
        center.translate(-72, -38),
        center.translate(72, -38),
        center.translate(-72, 52),
        center.translate(72, 52),
        for (var i = 4; i < count; i++)
          Offset(
            center.dx + math.cos(i * 1.7) * 90,
            center.dy + math.sin(i * 1.7) * 70,
          ),
      ],
  };
}
