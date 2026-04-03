import 'package:flutter/material.dart';

/// Renders line numbers in a vertical gutter, synchronized with editor scroll.
class LineNumberGutter extends StatelessWidget {
  /// Creates a line number gutter.
  const LineNumberGutter({
    super.key,
    required this.lineCount,
    required this.scrollController,
    required this.lineHeight,
    required this.topPadding,
  });

  /// Total number of lines in the editor.
  final int lineCount;

  /// The scroll controller shared with the editor content.
  final ScrollController scrollController;

  /// The height of each line in pixels.
  final double lineHeight;

  /// Top padding inside the editor (for first-line alignment).
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: _gutterWidth,
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
          final offset = scrollController.hasClients
              ? scrollController.offset
              : 0.0;
          return ClipRect(
            child: Transform.translate(
              offset: Offset(0, -offset + topPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(
                  lineCount,
                  (i) => SizedBox(
                    height: lineHeight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8, left: 8),
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 13,
                          height: lineHeight / 13,
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  double get _gutterWidth {
    // Width adapts to digit count.
    final digits = lineCount.toString().length;
    return (digits * 9.0 + 24).clamp(40.0, 80.0);
  }
}
