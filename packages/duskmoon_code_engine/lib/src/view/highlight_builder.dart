import 'package:duskmoon_highlight/tree_sitter.dart';
import 'package:flutter/painting.dart' hide InlineSpan;

import '../highlight/highlight.dart';
import '../highlight/tags.dart';

class InlineSpan {
  const InlineSpan(
      {required this.from, required this.to, required this.text, this.style});
  final int from;
  final int to;
  final String text;
  final TextStyle? style;
  int get length => to - from;
}

/// Resolves query captures into non-overlapping spans covering the exact slice.
class HighlightBuilder {
  HighlightBuilder._();

  static List<InlineSpan> buildSpans({
    required SyntaxSnapshot? tree,
    required String source,
    required HighlightStyle highlightStyle,
    required int lineFrom,
    required int lineTo,
    TextStyle? defaultStyle,
  }) {
    if (lineFrom >= lineTo || source.isEmpty) return const [];
    final captures = tree?.captures
            .where((c) =>
                c.from < lineTo &&
                c.to > lineFrom &&
                (c.name == 'none' ||
                    highlightStyle.style(Tag.capture(c.name)) != null))
            .toList() ??
        [];
    final boundaries = <int>{lineFrom, lineTo};
    for (final capture in captures) {
      boundaries.add(capture.from.clamp(lineFrom, lineTo));
      boundaries.add(capture.to.clamp(lineFrom, lineTo));
    }
    final sorted = boundaries.toList()..sort();
    final spans = <InlineSpan>[];
    for (var i = 0; i + 1 < sorted.length; i++) {
      final from = sorted[i];
      final to = sorted[i + 1];
      SyntaxCapture? winner;
      for (final candidate in captures) {
        if (candidate.from > from || candidate.to < to) continue;
        final current = winner;
        if (current == null || _compare(candidate, current) > 0) {
          winner = candidate;
        }
      }
      final style = winner == null
          ? defaultStyle
          : highlightStyle.style(Tag.capture(winner.name)) ?? defaultStyle;
      if (spans.isNotEmpty && spans.last.style == style) {
        final last = spans.removeLast();
        spans.add(InlineSpan(
            from: last.from,
            to: to,
            text: source.substring(last.from, to),
            style: style));
      } else {
        spans.add(InlineSpan(
            from: from,
            to: to,
            text: source.substring(from, to),
            style: style));
      }
    }
    return spans;
  }

  // Explicit priority wins, then the most specific range, then query order.
  static int _compare(SyntaxCapture a, SyntaxCapture b) {
    var value = a.priority.compareTo(b.priority);
    if (value != 0) return value;
    value = (b.to - b.from).compareTo(a.to - a.from);
    if (value != 0) return value;
    value = a.patternIndex.compareTo(b.patternIndex);
    return value != 0 ? value : a.name.compareTo(b.name);
  }
}
