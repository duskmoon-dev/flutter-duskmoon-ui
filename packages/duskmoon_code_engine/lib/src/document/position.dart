/// A character offset position in a document.
typedef Pos = int;

/// A from/to range in a document.
class Range {
  const Range(this.from, [int? to]) : to = to ?? from;

  /// Start offset (inclusive).
  final int from;

  /// End offset (exclusive).
  final int to;

  /// Whether this range is collapsed (cursor, no selection).
  bool get isEmpty => from == to;

  /// Number of characters in this range.
  int get length => to - from;

  @override
  bool operator ==(Object other) =>
      other is Range && from == other.from && to == other.to;

  @override
  int get hashCode => Object.hash(from, to);

  @override
  String toString() => 'Range($from, $to)';
}
