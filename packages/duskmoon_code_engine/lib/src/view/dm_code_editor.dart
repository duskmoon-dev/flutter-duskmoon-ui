import 'package:flutter/material.dart' hide InlineSpan;

import '../../duskmoon_code_engine.dart';

/// A batteries-included code editor with configurable top and bottom bars.
///
/// Wraps [CodeEditorWidget] in a [Column] with optional bar slots:
/// - [topBar]: `null` → [DmCodeEditorToolbar], explicit widget → replaces it,
///   `SizedBox.shrink()` → hides it.
/// - [bottomBar]: `null` → [DmCodeEditorStatusBar], explicit widget → replaces
///   it, `SizedBox.shrink()` → hides it.
///
/// When [topBar] is provided, [title] and [actions] are silently ignored.
class DmCodeEditor extends StatefulWidget {
  const DmCodeEditor({
    super.key,
    this.topBar,
    this.bottomBar,
    this.title,
    this.actions,
    this.languageName,
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

  /// Custom top bar widget. `null` uses [DmCodeEditorToolbar].
  final Widget? topBar;

  /// Custom bottom bar widget. `null` uses [DmCodeEditorStatusBar].
  final Widget? bottomBar;

  /// Title shown in the default toolbar. Ignored when [topBar] is provided.
  final String? title;

  /// Actions shown in the default toolbar. Ignored when [topBar] is provided.
  final List<DmEditorAction>? actions;

  /// Language name shown in the default status bar.
  final String? languageName;

  // --- Passthrough to CodeEditorWidget ---

  final String? initialDoc;
  final LanguageSupport? language;
  final List<Extension> extensions;
  final EditorTheme? theme;
  final bool readOnly;
  final bool lineNumbers;
  final bool highlightActiveLine;
  final void Function(EditorState state)? onStateChanged;
  final EditorViewController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final double? minHeight;
  final double? maxHeight;
  final EdgeInsets? padding;
  final ScrollPhysics? scrollPhysics;

  @override
  State<DmCodeEditor> createState() => _DmCodeEditorState();
}

class _DmCodeEditorState extends State<DmCodeEditor> {
  late EditorViewController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(DmCodeEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (_ownsController) _controller.dispose();
      _initController();
    }
  }

  void _initController() {
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
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  Widget _buildTopBar() {
    if (widget.topBar != null) return widget.topBar!;
    return DmCodeEditorToolbar(
      title: widget.title,
      actions: widget.actions ?? const [],
      controller: _controller,
    );
  }

  Widget _buildBottomBar() {
    if (widget.bottomBar != null) return widget.bottomBar!;
    return DmCodeEditorStatusBar(
      controller: _controller,
      languageName: widget.languageName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopBar(),
        Expanded(
          child: CodeEditorWidget(
            controller: _controller,
            language: widget.language,
            extensions: widget.extensions,
            theme: widget.theme,
            readOnly: widget.readOnly,
            lineNumbers: widget.lineNumbers,
            highlightActiveLine: widget.highlightActiveLine,
            onStateChanged: widget.onStateChanged,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            padding: widget.padding,
            scrollPhysics: widget.scrollPhysics,
          ),
        ),
        _buildBottomBar(),
      ],
    );
  }
}
