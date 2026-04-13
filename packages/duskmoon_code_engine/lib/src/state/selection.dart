import 'dart:math' as math;
import '../document/change.dart';

/// A single selection range with an anchor and head (cursor position).
class SelectionRange {
  const SelectionRange({required this.anchor, required this.head});
  const SelectionRange.cursor(int pos)
      : anchor = pos,
        head = pos;

  final int anchor;
  final int head;

  int get from => math.min(anchor, head);
  int get to => math.max(anchor, head);
  bool get isEmpty => anchor == head;

  SelectionRange map(ChangeSet changes) => SelectionRange(
        anchor: changes.mapPos(anchor, assoc: -1),
        head: changes.mapPos(head),
      );

  @override
  bool operator ==(Object other) =>
      other is SelectionRange && anchor == other.anchor && head == other.head;

  @override
  int get hashCode => Object.hash(anchor, head);

  @override
  String toString() => isEmpty ? 'Cursor($head)' : 'Selection($anchor→$head)';
}

/// The editor's selection state: one or more SelectionRanges.
class EditorSelection {
  const EditorSelection({required this.ranges, this.mainIndex = 0});

  factory EditorSelection.cursor(int pos) => EditorSelection(
        ranges: [SelectionRange.cursor(pos)],
      );

  factory EditorSelection.single({required int anchor, required int head}) =>
      EditorSelection(
        ranges: [SelectionRange(anchor: anchor, head: head)],
      );

  factory EditorSelection.range({required int anchor, required int head}) =>
      EditorSelection(
        ranges: [SelectionRange(anchor: anchor, head: head)],
      );

  final List<SelectionRange> ranges;
  final int mainIndex;

  SelectionRange get main => ranges[mainIndex];

  EditorSelection map(ChangeSet changes) => EditorSelection(
        ranges: ranges.map((r) => r.map(changes)).toList(),
        mainIndex: mainIndex,
      );

  @override
  bool operator ==(Object other) =>
      other is EditorSelection &&
      mainIndex == other.mainIndex &&
      _rangesEqual(ranges, other.ranges);

  @override
  int get hashCode => Object.hash(mainIndex, Object.hashAll(ranges));

  static bool _rangesEqual(List<SelectionRange> a, List<SelectionRange> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  String toString() => 'EditorSelection(main=$mainIndex, ranges=$ranges)';
}
