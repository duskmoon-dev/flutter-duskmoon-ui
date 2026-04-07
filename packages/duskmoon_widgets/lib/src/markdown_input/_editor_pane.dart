import 'package:flutter/material.dart';

import '_line_number_gutter.dart';
import '_markdown_editing_controller.dart';

/// The write/edit pane with syntax highlighting overlay and line numbers.
class EditorPane extends StatefulWidget {
  /// Creates an editor pane.
  const EditorPane({
    super.key,
    required this.controller,
    required this.focusNode,
    this.showLineNumbers = false,
    this.maxLines,
    this.minLines = 10,
    this.readOnly = false,
    this.decoration,
    this.textStyle,
  });

  /// The markdown editing controller (handles syntax highlighting).
  final MarkdownEditingController controller;

  /// Focus node for the editor.
  final FocusNode focusNode;

  /// Whether to show line numbers.
  final bool showLineNumbers;

  /// Maximum number of visible lines.
  final int? maxLines;

  /// Minimum number of visible lines.
  final int minLines;

  /// Whether the editor is read-only.
  final bool readOnly;

  /// Custom input decoration.
  final InputDecoration? decoration;

  /// Base text style for the editor.
  final TextStyle? textStyle;

  @override
  State<EditorPane> createState() => _EditorPaneState();
}

class _EditorPaneState extends State<EditorPane> {
  final _scrollController = ScrollController();
  static const _editorPadding = EdgeInsets.all(12);

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(EditorPane oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onTextChanged);
      widget.controller.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _scrollController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    // Rebuild to update line offsets in the gutter.
    setState(() {});
  }

  /// Measures the height of a single non-wrapped line.
  double _measureLineHeight(TextStyle style, StrutStyle strutStyle) {
    final tp = TextPainter(
      text: TextSpan(text: 'Xg', style: style),
      strutStyle: strutStyle,
      textDirection: TextDirection.ltr,
    )..layout();
    return tp.preferredLineHeight;
  }

  /// Computes the y-offset of each logical line by measuring how much vertical
  /// space each line occupies when word-wrapped to [maxWidth].
  List<double> _computeLineOffsets(
    TextStyle style,
    StrutStyle strutStyle,
    double maxWidth,
  ) {
    final text = widget.controller.text;
    final lines = text.split('\n');
    final offsets = <double>[];
    var y = 0.0;

    for (final line in lines) {
      offsets.add(y);
      final tp = TextPainter(
        text: TextSpan(text: line.isEmpty ? ' ' : line, style: style),
        strutStyle: strutStyle,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: maxWidth > 0 ? maxWidth : double.infinity);
      y += tp.height;
    }

    return offsets;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseStyle = widget.textStyle ??
        TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
          height: 1.5,
          color: colorScheme.onSurface,
        );

    final strutStyle = StrutStyle(
      fontFamily: baseStyle.fontFamily,
      fontSize: baseStyle.fontSize,
      height: baseStyle.height,
      forceStrutHeight: true,
    );

    if (!widget.showLineNumbers) {
      return _buildTextField(baseStyle, strutStyle);
    }

    // Use LayoutBuilder to know the available width for word-wrap measurement.
    return LayoutBuilder(
      builder: (context, constraints) {
        final lineCount = _lineCount;
        final gutterWidth = computeGutterWidth(lineCount);
        final textFieldWidth = constraints.maxWidth - gutterWidth;
        final contentWidth =
            textFieldWidth - _editorPadding.left - _editorPadding.right;

        final singleLineHeight = _measureLineHeight(baseStyle, strutStyle);
        final lineOffsets =
            _computeLineOffsets(baseStyle, strutStyle, contentWidth);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LineNumberGutter(
              lineOffsets: lineOffsets,
              singleLineHeight: singleLineHeight,
              scrollController: _scrollController,
              topPadding: _editorPadding.top,
              gutterWidth: gutterWidth,
            ),
            Expanded(child: _buildTextField(baseStyle, strutStyle)),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextStyle baseStyle, StrutStyle strutStyle) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      scrollController: _scrollController,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      readOnly: widget.readOnly,
      style: baseStyle,
      strutStyle: strutStyle,
      decoration: widget.decoration ??
          InputDecoration(
            border: InputBorder.none,
            contentPadding: _editorPadding,
            hintText: 'Write markdown...',
            hintStyle: TextStyle(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              fontFamily: 'monospace',
            ),
          ),
      keyboardType: TextInputType.multiline,
    );
  }

  int get _lineCount {
    final text = widget.controller.text;
    if (text.isEmpty) return 1;
    return '\n'.allMatches(text).length + 1;
  }
}
