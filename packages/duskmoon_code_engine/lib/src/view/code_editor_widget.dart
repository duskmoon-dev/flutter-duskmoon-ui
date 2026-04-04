import 'package:flutter/material.dart' hide InlineSpan;
import 'package:flutter/services.dart';

import '../commands/default_keymap.dart';
import '../commands/keymap.dart';
import '../language/language.dart';
import '../language/syntax.dart';
import '../lezer/common/tree.dart';
import '../state/editor_state.dart';
import '../state/extension.dart';
import '../state/selection.dart';
import '../theme/default_highlight.dart';
import '../theme/editor_theme.dart';
import 'cursor_blink.dart';
import 'editor_view_controller.dart';
import 'gutter_painter.dart';
import 'highlight_builder.dart';
import 'input_handler.dart';
import 'line_painter.dart';
import 'position_utils.dart';
import 'selection_painter.dart';

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
  late CursorBlink _cursorBlink;
  InputHandler? _inputHandler;
  late Keymap _keymap;

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

    _cursorBlink = CursorBlink();
    _cursorBlink.addListener(() => setState(() {}));
    _keymap = defaultKeymap();
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
    _cursorBlink.dispose();
    _inputHandler?.detach();
    super.dispose();
  }

  void _onViewChanged() {
    setState(() {});
    widget.onStateChanged?.call(_controller.state);
  }

  EditorTheme get _effectiveTheme =>
      widget.theme ?? _controller.theme ?? EditorTheme.light();

  // ---------------------------------------------------------------------------
  // Event handlers
  // ---------------------------------------------------------------------------

  void _handleFocusChange(bool focused) {
    if (focused) {
      _cursorBlink.start();
      if (!widget.readOnly) {
        _inputHandler = InputHandler(_controller.view);
        _inputHandler!.attach();
      }
    } else {
      _cursorBlink.stop();
      _inputHandler?.detach();
      _inputHandler = null;
    }
    setState(() {});
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (widget.readOnly) return KeyEventResult.ignored;

    final key = event.logicalKey;
    final ctrl = HardwareKeyboard.instance.isControlPressed ||
        HardwareKeyboard.instance.isMetaPressed;
    final shift = HardwareKeyboard.instance.isShiftPressed;
    final alt = HardwareKeyboard.instance.isAltPressed;

    final binding = _keymap.resolve(key, ctrl, shift, alt);
    if (binding?.run != null) {
      final handled = binding!.run!(_controller.view);
      if (handled) {
        _cursorBlink.restart();
        _inputHandler?.syncState();
        return KeyEventResult.handled;
      }
    }

    // Printable character insertion
    if (!ctrl &&
        !alt &&
        event.character != null &&
        event.character!.isNotEmpty &&
        !_isControlChar(event.character!)) {
      _controller.insertText(event.character!);
      _cursorBlink.restart();
      _inputHandler?.syncState();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  bool _isControlChar(String ch) {
    final code = ch.codeUnitAt(0);
    return code < 0x20 || code == 0x7F;
  }

  void _handleTapDown(TapDownDetails details) {
    final alreadyFocused = _focusNode.hasFocus;
    _focusNode.requestFocus();
    final localY = details.localPosition.dy;
    final lineIndex = PositionUtils.lineForY(
      localY,
      lineHeight: _kLineHeight,
      maxLine: _controller.document.lineCount - 1,
    );
    // MVP: place cursor at start of tapped line
    final offset = PositionUtils.offsetFromLineCol(
      lineIndex,
      0,
      _controller.document,
    );
    _controller.setSelection(EditorSelection.cursor(offset));
    // Only restart blink if focus was already active;
    // if gaining focus for the first time, _handleFocusChange will call start().
    if (alreadyFocused) {
      _cursorBlink.restart();
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = _effectiveTheme;
    final doc = _controller.document;
    final state = _controller.state;
    final lineCount = doc.lineCount;

    final activeLineNumber =
        doc.lineAtOffset(state.selection.main.head).number;
    final cursorLine = doc.lineAtOffset(state.selection.main.head);

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

        final hasCursor =
            _focusNode.hasFocus && (index + 1) == cursorLine.number;

        Widget lineWidget = CustomPaint(
          painter: LinePainter(
            spans: spans,
            lineHeight: _kLineHeight,
            fontFamily: _kFontFamily,
            fontSize: _kFontSize,
            backgroundColor: isActiveLine ? theme.lineHighlight : null,
          ),
        );

        if (hasCursor) {
          // Approximate cursor x using monospace character width
          final col = state.selection.main.head - cursorLine.from;
          const charWidth = _kFontSize * 0.6; // monospace approximation
          final cursorX = col * charWidth;

          lineWidget = Stack(
            children: [
              lineWidget,
              CustomPaint(
                painter: SelectionPainter(
                  selectionRects: const [],
                  cursorOffset: cursorX,
                  cursorHeight: _kLineHeight,
                  selectionColor: theme.selectionBackground,
                  cursorColor: theme.cursorColor,
                  cursorWidth: theme.cursorWidth,
                  showCursor: _cursorBlink.visible,
                ),
              ),
            ],
          );
        }

        return SizedBox(height: _kLineHeight, child: lineWidget);
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
      onFocusChange: _handleFocusChange,
      onKeyEvent: _handleKeyEvent,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        child: container,
      ),
    );
  }
}
