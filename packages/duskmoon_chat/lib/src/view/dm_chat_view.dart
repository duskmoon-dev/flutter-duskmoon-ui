import 'dart:math' as math;

import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';

import '../bubble/dm_chat_bubble.dart';
import '../models/dm_chat_message.dart';

class DmChatView extends StatefulWidget {
  const DmChatView({
    super.key,
    required this.messages,
    required this.onSend,
    this.onStop,
    this.markdownConfig = const DmMarkdownConfig(),
    this.assistantAvatar,
  });

  final List<DmChatMessage> messages;
  final ValueChanged<String> onSend;
  final VoidCallback? onStop;
  final DmMarkdownConfig markdownConfig;
  final Widget? assistantAvatar;

  @override
  State<DmChatView> createState() => _DmChatViewState();
}

class _DmChatViewState extends State<DmChatView> {
  late DmMarkdownInputController _inputController;

  @override
  void initState() {
    super.initState();
    _inputController = _createInputController();
  }

  @override
  void didUpdateWidget(DmChatView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_markdownParsingConfigChanged(
      oldWidget.markdownConfig,
      widget.markdownConfig,
    )) {
      final text = _inputController.text;
      final selection = _inputController.selection;
      _inputController.dispose();
      _inputController = _createInputController(text: text);
      _inputController.selection = selection.copyWith(
        baseOffset: selection.baseOffset.clamp(0, text.length),
        extentOffset: selection.extentOffset.clamp(0, text.length),
      );
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _inputController.text.trim();
    if (text.isEmpty) {
      return;
    }

    widget.onSend(text);
    _inputController.clear();
  }

  DmMarkdownInputController _createInputController({String? text}) {
    return DmMarkdownInputController(
      text: text,
      enableGfm: widget.markdownConfig.enableGfm,
      enableKatex: widget.markdownConfig.enableKatex,
    );
  }

  bool _markdownParsingConfigChanged(
    DmMarkdownConfig oldConfig,
    DmMarkdownConfig newConfig,
  ) {
    return oldConfig.enableGfm != newConfig.enableGfm ||
        oldConfig.enableKatex != newConfig.enableKatex;
  }

  @override
  Widget build(BuildContext context) {
    final reversedMessages = widget.messages.reversed.toList();
    final isStreaming = widget.messages.isNotEmpty &&
        widget.messages.last.status == DmChatMessageStatus.streaming;

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasBoundedHeight =
            constraints.hasBoundedHeight && constraints.maxHeight.isFinite;
        final verticalPadding =
            hasBoundedHeight && constraints.maxHeight < 280 ? 8.0 : 16.0;
        final composerHeight = _composerHeight(
          maxHeight: hasBoundedHeight ? constraints.maxHeight : null,
          verticalPadding: verticalPadding,
        );

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                reverse: true,
                padding: const EdgeInsets.all(16),
                itemCount: reversedMessages.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final message = reversedMessages[index];

                  return DmChatBubble(
                    key: ValueKey<String>(message.id),
                    message: message,
                    markdownConfig: widget.markdownConfig,
                    avatar: widget.assistantAvatar,
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(verticalPadding),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 0,
                  maxHeight: composerHeight,
                ),
                child: DmMarkdownInput(
                  key: ValueKey<Object>(
                    (
                      widget.markdownConfig.enableGfm,
                      widget.markdownConfig.enableKatex,
                    ),
                  ),
                  controller: _inputController,
                  config: widget.markdownConfig,
                  minLines: 1,
                  maxLines: 5,
                  showPreview: composerHeight >= 112,
                  bottomRight: isStreaming && widget.onStop != null
                      ? DmIconButton(
                          icon: const Icon(
                            Icons.stop_circle_outlined,
                            semanticLabel: 'Stop response',
                          ),
                          onPressed: widget.onStop,
                          tooltip: 'Stop response',
                        )
                      : DmIconButton(
                          icon: const Icon(
                            Icons.send,
                            semanticLabel: 'Send message',
                          ),
                          onPressed: _handleSend,
                          tooltip: 'Send message',
                        ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  double _composerHeight({
    required double? maxHeight,
    required double verticalPadding,
  }) {
    if (maxHeight == null) {
      return 180;
    }

    final availableHeight = math.max(0.0, maxHeight - verticalPadding * 2);
    final desiredHeight = (maxHeight * 0.35).clamp(96.0, 220.0).toDouble();

    return math.min(availableHeight, desiredHeight);
  }
}
