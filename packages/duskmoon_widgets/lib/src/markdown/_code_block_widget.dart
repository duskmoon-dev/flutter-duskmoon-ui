import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:collection';

import 'package:duskmoon_highlight/tree_sitter.dart';

/// Renders a syntax-highlighted code block with language label and copy button.
///
/// Uses the maintained `duskmoon_highlight` package for syntax highlighting.
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
  TreeSitterSession? _session;
  SyntaxSnapshot? _syntax;
  String? _language;
  int _loadGeneration = 0;

  @override
  void initState() {
    super.initState();
    _updateSyntax();
  }

  @override
  void didUpdateWidget(CodeBlockWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.code != widget.code ||
        oldWidget.language != widget.language) {
      _updateSyntax();
    }
  }

  void _updateSyntax() {
    final generation = ++_loadGeneration;
    final language = TreeSitterRuntime.resolveLanguage(widget.language ?? '');
    if (_language != language) {
      _session?.dispose();
      _session = null;
      _language = language;
    }
    _syntax = null;
    if (language == null) return;
    if (TreeSitterRuntime.isInitialized(language)) {
      _parse();
    } else {
      unawaited(_loadSyntax(language, generation));
    }
  }

  Future<void> _loadSyntax(String language, int generation) async {
    try {
      await TreeSitterRuntime.ensureInitialized(languages: {language});
      if (!mounted || generation != _loadGeneration) return;
      setState(_parse);
    } catch (_) {
      // Asset loading failures leave the exact source visible as plain text.
    }
  }

  void _parse() {
    try {
      _session ??= TreeSitterSession(language: _language!);
      _syntax = _session!.parse(widget.code);
    } catch (_) {
      _syntax = null;
    }
  }

  @override
  void dispose() {
    ++_loadGeneration;
    _session?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = switch (widget.codeTheme) {
      'github' => false,
      'monokai-sublime' => true,
      _ => Theme.of(context).brightness == Brightness.dark,
    };
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
    final syntax = _syntax;
    if (syntax == null) return Text(widget.code, style: baseStyle);
    return Text.rich(TextSpan(
      style: baseStyle,
      children: _highlightSpans(
        syntax,
        isDark ? _darkTheme : _lightTheme,
      ),
    ));
  }
}

/// Resolve overlapping captures without changing any source code units.
List<TextSpan> _highlightSpans(
  SyntaxSnapshot syntax,
  Map<String, TextStyle> theme,
) {
  TextStyle? captureStyle(String name) {
    if (name.startsWith('_')) return null;
    var key = name;
    while (true) {
      final style = theme[key];
      if (style != null) return style;
      final dot = key.lastIndexOf('.');
      if (dot < 0) return null;
      key = key.substring(0, dot);
    }
  }

  final captures = syntax.captures
      .where((c) =>
          c.to > c.from && (c.name == 'none' || captureStyle(c.name) != null))
      .toList();
  final events = <int, List<({int index, bool start})>>{};
  for (var i = 0; i < captures.length; i++) {
    final capture = captures[i];
    events.putIfAbsent(capture.from, () => []).add((index: i, start: true));
    events.putIfAbsent(capture.to, () => []).add((index: i, start: false));
  }
  events.putIfAbsent(0, () => []);
  events.putIfAbsent(syntax.source.length, () => []);
  final offsets = events.keys.toList()..sort();
  final active = SplayTreeSet<int>((a, b) {
    final left = captures[a];
    final right = captures[b];
    var order = left.priority.compareTo(right.priority);
    if (order == 0) {
      order = (right.to - right.from).compareTo(left.to - left.from);
    }
    if (order == 0) order = left.patternIndex.compareTo(right.patternIndex);
    return order == 0 ? a.compareTo(b) : order;
  });
  final spans = <TextSpan>[];
  for (var i = 0; i + 1 < offsets.length; i++) {
    final from = offsets[i];
    for (final event in events[from]!) {
      if (event.start) {
        active.add(event.index);
      } else {
        active.remove(event.index);
      }
    }
    final to = offsets[i + 1];
    final style =
        active.isEmpty ? null : captureStyle(captures[active.last].name);
    spans.add(TextSpan(text: syntax.source.substring(from, to), style: style));
  }
  return spans;
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

/// Light theme (GitHub-like) color mapping for Tree-sitter captures.
const Map<String, TextStyle> _lightTheme = {
  'punctuation.bracket': TextStyle(color: Color(0xFF22863A)),
  'constant': TextStyle(color: Color(0xFF005CC5)),
  'boolean': TextStyle(color: Color(0xFF005CC5)),
  'property': TextStyle(color: Color(0xFF6F42C1)),
  'operator': TextStyle(color: Color(0xFFD73A49)),
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

/// Dark theme (Monokai Sublime-like) mapping for Tree-sitter captures.
const Map<String, TextStyle> _darkTheme = {
  'punctuation.bracket': TextStyle(color: Color(0xFFF92672)),
  'constant': TextStyle(color: Color(0xFFAE81FF)),
  'boolean': TextStyle(color: Color(0xFFAE81FF)),
  'property': TextStyle(color: Color(0xFFA6E22E)),
  'operator': TextStyle(color: Color(0xFFF92672)),
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
