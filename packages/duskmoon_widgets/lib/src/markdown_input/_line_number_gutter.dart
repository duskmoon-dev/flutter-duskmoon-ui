import 'package:flutter/material.dart';

/// Renders line numbers in a vertical gutter, synchronized with editor scroll.
///
/// Uses [CustomPaint] to draw only visible line numbers. Each line number is
/// positioned at the y-offset computed by the parent (which measures actual
/// wrapped line heights), so line numbers stay aligned even when text wraps.
class LineNumberGutter extends StatelessWidget {
  /// Creates a line number gutter.
  const LineNumberGutter({
    super.key,
    required this.lineOffsets,
    required this.singleLineHeight,
    required this.scrollController,
    required this.topPadding,
    required this.gutterWidth,
  });

  /// The y-offset of each logical line, accounting for text wrapping.
  /// Length equals the number of logical lines.
  final List<double> lineOffsets;

  /// Height of a single (non-wrapped) line — used for the line number text.
  final double singleLineHeight;

  /// The scroll controller shared with the editor content.
  final ScrollController scrollController;

  /// Top padding inside the editor (for first-line alignment).
  final double topPadding;

  /// Width of the gutter column.
  final double gutterWidth;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: gutterWidth,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        border: Border(
          right: BorderSide(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: AnimatedBuilder(
        animation: scrollController,
        builder: (_, __) {
          final offset =
              scrollController.hasClients ? scrollController.offset : 0.0;
          return ClipRect(
            child: SizedBox.expand(
              child: CustomPaint(
                painter: _LineNumberPainter(
                  lineOffsets: lineOffsets,
                  singleLineHeight: singleLineHeight,
                  scrollOffset: offset,
                  topPadding: topPadding,
                  gutterWidth: gutterWidth,
                  foreground:
                      colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LineNumberPainter extends CustomPainter {
  _LineNumberPainter({
    required this.lineOffsets,
    required this.singleLineHeight,
    required this.scrollOffset,
    required this.topPadding,
    required this.gutterWidth,
    required this.foreground,
  });

  final List<double> lineOffsets;
  final double singleLineHeight;
  final double scrollOffset;
  final double topPadding;
  final double gutterWidth;
  final Color foreground;

  @override
  void paint(Canvas canvas, Size size) {
    if (lineOffsets.isEmpty) return;

    final viewTop = scrollOffset - topPadding;
    final viewBottom = viewTop + size.height;

    for (var i = 0; i < lineOffsets.length; i++) {
      final lineY = lineOffsets[i];

      // Skip lines above or below the visible area.
      if (lineY + singleLineHeight < viewTop) continue;
      if (lineY > viewBottom) break;

      final y = lineY - scrollOffset + topPadding;

      final tp = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
            height: singleLineHeight / 14,
            color: foreground,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
      )..layout();

      tp.paint(canvas, Offset(gutterWidth - 8 - tp.width, y));
    }
  }

  @override
  bool shouldRepaint(_LineNumberPainter old) =>
      lineOffsets != old.lineOffsets ||
      scrollOffset != old.scrollOffset ||
      foreground != old.foreground;
}

/// Compute the gutter width based on digit count.
double computeGutterWidth(int lineCount) {
  final digits = lineCount.toString().length;
  return (digits * 9.0 + 24).clamp(40.0, 80.0);
}
