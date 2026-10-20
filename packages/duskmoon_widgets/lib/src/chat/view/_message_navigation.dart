import 'dart:async';
import 'dart:math' as math;

import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/dm_chat_block.dart';
import '../models/dm_chat_message.dart';

/// Compact navigation through the user turns in a conversation.
class ChatMessageNavigation extends StatefulWidget {
  const ChatMessageNavigation({
    super.key,
    required this.messages,
    required this.activeMessageId,
    required this.onSelected,
  });

  final List<DmChatMessage> messages;
  final String? activeMessageId;
  final ValueChanged<String> onSelected;

  @override
  State<ChatMessageNavigation> createState() => _ChatMessageNavigationState();
}

class _ChatMessageNavigationState extends State<ChatMessageNavigation> {
  double _markerHeight = 10;
  double _railHeight = 0;
  int _activeIndex = -1;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _revealActive());
  }

  @override
  void didUpdateWidget(ChatMessageNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeMessageId != oldWidget.activeMessageId ||
        widget.messages.length != oldWidget.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _revealActive());
    }
  }

  void _revealActive() {
    if (!mounted || !_scrollController.hasClients) return;
    final index = widget.messages
        .where((message) => message.role == DmChatRole.user)
        .toList()
        .indexWhere((message) => message.id == widget.activeMessageId);
    if (index < 0) return;
    final position = _scrollController.position;
    final top = index * _markerHeight;
    if (top < position.pixels ||
        top + _markerHeight > position.pixels + position.viewportDimension) {
      _scrollController.jumpTo(
        (top - (position.viewportDimension - _markerHeight) / 2).clamp(
          0.0,
          position.maxScrollExtent,
        ),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entries = <_NavigationEntry>[];
    for (final message in widget.messages) {
      if (message.role == DmChatRole.user) {
        var prompt = _staticText(message);
        if (prompt.isEmpty) {
          prompt = message.blocks
              .whereType<DmChatAttachmentBlock>()
              .expand((block) => block.attachments)
              .map((attachment) => attachment.name)
              .join(', ');
        }
        entries.add(
          _NavigationEntry(
            id: message.id,
            prompt:
                prompt.isEmpty ? 'User message ${entries.length + 1}' : prompt,
          ),
        );
      } else if (message.role == DmChatRole.assistant &&
          entries.isNotEmpty &&
          entries.last.response == null) {
        final response = _staticText(message);
        if (response.isNotEmpty) {
          final entry = entries.last;
          entries[entries.length - 1] = _NavigationEntry(
            id: entry.id,
            prompt: entry.prompt,
            response: response,
          );
        }
      }
    }
    if (entries.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = math.min(256.0, constraints.maxHeight * 0.6);
        final markerHeight = (maxHeight / entries.length).clamp(4.0, 10.0);
        final railHeight = math.min(maxHeight, entries.length * markerHeight);
        final activeIndex =
            entries.indexWhere((entry) => entry.id == widget.activeMessageId);
        if (_markerHeight != markerHeight ||
            _railHeight != railHeight ||
            _activeIndex != activeIndex) {
          _markerHeight = markerHeight;
          _railHeight = railHeight;
          _activeIndex = activeIndex;
          WidgetsBinding.instance.addPostFrameCallback((_) => _revealActive());
        }

        return Center(
          child: SizedBox(
            height: railHeight,
            child: Scrollbar(
              controller: _scrollController,
              child: ListView.builder(
                controller: _scrollController,
                primary: false,
                padding: EdgeInsets.zero,
                itemExtent: markerHeight,
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return _NavigationMarker(
                    key: ValueKey('chat-navigation-${entry.id}'),
                    entry: entry,
                    index: index,
                    selected: entry.id == widget.activeMessageId,
                    onSelected: () => widget.onSelected(entry.id),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  static String _staticText(DmChatMessage message) => message.blocks
      .whereType<DmChatTextBlock>()
      .map((block) => block.text ?? '')
      .where((text) => text.trim().isNotEmpty)
      .join('\n')
      .trim();
}

class _NavigationEntry {
  const _NavigationEntry({
    required this.id,
    required this.prompt,
    this.response,
  });

  final String id;
  final String prompt;
  final String? response;
}

class _NavigationMarker extends StatefulWidget {
  const _NavigationMarker({
    super.key,
    required this.entry,
    required this.index,
    required this.selected,
    required this.onSelected,
  });

  final _NavigationEntry entry;
  final int index;
  final bool selected;
  final VoidCallback onSelected;

  @override
  State<_NavigationMarker> createState() => _NavigationMarkerState();
}

class _NavigationMarkerState extends State<_NavigationMarker> {
  final _previewController = OverlayPortalController();
  final _anchorKey = GlobalKey();
  Timer? _hoverTimer;
  ScrollPosition? _scrollPosition;
  bool _hovered = false;
  bool _focused = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final position = Scrollable.maybeOf(context)?.position;
    if (position != _scrollPosition) {
      _scrollPosition?.removeListener(_hidePreview);
      _scrollPosition = position;
      _scrollPosition?.addListener(_hidePreview);
    }
  }

  void _hidePreview() {
    _hoverTimer?.cancel();
    _previewController.hide();
  }

  void _onHover(bool hovered) {
    setState(() => _hovered = hovered);
    _hoverTimer?.cancel();
    if (hovered) {
      _hoverTimer = Timer(const Duration(milliseconds: 250), () {
        if (mounted && _hovered) _previewController.show();
      });
    } else {
      _hidePreview();
    }
  }

  @override
  void dispose() {
    _hoverTimer?.cancel();
    _scrollPosition?.removeListener(_hidePreview);
    super.dispose();
  }

  Widget _buildPreview(BuildContext context) {
    final anchor = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    if (anchor == null || !anchor.hasSize) return const SizedBox.shrink();
    final anchorRect = Rect.fromPoints(
      anchor.localToGlobal(Offset.zero, ancestor: overlay),
      anchor.localToGlobal(
        anchor.size.bottomRight(Offset.zero),
        ancestor: overlay,
      ),
    );
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final tokens = theme.extension<DmColorExtension>();
    final foreground = tokens?.baseContent ?? colors.onSurface;

    return Positioned.fill(
      child: ExcludeSemantics(
        child: IgnorePointer(
          child: CustomSingleChildLayout(
            delegate: _NavigationPreviewLayout(
              anchor: anchorRect,
              textDirection: Directionality.of(context),
            ),
            child: SizedBox(
              key: ValueKey('chat-navigation-preview-${widget.entry.id}'),
              width: 320,
              child: Material(
                color: tokens?.base200 ?? colors.surfaceContainerHigh,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: colors.outlineVariant),
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    primary: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.entry.prompt,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: foreground,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (widget.entry.response != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            widget.entry.response!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: foreground,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final emphasized = widget.selected || _hovered || _focused;

    return OverlayPortal(
      controller: _previewController,
      overlayChildBuilder: _buildPreview,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        child: Semantics(
          button: true,
          selected: widget.selected,
          label:
              'Jump to user message ${widget.index + 1}: ${widget.entry.prompt}',
          onTap: widget.onSelected,
          child: FocusableActionDetector(
            shortcuts: const {
              SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
              SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
              SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
            },
            actions: {
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (_) {
                  widget.onSelected();
                  return null;
                },
              ),
              DismissIntent: CallbackAction<DismissIntent>(
                onInvoke: (_) {
                  _hidePreview();
                  return null;
                },
              ),
            },
            onFocusChange: (value) {
              setState(() => _focused = value);
              if (value) {
                _hoverTimer?.cancel();
                _previewController.show();
              } else {
                _hidePreview();
              }
            },
            child: GestureDetector(
              key: _anchorKey,
              behavior: HitTestBehavior.opaque,
              excludeFromSemantics: true,
              onTap: widget.onSelected,
              onLongPressStart: (_) => _previewController.show(),
              onLongPressEnd: (_) => _hidePreview(),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: _focused ? Border.all(color: colors.primary) : null,
                ),
                child: Center(
                  child: AnimatedContainer(
                    duration: MediaQuery.disableAnimationsOf(context)
                        ? Duration.zero
                        : const Duration(milliseconds: 120),
                    width: emphasized ? 20 : 8,
                    height: 2,
                    color: emphasized ? colors.primary : colors.outline,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationPreviewLayout extends SingleChildLayoutDelegate {
  const _NavigationPreviewLayout({
    required this.anchor,
    required this.textDirection,
  });

  final Rect anchor;
  final TextDirection textDirection;
  static const _margin = 8.0;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final viewportWidth = math.max(0.0, constraints.maxWidth - _margin * 2);
    final sideWidth = textDirection == TextDirection.ltr
        ? constraints.maxWidth - anchor.right - _margin * 2
        : anchor.left - _margin * 2;
    return BoxConstraints(
      maxWidth: math.min(320, sideWidth >= 80 ? sideWidth : viewportWidth),
      maxHeight: math.max(0, constraints.maxHeight - _margin * 2),
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final preferredX = textDirection == TextDirection.ltr
        ? anchor.right + _margin
        : anchor.left - _margin - childSize.width;
    return Offset(
      preferredX.clamp(
        _margin,
        math.max(_margin, size.width - childSize.width - _margin),
      ),
      (anchor.center.dy - childSize.height / 2).clamp(
        _margin,
        math.max(_margin, size.height - childSize.height - _margin),
      ),
    );
  }

  @override
  bool shouldRelayout(_NavigationPreviewLayout oldDelegate) =>
      anchor != oldDelegate.anchor ||
      textDirection != oldDelegate.textDirection;
}
