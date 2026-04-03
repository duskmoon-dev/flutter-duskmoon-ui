import 'package:flutter/material.dart' hide InlineSpan;

import '../language/language.dart';
import '../language/syntax.dart';
import '../lezer/common/tree.dart';
import '../state/editor_state.dart';
import '../state/extension.dart';
import '../theme/default_highlight.dart';
import '../theme/editor_theme.dart';
import 'editor_view_controller.dart';
import 'gutter_painter.dart';
import 'highlight_builder.dart';
import 'line_painter.dart';

const String _kFontFamily = 'monospace';
const double _kFontSize = 14.0;
const double _kLineHeight = 22.0;
const double _kGutterWidth = 48.0;

/// A read/write code editor with syntax highlighting and optional line numbers.
///
/// Renders the document using [ListView.builder] for virtual line rendering.
/// Syntax highlighting is computed per-line from the current syntax tree.
class CodeEditorWidget extends StatefulWidget {
  const CodeEditorWidget({
    super.key,
    this.initialDoc,
    this.language,
    this.extensions = const [],
    this.theme,
    this.readOnly = false,
    this.lineNumbers = true,
    this.highlightActiveLine = true,
    this.onStateChanged,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.minHeight,
    this.maxHeight,
    this.padding,
    this.scrollPhysics,
  });

  /// Initial document text. Ignored when [controller] is provided.
  final String? initialDoc;

  /// Optional language support for syntax highlighting.
  final LanguageSupport? language;

  /// Additional editor extensions.
  final List<Extension> extensions;

  /// Editor visual theme. Defaults to [EditorTheme.light()].
  final EditorTheme? theme;

  /// When true, the editor does not accept user input.
  final bool readOnly;

  /// Whether to show line numbers in the gutter.
  final bool lineNumbers;

  /// Whether to highlight the line containing the primary cursor.
  final bool highlightActiveLine;

  /// Called whenever the [EditorState] changes.
  final void Function(EditorState state)? onStateChanged;

  /// Optional external controller. If not provided, one is created internally.
  final EditorViewController? controller;

  /// Optional external focus node.
  final FocusNode? focusNode;

  /// Whether to focus the editor immediately on mount.
  final bool autofocus;

  /// Minimum height of the editor container. `null` means unconstrained.
  final double? minHeight;

  /// Maximum height of the editor container. `null` means unconstrained.
  final double? maxHeight;

  /// Padding inside the content area.
  final EdgeInsets? padding;

  /// Scroll physics for the line list.
  final ScrollPhysics? scrollPhysics;

  @override
  State<CodeEditorWidget> createState() => _CodeEditorWidgetState();
}

class _CodeEditorWidgetState extends State<CodeEditorWidget> {
  late EditorViewController _controller;
  late FocusNode _focusNode;
  bool _ownsController = false;
  bool _ownsFocusNode = false;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      _controller = EditorViewController(
        text: widget.initialDoc ?? '',
        language: widget.language,
        extensions: widget.extensions,
        theme: widget.theme,
      );
      _ownsController = true;
    }

    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
      _ownsFocusNode = false;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    }

    _controller.view.addListener(_onViewChanged);
  }

  @override
  void didUpdateWidget(CodeEditorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle controller swap.
    if (widget.controller != oldWidget.controller) {
      _controller.view.removeListener(_onViewChanged);
      if (_ownsController) {
        _controller.dispose();
      }
      if (widget.controller != null) {
        _controller = widget.controller!;
        _ownsController = false;
      } else {
        _controller = EditorViewController(
          text: widget.initialDoc ?? '',
          language: widget.language,
          extensions: widget.extensions,
          theme: widget.theme,
        );
        _ownsController = true;
      }
      _controller.view.addListener(_onViewChanged);
    }

    // Handle focus node swap.
    if (widget.focusNode != oldWidget.focusNode) {
      if (_ownsFocusNode) _focusNode.dispose();
      if (widget.focusNode != null) {
        _focusNode = widget.focusNode!;
        _ownsFocusNode = false;
      } else {
        _focusNode = FocusNode();
        _ownsFocusNode = true;
      }
    }
  }

  @override
  void dispose() {
    _controller.view.removeListener(_onViewChanged);
    if (_ownsController) _controller.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  void _onViewChanged() {
    setState(() {});
    widget.onStateChanged?.call(_controller.state);
  }

  EditorTheme get _effectiveTheme =>
      widget.theme ?? _controller.theme ?? EditorTheme.light();

  @override
  Widget build(BuildContext context) {
    final theme = _effectiveTheme;
    final doc = _controller.document;
    final state = _controller.state;
    final lineCount = doc.lineCount;

    final activeLineNumber =
        doc.lineAtOffset(state.selection.main.head).number;

    Widget listView = ListView.builder(
      physics: widget.scrollPhysics,
      itemCount: lineCount,
      itemExtent: _kLineHeight,
      itemBuilder: (context, index) {
        final line = doc.lineAt(index + 1); // 1-based
        final tree = syntaxTree(state) ?? Tree.empty;
        final highlightStyle = theme.highlightStyle.specs.isEmpty
            ? defaultLightHighlight
            : theme.highlightStyle;
        final spans = HighlightBuilder.buildSpans(
          tree: tree,
          source: doc.toString(),
          lineFrom: line.from,
          lineTo: line.to,
          highlightStyle: highlightStyle,
          defaultStyle: TextStyle(color: theme.foreground),
        );

        final isActiveLine =
            widget.highlightActiveLine && (index + 1) == activeLineNumber;

        return SizedBox(
          height: _kLineHeight,
          child: CustomPaint(
            painter: LinePainter(
              spans: spans,
              lineHeight: _kLineHeight,
              fontFamily: _kFontFamily,
              fontSize: _kFontSize,
              backgroundColor: isActiveLine ? theme.lineHighlight : null,
            ),
          ),
        );
      },
    );

    if (widget.padding != null) {
      listView = Padding(padding: widget.padding!, child: listView);
    }

    Widget content;
    if (widget.lineNumbers) {
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _kGutterWidth,
            child: ListView.builder(
              physics: widget.scrollPhysics,
              itemCount: lineCount,
              itemExtent: _kLineHeight,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: _kLineHeight,
                  width: _kGutterWidth,
                  child: CustomPaint(
                    painter: GutterPainter(
                      firstLine: index,
                      lineCount: 1,
                      lineHeight: _kLineHeight,
                      activeLine: activeLineNumber,
                      foreground: theme.gutterForeground,
                      activeForeground: theme.gutterActiveForeground,
                      background: theme.gutterBackground,
                      fontFamily: _kFontFamily,
                      fontSize: _kFontSize,
                      gutterWidth: _kGutterWidth,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(child: listView),
        ],
      );
    } else {
      content = listView;
    }

    Widget container = Container(
      color: theme.background,
      child: content,
    );

    if (widget.minHeight != null || widget.maxHeight != null) {
      container = ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: widget.minHeight ?? 0.0,
          maxHeight: widget.maxHeight ?? double.infinity,
        ),
        child: container,
      );
    }

    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      child: container,
    );
  }
}
