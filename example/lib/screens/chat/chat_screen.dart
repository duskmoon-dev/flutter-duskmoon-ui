import 'dart:async';

import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:flutter/material.dart';

import '../../destination.dart';

class ChatScreen extends StatefulWidget {
  static const name = 'Chat';
  static const path = '/chat';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<DmChatMessage> _messages = [];
  bool _isStreaming = false;
  DmChatSubmitShortcut _shortcut = DmChatSubmitShortcut.cmdEnter;
  StreamController<String>? _activeThinking;
  StreamController<String>? _activeText;

  void _onSend(String text, List<DmChatAttachment> atts) {
    if (_isStreaming) return;
    setState(() {
      _messages.add(
        DmChatMessage(
          id: 'u${_messages.length}',
          role: DmChatRole.user,
          blocks: [
            if (text.isNotEmpty) DmChatTextBlock(text: text),
            if (atts.isNotEmpty) DmChatAttachmentBlock(attachments: atts),
          ],
        ),
      );
      _startAssistantResponse(text);
    });
  }

  void _startAssistantResponse(String prompt) {
    _activeThinking = StreamController<String>();
    _activeText = StreamController<String>();
    final thinking = _activeThinking!;
    final textC = _activeText!;
    final id = 'a${_messages.length}';
    var toolCall = DmChatToolCallBlock(
      id: 't$id',
      name: 'run_code',
      input: const {'snippet': 'print("ok")'},
      status: DmChatToolCallStatus.pending,
    );
    _messages.add(
      DmChatMessage(
        id: id,
        role: DmChatRole.assistant,
        status: DmChatMessageStatus.streaming,
        blocks: [
          DmChatThinkingBlock(stream: thinking.stream),
          toolCall,
          DmChatTextBlock(stream: textC.stream),
        ],
      ),
    );
    _isStreaming = true;

    final chunks = <({Duration delay, void Function() send})>[
      (
        delay: const Duration(milliseconds: 200),
        send: () => thinking.add('Considering prompt: "$prompt"... '),
      ),
      (
        delay: const Duration(milliseconds: 600),
        send: () => thinking.add('Checking options. '),
      ),
      (
        delay: const Duration(milliseconds: 300),
        send: () {
          toolCall = toolCall.copyWith(status: DmChatToolCallStatus.running);
          setState(() => _replaceBlock(id, toolCall));
        },
      ),
      (
        delay: const Duration(milliseconds: 500),
        send: () {
          toolCall = toolCall.copyWith(
            status: DmChatToolCallStatus.done,
            output: 'ok\n',
          );
          setState(() => _replaceBlock(id, toolCall));
        },
      ),
      (
        delay: const Duration(milliseconds: 300),
        send: () => textC.add('Here is the response:\n\n'),
      ),
      (
        delay: const Duration(milliseconds: 200),
        send: () => textC.add('Hello! '),
      ),
      (
        delay: const Duration(milliseconds: 200),
        send: () => textC.add('The tool call completed successfully.'),
      ),
      (
        delay: const Duration(milliseconds: 200),
        send: () {
          thinking.close();
          textC.close();
          setState(() {
            _isStreaming = false;
            final idx = _messages.indexWhere((m) => m.id == id);
            if (idx >= 0) {
              _messages[idx] = _messages[idx]
                  .copyWith(status: DmChatMessageStatus.complete);
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

  void _replaceBlock(String messageId, DmChatToolCallBlock updated) {
    final idx = _messages.indexWhere((m) => m.id == messageId);
    if (idx < 0) return;
    final blocks = _messages[idx].blocks.map<DmChatBlock>((b) {
      if (b is DmChatToolCallBlock && b.id == updated.id) return updated;
      return b;
    }).toList();
    _messages[idx] = _messages[idx].copyWith(blocks: blocks);
  }

  @override
  void dispose() {
    _activeThinking?.close();
    _activeText?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DmAdaptiveScaffold(
      selectedIndex: Destinations.indexOf(const Key(ChatScreen.name)),
      onSelectedIndexChange: (idx) => Destinations.changeHandler(idx, context),
      destinations: Destinations.navs,
      useDrawer: true,
      transitionDuration: Duration.zero,
      appBar: DmAppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Chat'),
        actions: [
          PopupMenuButton<DmChatSubmitShortcut>(
            tooltip: 'Submit shortcut',
            initialValue: _shortcut,
            onSelected: (v) => setState(() => _shortcut = v),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: DmChatSubmitShortcut.cmdEnter,
                child: Text('Cmd/Ctrl+Enter submits'),
              ),
              PopupMenuItem(
                value: DmChatSubmitShortcut.enter,
                child: Text('Enter submits'),
              ),
            ],
            icon: const Icon(Icons.keyboard),
          ),
          const PlatformSwitchAction(),
        ],
      ),
      appBarBreakpoint: Breakpoints.standard,
      body: (_) => DmChatView(
        messages: _messages,
        onSend: _onSend,
        isStreaming: _isStreaming,
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
}
