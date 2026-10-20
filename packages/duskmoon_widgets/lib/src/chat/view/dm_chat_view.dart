import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../markdown/dm_markdown_config.dart';
import '../../markdown_input/dm_markdown_input_controller.dart';
import '../bubble/dm_chat_bubble.dart';
import '../input/dm_chat_input.dart';
import '../input/dm_chat_submit_shortcut.dart';
import '../models/dm_chat_attachment.dart';
import '../models/dm_chat_message.dart';
import '../theme/dm_chat_theme.dart';
import '_message_navigation.dart';
import '_scroll_tracker.dart';

/// Optional retry callback exposed on [DmChatView] for error recovery.
typedef DmChatRetryCallback = void Function(DmChatMessage message);

/// Composed chat view with user-message navigation, pinned auto-scroll,
/// and an input bar. Messages are ordered from oldest to newest.
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
    this.inputMinLines = 1,
    this.inputMaxLines = 8,
    this.submitShortcut = DmChatSubmitShortcut.cmdEnter,
    this.markdownConfig = const DmMarkdownConfig(),
    this.emptyBuilder,
    this.avatarBuilder,
    this.headerBuilder,
    this.showJumpToBottom = true,
    this.showMessageNavigation = true,
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
  final int inputMinLines;
  final int inputMaxLines;
  final DmChatSubmitShortcut submitShortcut;
  final DmMarkdownConfig markdownConfig;
  final WidgetBuilder? emptyBuilder;
  final Widget? Function(BuildContext, DmChatMessage)? avatarBuilder;
  final Widget? Function(BuildContext, DmChatMessage)? headerBuilder;
  final bool showJumpToBottom;

  /// Shows a leading navigation rail with one marker per user message.
  /// Hover or focus a marker to preview the turn; activate it to jump there.
  final bool showMessageNavigation;
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
  late final ChatScrollTracker _tracker =
      ChatScrollTracker(reverse: widget.reverse)
        ..attach()
        ..controller.addListener(_scheduleNavigationUpdate);
  final _listKey = GlobalKey();
  final _messageKeys = <String, GlobalKey>{};
  final _activeMessageId = ValueNotifier<String?>(null);
  late int _messageCount;
  bool _navigationUpdateScheduled = false;
  int _navigationGeneration = 0;
  String? _navigatingTo;

  @override
  void initState() {
    super.initState();
    _messageCount = widget.messages.length;
  }

  @override
  void didUpdateWidget(DmChatView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _tracker.reverse = widget.reverse;
    if (widget.messages.length > _messageCount && widget.autoScroll) {
      final added = widget.messages.last;
      final fromAssistant = added.role == DmChatRole.assistant;
      if (_tracker.pinned && _navigatingTo == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _tracker.scrollToBottom();
        });
      } else {
        _tracker.onNewMessage(fromAssistant: fromAssistant);
      }
    }
    _messageCount = widget.messages.length;
    if (!widget.showMessageNavigation ||
        !widget.messages.any((message) => message.id == _navigatingTo)) {
      _cancelNavigation();
    }
    _scheduleNavigationUpdate();
  }

  @override
  void dispose() {
    _navigationGeneration++;
    _tracker.controller.removeListener(_scheduleNavigationUpdate);
    _tracker.dispose();
    _activeMessageId.dispose();
    super.dispose();
  }

  void _cancelNavigation() {
    _navigationGeneration++;
    _navigatingTo = null;
  }

  void _scheduleNavigationUpdate() {
    if (_navigationUpdateScheduled) return;
    _navigationUpdateScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigationUpdateScheduled = false;
      if (!mounted) return;
      _tracker.refresh();
      if (!widget.showMessageNavigation || _navigatingTo != null) return;
      final viewport = _listKey.currentContext?.findRenderObject();
      if (viewport is! RenderBox || !viewport.hasSize) return;

      var visibleIndex = -1;
      var firstTop = double.infinity;
      for (var i = 0; i < widget.messages.length; i++) {
        final box = _messageKeys[widget.messages[i].id]
            ?.currentContext
            ?.findRenderObject();
        if (box is! RenderBox || !box.attached || !box.hasSize) continue;
        final top = box.localToGlobal(Offset.zero, ancestor: viewport).dy;
        if (top + box.size.height > 0 &&
            top < viewport.size.height &&
            top < firstTop) {
          visibleIndex = i;
          firstTop = top;
        }
      }
      if (_tracker.pinned) visibleIndex = widget.messages.length - 1;
      String? active;
      for (var i = visibleIndex; i >= 0; i--) {
        if (widget.messages[i].role == DmChatRole.user) {
          active = widget.messages[i].id;
          break;
        }
      }
      _activeMessageId.value = active;
    });
  }

  Future<void> _scrollToMessage(String id) async {
    final generation = ++_navigationGeneration;
    _navigatingTo = id;
    _activeMessageId.value = id;
    double? lowerBound;
    double? upperBound;

    // Lazy rows do not have a render object until built. Seek using measured
    // rows, then reveal the actual target rather than an estimated fraction.
    while (mounted && generation == _navigationGeneration) {
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted || generation != _navigationGeneration) return;
      if (!_tracker.controller.hasClients) break;
      final messages = widget.reverse
          ? widget.messages.reversed.toList(growable: false)
          : widget.messages;
      final target = messages.indexWhere((message) => message.id == id);
      if (target < 0) break;
      final position = _tracker.controller.position;
      final targetBox = _messageKeys[id]?.currentContext?.findRenderObject();
      if (targetBox is RenderBox && targetBox.attached && targetBox.hasSize) {
        await position.ensureVisible(
          targetBox,
          alignment: widget.reverse ? 1 : 0,
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
        break;
      }

      final rows = <({int index, RenderBox box})>[];
      for (var i = 0; i < messages.length; i++) {
        final box =
            _messageKeys[messages[i].id]?.currentContext?.findRenderObject();
        if (box is RenderBox && box.attached && box.hasSize) {
          rows.add((index: i, box: box));
        }
      }
      if (rows.isEmpty) break;
      if (target > rows.last.index) lowerBound = position.pixels;
      if (target < rows.first.index) upperBound = position.pixels;
      final anchor = rows.reduce((a, b) =>
          (a.index - target).abs() < (b.index - target).abs() ? a : b);
      final average =
          rows.fold<double>(0, (sum, row) => sum + row.box.size.height) /
              rows.length;
      final anchorOffset = RenderAbstractViewport.of(anchor.box)
          .getOffsetToReveal(anchor.box, 0)
          .offset;
      final delta = target - anchor.index;
      var next = anchorOffset +
          (delta > 0
              ? anchor.box.size.height + (delta - 1) * average
              : delta * average);
      if (lowerBound != null &&
          upperBound != null &&
          (next <= lowerBound || next >= upperBound)) {
        next = (lowerBound + upperBound) / 2;
      }
      next = next.clamp(position.minScrollExtent, position.maxScrollExtent);
      if ((next - position.pixels).abs() < 0.5) break;
      _tracker.controller.jumpTo(next);
    }
    if (mounted && generation == _navigationGeneration) {
      _navigatingTo = null;
      _scheduleNavigationUpdate();
    }
  }

  Widget _buildList() {
    final messages = widget.reverse
        ? widget.messages.reversed.toList(growable: false)
        : widget.messages;
    final ids = messages.map((message) => message.id).toSet();
    _messageKeys.removeWhere((id, _) => !ids.contains(id));
    final indices = <Key, int>{
      for (var i = 0; i < messages.length; i++)
        _messageKeys.putIfAbsent(messages[i].id, GlobalKey.new): i,
    };
    final spacing = (widget.theme ??
            Theme.of(context).extension<DmChatTheme>() ??
            DmChatTheme.withContext(context))
        .rowSpacing;
    _scheduleNavigationUpdate();
    return ListView.builder(
      key: _listKey,
      controller: _tracker.controller,
      reverse: widget.reverse,
      padding: widget.padding ?? const EdgeInsets.all(16),
      itemCount: messages.length,
      findChildIndexCallback: (key) => indices[key],
      itemBuilder: (ctx, i) {
        final msg = messages[i];
        final gap = i == messages.length - 1 ? 0.0 : spacing;
        return Padding(
          key: _messageKeys[msg.id],
          padding: widget.reverse
              ? EdgeInsets.only(top: gap)
              : EdgeInsets.only(bottom: gap),
          child: SizeChangedLayoutNotifier(
            child: DmChatBubble(
              key: ValueKey(msg.id),
              message: msg,
              avatar: widget.avatarBuilder?.call(ctx, msg),
              header: widget.headerBuilder?.call(ctx, msg),
              markdownConfig: widget.markdownConfig,
              theme: widget.theme,
            ),
          ),
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
              NotificationListener<ScrollMetricsNotification>(
                onNotification: (_) {
                  _scheduleNavigationUpdate();
                  return false;
                },
                child: NotificationListener<SizeChangedLayoutNotification>(
                  onNotification: (_) {
                    _scheduleNavigationUpdate();
                    return false;
                  },
                  child: NotificationListener<UserScrollNotification>(
                    onNotification: (notification) {
                      if (notification.direction != ScrollDirection.idle) {
                        _cancelNavigation();
                      }
                      return false;
                    },
                    child: _buildList(),
                  ),
                ),
              ),
              if (widget.showJumpToBottom)
                AnimatedBuilder(
                  animation: _tracker,
                  builder: (_, _) {
                    if (_tracker.pinned) return const SizedBox.shrink();
                    return Positioned(
                      right: 16,
                      bottom: 16,
                      child: FloatingActionButton.small(
                        heroTag: null,
                        onPressed: () {
                          _cancelNavigation();
                          _tracker.scrollToBottom();
                        },
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
          Expanded(
            child: Row(
              children: [
                if (widget.showMessageNavigation &&
                    widget.messages.any((m) => m.role == DmChatRole.user))
                  SizedBox(
                    width: 40,
                    child: ValueListenableBuilder<String?>(
                      valueListenable: _activeMessageId,
                      builder: (_, active, _) => ChatMessageNavigation(
                        messages: widget.messages,
                        activeMessageId: active,
                        onSelected: _scrollToMessage,
                      ),
                    ),
                  ),
                Expanded(child: body),
              ],
            ),
          ),
          DmChatInput(
            controller: widget.inputController,
            onSend: widget.onSend ?? (_, _) {},
            onStop: widget.onStop,
            onAttach: widget.onAttach,
            uploadAdapter: widget.uploadAdapter,
            isStreaming: widget.isStreaming,
            pendingAttachments: widget.pendingAttachments,
            onRemoveAttachment: widget.onRemoveAttachment,
            placeholder: widget.inputPlaceholder,
            leading: widget.inputLeading,
            trailing: widget.inputTrailing,
            minLines: widget.inputMinLines,
            maxLines: widget.inputMaxLines,
            submitShortcut: widget.submitShortcut,
          ),
        ],
      ),
    );
  }
}
