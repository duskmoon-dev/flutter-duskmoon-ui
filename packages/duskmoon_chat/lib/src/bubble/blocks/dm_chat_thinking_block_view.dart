import 'dart:async';

import 'package:duskmoon_widgets/duskmoon_widgets.dart'
    show DmCard, DmMarkdown, DmMarkdownConfig;
import 'package:flutter/material.dart';

import '../../models/dm_chat_message.dart';

class DmChatThinkingBlockView extends StatefulWidget {
  const DmChatThinkingBlockView({
    super.key,
    required this.block,
    this.config = const DmMarkdownConfig(),
    this.themeData,
    this.markdownPadding,
  });

  static const headerKey = ValueKey<String>('dm-chat-thinking-block-header');

  final DmChatThinkingBlock block;
  final DmMarkdownConfig config;
  final ThemeData? themeData;
  final EdgeInsets? markdownPadding;

  @override
  State<DmChatThinkingBlockView> createState() =>
      _DmChatThinkingBlockViewState();
}

class _DmChatThinkingBlockViewState extends State<DmChatThinkingBlockView> {
  late bool _expanded;
  StreamSubscription<String>? _streamSubscription;
  String _streamText = '';
  bool _hasStreamError = false;

  @override
  void initState() {
    super.initState();
    _expanded = widget.block.initiallyExpanded;
    _subscribeToStream(widget.block.stream);
  }

  @override
  void didUpdateWidget(DmChatThinkingBlockView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.block.initiallyExpanded != widget.block.initiallyExpanded) {
      _expanded = widget.block.initiallyExpanded;
    }
    if (oldWidget.block.stream != widget.block.stream) {
      _subscribeToStream(widget.block.stream);
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final headerText = widget.block.duration != null && !_expanded
        ? 'Thought for ${widget.block.duration!.inSeconds}s'
        : 'Thinking...';

    return DmCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            key: DmChatThinkingBlockView.headerKey,
            button: true,
            expanded: _expanded,
            label: headerText,
            onTap: _toggleExpanded,
            child: ExcludeSemantics(
              child: InkWell(
                excludeFromSemantics: true,
                onTap: _toggleExpanded,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.psychology_outlined,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          headerText,
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(
                        _expanded ? Icons.expand_less : Icons.expand_more,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DmMarkdown(
                    data: widget.block.text ?? _streamText,
                    config: widget.config,
                    themeData: widget.themeData,
                    padding: widget.markdownPadding,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                  if (_hasStreamError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Thinking stopped',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _toggleExpanded() {
    setState(() => _expanded = !_expanded);
  }

  void _subscribeToStream(Stream<String>? stream) {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _streamText = '';
    _hasStreamError = false;

    if (stream == null) {
      return;
    }

    _streamSubscription = stream.listen(
      (chunk) {
        if (!mounted) {
          return;
        }
        setState(() {
          _streamText += chunk;
          _hasStreamError = false;
        });
      },
      onError: (Object error, StackTrace stackTrace) {
        if (!mounted) {
          return;
        }
        setState(() => _hasStreamError = true);
      },
    );
  }
}
