import 'dart:math' as math;

import 'package:flutter/material.dart';

import '_line_number_gutter.dart';
import '_logical_line_metric.dart';
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
  final _editableTextKey = GlobalKey<EditableTextState>();

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

  /// Computes vertical metrics for the laid-out editor paragraph by using the
  /// controller's styled [TextSpan], so wrapping matches the rendered TextField.
  _ParagraphLayoutMetrics _computeParagraphLayoutMetrics(
    TextStyle style,
    StrutStyle strutStyle,
    TextScaler textScaler,
    double maxWidth,
  ) {
    // Use the controller's styled text span so bold/italic/code styles
    // affect wrapping measurement the same way as the rendered TextField.
    final styledSpan = widget.controller.buildTextSpan(
      context: context,
      style: style,
      withComposing: false,
    );

    final tp = TextPainter(
      text: styledSpan,
      strutStyle: strutStyle,
      textDirection: TextDirection.ltr,
      textScaler: textScaler,
    )..layout(maxWidth: maxWidth > 0 ? maxWidth : double.infinity);

    var lineMetrics = tp.computeLineMetrics();
    if (lineMetrics.isEmpty) {
      // Empty text — measure a space to get correct baseline alignment.
      final sampleTp = TextPainter(
        text: TextSpan(text: ' ', style: style),
        strutStyle: strutStyle,
        textDirection: TextDirection.ltr,
        textScaler: textScaler,
      )..layout(maxWidth: maxWidth > 0 ? maxWidth : double.infinity);
      lineMetrics = sampleTp.computeLineMetrics();
      if (lineMetrics.isEmpty) {
        return _ParagraphLayoutMetrics(
          lineMetrics: const [
            LogicalLineMetric(top: 0.0, baseline: 0.0, height: 0.0)
          ],
          lineHeight: tp.preferredLineHeight,
        );
      }
    }

    final metrics = <LogicalLineMetric>[];
    for (var i = 0; i < lineMetrics.length; i++) {
      if (i == 0 || lineMetrics[i - 1].hardBreak) {
        final metric = lineMetrics[i];
        metrics.add(
          LogicalLineMetric(
            top: metric.baseline - metric.ascent,
            baseline: metric.baseline,
            height: metric.height,
          ),
        );
      }
    }

    return _ParagraphLayoutMetrics(
      lineMetrics: metrics,
      lineHeight: lineMetrics.first.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textScaler = MediaQuery.textScalerOf(context);
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

    // Use LayoutBuilder to know the available width for wrap measurement and
    // whether the editor should expand to fill bounded height.
    return LayoutBuilder(
      builder: (context, constraints) {
        final expandToFit =
            constraints.hasBoundedHeight && constraints.maxHeight > 0;

        if (!widget.showLineNumbers) {
          return _buildTextField(
            baseStyle,
            strutStyle,
            expandToFit: expandToFit,
          );
        }

        final lineCount = _lineCount;
        final gutterWidth = computeGutterWidth(
          lineCount: lineCount,
          textStyle: baseStyle,
          textScaler: textScaler,
        );
        final textFieldWidth =
            math.max(0.0, constraints.maxWidth - gutterWidth);
        final contentWidth =
            math.max(0.0, textFieldWidth - _editorPadding.horizontal);

        final paragraphMetrics = _computeParagraphLayoutMetrics(
          baseStyle,
          strutStyle,
          textScaler,
          contentWidth,
        );

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LineNumberGutter(
              lineMetrics: paragraphMetrics.lineMetrics,
              singleLineHeight: paragraphMetrics.lineHeight,
              scrollController: _scrollController,
              topPadding: _editorPadding.top,
              gutterWidth: gutterWidth,
              textStyle: baseStyle,
              strutStyle: strutStyle,
              textScaler: textScaler,
            ),
            Expanded(
              child: _buildTextField(
                baseStyle,
                strutStyle,
                expandToFit: expandToFit,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
    TextStyle baseStyle,
    StrutStyle strutStyle, {
    required bool expandToFit,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveDecoration = widget.decoration ??
        InputDecoration(
          border: InputBorder.none,
          contentPadding: _editorPadding,
          hintText: 'Write markdown...',
          hintStyle: TextStyle(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            fontFamily: 'monospace',
          ),
        );
    final padding = (effectiveDecoration.contentPadding ?? _editorPadding)
        .resolve(Directionality.of(context));
    final hintText = effectiveDecoration.hintText ?? 'Write markdown...';
    final hintStyle = effectiveDecoration.hintStyle ??
        TextStyle(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          fontFamily: 'monospace',
        );

    return Stack(
      key: const ValueKey('dm-markdown-editor-surface'),
      fit: StackFit.expand,
      children: [
        Padding(
          padding: padding,
          child: EditableText(
            key: _editableTextKey,
            controller: widget.controller,
            focusNode: widget.focusNode,
            scrollController: _scrollController,
            maxLines: expandToFit ? null : widget.maxLines,
            minLines: expandToFit ? null : widget.minLines,
            expands: expandToFit,
            readOnly: widget.readOnly,
            style: baseStyle,
            strutStyle: strutStyle,
            cursorColor: colorScheme.primary,
            backgroundCursorColor: colorScheme.onSurface,
            selectionColor: colorScheme.primary.withValues(alpha: 0.28),
            selectionControls: materialTextSelectionControls,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
          ),
        ),
        if (widget.controller.text.isEmpty)
          IgnorePointer(
            child: Padding(
              padding: padding,
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(hintText, style: hintStyle),
              ),
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

class _ParagraphLayoutMetrics {
  const _ParagraphLayoutMetrics({
    required this.lineMetrics,
    required this.lineHeight,
  });

  final List<LogicalLineMetric> lineMetrics;
  final double lineHeight;
}
