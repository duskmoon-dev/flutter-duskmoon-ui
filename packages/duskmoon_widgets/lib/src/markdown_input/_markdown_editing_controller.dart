import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

import '../_shared/incremental_parser.dart';
import '_ast_span_visitor.dart';

/// A [TextEditingController] that produces syntax-highlighted [TextSpan]s
/// from the current markdown text using AST-based parsing.
///
/// Implements 3-tier error fallback to ensure the editor never breaks.
class MarkdownEditingController extends TextEditingController {
  /// Creates a markdown editing controller.
  MarkdownEditingController({
    super.text,
    this.enableGfm = true,
    this.enableKatex = true,
  }) {
    _parser = IncrementalParser(enableGfm: enableGfm, enableKatex: enableKatex);
    if (text.isNotEmpty) {
      _parse(text);
    }
  }

  /// Whether GFM is enabled.
  final bool enableGfm;

  /// Whether KaTeX is enabled.
  final bool enableKatex;

  late final IncrementalParser _parser;
  List<StyledRange> _cachedRanges = [];
  List<md.Node> _cachedNodes = [];
  String _lastParsedText = '';
  final _nodesNotifier = ValueNotifier<List<md.Node>>([]);

  /// The current cached AST nodes.
  List<md.Node> get cachedNodes => _cachedNodes;

  /// Notifier that fires when the AST changes.
  ValueListenable<List<md.Node>> get nodesNotifier => _nodesNotifier;

  @override
  set value(TextEditingValue newValue) {
    final oldText = text;
    final normalizedValue = _normalizeValue(newValue);
    super.value = normalizedValue;
    if (normalizedValue.text != oldText) {
      _onTextChanged(oldText, normalizedValue.text);
    }
  }

  /// Applies a controller-managed text mutation and clears any stale IME
  /// composing range that no longer matches the transformed text.
  @protected
  void applyMutation({
    required String text,
    required TextSelection selection,
  }) {
    value = value.copyWith(
      text: text,
      selection: selection,
      composing: TextRange.empty,
    );
  }

  void _onTextChanged(String oldText, String newText) {
    if (newText == _lastParsedText) return;
    _parse(newText);
  }

  void _parse(String text) {
    try {
      final result = _parser.fullParse(text);
      _cachedNodes = List.of(result.nodes);
      _lastParsedText = text;

      final visitor = AstSpanVisitor(
        source: text,
        colorScheme: _colorScheme ?? _defaultColorScheme,
      );
      _cachedRanges = visitor.visit(_cachedNodes);
      _nodesNotifier.value = _cachedNodes;
    } catch (e) {
      // Tier 2/3: keep last known good state.
      debugPrint('MarkdownEditingController parse error: $e');
    }
  }

  TextEditingValue _normalizeValue(TextEditingValue value) {
    final textLength = value.text.length;
    final normalizedSelection =
        _normalizeSelection(value.selection, textLength);
    final normalizedComposing =
        _normalizeComposing(value.composing, textLength);

    if (normalizedSelection == value.selection &&
        normalizedComposing == value.composing) {
      return value;
    }

    return value.copyWith(
      selection: normalizedSelection,
      composing: normalizedComposing,
    );
  }

  TextSelection _normalizeSelection(TextSelection selection, int textLength) {
    if (selection.start == -1 && selection.end == -1) {
      return selection;
    }

    final baseOffset = selection.baseOffset.clamp(0, textLength);
    final extentOffset = selection.extentOffset.clamp(0, textLength);

    return TextSelection(
      baseOffset: baseOffset,
      extentOffset: extentOffset,
      affinity: selection.affinity,
      isDirectional: selection.isDirectional,
    );
  }

  TextRange _normalizeComposing(TextRange composing, int textLength) {
    if (composing.start == -1 && composing.end == -1) {
      return TextRange.empty;
    }

    final hasNegativeOffset = composing.start < 0 || composing.end < 0;
    final exceedsLength =
        composing.start > textLength || composing.end > textLength;
    final reversed = composing.start > composing.end;

    if (hasNegativeOffset || exceedsLength || reversed) {
      return TextRange.empty;
    }

    return composing;
  }

  ColorScheme? _colorScheme;
  static const _defaultColorScheme = ColorScheme.dark();

  /// Updates the color scheme used for syntax highlighting.
  void updateColorScheme(ColorScheme colorScheme) {
    if (_colorScheme != colorScheme) {
      _colorScheme = colorScheme;
      if (text.isNotEmpty) {
        _parse(text);
      }
    }
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    // Update color scheme from context and re-parse so styled ranges use
    // the correct theme colors (fixes invisible text when switching themes).
    final cs = Theme.of(context).colorScheme;
    if (_colorScheme != cs) {
      _colorScheme = cs;
      if (text.isNotEmpty) {
        _parse(text);
      }
    }

    try {
      return _buildFromRanges(style);
    } catch (e) {
      // Tier 3: plain text fallback — editor always works.
      debugPrint('MarkdownEditingController buildTextSpan error: $e');
      return TextSpan(text: text, style: style);
    }
  }

  TextSpan _buildFromRanges(TextStyle? baseStyle) {
    if (_cachedRanges.isEmpty || text.isEmpty) {
      return TextSpan(text: text, style: baseStyle);
    }

    final spans = <TextSpan>[];
    var lastEnd = 0;

    // Sort ranges by start offset.
    final sorted = List.of(_cachedRanges)
      ..sort((a, b) => a.start.compareTo(b.start));

    for (final range in sorted) {
      final start = range.start.clamp(0, text.length);
      final end = range.end.clamp(start, text.length);

      // Add unstyled text before this range.
      if (start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, start),
          style: baseStyle,
        ));
      }

      // Add styled range.
      if (end > start) {
        spans.add(TextSpan(
          text: text.substring(start, end),
          style: baseStyle?.merge(range.style) ?? range.style,
        ));
      }

      lastEnd = end;
    }

    // Add remaining unstyled text.
    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: baseStyle,
      ));
    }

    return TextSpan(style: baseStyle, children: spans);
  }

  @override
  void dispose() {
    _nodesNotifier.dispose();
    super.dispose();
  }
}
