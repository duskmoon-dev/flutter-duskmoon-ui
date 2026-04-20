import 'package:flutter/material.dart';

import '../../markdown/dm_markdown_config.dart';
import '../../markdown_input/dm_markdown_input_controller.dart';
import '../bubble/dm_chat_bubble.dart';
import '../input/dm_chat_input.dart';
import '../input/dm_chat_submit_shortcut.dart';
import '../models/dm_chat_attachment.dart';
import '../models/dm_chat_message.dart';
import '../theme/dm_chat_theme.dart';
import '_scroll_tracker.dart';

/// Optional retry callback exposed on [DmChatView] for error recovery.
typedef DmChatRetryCallback = void Function(DmChatMessage message);

/// Composed chat view — reverse list + pinned auto-scroll + input bar.
class DmChatView extends StatefulWidget {
  const DmChatView({
    super.key,
    required this.messages,
    this.onSend,
    this.onStop,
    this.onAttach,
    this.onRetry,
    this.uploadAdapter,
    this.isStreaming = false,
    this.inputController,
    this.inputPlaceholder = 'Message…',
    this.inputLeading,
    this.inputTrailing,
    this.submitShortcut = DmChatSubmitShortcut.cmdEnter,
    this.markdownConfig = const DmMarkdownConfig(),
    this.emptyBuilder,
    this.avatarBuilder,
    this.headerBuilder,
    this.showJumpToBottom = true,
    this.autoScroll = true,
    this.reverse = true,
    this.padding,
    this.theme,
    this.onRemoveAttachment,
    this.pendingAttachments = const [],
  });

  final List<DmChatMessage> messages;
  final DmChatSendCallback? onSend;
  final VoidCallback? onStop;
  final ValueChanged<List<DmChatAttachment>>? onAttach;
  final DmChatRetryCallback? onRetry;
  final DmChatUploadAdapter? uploadAdapter;
  final bool isStreaming;
  final DmMarkdownInputController? inputController;
  final String inputPlaceholder;
  final Widget? inputLeading;
  final Widget? inputTrailing;
  final DmChatSubmitShortcut submitShortcut;
  final DmMarkdownConfig markdownConfig;
  final WidgetBuilder? emptyBuilder;
  final Widget? Function(BuildContext, DmChatMessage)? avatarBuilder;
  final Widget? Function(BuildContext, DmChatMessage)? headerBuilder;
  final bool showJumpToBottom;
  final bool autoScroll;
  final bool reverse;
  final EdgeInsets? padding;
  final DmChatTheme? theme;
  final ValueChanged<DmChatAttachment>? onRemoveAttachment;
  final List<DmChatAttachment> pendingAttachments;

  @override
  State<DmChatView> createState() => _DmChatViewState();
}

class _DmChatViewState extends State<DmChatView> {
  late final ChatScrollTracker _tracker = ChatScrollTracker()..attach();

  @override
  void didUpdateWidget(DmChatView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length > oldWidget.messages.length &&
        widget.autoScroll) {
      final added = widget.messages.last;
      final fromAssistant = added.role == DmChatRole.assistant;
      if (_tracker.pinned) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _tracker.scrollToBottom();
        });
      } else {
        _tracker.onNewMessage(fromAssistant: fromAssistant);
      }
    }
  }

  @override
  void dispose() {
    _tracker.dispose();
    super.dispose();
  }

  Widget _buildList() {
    final reversed = widget.messages.reversed.toList(growable: false);
    return ListView.separated(
      controller: _tracker.controller,
      reverse: widget.reverse,
      padding: widget.padding ?? const EdgeInsets.all(16),
      itemCount: reversed.length,
      separatorBuilder: (_, __) => SizedBox(
        height: (Theme.of(context).extension<DmChatTheme>() ??
                DmChatTheme.withContext(context))
            .rowSpacing,
      ),
      itemBuilder: (ctx, i) {
        final msg = reversed[i];
        return DmChatBubble(
          key: ValueKey(msg.id),
          message: msg,
          avatar: widget.avatarBuilder?.call(ctx, msg),
          header: widget.headerBuilder?.call(ctx, msg),
          markdownConfig: widget.markdownConfig,
          theme: widget.theme,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ??
        Theme.of(context).extension<DmChatTheme>() ??
        DmChatTheme.withContext(context);
    final body = widget.messages.isEmpty && widget.emptyBuilder != null
        ? Center(child: widget.emptyBuilder!(context))
        : Stack(
            children: [
              _buildList(),
              if (widget.showJumpToBottom)
                AnimatedBuilder(
                  animation: _tracker,
                  builder: (_, __) {
                    if (_tracker.pinned) return const SizedBox.shrink();
                    return Positioned(
                      right: 16,
                      bottom: 16,
                      child: FloatingActionButton.small(
                        heroTag: null,
                        onPressed: _tracker.scrollToBottom,
                        child: Badge(
                          label: _tracker.unread > 0
                              ? Text('${_tracker.unread}')
                              : null,
                          isLabelVisible: _tracker.unread > 0,
                          child: const Icon(Icons.arrow_downward),
                        ),
                      ),
                    );
                  },
                ),
            ],
          );

    return Theme(
      data: Theme.of(context).copyWith(extensions: [
        ...Theme.of(context).extensions.values.where((e) => e is! DmChatTheme),
        theme,
      ]),
      child: Column(
        children: [
          Expanded(child: body),
          DmChatInput(
            controller: widget.inputController,
            onSend: widget.onSend ?? (_, __) {},
            onStop: widget.onStop,
            onAttach: widget.onAttach,
            uploadAdapter: widget.uploadAdapter,
            isStreaming: widget.isStreaming,
            pendingAttachments: widget.pendingAttachments,
            onRemoveAttachment: widget.onRemoveAttachment,
            placeholder: widget.inputPlaceholder,
            leading: widget.inputLeading,
            trailing: widget.inputTrailing,
            submitShortcut: widget.submitShortcut,
          ),
        ],
      ),
    );
  }
}
