import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

import '../_shared/incremental_parser.dart';
import '_block_widget_builder.dart';
import '_stream_handler.dart';
import 'dm_markdown_config.dart';
import 'dm_markdown_scroll_controller.dart';

/// A standalone read-only markdown renderer.
///
/// Accepts one of three input modes:
/// - [data]: Raw markdown string — parsed internally.
/// - [nodes]: Pre-parsed AST nodes — renders directly (no parse step).
/// - [stream]: Streaming markdown chunks — incrementally parsed.
///
/// Features include GFM, KaTeX math, syntax-highlighted code, scroll-to-anchor,
/// selectable text, and custom theme override.
///
/// ```dart
/// DmMarkdown(data: '# Hello\n\nSome **bold** text')
/// ```
class DmMarkdown extends StatefulWidget {
  /// Creates a markdown widget. Exactly one of [data], [nodes], or [stream]
  /// must be provided.
  const DmMarkdown({
    super.key,
    this.data,
    this.nodes,
    this.stream,
    this.config = const DmMarkdownConfig(),
    this.controller,
    this.selectable = true,
    this.shrinkWrap = false,
    this.physics,
    this.padding,
    this.themeData,
    this.onLinkTap,
    this.onImageTap,
    this.imageErrorBuilder,
  }) : assert(
          (data != null ? 1 : 0) +
                  (nodes != null ? 1 : 0) +
                  (stream != null ? 1 : 0) ==
              1,
          'Exactly one of data, nodes, or stream must be provided',
        );

  /// Raw markdown string — parsed internally.
  final String? data;

  /// Pre-parsed AST nodes — skips parsing. Used by [DmMarkdownInput].
  final List<md.Node>? nodes;

  /// Streaming markdown input — incrementally parsed as chunks arrive.
  /// Ideal for LLM output rendering.
  final Stream<String>? stream;

  /// Rendering configuration (features, code theme, custom builders).
  final DmMarkdownConfig config;

  /// Scroll controller for the internal ListView.
  /// Pass a [DmMarkdownScrollController] to enable anchor navigation.
  final ScrollController? controller;

  /// Wrap content in [SelectionArea] for text selection. Defaults to `true`.
  final bool selectable;

  /// If `true`, the ListView uses shrinkWrap (for embedding in Column/scroll).
  final bool shrinkWrap;

  /// Scroll physics override.
  final ScrollPhysics? physics;

  /// Padding around the rendered content.
  final EdgeInsets? padding;

  /// Optional theme override — wraps rendering in a [Theme] widget.
  /// If null, uses the ambient [Theme].
  final ThemeData? themeData;

  /// Called when a link is tapped. If null, defaults to [url_launcher].
  final void Function(String url, String? title)? onLinkTap;

  /// Called when an image is tapped.
  final void Function(String src, String? alt)? onImageTap;

  /// Custom widget shown when an image fails to load.
  final Widget Function(String src, String? alt)? imageErrorBuilder;

  @override
  State<DmMarkdown> createState() => _DmMarkdownState();
}

class _DmMarkdownState extends State<DmMarkdown> {
  IncrementalParser? _parser;
  StreamHandler? _streamHandler;
  List<md.Node> _currentNodes = [];
  bool _isStreamActive = false;

  @override
  void initState() {
    super.initState();
    _initializeInput();
  }

  @override
  void didUpdateWidget(DmMarkdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.data != oldWidget.data && widget.data != null) {
      _parser ??= _createParser();
      final result = _parser!.fullParse(widget.data!);
      setState(() => _currentNodes = result.nodes);
    } else if (widget.nodes != oldWidget.nodes && widget.nodes != null) {
      setState(() => _currentNodes = widget.nodes!);
    } else if (widget.stream != oldWidget.stream && widget.stream != null) {
      _streamHandler?.dispose();
      _initializeStream();
    }
  }

  @override
  void dispose() {
    _streamHandler?.dispose();
    super.dispose();
  }

  void _initializeInput() {
    if (widget.data != null) {
      _parser = _createParser();
      final result = _parser!.fullParse(widget.data!);
      _currentNodes = result.nodes;
    } else if (widget.nodes != null) {
      _currentNodes = widget.nodes!;
    } else if (widget.stream != null) {
      _initializeStream();
    }
  }

  void _initializeStream() {
    _parser = _createParser();
    _isStreamActive = true;
    _streamHandler = StreamHandler(
      stream: widget.stream!,
      parser: _parser!,
      onNodesChanged: (nodes) {
        if (mounted) {
          setState(() {
            _currentNodes = nodes;
            _isStreamActive = _streamHandler?.isActive ?? false;
          });
        }
      },
    );
  }

  IncrementalParser _createParser() {
    return IncrementalParser(
      enableGfm: widget.config.enableGfm,
      enableKatex: widget.config.enableKatex,
    );
  }

  void _defaultLinkHandler(String url, String? title) {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _buildContent(context);

    if (widget.themeData != null) {
      content = Theme(data: widget.themeData!, child: content);
    }

    return content;
  }

  Widget _buildContent(BuildContext context) {
    final theme = widget.themeData ?? Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Clear and rebuild anchor keys.
    final scrollController = widget.controller is DmMarkdownScrollController
        ? widget.controller! as DmMarkdownScrollController
        : null;
    scrollController?.clearAnchors();

    final slugs = <String>{};

    final builder = BlockWidgetBuilder(
      config: widget.config,
      colorScheme: colorScheme,
      textTheme: textTheme,
      slugs: slugs,
      scrollController: scrollController,
      onLinkTap: widget.onLinkTap ?? _defaultLinkHandler,
      onImageTap: widget.onImageTap,
      imageErrorBuilder: widget.imageErrorBuilder,
    );

    final widgets = builder.buildAll(_currentNodes);

    // Add streaming cursor indicator.
    if (_isStreamActive && widgets.isNotEmpty) {
      widgets.add(_StreamingCursor(colorScheme: colorScheme));
    }

    Widget listView = ListView.builder(
      controller: widget.controller,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics ??
          (widget.shrinkWrap ? const NeverScrollableScrollPhysics() : null),
      padding: widget.padding ?? const EdgeInsets.all(16),
      itemCount: widgets.length,
      itemBuilder: (_, index) => widgets[index],
    );

    if (widget.selectable) {
      listView = SelectionArea(child: listView);
    }

    return listView;
  }
}

/// A blinking cursor shown at the end of streaming content.
class _StreamingCursor extends StatefulWidget {
  const _StreamingCursor({required this.colorScheme});
  final ColorScheme colorScheme;

  @override
  State<_StreamingCursor> createState() => _StreamingCursorState();
}

class _StreamingCursorState extends State<_StreamingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Opacity(
        opacity: _controller.value,
        child: Container(
          width: 8,
          height: 18,
          margin: const EdgeInsets.only(left: 2),
          color: widget.colorScheme.primary,
        ),
      ),
    );
  }
}
