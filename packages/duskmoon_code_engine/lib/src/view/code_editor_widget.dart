import 'dart:math' as math;

import 'package:flutter/material.dart' hide InlineSpan;
import 'package:flutter/services.dart';

import '../commands/commands.dart';
import '../commands/default_keymap.dart';
import '../commands/keymap.dart';
import '../document/document.dart';
import '../document/text.dart';
import '../language/language.dart';
import '../language/syntax.dart';
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
import 'search_panel.dart';
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
    this.onChanged,
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

  /// Called when the document text actually changes.
  final ValueChanged<String>? onChanged;

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
  bool _showSearch = false;
  Document? _lastDoc;
  int _lastSearchToggleCount = 0;
  int? _dragAnchorOffset;
  DateTime? _lastTapTime;
  Offset? _lastTapPosition;
  late final ScrollController _scrollController;
  late final ScrollController _horizontalScrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _horizontalScrollController = ScrollController();

    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
      if (widget.language != null && _controller.language != widget.language) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _controller.language = widget.language;
        });
      }
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

    _controller.view.readOnly = widget.readOnly;
    _lastDoc = _controller.document;
    _lastSearchToggleCount = _controller.view.searchToggleCount;
    _controller.view.addListener(_onViewChanged);

    _cursorBlink = CursorBlink();
    _keymap = defaultKeymap();
  }

  @override
  void didUpdateWidget(CodeEditorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final inputChanged = widget.controller != oldWidget.controller ||
        widget.focusNode != oldWidget.focusNode ||
        widget.readOnly != oldWidget.readOnly;
    if (inputChanged) {
      _inputHandler?.detach();
      _inputHandler = null;
    }

    // Handle controller swap.
    if (widget.controller != oldWidget.controller) {
      _controller.view.removeListener(_onViewChanged);
      if (_ownsController) {
        _controller.dispose();
      }
      if (widget.controller != null) {
        _controller = widget.controller!;
        _ownsController = false;
        if (widget.language != null) _controller.language = widget.language;
      } else {
        _controller = EditorViewController(
          text: widget.initialDoc ?? '',
          language: widget.language,
          extensions: widget.extensions,
          theme: widget.theme,
        );
        _ownsController = true;
      }
      _lastDoc = _controller.document;
      _lastSearchToggleCount = _controller.view.searchToggleCount;
      _controller.view.addListener(_onViewChanged);
    }

    _controller.view.readOnly = widget.readOnly;

    if (widget.language != oldWidget.language &&
        widget.controller == oldWidget.controller) {
      _controller.language = widget.language;
    }
    if (widget.theme != oldWidget.theme &&
        widget.controller == oldWidget.controller) {
      _controller.theme = widget.theme;
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

    if (inputChanged && _focusNode.hasFocus && !widget.readOnly) {
      _inputHandler = InputHandler(_controller.view)..attach();
    }
  }

  @override
  void dispose() {
    _controller.view.removeListener(_onViewChanged);
    if (_ownsController) _controller.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    _cursorBlink.dispose();
    _inputHandler?.detach();
    _scrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  (Line, LinePainter) _buildLinePainter(
    Document doc,
    EditorState state,
    EditorTheme theme,
    int lineNumber, {
    bool isActiveLine = false,
  }) {
    final line = doc.lineAt(lineNumber);
    final lineText = line.text;
    final highlightStyle = theme.highlightStyle.specs.isEmpty
        ? defaultLightHighlight
        : theme.highlightStyle;
    final spans = HighlightBuilder.buildSpans(
      tree: syntaxTree(state),
      lineText: lineText,
      lineFrom: line.from,
      lineTo: line.to,
      highlightStyle: highlightStyle,
      defaultStyle: TextStyle(color: theme.foreground),
    );
    final painter = LinePainter(
      spans: spans,
      lineHeight: _kLineHeight,
      fontFamily: _kFontFamily,
      fontSize: _kFontSize,
      fallbackText: lineText,
      defaultStyle: TextStyle(color: theme.foreground),
      backgroundColor: isActiveLine ? theme.lineHighlight : null,
    );
    return (line, painter);
  }

  void _revealCursorIfNeeded() {
    if (!mounted) return;
    final doc = _controller.document;
    final state = _controller.state;
    final cursorLine = doc.lineAtOffset(state.selection.main.head);
    final cursorLineNumber = cursorLine.number;

    if (_scrollController.hasClients) {
      final targetY = (cursorLineNumber - 1) * _kLineHeight;
      final viewportHeight = _scrollController.position.viewportDimension;
      final currentOffsetY = _scrollController.offset;
      if (targetY < currentOffsetY) {
        _scrollController.jumpTo(targetY);
      } else if (targetY + _kLineHeight > currentOffsetY + viewportHeight) {
        _scrollController.jumpTo(
          (targetY + _kLineHeight - viewportHeight).clamp(
            0.0,
            _scrollController.position.maxScrollExtent,
          ),
        );
      }
    }

    if (_horizontalScrollController.hasClients) {
      final (_, painter) = _buildLinePainter(
        doc,
        state,
        _effectiveTheme,
        cursorLineNumber,
      );
      final tp = painter.createTextPainter();
      final col = (state.selection.main.head - cursorLine.from).clamp(
        0,
        cursorLine.length,
      );
      final cursorX =
          tp.getOffsetForCaret(TextPosition(offset: col), Rect.zero).dx;
      final gutterWidth = widget.lineNumbers ? _kGutterWidth : 0.0;
      final viewportWidth =
          _horizontalScrollController.position.viewportDimension - gutterWidth;
      if (viewportWidth > 0) {
        final currentOffsetX = _horizontalScrollController.offset;
        if (cursorX < currentOffsetX) {
          _horizontalScrollController.jumpTo(
            cursorX.clamp(
              0.0,
              _horizontalScrollController.position.maxScrollExtent,
            ),
          );
        } else if (cursorX + 24.0 > currentOffsetX + viewportWidth) {
          _horizontalScrollController.jumpTo(
            (cursorX + 24.0 - viewportWidth).clamp(
              0.0,
              _horizontalScrollController.position.maxScrollExtent,
            ),
          );
        }
      }
    }
  }

  void _closeSearch() {
    if (!_showSearch) return;
    setState(() => _showSearch = false);
    _focusNode.requestFocus();
  }

  void _onViewChanged() {
    if (_controller.view.searchToggleCount != _lastSearchToggleCount) {
      _lastSearchToggleCount = _controller.view.searchToggleCount;
      final nextShow = !_showSearch;
      _showSearch = nextShow;
      if (!nextShow) {
        _focusNode.requestFocus();
      }
    }
    setState(() {});
    widget.onStateChanged?.call(_controller.state);
    final currentDoc = _controller.document;
    if (!identical(currentDoc, _lastDoc)) {
      _lastDoc = currentDoc;
      widget.onChanged?.call(_controller.text);
    }
    _inputHandler?.syncState();
    if (_controller.view.shouldRevealCursor) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _revealCursorIfNeeded(),
      );
    }
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
        _inputHandler ??= InputHandler(_controller.view);
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

    final key = event.logicalKey;
    final ctrl = HardwareKeyboard.instance.isControlPressed ||
        HardwareKeyboard.instance.isMetaPressed;
    final shift = HardwareKeyboard.instance.isShiftPressed;
    final alt = HardwareKeyboard.instance.isAltPressed;

    // Search toggle
    if (ctrl && key == LogicalKeyboardKey.keyF) {
      if (_showSearch) {
        _closeSearch();
      } else {
        setState(() => _showSearch = true);
      }
      return KeyEventResult.handled;
    }
    // Close search on Escape
    if (key == LogicalKeyboardKey.escape && _showSearch) {
      _closeSearch();
      return KeyEventResult.handled;
    }

    // When IME is actively composing and no command modifier is held,
    // let IME handle the keystroke (candidate navigation, enter, backspace, etc.)
    if (!widget.readOnly && _inputHandler?.isComposing == true && !ctrl) {
      return KeyEventResult.ignored;
    }

    final binding = _keymap.resolve(key, ctrl, shift, alt);
    if (binding != null) {
      final cmd =
          (shift && binding.shift != null) ? binding.shift : binding.run;
      if (cmd != null) {
        final handled = cmd(_controller.view);
        if (handled) {
          _cursorBlink.restart();
          _inputHandler?.syncState();
          return KeyEventResult.handled;
        }
      }
    }

    return KeyEventResult.ignored;
  }

  (int, double, double) _hitTestPosition(Offset localPosition) {
    final localY = localPosition.dy;
    final scrollOffsetY =
        _scrollController.hasClients ? _scrollController.offset : 0.0;
    final scrollOffsetX = _horizontalScrollController.hasClients
        ? _horizontalScrollController.offset
        : 0.0;
    final paddingTop = widget.padding?.top ?? 0.0;
    final paddingLeft = widget.padding?.left ?? 0.0;
    final gutterWidth = widget.lineNumbers ? _kGutterWidth : 0.0;

    final effectiveY = localY + scrollOffsetY - paddingTop;
    final contentX =
        localPosition.dx + scrollOffsetX - paddingLeft - gutterWidth;

    final doc = _controller.document;
    final lineIndex = PositionUtils.lineForY(
      effectiveY,
      lineHeight: _kLineHeight,
      maxLine: doc.lineCount - 1,
    );
    final lineNumber = lineIndex + 1;
    final (line, linePainter) = _buildLinePainter(
      doc,
      _controller.state,
      _effectiveTheme,
      lineNumber,
    );
    final tp = linePainter.createTextPainter();
    final pos = tp.getPositionForOffset(
      Offset(contentX.clamp(0.0, double.infinity), _kLineHeight / 2),
    );
    final col = pos.offset.clamp(0, line.length);
    return (line.from + col, contentX, tp.width);
  }

  void _handleTapDown(TapDownDetails details) {
    final alreadyFocused = _focusNode.hasFocus;
    _focusNode.requestFocus();
    final (offset, contentX, lineWidth) = _hitTestPosition(
      details.localPosition,
    );
    final shift = HardwareKeyboard.instance.isShiftPressed;
    final now = DateTime.now();

    final isDoubleTap = !shift &&
        _lastTapTime != null &&
        now.difference(_lastTapTime!) <= const Duration(milliseconds: 300) &&
        _lastTapPosition != null &&
        (details.localPosition - _lastTapPosition!).distance <= 24.0 &&
        contentX >= 0.0 &&
        contentX <= lineWidth + 4.0;

    if (isDoubleTap) {
      final (from, to) = EditorCommands.wordRangeAt(_controller.state, offset);
      _controller.setSelection(EditorSelection.single(anchor: from, head: to));
      _dragAnchorOffset = from;
      _lastTapTime = null;
      _lastTapPosition = null;
    } else if (shift) {
      final anchor = _controller.state.selection.main.anchor;
      _controller.setSelection(
        EditorSelection.single(anchor: anchor, head: offset),
      );
      _dragAnchorOffset = anchor;
      _lastTapTime = now;
      _lastTapPosition = details.localPosition;
    } else {
      _controller.setSelection(EditorSelection.cursor(offset));
      _dragAnchorOffset = offset;
      _lastTapTime = now;
      _lastTapPosition = details.localPosition;
    }

    if (alreadyFocused) {
      _cursorBlink.restart();
      if (!widget.readOnly) {
        _inputHandler ??= InputHandler(_controller.view);
        _inputHandler!.attach();
      }
    }
  }

  void _handlePanStart(DragStartDetails details) {
    _focusNode.requestFocus();
    final (offset, _, _) = _hitTestPosition(details.localPosition);
    _dragAnchorOffset ??= offset;
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    final anchor = _dragAnchorOffset ?? _controller.state.selection.main.anchor;
    final (head, _, _) = _hitTestPosition(details.localPosition);
    _controller.setSelection(
      EditorSelection.single(anchor: anchor, head: head),
    );
    _cursorBlink.restart();
  }

  void _handlePanEnd(DragEndDetails details) {
    _dragAnchorOffset = null;
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

    final cursorLine = doc.lineAtOffset(state.selection.main.head);
    final activeLineNumber = cursorLine.number;

    // Single ListView.builder that renders both gutter cell and content cell
    // per row, so gutter and content always scroll together.
    Widget listView = ListView.builder(
      controller: _scrollController,
      physics: widget.scrollPhysics,
      itemCount: lineCount,
      itemExtent: _kLineHeight,
      itemBuilder: (context, index) {
        final lineNumber = index + 1;
        final isActiveLine =
            widget.highlightActiveLine && lineNumber == activeLineNumber;
        final (line, linePainter) = _buildLinePainter(
          doc,
          state,
          theme,
          lineNumber,
          isActiveLine: isActiveLine,
        );

        final tp = linePainter.createTextPainter();

        // Selection boxes for this line
        final mainSel = state.selection.main;
        final hasSelection = !mainSel.isEmpty &&
            mainSel.from <= line.to &&
            mainSel.to >= line.from;

        final selectionRects = <Rect>[];
        if (hasSelection) {
          final selStartOnLine =
              (mainSel.from < line.from ? 0 : mainSel.from - line.from).clamp(
            0,
            line.length,
          );
          final selEndOnLine =
              (mainSel.to > line.to ? line.length : mainSel.to - line.from)
                  .clamp(0, line.length);
          final extendsPastEnd = mainSel.to > line.to && lineNumber < lineCount;

          if (selStartOnLine < selEndOnLine || extendsPastEnd) {
            final boxes = tp.getBoxesForSelection(
              TextSelection(
                baseOffset: selStartOnLine,
                extentOffset: selEndOnLine,
              ),
            );
            for (final box in boxes) {
              selectionRects.add(
                Rect.fromLTWH(box.left, 0, box.right - box.left, _kLineHeight),
              );
            }
            if (extendsPastEnd) {
              final rightEdge = boxes.isNotEmpty
                  ? boxes.last.right
                  : (line.length == 0 ? 0.0 : tp.width);
              selectionRects.add(
                Rect.fromLTWH(rightEdge, 0, 10.0, _kLineHeight),
              );
            }
          }
        }

        final hasCursor =
            _focusNode.hasFocus && lineNumber == cursorLine.number;

        double? cursorX;
        if (hasCursor) {
          final col = (state.selection.main.head - cursorLine.from).clamp(
            0,
            line.length,
          );
          final caretOffset = tp.getOffsetForCaret(
            TextPosition(offset: col),
            Rect.zero,
          );
          cursorX = caretOffset.dx;
        }

        Widget lineWidget = CustomPaint(painter: linePainter);

        if (selectionRects.isNotEmpty || (hasCursor && cursorX != null)) {
          lineWidget = Stack(
            children: [
              if (selectionRects.isNotEmpty)
                CustomPaint(
                  painter: SelectionPainter(
                    selectionRects: selectionRects,
                    cursorOffset: null,
                    cursorHeight: _kLineHeight,
                    selectionColor: theme.selectionBackground,
                    cursorColor: theme.cursorColor,
                    cursorWidth: theme.cursorWidth,
                    showCursor: false,
                  ),
                ),
              lineWidget,
              if (hasCursor && cursorX != null)
                CustomPaint(
                  painter: SelectionPainter(
                    repaint: _cursorBlink,
                    cursorBlink: _cursorBlink,
                    selectionRects: const [],
                    cursorOffset: cursorX,
                    cursorHeight: _kLineHeight,
                    selectionColor: theme.selectionBackground,
                    cursorColor: theme.cursorColor,
                    cursorWidth: theme.cursorWidth,
                    showCursor: true,
                  ),
                ),
            ],
          );
        }

        if (widget.lineNumbers) {
          return SizedBox(
            height: _kLineHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: _kGutterWidth,
                  height: _kLineHeight,
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
                ),
                Expanded(child: lineWidget),
              ],
            ),
          );
        }

        return SizedBox(height: _kLineHeight, child: lineWidget);
      },
    );

    if (widget.padding != null) {
      listView = Padding(padding: widget.padding!, child: listView);
    }

    final (_, cursorPainter) = _buildLinePainter(
      doc,
      state,
      theme,
      activeLineNumber,
    );
    final cursorLineWidth = cursorPainter.createTextPainter().width;
    final estimatedLineWidth = math.max(
      doc.maxLineLength * (_kFontSize * 0.75),
      cursorLineWidth,
    );

    Widget content = LayoutBuilder(
      builder: (context, constraints) {
        final gutterWidth = widget.lineNumbers ? _kGutterWidth : 0.0;
        final totalWidth = math.max(
          constraints.maxWidth,
          estimatedLineWidth + gutterWidth + 40.0,
        );

        return SingleChildScrollView(
          controller: _horizontalScrollController,
          scrollDirection: Axis.horizontal,
          physics: widget.scrollPhysics,
          child: SizedBox(width: totalWidth, child: listView),
        );
      },
    );

    Widget editorViewport = Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onFocusChange: _handleFocusChange,
      onKeyEvent: _handleKeyEvent,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _handleTapDown,
        onPanStart: _handlePanStart,
        onPanUpdate: _handlePanUpdate,
        onPanEnd: _handlePanEnd,
        child: Container(color: theme.background, child: content),
      ),
    );

    Widget editorContent = editorViewport;

    if (_showSearch) {
      editorContent = Column(
        children: [
          SearchPanel(
            view: _controller.view,
            readOnly: widget.readOnly,
            onClose: _closeSearch,
          ),
          Expanded(child: editorViewport),
        ],
      );
    }

    Widget container = editorContent;

    if (widget.minHeight != null || widget.maxHeight != null) {
      container = ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: widget.minHeight ?? 0.0,
          maxHeight: widget.maxHeight ?? double.infinity,
        ),
        child: container,
      );
    }

    return container;
  }
}
