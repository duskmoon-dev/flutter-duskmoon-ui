import 'package:flutter/painting.dart';
import 'tags.dart';

class TagStyle {
  const TagStyle(this.tag, this.style);
  final Tag tag;
  final TextStyle style;
}

class HighlightStyle {
  HighlightStyle(this.specs) : _byTag = {for (final s in specs) s.tag: s.style};

  final List<TagStyle> specs;
  final Map<Tag, TextStyle> _byTag;

  /// Resolve style for tag, walking up parent hierarchy for fallback.
  TextStyle? style(Tag tag) {
    final exact = _byTag[tag];
    if (exact != null) return exact;
    var current = tag.parent;
    while (current != null) {
      final parentStyle = _byTag[current];
      if (parentStyle != null) return parentStyle;
      current = current.parent;
    }
    return null;
  }
}
