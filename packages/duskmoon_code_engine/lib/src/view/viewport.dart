import 'dart:math' as math;

/// Calculates which document lines are visible in the editor viewport.
/// Assumes fixed line height (monospace) for O(1) line↔pixel mapping.
class EditorViewport {
  EditorViewport({
    required this.scrollOffset,
    required this.viewportHeight,
    required this.lineHeight,
    required this.totalLines,
    this.overscan = 5,
  });

  final double scrollOffset;
  final double viewportHeight;
  final double lineHeight;
  final int totalLines;
  final int overscan;

  int get firstVisibleLine =>
      math.max(0, (scrollOffset / lineHeight).floor() - overscan);

  int get lastVisibleLine => math.min(
        totalLines,
        ((scrollOffset + viewportHeight) / lineHeight).ceil() + overscan,
      );

  int get visibleLineCount => lastVisibleLine - firstVisibleLine;

  double get maxScrollExtent => totalLines * lineHeight;

  int lineAtY(double y) => ((scrollOffset + y) / lineHeight).floor();

  double yForLine(int line) => line * lineHeight - scrollOffset;
}
