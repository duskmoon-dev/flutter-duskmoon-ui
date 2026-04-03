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
  static const _lineHeight = 20.0;
  static const _editorPadding = EdgeInsets.all(12);

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseStyle = widget.textStyle ??
        TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
          height: _lineHeight / 14,
          color: colorScheme.onSurface,
        );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLineNumbers)
          LineNumberGutter(
            lineCount: _lineCount,
            scrollController: _scrollController,
            lineHeight: _lineHeight,
            topPadding: _editorPadding.top,
          ),
        Expanded(
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            scrollController: _scrollController,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            readOnly: widget.readOnly,
            style: baseStyle,
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
          ),
        ),
      ],
    );
  }

  int get _lineCount {
    final text = widget.controller.text;
    if (text.isEmpty) return 1;
    return '\n'.allMatches(text).length + 1;
  }
}
