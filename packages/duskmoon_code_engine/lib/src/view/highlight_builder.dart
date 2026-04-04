// Hide Flutter's InlineSpan to avoid conflict with our InlineSpan class.
import 'package:flutter/painting.dart' hide InlineSpan;

import '../lezer/common/node_type.dart';
import '../lezer/common/tree.dart';
import '../lezer/highlight/highlight.dart';
import '../lezer/highlight/tags.dart';

/// A styled text span covering [from..to] in the document.
class InlineSpan {
  const InlineSpan({
    required this.from,
    required this.to,
    required this.text,
    this.style,
  });

  final int from;
  final int to;
  final String text;
  final TextStyle? style;

  int get length => to - from;
}

/// Converts a syntax [Tree] into a flat list of [InlineSpan]s for rendering.
///
/// Walks the tree's leaf nodes, maps node names to [Tag]s, resolves each
/// [Tag] to a [TextStyle] via the provided [HighlightStyle], and fills any
/// gaps with default-styled spans. The returned spans cover exactly
/// `source[lineFrom..lineTo]`.
class HighlightBuilder {
  HighlightBuilder._();

  /// Build spans for the source slice `[lineFrom, lineTo)` given a parsed
  /// syntax [tree] and a [highlightStyle].
  ///
  /// [lineFrom] and [lineTo] are character offsets into [source].
  static List<InlineSpan> buildSpans({
    required Tree tree,
    required String source,
    required HighlightStyle highlightStyle,
    required int lineFrom,
    required int lineTo,
    TextStyle? defaultStyle,
  }) {
    if (lineFrom >= lineTo || source.isEmpty) return const [];

    final spans = <InlineSpan>[];
    int pos = lineFrom;

    void addGap(int gapFrom, int gapTo) {
      if (gapFrom >= gapTo) return;
      spans.add(InlineSpan(
        from: gapFrom,
        to: gapTo,
        text: source.substring(gapFrom, gapTo),
        style: defaultStyle,
      ));
    }

    // Collect leaf nodes via recursive walk.
    _collectLeaves(tree, 0, lineFrom, lineTo, (nodeFrom, nodeTo, name, type) {
      final spanFrom = nodeFrom.clamp(lineFrom, lineTo);
      final spanTo = nodeTo.clamp(lineFrom, lineTo);
      if (spanFrom >= spanTo) return;

      // Fill gap before this span.
      addGap(pos, spanFrom);
      pos = spanFrom;

      final tag = _defaultTagForName(name);
      TextStyle? style = defaultStyle;
      if (tag != null) {
        style = highlightStyle.style(tag) ?? defaultStyle;
      }

      spans.add(InlineSpan(
        from: spanFrom,
        to: spanTo,
        text: source.substring(spanFrom, spanTo),
        style: style,
      ));
      pos = spanTo;
    });

    // Fill trailing gap.
    addGap(pos, lineTo);

    return spans;
  }

  /// Recursively walk [node] (rooted at [offset]) and call [onLeaf] for each
  /// leaf node whose range overlaps [lineFrom..lineTo].
  ///
  /// A leaf node is a non-top, non-empty-name node with no Tree children.
  static void _collectLeaves(
    Tree node,
    int offset,
    int lineFrom,
    int lineTo,
    void Function(int from, int to, String name, NodeType type) onLeaf,
  ) {
    final nodeFrom = offset;
    final nodeTo = offset + node.length;

    // Prune if outside range.
    if (nodeTo <= lineFrom || nodeFrom >= lineTo) return;

    // Determine if this node has any Tree children.
    final treeChildren = node.children.whereType<Tree>().toList();

    if (treeChildren.isEmpty) {
      // Leaf node: emit if not top-level and has a name.
      if (!node.type.isTop && node.type.name.isNotEmpty) {
        onLeaf(nodeFrom, nodeTo, node.type.name, node.type);
      }
    } else {
      // Internal node: recurse into Tree children.
      for (var i = 0; i < node.children.length; i++) {
        final child = node.children[i];
        if (child is Tree) {
          final childOffset = offset + node.positions[i];
          _collectLeaves(child, childOffset, lineFrom, lineTo, onLeaf);
        }
      }
    }
  }

  static Tag? _defaultTagForName(String name) {
    return switch (name) {
      'String' || 'StringLiteral' => Tag.string,
      'Number' || 'NumberLiteral' => Tag.number,
      'Boolean' || 'BooleanLiteral' || 'True' || 'False' => Tag.bool_,
      'Null' || 'None' => Tag.null_,
      'Comment' || 'LineComment' || 'BlockComment' => Tag.comment,
      '{' || '}' => Tag.brace,
      '(' || ')' => Tag.paren,
      '[' || ']' => Tag.squareBracket,
      ',' || ':' || ';' => Tag.separator,
      _ => null,
    };
  }
}
