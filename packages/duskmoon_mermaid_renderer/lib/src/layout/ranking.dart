import 'dart:collection';
import 'dart:math' as math;

import '../ir/graph.dart';

Map<String, int> assignRanks(Graph graph) {
  final incoming = <String, int>{
    for (final id in graph.nodes.keys) id: 0,
  };
  final adjacency = <String, List<String>>{
    for (final id in graph.nodes.keys) id: <String>[],
  };

  for (final edge in graph.edges) {
    incoming[edge.to] = (incoming[edge.to] ?? 0) + 1;
    adjacency.putIfAbsent(edge.from, () => <String>[]).add(edge.to);
    adjacency.putIfAbsent(edge.to, () => <String>[]);
  }

  final ranks = <String, int>{};
  final queue = Queue<String>();
  final roots = incoming.entries
      .where((entry) => entry.value == 0)
      .map((entry) => entry.key)
      .toList()
    ..sort();

  queue.addAll(roots.isEmpty ? (graph.nodes.keys.toList()..sort()) : roots);
  for (final root in queue) {
    ranks[root] = 0;
  }

  while (queue.isNotEmpty) {
    final id = queue.removeFirst();
    final nextRank = (ranks[id] ?? 0) + 1;
    final targets = adjacency[id] ?? const <String>[];
    for (final target in targets) {
      final current = ranks[target];
      if (current == null || nextRank > current) {
        ranks[target] = nextRank;
        queue.add(target);
      }
    }
  }

  for (final id in graph.nodes.keys) {
    ranks.putIfAbsent(id, () => ranks.values.fold(0, math.max) + 1);
  }

  return ranks;
}
