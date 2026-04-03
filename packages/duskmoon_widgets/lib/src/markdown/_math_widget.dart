import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// Renders a KaTeX math expression using `flutter_math_fork`.
///
/// Supports both inline and display modes. Falls back to showing raw TeX
/// source in monospace if parsing fails.
class MathWidget extends StatelessWidget {
  /// Creates a math widget.
  const MathWidget({
    super.key,
    required this.tex,
    this.displayMode = false,
  });

  /// The TeX source string.
  final String tex;

  /// Whether to render in display mode (centered, larger) or inline.
  final bool displayMode;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (displayMode) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Math.tex(
            tex,
            mathStyle: MathStyle.display,
            textStyle: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 16,
            ),
            onErrorFallback: (error) =>
                _MathErrorFallback(tex: tex, error: error),
          ),
        ),
      );
    }

    return Math.tex(
      tex,
      mathStyle: MathStyle.text,
      textStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
      ),
      onErrorFallback: (error) => _MathErrorFallback(tex: tex, error: error),
    );
  }
}

/// Fallback widget when TeX parsing fails.
///
/// Shows the raw TeX source in monospace with an error indicator.
class _MathErrorFallback extends StatelessWidget {
  const _MathErrorFallback({required this.tex, required this.error});

  final String tex;
  final FlutterMathException error;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: error.message,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          tex,
          style: TextStyle(
            fontFamily: 'monospace',
            color: colorScheme.onErrorContainer,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
