import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

/// A styled text range describing the appearance of a character range.
@immutable
class StyledRange {
  /// Creates a styled range.
  const StyledRange(this.start, this.end, this.style);

  /// Start character offset (inclusive).
  final int start;

  /// End character offset (exclusive).
  final int end;

  /// The text style to apply for this range.
  final TextStyle style;
}

/// Walks the markdown AST and produces a list of [StyledRange]s
/// mapping source character offsets to text styles.
///
/// Since the `markdown` package does not expose source offsets on AST nodes,
/// this visitor reconstructs offsets by string-matching node text content
/// against the source text in document order.
class AstSpanVisitor {
  /// Creates a visitor for the given [source] text and [colorScheme].
  AstSpanVisitor({
    required this.source,
    required this.colorScheme,
  });

  /// The full source text being highlighted.
  final String source;

  /// Color scheme for styling.
  final ColorScheme colorScheme;

  /// Visits [nodes] and returns styled ranges for the entire source.
  List<StyledRange> visit(List<md.Node> nodes) {
    final ranges = <StyledRange>[];
    var offset = 0;

    for (final node in nodes) {
      offset = _visitBlock(node, ranges, offset);
    }

    return ranges;
  }

  int _visitBlock(md.Node node, List<StyledRange> ranges, int offset) {
    if (node is md.Element) {
      return _visitElement(node, ranges, offset);
    }
    if (node is md.Text) {
      // Plain text — advance past it.
      final idx = source.indexOf(node.text, offset);
      if (idx >= 0) return idx + node.text.length;
      return offset + node.text.length;
    }
    return offset;
  }

  int _visitElement(md.Element el, List<StyledRange> ranges, int offset) {
    final tag = el.tag;
    final style = _styleForTag(tag);

    switch (tag) {
      case 'h1':
      case 'h2':
      case 'h3':
      case 'h4':
      case 'h5':
      case 'h6':
        return _visitHeading(el, ranges, offset);
      case 'pre':
        return _visitCodeBlock(el, ranges, offset);
      case 'mathBlock':
        return _visitMathBlock(el, ranges, offset);
      default:
        if (style != null) {
          return _visitStyledElement(el, ranges, offset, style);
        }
        return _visitChildren(el, ranges, offset);
    }
  }

  int _visitHeading(md.Element el, List<StyledRange> ranges, int offset) {
    // Find the heading marker (#, ##, etc.) in source.
    final level = int.tryParse(el.tag.substring(1)) ?? 1;
    final marker = '#' * level;
    final markerIdx = source.indexOf(marker, offset);

    if (markerIdx >= 0) {
      // Style the marker dimmed.
      ranges.add(StyledRange(
        markerIdx,
        markerIdx + marker.length,
        TextStyle(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
      ));

      // Style the heading content.
      final contentStart = markerIdx + marker.length;
      final lineEnd = source.indexOf('\n', contentStart);
      final end = lineEnd >= 0 ? lineEnd : source.length;

      ranges.add(StyledRange(
        contentStart,
        end,
        TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ));
      return end;
    }

    return _visitChildren(el, ranges, offset);
  }

  int _visitCodeBlock(md.Element el, List<StyledRange> ranges, int offset) {
    // Find the opening ``` in source.
    final fenceIdx = source.indexOf('```', offset);
    if (fenceIdx < 0) return _visitChildren(el, ranges, offset);

    // Find the closing ```.
    final closingIdx = source.indexOf('```', fenceIdx + 3);
    final end = closingIdx >= 0 ? closingIdx + 3 : source.length;

    ranges.add(StyledRange(
      fenceIdx,
      end,
      TextStyle(
        color: colorScheme.tertiary,
        fontFamily: 'monospace',
      ),
    ));

    return end;
  }

  int _visitMathBlock(md.Element el, List<StyledRange> ranges, int offset) {
    final fenceIdx = source.indexOf(r'$$', offset);
    if (fenceIdx < 0) return offset;

    final closingIdx = source.indexOf(r'$$', fenceIdx + 2);
    final end = closingIdx >= 0 ? closingIdx + 2 : source.length;

    ranges.add(StyledRange(
      fenceIdx,
      end,
      TextStyle(
        color: colorScheme.tertiary,
        fontStyle: FontStyle.italic,
      ),
    ));
    return end;
  }

  int _visitStyledElement(
    md.Element el,
    List<StyledRange> ranges,
    int offset,
    TextStyle style,
  ) {
    final text = el.textContent;
    final idx = source.indexOf(text, offset);

    if (idx >= 0) {
      // Find the marker before the text.
      final marker = _markerForTag(el.tag);
      if (marker != null) {
        final markerIdx = source.lastIndexOf(marker, idx);
        if (markerIdx >= offset && markerIdx < idx) {
          ranges.add(StyledRange(
            markerIdx,
            markerIdx + marker.length,
            TextStyle(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ));
        }
        // Closing marker.
        final closingMarker = _closingMarkerForTag(el.tag) ?? marker;
        final closingIdx = source.indexOf(closingMarker, idx + text.length);
        if (closingIdx >= 0) {
          ranges.add(StyledRange(
            closingIdx,
            closingIdx + closingMarker.length,
            TextStyle(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ));
        }
      }

      ranges.add(StyledRange(idx, idx + text.length, style));
      return idx + text.length + (marker?.length ?? 0);
    }

    return _visitChildren(el, ranges, offset);
  }

  int _visitChildren(md.Element el, List<StyledRange> ranges, int offset) {
    var pos = offset;
    for (final child in el.children ?? <md.Node>[]) {
      pos = _visitBlock(child, ranges, pos);
    }
    return pos;
  }

  TextStyle? _styleForTag(String tag) {
    return switch (tag) {
      'strong' => TextStyle(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      'em' => TextStyle(
          fontStyle: FontStyle.italic,
          color: colorScheme.onSurface,
        ),
      'del' => TextStyle(
          decoration: TextDecoration.lineThrough,
          color: colorScheme.onSurfaceVariant,
        ),
      'code' => TextStyle(
          fontFamily: 'monospace',
          color: colorScheme.tertiary,
        ),
      'a' => TextStyle(
          color: colorScheme.primary,
          decoration: TextDecoration.underline,
        ),
      'math' => TextStyle(
          fontFamily: 'monospace',
          fontStyle: FontStyle.italic,
          color: colorScheme.tertiary,
        ),
      'blockquote' => TextStyle(
          fontStyle: FontStyle.italic,
          color: colorScheme.secondary,
        ),
      'hr' => TextStyle(color: colorScheme.outlineVariant),
      _ => null,
    };
  }

  String? _markerForTag(String tag) {
    return switch (tag) {
      'strong' => '**',
      'em' => '*',
      'del' => '~~',
      'code' => '`',
      'math' => r'$',
      _ => null,
    };
  }

  String? _closingMarkerForTag(String tag) {
    // Most markers are symmetric — return null to use the same marker.
    return null;
  }
}
