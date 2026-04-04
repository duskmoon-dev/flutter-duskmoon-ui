import '../document/document.dart';
import '../state/editor_state.dart';

/// A matched pair of bracket positions in the document.
class BracketPair {
  const BracketPair(this.open, this.close);

  /// The offset of the opening bracket.
  final int open;

  /// The offset of the closing bracket.
  final int close;
}

abstract final class BracketMatching {
  static const _openers = <String>{'{', '(', '['};
  static const _closers = <String>{'}', ')', ']'};

  static const _matchingClose = <String, String>{
    '{': '}',
    '(': ')',
    '[': ']',
  };
  static const _matchingOpen = <String, String>{
    '}': '{',
    ')': '(',
    ']': '[',
  };

  /// Returns the position of the bracket that matches the bracket at [pos],
  /// or null if [pos] is not a bracket or no match is found.
  ///
  /// - For opener brackets (`{`, `(`, `[`), scans forward.
  /// - For closer brackets (`}`, `)`, `]`), scans backward.
  static int? findMatch(Document doc, int pos) {
    if (pos < 0 || pos >= doc.length) return null;

    final text = doc.toString();
    final ch = text[pos];

    if (_openers.contains(ch)) {
      // Scan forward for matching close.
      final expected = _matchingClose[ch]!;
      var depth = 1;
      for (var i = pos + 1; i < text.length; i++) {
        final c = text[i];
        if (c == ch) {
          depth++;
        } else if (c == expected) {
          depth--;
          if (depth == 0) return i;
        }
      }
      return null;
    }

    if (_closers.contains(ch)) {
      // Scan backward for matching open.
      final expected = _matchingOpen[ch]!;
      var depth = 1;
      for (var i = pos - 1; i >= 0; i--) {
        final c = text[i];
        if (c == ch) {
          depth++;
        } else if (c == expected) {
          depth--;
          if (depth == 0) return i;
        }
      }
      return null;
    }

    return null;
  }

  /// Checks for a bracket at the cursor position and the position immediately
  /// before the cursor. Returns a [BracketPair] with the open/close positions,
  /// or null if neither position is a bracket.
  ///
  /// Priority: cursor position is checked first, then the position before.
  static BracketPair? matchForState(EditorState state) {
    final head = state.selection.main.head;

    // Check character at cursor.
    final matchAtCursor = _tryMatch(state.doc, head);
    if (matchAtCursor != null) return matchAtCursor;

    // Check character before cursor.
    if (head > 0) {
      return _tryMatch(state.doc, head - 1);
    }

    return null;
  }

  static BracketPair? _tryMatch(Document doc, int pos) {
    if (pos < 0 || pos >= doc.length) return null;
    final text = doc.toString();
    final ch = text[pos];

    if (_openers.contains(ch)) {
      final matchPos = findMatch(doc, pos);
      if (matchPos == null) return null;
      return BracketPair(pos, matchPos);
    }

    if (_closers.contains(ch)) {
      final matchPos = findMatch(doc, pos);
      if (matchPos == null) return null;
      return BracketPair(matchPos, pos);
    }

    return null;
  }
}
