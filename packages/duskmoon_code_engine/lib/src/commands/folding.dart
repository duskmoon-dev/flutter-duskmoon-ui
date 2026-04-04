import '../document/document.dart';

/// A foldable region in the document (both bounds are 1-based line numbers).
class FoldRegion {
  const FoldRegion(this.startLine, this.endLine);

  /// The line that owns the fold (the "header" line), 1-based.
  final int startLine;

  /// The last line of the folded block, 1-based.
  final int endLine;

  @override
  bool operator ==(Object other) =>
      other is FoldRegion &&
      other.startLine == startLine &&
      other.endLine == endLine;

  @override
  int get hashCode => Object.hash(startLine, endLine);

  @override
  String toString() => 'FoldRegion($startLine, $endLine)';
}

abstract final class FoldDetector {
  /// Returns all foldable regions in [doc] based on indentation.
  ///
  /// A fold starts at line *i* when line *i+1* has a strictly higher indent
  /// level.  The fold ends at the last consecutive line whose indent is
  /// greater than line *i*'s indent.
  ///
  /// Indent is measured by counting leading spaces (a tab counts as 2 spaces).
  static List<FoldRegion> detectRegions(Document doc) {
    final lineCount = doc.lineCount;
    if (lineCount <= 1) return const [];

    // Compute indent level for each line (1-based index → indent value).
    final indents = List<int>.filled(lineCount + 1, 0);
    for (var n = 1; n <= lineCount; n++) {
      indents[n] = _indentOf(doc.lineAt(n).text);
    }

    final regions = <FoldRegion>[];

    for (var i = 1; i < lineCount; i++) {
      if (indents[i + 1] > indents[i]) {
        // Line i is a fold start. Find the end.
        var end = i + 1;
        while (end < lineCount && indents[end + 1] > indents[i]) {
          end++;
        }
        regions.add(FoldRegion(i, end));
      }
    }

    return regions;
  }

  /// Returns the [FoldRegion] whose [FoldRegion.startLine] equals [lineNumber],
  /// or null if no such region exists.
  static FoldRegion? regionAtLine(Document doc, int lineNumber) {
    for (final region in detectRegions(doc)) {
      if (region.startLine == lineNumber) return region;
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  static int _indentOf(String text) {
    var count = 0;
    for (var i = 0; i < text.length; i++) {
      if (text[i] == ' ') {
        count++;
      } else if (text[i] == '\t') {
        count += 2;
      } else {
        break;
      }
    }
    return count;
  }
}
