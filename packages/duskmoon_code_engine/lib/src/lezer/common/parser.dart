import 'tree.dart';

/// A range of the document that changed (for incremental parsing).
class ChangedRange {
  const ChangedRange(this.fromA, this.toA, this.fromB, this.toB);
  final int fromA;
  final int toA;
  final int fromB;
  final int toB;
}

/// Abstract interface for parsers.
abstract class Parser {
  const Parser();

  Tree parse(
    String input, {
    Tree? previousTree,
    List<ChangedRange>? changedRanges,
    int? stopAt,
  });
}
