import 'text.dart';

/// Maximum number of characters stored in a single [RopeLeaf].
const int _maxLeafSize = 1024;

// ---------------------------------------------------------------------------
// Node hierarchy
// ---------------------------------------------------------------------------

/// A node in the rope tree.
sealed class RopeNode {
  const RopeNode();

  /// Total number of characters in this subtree.
  int get length;

  /// Number of lines in this subtree.
  ///
  /// Defined as `newlineCount + 1`. An empty string has lineCount 1.
  /// When combining two nodes the shared line boundary is not double-counted:
  /// `branch.lineCount = left.lineCount + right.lineCount - 1`.
  int get lineCount;
}

/// A leaf node that holds raw text (at most [_maxLeafSize] characters).
final class RopeLeaf extends RopeNode {
  RopeLeaf(this.text)
      : length = text.length,
        lineCount = _countLines(text);

  final String text;

  @override
  final int length;

  @override
  final int lineCount;

  static int _countLines(String s) {
    var count = 1;
    for (var i = 0; i < s.length; i++) {
      if (s.codeUnitAt(i) == 10) count++; // '\n'
    }
    return count;
  }
}

/// An internal branch node that combines two child nodes.
final class RopeBranch extends RopeNode {
  RopeBranch(this.left, this.right)
      : length = left.length + right.length,
        lineCount = left.lineCount + right.lineCount - 1;

  final RopeNode left;
  final RopeNode right;

  @override
  final int length;

  @override
  final int lineCount;
}

// ---------------------------------------------------------------------------
// Rope facade
// ---------------------------------------------------------------------------

/// An immutable rope — a balanced binary tree of text chunks.
///
/// All mutation operations return a new [Rope]; the original is unchanged.
class Rope {
  const Rope._(this.root);

  /// The root node of the rope tree.
  final RopeNode root;

  /// Total character length of the document.
  int get length => root.length;

  /// Number of lines in the document.
  int get lineCount => root.lineCount;

  // -------------------------------------------------------------------------
  // Construction
  // -------------------------------------------------------------------------

  /// Build a balanced rope from [text].
  factory Rope.fromString(String text) {
    return Rope._(_buildNode(text));
  }

  static RopeNode _buildNode(String text) {
    if (text.length <= _maxLeafSize) {
      return RopeLeaf(text);
    }
    final mid = text.length ~/ 2;
    final left = _buildNode(text.substring(0, mid));
    final right = _buildNode(text.substring(mid));
    return RopeBranch(left, right);
  }

  // -------------------------------------------------------------------------
  // Character access
  // -------------------------------------------------------------------------

  /// Returns the single character at [offset] as a [String].
  String charAt(int offset) => sliceString(offset, offset + 1);

  // -------------------------------------------------------------------------
  // Substring extraction
  // -------------------------------------------------------------------------

  /// Extracts the substring from [from] (inclusive) to [to] (exclusive).
  ///
  /// If [to] is omitted the slice extends to the end of the document.
  String sliceString(int from, [int? to]) {
    final end = to ?? length;
    final buf = StringBuffer();
    _collectSlice(root, 0, from, end, buf);
    return buf.toString();
  }

  static void _collectSlice(
    RopeNode node,
    int nodeStart,
    int from,
    int to,
    StringBuffer buf,
  ) {
    final nodeEnd = nodeStart + node.length;
    if (nodeEnd <= from || nodeStart >= to) return; // no overlap

    switch (node) {
      case RopeLeaf(:final text):
        final start = (from - nodeStart).clamp(0, text.length);
        final end = (to - nodeStart).clamp(0, text.length);
        buf.write(text.substring(start, end));
      case RopeBranch(:final left, :final right):
        _collectSlice(left, nodeStart, from, to, buf);
        _collectSlice(right, nodeStart + left.length, from, to, buf);
    }
  }

  // -------------------------------------------------------------------------
  // Splice (immutable replace)
  // -------------------------------------------------------------------------

  /// Returns a new [Rope] with the range [from]..[to] replaced by [insert].
  ///
  /// To insert without deleting, pass `from == to`.
  /// To delete without inserting, pass an empty [insert].
  Rope splice(int from, int to, String insert) {
    final before = sliceString(0, from);
    final after = sliceString(to);
    return Rope.fromString(before + insert + after);
  }

  // -------------------------------------------------------------------------
  // Line queries
  // -------------------------------------------------------------------------

  /// Returns the [Line] for the given 1-based [lineNumber].
  Line lineAt(int lineNumber) {
    assert(lineNumber >= 1 && lineNumber <= lineCount);
    return _buildLine(lineNumber);
  }

  /// Returns the [Line] that contains the given character [offset].
  Line lineAtOffset(int offset) {
    assert(offset >= 0 && offset <= length);
    final lineNumber = _lineNumberForOffset(offset);
    return _buildLine(lineNumber);
  }

  /// Iterates lines from [fromLine] to [toLine] inclusive (1-based).
  Iterable<Line> linesInRange(int fromLine, int toLine) sync* {
    for (var n = fromLine; n <= toLine; n++) {
      yield _buildLine(n);
    }
  }

  // -------------------------------------------------------------------------
  // Internal line helpers
  // -------------------------------------------------------------------------

  /// Determines the 1-based line number that contains [offset].
  ///
  /// The newline character itself is considered part of its own line
  /// (i.e. offset pointing at '\n' returns that line, not the next).
  int _lineNumberForOffset(int offset) {
    // Walk the full text up to and including offset counting newlines.
    var lineNumber = 1;
    _collectLineNumber(root, 0, offset, lineNumber, (n) => lineNumber = n);
    return lineNumber;
  }

  static void _collectLineNumber(
    RopeNode node,
    int nodeStart,
    int offset,
    int current,
    void Function(int) update,
  ) {
    if (nodeStart > offset) return;
    final nodeEnd = nodeStart + node.length;
    if (nodeEnd <= nodeStart) return; // empty node

    switch (node) {
      case RopeLeaf(:final text):
        final limit = (offset - nodeStart).clamp(0, text.length);
        var count = current;
        for (var i = 0; i < limit; i++) {
          if (text.codeUnitAt(i) == 10) count++;
        }
        update(count);
      case RopeBranch(:final left, :final right):
        // Process left child.
        var afterLeft = current;
        _collectLineNumber(left, nodeStart, offset, current, (n) {
          afterLeft = n;
        });
        update(afterLeft);
        // Process right child only if offset reaches into it.
        final rightStart = nodeStart + left.length;
        if (offset >= rightStart) {
          var afterRight = afterLeft;
          _collectLineNumber(right, rightStart, offset, afterLeft, (n) {
            afterRight = n;
          });
          update(afterRight);
        }
    }
  }

  /// Builds a [Line] object for the given 1-based [lineNumber] in O(log n)
  /// time by walking the rope tree using cached [lineCount] values.
  ///
  /// The algorithm navigates the tree to find the start offset of the target
  /// line, then extracts only that line's text — avoiding full materialisation.
  Line _buildLine(int lineNumber) {
    // Find the character offset where lineNumber begins.
    final lineStart = _lineStartOffset(root, 0, lineNumber);

    // Extract just this line (up to the next newline or end of document).
    final lineEnd = _lineEndOffset(root, 0, lineStart);

    final text = sliceString(lineStart, lineEnd);
    return Line(
      number: lineNumber,
      from: lineStart,
      to: lineEnd,
      text: text,
    );
  }

  /// Returns the character offset at which [targetLine] (1-based) starts.
  ///
  /// Walks the rope tree in O(log n) using [RopeNode.lineCount] to choose
  /// left vs right at each branch.
  static int _lineStartOffset(RopeNode node, int nodeStart, int targetLine) {
    switch (node) {
      case RopeLeaf(:final text):
        // Scan within this leaf to find the start of targetLine.
        // linesBeforeNode is implicit: caller ensures nodeStart's line context.
        var currentLine = 1;
        for (var i = 0; i < text.length; i++) {
          if (currentLine == targetLine) return nodeStart + i;
          if (text.codeUnitAt(i) == 10) currentLine++;
        }
        // targetLine == currentLine and we're at end-of-leaf (no newline after).
        return nodeStart + text.length;
      case RopeBranch(:final left, :final right):
        // left spans lines 1 .. left.lineCount (relative to this branch start).
        if (targetLine <= left.lineCount) {
          return _lineStartOffset(left, nodeStart, targetLine);
        } else {
          // The target line is in the right subtree.
          // Right starts at line (left.lineCount) relative to branch start
          // because the last line of left continues into right (shared boundary).
          final rightStart = nodeStart + left.length;
          final targetInRight = targetLine - (left.lineCount - 1);
          return _lineStartOffset(right, rightStart, targetInRight);
        }
    }
  }

  /// Returns the end offset (exclusive, before newline) of the line that
  /// starts at [lineStart].
  static int _lineEndOffset(RopeNode node, int nodeStart, int lineStart) {
    final nodeEnd = nodeStart + node.length;
    if (lineStart >= nodeEnd) return nodeEnd;

    switch (node) {
      case RopeLeaf(:final text):
        final localStart = lineStart - nodeStart;
        for (var i = localStart; i < text.length; i++) {
          if (text.codeUnitAt(i) == 10) return nodeStart + i;
        }
        return nodeEnd; // no newline in this leaf — end of document (or line spans further)
      case RopeBranch(:final left, :final right):
        final rightNodeStart = nodeStart + left.length;
        if (lineStart < rightNodeStart) {
          // lineStart is in the left subtree; the line may extend into right.
          final endInLeft = _lineEndOffset(left, nodeStart, lineStart);
          if (endInLeft < rightNodeStart) {
            // Newline was found inside the left subtree.
            return endInLeft;
          }
          // Line continues into right subtree — search from right's beginning.
          return _lineEndOffset(right, rightNodeStart, rightNodeStart);
        } else {
          return _lineEndOffset(right, rightNodeStart, lineStart);
        }
    }
  }
}
