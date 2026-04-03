import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:highlighting/highlighting.dart';

/// Renders a syntax-highlighted code block with language label and copy button.
///
/// Uses the `highlighting` package (HighlightJS port) for syntax detection.
/// Theme is auto-selected based on ambient brightness unless overridden.
class CodeBlockWidget extends StatefulWidget {
  /// Creates a code block widget.
  const CodeBlockWidget({
    super.key,
    required this.code,
    this.language,
    this.codeTheme,
  });

  /// The source code to highlight.
  final String code;

  /// The language identifier (e.g. `dart`, `python`). If `null`, no
  /// language-specific highlighting is applied.
  final String? language;

  /// Override for the highlighting theme name.
  final String? codeTheme;

  @override
  State<CodeBlockWidget> createState() => _CodeBlockWidgetState();
}

class _CodeBlockWidgetState extends State<CodeBlockWidget> {
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: 13,
      height: 1.5,
      color: colorScheme.onSurface,
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header bar with language label and copy button.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                if (widget.language != null && widget.language!.isNotEmpty)
                  Text(
                    widget.language!,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                      fontFamily: 'monospace',
                    ),
                  ),
                const Spacer(),
                _CopyButton(
                  code: widget.code,
                  copied: _copied,
                  onCopied: () {
                    setState(() => _copied = true);
                    Future.delayed(const Duration(seconds: 2), () {
                      if (mounted) setState(() => _copied = false);
                    });
                  },
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ),
          // Code content, horizontally scrollable.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            child: _buildHighlightedCode(textStyle, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedCode(TextStyle baseStyle, bool isDark) {
    if (widget.language == null || widget.language!.isEmpty) {
      return Text(widget.code, style: baseStyle);
    }

    try {
      final result = highlight.parse(
        widget.code,
        languageId: widget.language!,
      );

      return Text.rich(
        _buildTextSpanFromResult(result, baseStyle, isDark),
      );
    } catch (_) {
      // Fallback: plain unhighlighted text.
      return Text(widget.code, style: baseStyle);
    }
  }

  TextSpan _buildTextSpanFromResult(
    Result result,
    TextStyle baseStyle,
    bool isDark,
  ) {
    final theme = isDark ? _darkTheme : _lightTheme;
    final spans = <TextSpan>[];
    _processNode(result.rootNode, spans, baseStyle, theme);
    return TextSpan(style: baseStyle, children: spans);
  }

  void _processNode(
    Node node,
    List<TextSpan> spans,
    TextStyle baseStyle,
    Map<String, TextStyle> theme,
  ) {
    // If it's a leaf node with text value, emit a span.
    if (node.value != null) {
      final style = node.className != null
          ? baseStyle.merge(theme[node.className] ?? const TextStyle())
          : baseStyle;
      spans.add(TextSpan(text: node.value, style: style));
      return;
    }

    // Otherwise, recurse into children.
    final childStyle = node.className != null
        ? baseStyle.merge(theme[node.className] ?? const TextStyle())
        : baseStyle;
    for (final child in node.children) {
      _processNode(child, spans, childStyle, theme);
    }
  }
}

/// Copy button for code blocks.
class _CopyButton extends StatelessWidget {
  const _CopyButton({
    required this.code,
    required this.copied,
    required this.onCopied,
    required this.colorScheme,
  });

  final String code;
  final bool copied;
  final VoidCallback onCopied;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 14,
        icon: Icon(
          copied ? Icons.check : Icons.copy,
          color: copied ? colorScheme.primary : colorScheme.onSurfaceVariant,
        ),
        tooltip: copied ? 'Copied!' : 'Copy code',
        onPressed: () {
          Clipboard.setData(ClipboardData(text: code));
          onCopied();
        },
      ),
    );
  }
}

// ── Syntax highlighting themes ──────────────────────────────────────────────

/// Light theme (GitHub-like) color mapping for highlight.js class names.
const Map<String, TextStyle> _lightTheme = {
  'keyword': TextStyle(color: Color(0xFFD73A49), fontWeight: FontWeight.bold),
  'built_in': TextStyle(color: Color(0xFF005CC5)),
  'type': TextStyle(color: Color(0xFF005CC5)),
  'literal': TextStyle(color: Color(0xFF005CC5)),
  'number': TextStyle(color: Color(0xFF005CC5)),
  'regexp': TextStyle(color: Color(0xFF032F62)),
  'string': TextStyle(color: Color(0xFF032F62)),
  'subst': TextStyle(color: Color(0xFF24292E)),
  'symbol': TextStyle(color: Color(0xFF005CC5)),
  'class': TextStyle(color: Color(0xFF6F42C1)),
  'function': TextStyle(color: Color(0xFF6F42C1)),
  'title': TextStyle(color: Color(0xFF6F42C1), fontWeight: FontWeight.bold),
  'params': TextStyle(color: Color(0xFF24292E)),
  'comment': TextStyle(
    color: Color(0xFF6A737D),
    fontStyle: FontStyle.italic,
  ),
  'doctag': TextStyle(color: Color(0xFF005CC5)),
  'meta': TextStyle(color: Color(0xFF005CC5)),
  'section': TextStyle(color: Color(0xFF005CC5), fontWeight: FontWeight.bold),
  'tag': TextStyle(color: Color(0xFF22863A)),
  'name': TextStyle(color: Color(0xFF22863A)),
  'attr': TextStyle(color: Color(0xFF6F42C1)),
  'attribute': TextStyle(color: Color(0xFF005CC5)),
  'variable': TextStyle(color: Color(0xFF005CC5)),
  'bullet': TextStyle(color: Color(0xFF005CC5)),
  'code': TextStyle(color: Color(0xFF032F62)),
  'emphasis': TextStyle(fontStyle: FontStyle.italic),
  'strong': TextStyle(fontWeight: FontWeight.bold),
  'formula': TextStyle(color: Color(0xFF005CC5)),
  'link': TextStyle(
    color: Color(0xFF032F62),
    decoration: TextDecoration.underline,
  ),
  'quote': TextStyle(color: Color(0xFF6A737D), fontStyle: FontStyle.italic),
  'addition': TextStyle(
    color: Color(0xFF22863A),
    backgroundColor: Color(0xFFE6FFED),
  ),
  'deletion': TextStyle(
    color: Color(0xFFB31D28),
    backgroundColor: Color(0xFFFFDCE0),
  ),
};

/// Dark theme (Monokai Sublime-like) mapping for highlight.js class names.
const Map<String, TextStyle> _darkTheme = {
  'keyword': TextStyle(color: Color(0xFFF92672), fontWeight: FontWeight.bold),
  'built_in': TextStyle(color: Color(0xFF66D9EF)),
  'type': TextStyle(color: Color(0xFF66D9EF), fontStyle: FontStyle.italic),
  'literal': TextStyle(color: Color(0xFFAE81FF)),
  'number': TextStyle(color: Color(0xFFAE81FF)),
  'regexp': TextStyle(color: Color(0xFFE6DB74)),
  'string': TextStyle(color: Color(0xFFE6DB74)),
  'subst': TextStyle(color: Color(0xFFF8F8F2)),
  'symbol': TextStyle(color: Color(0xFFAE81FF)),
  'class': TextStyle(color: Color(0xFFA6E22E)),
  'function': TextStyle(color: Color(0xFFA6E22E)),
  'title': TextStyle(color: Color(0xFFA6E22E), fontWeight: FontWeight.bold),
  'params': TextStyle(color: Color(0xFFF8F8F2)),
  'comment': TextStyle(
    color: Color(0xFF75715E),
    fontStyle: FontStyle.italic,
  ),
  'doctag': TextStyle(color: Color(0xFF66D9EF)),
  'meta': TextStyle(color: Color(0xFF66D9EF)),
  'section': TextStyle(color: Color(0xFFA6E22E), fontWeight: FontWeight.bold),
  'tag': TextStyle(color: Color(0xFFF92672)),
  'name': TextStyle(color: Color(0xFFF92672)),
  'attr': TextStyle(color: Color(0xFFA6E22E)),
  'attribute': TextStyle(color: Color(0xFFA6E22E)),
  'variable': TextStyle(color: Color(0xFFF8F8F2)),
  'bullet': TextStyle(color: Color(0xFFAE81FF)),
  'code': TextStyle(color: Color(0xFF66D9EF)),
  'emphasis': TextStyle(fontStyle: FontStyle.italic),
  'strong': TextStyle(fontWeight: FontWeight.bold),
  'formula': TextStyle(color: Color(0xFFAE81FF)),
  'link': TextStyle(
    color: Color(0xFF66D9EF),
    decoration: TextDecoration.underline,
  ),
  'quote': TextStyle(color: Color(0xFF75715E), fontStyle: FontStyle.italic),
  'addition': TextStyle(
    color: Color(0xFFA6E22E),
    backgroundColor: Color(0xFF283D28),
  ),
  'deletion': TextStyle(
    color: Color(0xFFF92672),
    backgroundColor: Color(0xFF3D2828),
  ),
};
