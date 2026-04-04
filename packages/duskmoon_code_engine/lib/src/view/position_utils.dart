import 'dart:math' as math;
import '../document/document.dart';

class LineColumn {
  const LineColumn(this.lineIndex, this.column);
  final int lineIndex; // 0-based
  final int column; // 0-based
}

abstract final class PositionUtils {
  /// 0-based line index for y coordinate.
  static int lineForY(
    double y, {
    required double lineHeight,
    int maxLine = 0x7FFFFFFF,
  }) {
    return math.max(0, math.min(maxLine, (y / lineHeight).floor()));
  }

  /// Y coordinate for 0-based line index.
  static double yForLine(int lineIndex, {required double lineHeight}) {
    return lineIndex * lineHeight;
  }

  /// Document offset → line index + column.
  static LineColumn offsetInLine(int offset, Document doc) {
    final line = doc.lineAtOffset(offset);
    return LineColumn(line.number - 1, offset - line.from);
  }

  /// Line index + column → document offset. Clamps column to line length.
  static int offsetFromLineCol(int lineIndex, int column, Document doc) {
    final lineNumber = lineIndex + 1;
    if (lineNumber > doc.lineCount) return doc.length;
    final line = doc.lineAt(lineNumber);
    return line.from + math.min(column, line.length);
  }
}
