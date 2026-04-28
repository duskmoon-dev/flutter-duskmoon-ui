import 'dart:async';

import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart' as chat_widgets;
import 'package:flutter/material.dart';

import '../../destination.dart';

class ChatScreen extends StatefulWidget {
  static const name = 'Chat';
  static const path = 'chat';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

enum _ChatDemo {
  empty('Empty'),
  mixed('Mixed blocks'),
  longHistory('50-round history');

  const _ChatDemo(this.label);

  final String label;
}

class _ChatScreenState extends State<ChatScreen> {
  late final Map<_ChatDemo, List<chat_widgets.DmChatMessage>> _demoMessages;
  final List<chat_widgets.DmChatAttachment> _pendingAttachments = [];
  _ChatDemo _demo = _ChatDemo.mixed;
  bool _isStreaming = false;
  chat_widgets.DmChatSubmitShortcut _shortcut =
      chat_widgets.DmChatSubmitShortcut.cmdEnter;
  StreamController<String>? _activeThinking;
  StreamController<String>? _activeText;

  @override
  void initState() {
    super.initState();
    _demoMessages = {
      _ChatDemo.empty: <chat_widgets.DmChatMessage>[],
      _ChatDemo.mixed: _buildMixedMessages(),
      _ChatDemo.longHistory: _buildLongHistoryMessages(),
    };
  }

  List<chat_widgets.DmChatMessage> get _messages => _demoMessages[_demo]!;

  void _onDemoChanged(_ChatDemo demo) {
    if (_demo == demo) return;
    setState(() {
      _demo = demo;
      _pendingAttachments.clear();
    });
  }

  void _onAttach(List<chat_widgets.DmChatAttachment> attachments) {
    setState(() {
      _pendingAttachments.addAll(
        attachments.map(
          (attachment) => attachment.copyWith(
            status: chat_widgets.DmChatAttachmentStatus.done,
            uploadProgress: 1,
          ),
        ),
      );
    });
  }

  void _removePendingAttachment(chat_widgets.DmChatAttachment attachment) {
    setState(() {
      _pendingAttachments.removeWhere((item) => item.id == attachment.id);
    });
  }

  void _onSend(String text, List<chat_widgets.DmChatAttachment> atts) {
    if (_isStreaming) return;
    final demo = _demo;
    final messages = _demoMessages[demo]!;
    setState(() {
      messages.add(
        chat_widgets.DmChatMessage(
          id: '${demo.name}-u${messages.length}',
          role: chat_widgets.DmChatRole.user,
          blocks: [
            if (text.trim().isNotEmpty)
              chat_widgets.DmChatTextBlock(text: text),
            if (atts.isNotEmpty)
              chat_widgets.DmChatAttachmentBlock(attachments: atts),
          ],
        ),
      );
      _pendingAttachments.clear();
      _startAssistantResponse(demo, text, atts);
    });
  }

  void _startAssistantResponse(
    _ChatDemo demo,
    String prompt,
    List<chat_widgets.DmChatAttachment> attachments,
  ) {
    _activeThinking = StreamController<String>();
    _activeText = StreamController<String>();
    final thinking = _activeThinking!;
    final textC = _activeText!;
    final messages = _demoMessages[demo]!;
    final id = '${demo.name}-a${messages.length}';
    final promptLabel = prompt.trim().isEmpty
        ? '${attachments.length} attachment(s)'
        : prompt.trim();
    var toolCall = chat_widgets.DmChatToolCallBlock(
      id: 't$id',
      name: 'run_code',
      input: const {'snippet': 'print("ok")'},
      status: chat_widgets.DmChatToolCallStatus.pending,
    );
    messages.add(
      chat_widgets.DmChatMessage(
        id: id,
        role: chat_widgets.DmChatRole.assistant,
        status: chat_widgets.DmChatMessageStatus.streaming,
        blocks: [
          chat_widgets.DmChatThinkingBlock(stream: thinking.stream),
          toolCall,
          chat_widgets.DmChatTextBlock(stream: textC.stream),
        ],
      ),
    );
    _isStreaming = true;

    final chunks = <({Duration delay, void Function() send})>[
      (
        delay: const Duration(milliseconds: 200),
        send: () => thinking.add('Considering: "$promptLabel"... '),
      ),
      (
        delay: const Duration(milliseconds: 600),
        send: () => thinking.add('Checking selected demo context. '),
      ),
      (
        delay: const Duration(milliseconds: 300),
        send: () {
          toolCall = toolCall.copyWith(
            status: chat_widgets.DmChatToolCallStatus.running,
          );
          setState(() => _replaceBlock(demo, id, toolCall));
        },
      ),
      (
        delay: const Duration(milliseconds: 500),
        send: () {
          toolCall = toolCall.copyWith(
            status: chat_widgets.DmChatToolCallStatus.done,
            output: 'ok\n',
          );
          setState(() => _replaceBlock(demo, id, toolCall));
        },
      ),
      (
        delay: const Duration(milliseconds: 300),
        send: () => textC.add('Here is the response:\n\n'),
      ),
      (
        delay: const Duration(milliseconds: 200),
        send: () => textC.add('The demo composer accepts markdown, '),
      ),
      (
        delay: const Duration(milliseconds: 200),
        send: () => textC.add('picked files, and the selected chat scenario.'),
      ),
      (
        delay: const Duration(milliseconds: 200),
        send: () {
          _closeController(thinking);
          _closeController(textC);
          setState(() {
            _isStreaming = false;
            _activeThinking = null;
            _activeText = null;
            final idx = messages.indexWhere((m) => m.id == id);
            if (idx >= 0) {
              messages[idx] = messages[idx].copyWith(
                status: chat_widgets.DmChatMessageStatus.complete,
              );
            }
          });
        },
      ),
    ];

    var elapsed = Duration.zero;
    for (final c in chunks) {
      elapsed += c.delay;
      Future.delayed(elapsed, () {
        if (!mounted) return;
        c.send();
      });
    }
  }

  void _replaceBlock(
    _ChatDemo demo,
    String messageId,
    chat_widgets.DmChatToolCallBlock updated,
  ) {
    final messages = _demoMessages[demo]!;
    final idx = messages.indexWhere((m) => m.id == messageId);
    if (idx < 0) return;
    final blocks = messages[idx].blocks.map<chat_widgets.DmChatBlock>((b) {
      if (b is chat_widgets.DmChatToolCallBlock && b.id == updated.id) {
        return updated;
      }
      return b;
    }).toList();
    messages[idx] = messages[idx].copyWith(blocks: blocks);
  }

  void _closeController(StreamController<String>? controller) {
    if (controller != null && !controller.isClosed) {
      controller.close();
    }
  }

  @override
  void dispose() {
    _closeController(_activeThinking);
    _closeController(_activeText);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DmAdaptiveScaffold(
      selectedIndex: Destinations.indexOf(const Key('Widgets')),
      onSelectedIndexChange: (idx) => Destinations.changeHandler(idx, context),
      destinations: Destinations.navs,
      useDrawer: true,
      transitionDuration: Duration.zero,
      appBar: DmAppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: const BackButton(),
        title: const Text('Chat'),
        actions: [
          PopupMenuButton<chat_widgets.DmChatSubmitShortcut>(
            tooltip: 'Submit shortcut',
            initialValue: _shortcut,
            onSelected: (v) => setState(() => _shortcut = v),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: chat_widgets.DmChatSubmitShortcut.cmdEnter,
                child: Text('Cmd/Ctrl+Enter submits'),
              ),
              PopupMenuItem(
                value: chat_widgets.DmChatSubmitShortcut.enter,
                child: Text('Enter submits'),
              ),
            ],
            icon: const Icon(Icons.keyboard),
          ),
          const PlatformSwitchAction(),
        ],
      ),
      appBarBreakpoint: Breakpoints.standard,
      body: (_) => chat_widgets.DmChatView(
        messages: _messages,
        onSend: _onSend,
        onAttach: _onAttach,
        onRemoveAttachment: _removePendingAttachment,
        pendingAttachments: _pendingAttachments,
        isStreaming: _isStreaming,
        inputPlaceholder: 'Model not ready',
        inputMinLines: 10,
        inputMaxLines: 10,
        inputLeading: _DemoSelector(
          value: _demo,
          enabled: !_isStreaming,
          onChanged: _onDemoChanged,
        ),
        avatarBuilder: _avatarBuilder,
        headerBuilder: _headerBuilder,
        submitShortcut: _shortcut,
        emptyBuilder: (_) => const Center(
          child: Text(
            'Send a message to begin.',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ),
    );
  }

  Widget? _avatarBuilder(
    BuildContext context,
    chat_widgets.DmChatMessage message,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (message.role) {
      chat_widgets.DmChatRole.user => DmAvatar(
          radius: 15,
          backgroundColor: colorScheme.primary,
          child: Text(
            'U',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      chat_widgets.DmChatRole.assistant => DmAvatar(
          radius: 15,
          backgroundColor: colorScheme.tertiaryContainer,
          child: Icon(
            Icons.auto_awesome,
            color: colorScheme.onTertiaryContainer,
            size: 16,
          ),
        ),
      chat_widgets.DmChatRole.system => null,
    };
  }

  Widget? _headerBuilder(
    BuildContext context,
    chat_widgets.DmChatMessage message,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final label = switch (message.role) {
      chat_widgets.DmChatRole.user => 'User',
      chat_widgets.DmChatRole.assistant => 'Assistant',
      chat_widgets.DmChatRole.system => null,
    };
    if (label == null) return null;
    return Text(
      label,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
    );
  }

  static List<chat_widgets.DmChatMessage> _buildMixedMessages() {
    return [
      const chat_widgets.DmChatMessage(
        id: 'mixed-system',
        role: chat_widgets.DmChatRole.system,
        blocks: [
          chat_widgets.DmChatTextBlock(
            text: 'System note: this scenario shows built-in block types.',
          ),
        ],
      ),
      chat_widgets.DmChatMessage(
        id: 'mixed-user-1',
        role: chat_widgets.DmChatRole.user,
        blocks: [
          const chat_widgets.DmChatTextBlock(
            text: 'Summarize this uploaded design note.',
          ),
          chat_widgets.DmChatAttachmentBlock(
            attachments: [
              _attachment(
                  'mixed-note', 'design-note.md', 18642, 'text/markdown'),
            ],
          ),
        ],
      ),
      const chat_widgets.DmChatMessage(
        id: 'mixed-assistant-1',
        role: chat_widgets.DmChatRole.assistant,
        blocks: [
          chat_widgets.DmChatThinkingBlock(
            text: 'Checked file type, extracted headings, and grouped actions.',
            elapsed: Duration(seconds: 7),
          ),
          chat_widgets.DmChatToolCallBlock(
            id: 'mixed-tool-1',
            name: 'parse_markdown',
            input: {'file': 'design-note.md'},
            output: {'headings': 6, 'actions': 4},
            status: chat_widgets.DmChatToolCallStatus.done,
          ),
          chat_widgets.DmChatTextBlock(
            text: 'The note has **4 action items** and one API decision.',
          ),
        ],
      ),
      const chat_widgets.DmChatMessage(
        id: 'mixed-assistant-2',
        role: chat_widgets.DmChatRole.assistant,
        blocks: [
          chat_widgets.DmChatToolCallBlock(
            id: 'mixed-tool-2',
            name: 'fetch_remote_model',
            input: {'model': 'deepseek-v4-flash'},
            status: chat_widgets.DmChatToolCallStatus.error,
            errorMessage: 'Model not ready',
          ),
          chat_widgets.DmChatTextBlock(
            text:
                'The remote model is unavailable, so the demo is in offline mode.',
          ),
        ],
      ),
      const chat_widgets.DmChatMessage(
        id: 'mixed-user-2',
        role: chat_widgets.DmChatRole.user,
        blocks: [
          chat_widgets.DmChatTextBlock(
            text: 'Keep this as the default mixed chat demo.',
          ),
        ],
      ),
    ];
  }

  static List<chat_widgets.DmChatMessage> _buildLongHistoryMessages() {
    final messages = <chat_widgets.DmChatMessage>[
      const chat_widgets.DmChatMessage(
        id: 'history-system-0',
        role: chat_widgets.DmChatRole.system,
        blocks: [
          chat_widgets.DmChatTextBlock(
            text:
                'Long-history demo: 50 rounds with text, attachments, thinking, tool calls, and system notes.',
          ),
        ],
      ),
    ];

    for (var i = 1; i <= 50; i++) {
      final userBlocks = <chat_widgets.DmChatBlock>[
        chat_widgets.DmChatTextBlock(
          text:
              'Round $i user request: review the latest widget state and return a concise update.',
        ),
      ];
      if (i % 7 == 0 || i == 50) {
        userBlocks.add(
          chat_widgets.DmChatAttachmentBlock(
            attachments: [
              _attachment(
                'history-u$i-spec',
                'round-$i-spec.pdf',
                42000 + i * 317,
                'application/pdf',
              ),
            ],
          ),
        );
      }
      messages.add(
        chat_widgets.DmChatMessage(
          id: 'history-u$i',
          role: chat_widgets.DmChatRole.user,
          blocks: userBlocks,
        ),
      );

      final assistantBlocks = <chat_widgets.DmChatBlock>[];
      if (i % 5 == 0) {
        assistantBlocks.add(
          chat_widgets.DmChatThinkingBlock(
            text:
                'Compared round $i against the retained conversation state and scoped the answer.',
            elapsed: Duration(seconds: 3 + (i % 6)),
          ),
        );
      }
      if (i % 10 == 0) {
        assistantBlocks.add(
          chat_widgets.DmChatToolCallBlock(
            id: 'history-tool-$i',
            name: 'search_docs',
            input: {'query': 'round $i widget state'},
            output: {'matches': 3, 'latest': 'widgets/chat'},
            status: chat_widgets.DmChatToolCallStatus.done,
          ),
        );
      } else if (i % 13 == 0) {
        assistantBlocks.add(
          chat_widgets.DmChatToolCallBlock(
            id: 'history-tool-$i',
            name: 'sync_remote_model',
            input: {'model': 'deepseek-v4-flash'},
            status: chat_widgets.DmChatToolCallStatus.error,
            errorMessage: 'Remote endpoint unavailable',
          ),
        );
      }
      assistantBlocks.add(
        chat_widgets.DmChatTextBlock(
          text: 'Round $i assistant response:\n\n'
              '- Kept the change scoped to the chat widgets demo.\n'
              '- Preserved markdown rendering in message bodies.\n'
              '- Verified the composer state before replying.',
        ),
      );
      if (i % 11 == 0 || i == 50) {
        assistantBlocks.add(
          chat_widgets.DmChatAttachmentBlock(
            attachments: [
              _attachment(
                'history-a$i-report',
                'round-$i-summary.csv',
                12000 + i * 91,
                'text/csv',
              ),
            ],
          ),
        );
      }
      messages.add(
        chat_widgets.DmChatMessage(
          id: 'history-a$i',
          role: chat_widgets.DmChatRole.assistant,
          blocks: assistantBlocks,
        ),
      );

      if (i % 15 == 0) {
        messages.add(
          chat_widgets.DmChatMessage(
            id: 'history-system-$i',
            role: chat_widgets.DmChatRole.system,
            blocks: [
              chat_widgets.DmChatTextBlock(
                text: 'System checkpoint after round $i: context retained.',
              ),
            ],
          ),
        );
      }
    }
    return messages;
  }

  static chat_widgets.DmChatAttachment _attachment(
    String id,
    String name,
    int sizeBytes,
    String mimeType,
  ) {
    return chat_widgets.DmChatAttachment(
      id: id,
      name: name,
      sizeBytes: sizeBytes,
      mimeType: mimeType,
      status: chat_widgets.DmChatAttachmentStatus.done,
    );
  }
}

class _DemoSelector extends StatelessWidget {
  const _DemoSelector({
    required this.value,
    required this.onChanged,
    required this.enabled,
  });

  final _ChatDemo value;
  final ValueChanged<_ChatDemo> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<_ChatDemo>(
      tooltip: 'Select demo',
      enabled: enabled,
      initialValue: value,
      onSelected: onChanged,
      itemBuilder: (context) => [
        for (final demo in _ChatDemo.values)
          PopupMenuItem(
            value: demo,
            child: Text(demo.label),
          ),
      ],
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 240),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  'Demo: ${value.label}',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.arrow_drop_down,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
