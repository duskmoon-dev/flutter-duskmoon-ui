import 'package:flutter/material.dart';

import '../../markdown/dm_markdown_config.dart';
import '../models/dm_chat_block.dart';
import '../models/dm_chat_message.dart';
import '../theme/dm_chat_theme.dart';
import '_bubble_frame.dart';
import '_bubble_stream_coordinator.dart';
import 'blocks/_attachment_block_view.dart';
import 'blocks/_custom_block_view.dart';
import 'blocks/_text_block_view.dart';
import 'blocks/_thinking_block_view.dart';
import 'blocks/_tool_call_block_view.dart';

/// Renders a single chat message. Stateful so each block can own per-stream
/// subscriptions without losing state across rebuilds.
class DmChatBubble extends StatefulWidget {
  const DmChatBubble({
    super.key,
    required this.message,
    this.avatar,
    this.header,
    this.markdownConfig = const DmMarkdownConfig(),
    this.theme,
  });

  final DmChatMessage message;
  final Widget? avatar;
  final Widget? header;
  final DmMarkdownConfig markdownConfig;
  final DmChatTheme? theme;

  @override
  State<DmChatBubble> createState() => _DmChatBubbleState();
}

class _DmChatBubbleState extends State<DmChatBubble> {
  late final BubbleStreamCoordinator _coordinator = BubbleStreamCoordinator();

  @override
  void dispose() {
    _coordinator.dispose();
    super.dispose();
  }

  List<Widget> _buildBlocks() {
    final blocks = widget.message.blocks;
    final children = <Widget>[];
    for (var i = 0; i < blocks.length; i++) {
      final b = blocks[i];
      children.add(_buildBlock(b));
      if (i < blocks.length - 1) {
        children.add(const SizedBox(height: 8));
      }
    }
    return children;
  }

  Widget _buildBlock(DmChatBlock b) {
    return switch (b) {
      DmChatTextBlock() => _TextBlockWithStreamSignal(
          block: b,
          config: widget.markdownConfig,
          coordinator: _coordinator,
        ),
      DmChatThinkingBlock() => DmChatThinkingBlockView(
          block: b,
          config: widget.markdownConfig,
        ),
      DmChatToolCallBlock() => DmChatToolCallBlockView(
          block: b,
          config: widget.markdownConfig,
        ),
      DmChatAttachmentBlock() => DmChatAttachmentBlockView(block: b),
      DmChatCustomBlock() => CustomBlockView(block: b),
    };
  }

  @override
  Widget build(BuildContext context) {
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _buildBlocks(),
    );
    final frame = BubbleFrame(
      role: widget.message.role,
      avatar: widget.avatar,
      header: widget.header,
      child: body,
    );
    final wrapped = BubbleStreamScope(
      coordinator: _coordinator,
      child: frame,
    );
    if (widget.theme != null) {
      return Theme(
        data: Theme.of(context).copyWith(extensions: [
          ...Theme.of(context).extensions.values,
          widget.theme!,
        ]),
        child: wrapped,
      );
    }
    return wrapped;
  }
}

/// Wrapper that signals the bubble coordinator on first stream emission.
class _TextBlockWithStreamSignal extends StatefulWidget {
  const _TextBlockWithStreamSignal({
    required this.block,
    required this.config,
    required this.coordinator,
  });

  final DmChatTextBlock block;
  final DmMarkdownConfig config;
  final BubbleStreamCoordinator coordinator;

  @override
  State<_TextBlockWithStreamSignal> createState() =>
      _TextBlockWithStreamSignalState();
}

class _TextBlockWithStreamSignalState
    extends State<_TextBlockWithStreamSignal> {
  Stream<String>? _wrappedStream;

  @override
  void initState() {
    super.initState();
    _wrapStream();
  }

  @override
  void didUpdateWidget(_TextBlockWithStreamSignal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.block.stream != oldWidget.block.stream) {
      _wrapStream();
    }
    if (widget.block.text != null && widget.block.text!.isNotEmpty) {
      widget.coordinator.markTextStarted();
    }
  }

  void _wrapStream() {
    final src = widget.block.stream;
    if (src == null) {
      _wrappedStream = null;
      return;
    }
    _wrappedStream = src.map((chunk) {
      if (chunk.isNotEmpty) widget.coordinator.markTextStarted();
      return chunk;
    });
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBlock = _wrappedStream != null
        ? DmChatTextBlock(stream: _wrappedStream)
        : widget.block;
    return TextBlockView(block: effectiveBlock, config: widget.config);
  }
}
