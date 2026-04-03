import 'package:markdown/markdown.dart' as md;

import 'math_syntax.dart';

/// A dirty region representing a range of lines that changed.
class DirtyRegion {
  /// Creates a dirty region from [startLine] to [endLine] (inclusive, 0-based).
  const DirtyRegion(this.startLine, this.endLine);

  /// Start of the dirty range (0-based line index).
  final int startLine;

  /// End of the dirty range (0-based line index, inclusive).
  final int endLine;
}

/// Result of an incremental parse operation.
class ParseResult {
  /// Creates a parse result.
  const ParseResult({
    required this.nodes,
    required this.wasFullReparse,
  });

  /// The full list of AST nodes after the parse.
  final List<md.Node> nodes;

  /// Whether this was a full (non-incremental) reparse.
  final bool wasFullReparse;
}

/// Incremental markdown parser wrapping the `markdown` package.
///
/// Supports full parse and dirty-region incremental parsing. Used by
/// both [DmMarkdown] (renderer) and [DmMarkdownInput] (editor).
class IncrementalParser {
  /// Creates an incremental parser with optional feature flags.
  IncrementalParser({
    this.enableGfm = true,
    this.enableKatex = true,
  });

  /// Whether GFM extensions are enabled.
  final bool enableGfm;

  /// Whether KaTeX math extensions are enabled.
  final bool enableKatex;

  /// Cached AST nodes from the most recent parse.
  List<md.Node> _cachedNodes = [];

  /// Cached source lines for incremental diffing.
  List<String> _cachedLines = [];

  /// Returns the current cached AST nodes.
  List<md.Node> get cachedNodes => List.unmodifiable(_cachedNodes);

  /// Returns the current cached source lines.
  List<String> get cachedLines => List.unmodifiable(_cachedLines);

  /// Performs a full parse of [text] and caches the result.
  ParseResult fullParse(String text) {
    _cachedLines = text.split('\n');
    _cachedNodes = _parseLines(_cachedLines);
    return ParseResult(nodes: cachedNodes, wasFullReparse: true);
  }

  /// Attempts an incremental parse given an edit [delta].
  ///
  /// [newText] is the full text after the edit. [editOffset] is the character
  /// offset where the edit occurred. [deletedLength] is the number of chars
  /// removed. [insertedLength] is the number of chars inserted.
  ///
  /// Falls back to a full reparse if the edit cannot be handled incrementally
  /// (e.g. cross-block edits, code fence creation/destruction).
  ParseResult incrementalParse(
    String newText, {
    required int editOffset,
    required int deletedLength,
    required int insertedLength,
  }) {
    final newLines = newText.split('\n');

    // Determine which lines changed.
    final editLineStart = _lineIndexAtOffset(editOffset, _cachedLines);
    final editLineEnd = _lineIndexAtOffset(
      editOffset + insertedLength,
      newLines,
    );

    // Expand to block boundaries.
    final dirtyStart = _expandToBlockStart(newLines, editLineStart);
    final dirtyEnd = _expandToBlockEnd(newLines, editLineEnd);

    // Check if we need a full reparse.
    if (_requiresFullReparse(
      newLines,
      dirtyStart: dirtyStart,
      dirtyEnd: dirtyEnd,
    )) {
      return fullParse(newText);
    }

    // Parse just the dirty region.
    final dirtyLines = newLines.sublist(dirtyStart, dirtyEnd + 1);
    final dirtyNodes = _parseLines(dirtyLines);

    // Find the corresponding old block range to replace.
    final oldDirtyStart = _expandToBlockStart(_cachedLines, editLineStart);
    final oldDirtyEnd = _expandToBlockEnd(
      _cachedLines,
      (editLineStart + (editLineEnd - editLineStart))
          .clamp(0, _cachedLines.length - 1),
    );

    // Map line ranges to node indices.
    final oldNodeRange = _nodeRangeForLines(
      _cachedNodes,
      _cachedLines,
      oldDirtyStart,
      oldDirtyEnd,
    );

    // Splice new nodes into cached list.
    if (oldNodeRange != null) {
      _cachedNodes.replaceRange(
        oldNodeRange.start,
        oldNodeRange.end,
        dirtyNodes,
      );
    } else {
      // Could not map — full reparse.
      return fullParse(newText);
    }

    _cachedLines = newLines;
    return ParseResult(nodes: cachedNodes, wasFullReparse: false);
  }

  /// Appends [chunk] to the existing cached text and re-parses
  /// only the tail region. Optimized for streaming input.
  ParseResult appendParse(String fullText) {
    final newLines = fullText.split('\n');

    // Find where new content starts.
    var divergeAt = 0;
    final minLen =
        _cachedLines.length < newLines.length
            ? _cachedLines.length
            : newLines.length;
    for (var i = 0; i < minLen; i++) {
      if (i >= _cachedLines.length || _cachedLines[i] != newLines[i]) break;
      divergeAt = i + 1;
    }

    // If the only change is appended lines at the end, parse just the tail.
    if (divergeAt >= _cachedLines.length - 1) {
      final dirtyStart = _expandToBlockStart(newLines, divergeAt);
      final dirtyLines = newLines.sublist(dirtyStart);
      final dirtyNodes = _parseLines(dirtyLines);

      // Replace from the corresponding node index to end.
      final oldNodeRange = _nodeRangeForLines(
        _cachedNodes,
        _cachedLines,
        dirtyStart,
        _cachedLines.length - 1,
      );

      if (oldNodeRange != null) {
        _cachedNodes.replaceRange(
          oldNodeRange.start,
          _cachedNodes.length,
          dirtyNodes,
        );
        _cachedLines = newLines;
        return ParseResult(nodes: cachedNodes, wasFullReparse: false);
      }
    }

    // Fallback: full reparse.
    return fullParse(fullText);
  }

  // ── Private helpers ───────────────────────────────────────────────────

  List<md.Node> _parseLines(List<String> lines) {
    final doc = md.Document(
      extensionSet: enableGfm ? md.ExtensionSet.gitHubFlavored : null,
      blockSyntaxes: enableKatex ? dmBlockSyntaxes() : [],
      inlineSyntaxes: enableKatex ? dmInlineSyntaxes() : [],
    );
    return doc.parseLines(lines);
  }

  /// Returns the 0-based line index for a character [offset].
  int _lineIndexAtOffset(int offset, List<String> lines) {
    var charCount = 0;
    for (var i = 0; i < lines.length; i++) {
      charCount += lines[i].length + 1; // +1 for newline
      if (charCount > offset) return i;
    }
    return lines.length - 1;
  }

  /// Expands [lineIndex] backward to the nearest block boundary.
  int _expandToBlockStart(List<String> lines, int lineIndex) {
    var i = lineIndex.clamp(0, lines.length - 1);
    while (i > 0) {
      if (_isBlockBoundary(lines[i - 1])) break;
      i--;
    }
    return i;
  }

  /// Expands [lineIndex] forward to the nearest block boundary.
  int _expandToBlockEnd(List<String> lines, int lineIndex) {
    var i = lineIndex.clamp(0, lines.length - 1);
    while (i < lines.length - 1) {
      if (_isBlockBoundary(lines[i + 1])) break;
      i++;
    }
    return i;
  }

  /// A line is a block boundary if it's blank or starts a new block element.
  bool _isBlockBoundary(String line) {
    final trimmed = line.trimLeft();
    if (trimmed.isEmpty) return true;
    if (trimmed.startsWith('#')) return true;
    if (trimmed.startsWith('```')) return true;
    if (trimmed.startsWith('> ')) return true;
    if (trimmed.startsWith('---') || trimmed.startsWith('***')) return true;
    if (trimmed.startsWith(r'$$')) return true;
    if (RegExp(r'^[\-\*\+]\s').hasMatch(trimmed)) return true;
    if (RegExp(r'^\d+\.\s').hasMatch(trimmed)) return true;
    return false;
  }

  /// Checks whether a full reparse is required for the edit.
  bool _requiresFullReparse(
    List<String> lines, {
    required int dirtyStart,
    required int dirtyEnd,
  }) {
    // Code fence edits invalidate global block structure.
    for (var i = dirtyStart; i <= dirtyEnd && i < lines.length; i++) {
      if (lines[i].trimLeft().startsWith('```')) return true;
      if (lines[i].trimLeft().startsWith(r'$$')) return true;
    }
    return false;
  }

  /// Maps a line range to a node index range in [nodes].
  ///
  /// Returns `null` if the mapping cannot be determined.
  _IntRange? _nodeRangeForLines(
    List<md.Node> nodes,
    List<String> lines,
    int lineStart,
    int lineEnd,
  ) {
    if (nodes.isEmpty) return const _IntRange(0, 0);

    // Approximate: each top-level node corresponds to a contiguous run of
    // lines. We walk nodes and count lines consumed.
    var lineCounter = 0;
    int? startNode;
    int? endNode;

    for (var i = 0; i < nodes.length; i++) {
      final nodeLineCount = _estimateNodeLineCount(nodes[i], lines, lineCounter);
      final nodeEndLine = lineCounter + nodeLineCount - 1;

      if (startNode == null && nodeEndLine >= lineStart) {
        startNode = i;
      }
      if (nodeEndLine >= lineEnd) {
        endNode = i + 1;
        break;
      }
      lineCounter += nodeLineCount;
    }

    startNode ??= 0;
    endNode ??= nodes.length;
    return _IntRange(startNode, endNode);
  }

  /// Estimates how many source lines a node spans.
  int _estimateNodeLineCount(
    md.Node node,
    List<String> lines,
    int startLine,
  ) {
    if (node is! md.Element) return 1;

    // Code blocks and block quotes can span many lines.
    final tag = node.tag;
    if (tag == 'pre' || tag == 'blockquote' || tag == 'mathBlock') {
      // Scan forward for the end of this block.
      var count = 1;
      for (var i = startLine + 1; i < lines.length; i++) {
        if (_isBlockBoundary(lines[i]) && lines[i].trim().isNotEmpty) break;
        count++;
      }
      return count;
    }

    if (tag == 'ul' || tag == 'ol') {
      // Count child list items.
      var count = 0;
      for (final child in node.children ?? <md.Node>[]) {
        count += _estimateNodeLineCount(child, lines, startLine + count);
      }
      return count.clamp(1, lines.length - startLine);
    }

    // Headings, paragraphs, HR — typically 1–2 lines + trailing blank.
    if (startLine < lines.length - 1 && lines[startLine + 1].trim().isEmpty) {
      return 2;
    }
    return 1;
  }
}

/// A simple integer range [start, end).
class _IntRange {
  const _IntRange(this.start, this.end);
  final int start;
  final int end;
}
