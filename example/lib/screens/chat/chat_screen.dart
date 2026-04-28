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

class _ChatScreenState extends State<ChatScreen> {
  final List<chat_widgets.DmChatMessage> _messages = [];
  bool _isStreaming = false;
  chat_widgets.DmChatSubmitShortcut _shortcut =
      chat_widgets.DmChatSubmitShortcut.cmdEnter;
  StreamController<String>? _activeThinking;
  StreamController<String>? _activeText;

  void _onSend(String text, List<chat_widgets.DmChatAttachment> atts) {
    if (_isStreaming) return;
    setState(() {
      _messages.add(
        chat_widgets.DmChatMessage(
          id: 'u${_messages.length}',
          role: chat_widgets.DmChatRole.user,
          blocks: [
            if (text.isNotEmpty) chat_widgets.DmChatTextBlock(text: text),
            if (atts.isNotEmpty)
              chat_widgets.DmChatAttachmentBlock(attachments: atts),
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
    var toolCall = chat_widgets.DmChatToolCallBlock(
      id: 't$id',
      name: 'run_code',
      input: const {'snippet': 'print("ok")'},
      status: chat_widgets.DmChatToolCallStatus.pending,
    );
    _messages.add(
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
        send: () => thinking.add('Considering prompt: "$prompt"... '),
      ),
      (
        delay: const Duration(milliseconds: 600),
        send: () => thinking.add('Checking options. '),
      ),
      (
        delay: const Duration(milliseconds: 300),
        send: () {
          toolCall = toolCall.copyWith(
            status: chat_widgets.DmChatToolCallStatus.running,
          );
          setState(() => _replaceBlock(id, toolCall));
        },
      ),
      (
        delay: const Duration(milliseconds: 500),
        send: () {
          toolCall = toolCall.copyWith(
            status: chat_widgets.DmChatToolCallStatus.done,
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
              _messages[idx] = _messages[idx].copyWith(
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
    String messageId,
    chat_widgets.DmChatToolCallBlock updated,
  ) {
    final idx = _messages.indexWhere((m) => m.id == messageId);
    if (idx < 0) return;
    final blocks = _messages[idx].blocks.map<chat_widgets.DmChatBlock>((b) {
      if (b is chat_widgets.DmChatToolCallBlock && b.id == updated.id) {
        return updated;
      }
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
