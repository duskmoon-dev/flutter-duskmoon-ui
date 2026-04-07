import 'package:flutter/material.dart';

import '_logical_line_metric.dart';

const _kGutterLeftPadding = 12.0;
const _kGutterRightPadding = 8.0;
const _kMinGutterWidth = 40.0;
const _kMaxGutterWidth = 80.0;

/// Renders line numbers in a vertical gutter, synchronized with editor scroll.
///
/// Uses [CustomPaint] to draw only visible line numbers. Each line number is
/// positioned at the y-offset computed by the parent (which measures actual
/// wrapped line heights), so line numbers stay aligned even when text wraps.
class LineNumberGutter extends StatelessWidget {
  /// Creates a line number gutter.
  const LineNumberGutter({
    super.key,
    required this.lineMetrics,
    required this.singleLineHeight,
    required this.scrollController,
    required this.topPadding,
    required this.gutterWidth,
    required this.textStyle,
    required this.strutStyle,
    required this.textScaler,
  });

  /// Metrics for each logical line, accounting for text wrapping.
  /// Length equals the number of logical lines.
  final List<LogicalLineMetric> lineMetrics;

  /// Height of a single (non-wrapped) line — used for the line number text.
  final double singleLineHeight;

  /// The scroll controller shared with the editor content.
  final ScrollController scrollController;

  /// Top padding inside the editor (for first-line alignment).
  final double topPadding;

  /// Width of the gutter column.
  final double gutterWidth;

  /// Text style used for line numbers.
  final TextStyle textStyle;

  /// Strut style used by the editor text layout.
  final StrutStyle strutStyle;

  /// Text scaling applied to line numbers.
  final TextScaler textScaler;

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
                  lineMetrics: lineMetrics,
                  singleLineHeight: singleLineHeight,
                  scrollOffset: offset,
                  topPadding: topPadding,
                  gutterWidth: gutterWidth,
                  textStyle: textStyle,
                  strutStyle: strutStyle,
                  textScaler: textScaler,
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
    required this.lineMetrics,
    required this.singleLineHeight,
    required this.scrollOffset,
    required this.topPadding,
    required this.gutterWidth,
    required this.textStyle,
    required this.strutStyle,
    required this.textScaler,
    required this.foreground,
  });

  final List<LogicalLineMetric> lineMetrics;
  final double singleLineHeight;
  final double scrollOffset;
  final double topPadding;
  final double gutterWidth;
  final TextStyle textStyle;
  final StrutStyle strutStyle;
  final TextScaler textScaler;
  final Color foreground;

  @override
  void paint(Canvas canvas, Size size) {
    if (lineMetrics.isEmpty) return;

    final viewTop = scrollOffset - topPadding;
    final viewBottom = viewTop + size.height;
    final lineNumberBaseline = _computeLineNumberBaseline();

    for (var i = 0; i < lineMetrics.length; i++) {
      final metric = lineMetrics[i];

      // Skip lines above or below the visible area.
      if (metric.top + metric.height < viewTop) continue;
      if (metric.top > viewBottom) break;

      final tp = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: textStyle.copyWith(color: foreground),
        ),
        strutStyle: strutStyle,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
        textScaler: textScaler,
      )..layout(
          maxWidth: gutterWidth - _kGutterLeftPadding - _kGutterRightPadding);

      final y =
          metric.baseline - scrollOffset + topPadding - lineNumberBaseline;

      tp.paint(
          canvas, Offset(gutterWidth - _kGutterRightPadding - tp.width, y));
    }
  }

  double _computeLineNumberBaseline() {
    final tp = TextPainter(
      text: TextSpan(
        text: '0',
        style: textStyle,
      ),
      strutStyle: strutStyle,
      textDirection: TextDirection.ltr,
      textScaler: textScaler,
    )..layout();

    return tp.computeDistanceToActualBaseline(TextBaseline.alphabetic);
  }

  @override
  bool shouldRepaint(_LineNumberPainter old) =>
      lineMetrics != old.lineMetrics ||
      scrollOffset != old.scrollOffset ||
      textStyle != old.textStyle ||
      strutStyle != old.strutStyle ||
      textScaler != old.textScaler ||
      foreground != old.foreground;
}

/// Compute the gutter width from the actual rendered line-number text width.
double computeGutterWidth({
  required int lineCount,
  required TextStyle textStyle,
  required TextScaler textScaler,
}) {
  final tp = TextPainter(
    text: TextSpan(
      text: lineCount.clamp(1, 999999).toString(),
      style: textStyle,
    ),
    textDirection: TextDirection.ltr,
    textScaler: textScaler,
  )..layout();

  return (tp.width + _kGutterLeftPadding + _kGutterRightPadding)
      .clamp(_kMinGutterWidth, _kMaxGutterWidth)
      .toDouble();
}
