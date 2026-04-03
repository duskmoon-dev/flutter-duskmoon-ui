/// A single line in a document.
class Line {
  const Line({
    required this.number,
    required this.from,
    required this.to,
    required this.text,
  });

  /// 1-based line number.
  final int number;

  /// Start offset (inclusive).
  final int from;

  /// End offset (exclusive, before newline).
  final int to;

  /// Line text content (without trailing newline).
  final String text;

  /// Character length of this line.
  int get length => to - from;

  @override
  String toString() => 'Line($number, $from..$to, "$text")';
}
