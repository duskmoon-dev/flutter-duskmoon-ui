# DmChat Widget Module Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a production-grade LLM-focused chat widget package (`duskmoon_chat`) with streaming markdown, thinking blocks, tool calls, and auto-scrolling.

**Architecture:** A layered approach separating immutable data models (`DmChatMessage`, `DmChatBlock` variants), primitive block renderers, bubble compositing, and a top-level `DmChatView` orchestrating the scroll list and input area.

**Tech Stack:** Dart, Flutter, `duskmoon_widgets` (for Markdown/Inputs), `duskmoon_theme`, `file_picker`.

---

### Task 1: Package Scaffolding

**Files:**
- Create: `packages/duskmoon_chat/pubspec.yaml`
- Create: `packages/duskmoon_chat/lib/duskmoon_chat.dart`

- [ ] **Step 1: Create pubspec.yaml**

```yaml
name: duskmoon_chat
description: LLM-focused chat widget module for the DuskMoon Design System
version: 1.5.0
publish_to: none

environment:
  sdk: ">=3.5.0 <4.0.0"
  flutter: ">=3.24.0"

dependencies:
  flutter:
    sdk: flutter
  duskmoon_theme:
    path: ../duskmoon_theme
  duskmoon_widgets:
    path: ../duskmoon_widgets
  file_picker: ^8.1.4

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

- [ ] **Step 2: Create barrel file**

```dart
/// LLM-focused chat widget module for the DuskMoon Design System
library;

// Intentionally empty for now, will export components as we build them.
```

- [ ] **Step 3: Fetch dependencies**

Run: `dart pub get` in project root (Melos workspace).
Expected: PASS

- [ ] **Step 4: Commit**

```bash
git add packages/duskmoon_chat/pubspec.yaml packages/duskmoon_chat/lib/duskmoon_chat.dart
git commit -m "feat(chat): initialize duskmoon_chat package scaffold"
```

---

### Task 2: Data Models

**Files:**
- Create: `packages/duskmoon_chat/lib/src/models/dm_chat_message.dart`
- Create: `packages/duskmoon_chat/test/models/dm_chat_message_test.dart`

- [ ] **Step 1: Write failing test**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_chat/src/models/dm_chat_message.dart';

void main() {
  test('DmChatMessage instantiates correctly', () {
    final msg = DmChatMessage(
      id: 'msg-1',
      role: DmChatRole.user,
      blocks: [DmChatTextBlock(text: 'Hello')],
      status: DmChatMessageStatus.done,
    );

    expect(msg.id, 'msg-1');
    expect(msg.role, DmChatRole.user);
    expect(msg.blocks.length, 1);
    expect(msg.status, DmChatMessageStatus.done);
    expect((msg.blocks.first as DmChatTextBlock).text, 'Hello');
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd packages/duskmoon_chat && flutter test test/models/dm_chat_message_test.dart`
Expected: FAIL (types not found)

- [ ] **Step 3: Write minimal implementation**

```dart
import 'dart:typed_data';

enum DmChatRole { user, assistant, system }
enum DmChatMessageStatus { pending, streaming, done, error, stopped }

class DmChatMessage {
  const DmChatMessage({
    required this.id,
    required this.role,
    required this.blocks,
    this.createdAt,
    this.status = DmChatMessageStatus.done,
    this.error,
  });

  final String id;
  final DmChatRole role;
  final List<DmChatBlock> blocks;
  final DateTime? createdAt;
  final DmChatMessageStatus status;
  final Object? error;
}

sealed class DmChatBlock {
  const DmChatBlock();
}

class DmChatTextBlock extends DmChatBlock {
  const DmChatTextBlock({this.text, this.stream})
      : assert(text != null || stream != null),
        assert(text == null || stream == null);

  final String? text;
  final Stream<String>? stream;
}

class DmChatThinkingBlock extends DmChatBlock {
  const DmChatThinkingBlock({
    this.text,
    this.stream,
    this.duration,
    this.initiallyExpanded = true,
  })  : assert(text != null || stream != null),
        assert(text == null || stream == null);

  final String? text;
  final Stream<String>? stream;
  final Duration? duration;
  final bool initiallyExpanded;
}

enum DmChatToolCallStatus { running, done, error }

class DmChatToolCallBlock extends DmChatBlock {
  const DmChatToolCallBlock({
    required this.toolName,
    required this.input,
    this.output,
    this.status = DmChatToolCallStatus.running,
    this.error,
  });

  final String toolName;
  final Map<String, Object?> input;
  final String? output;
  final DmChatToolCallStatus status;
  final Object? error;
}

enum DmChatUploadStatus { idle, uploading, done, error }

class DmChatAttachment {
  const DmChatAttachment({
    required this.id,
    required this.name,
    this.sizeBytes,
    this.mimeType,
    this.url,
    this.bytes,
    this.uploadStatus = DmChatUploadStatus.idle,
    this.uploadProgress,
    this.uploadError,
  });

  final String id;
  final String name;
  final int? sizeBytes;
  final String? mimeType;
  final Uri? url;
  final Uint8List? bytes;
  final DmChatUploadStatus uploadStatus;
  final double? uploadProgress;
  final Object? uploadError;
}

class DmChatAttachmentBlock extends DmChatBlock {
  const DmChatAttachmentBlock({required this.attachments});
  final List<DmChatAttachment> attachments;
}

class DmChatCustomBlock extends DmChatBlock {
  const DmChatCustomBlock({required this.kind, this.data});
  final String kind;
  final Object? data;
}

abstract class DmChatUploadAdapter {
  Stream<DmChatAttachment> upload(DmChatAttachment attachment);
  Future<void> cancel(String attachmentId);
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd packages/duskmoon_chat && flutter test test/models/dm_chat_message_test.dart`
Expected: PASS

- [ ] **Step 5: Export models in barrel**

Modify: `packages/duskmoon_chat/lib/duskmoon_chat.dart`
```dart
library;

export 'src/models/dm_chat_message.dart';
```

- [ ] **Step 6: Commit**

```bash
git add packages/duskmoon_chat/lib packages/duskmoon_chat/test
git commit -m "feat(chat): implement immutable chat data models"
```

---

### Task 3: Text Block Renderer

**Files:**
- Create: `packages/duskmoon_chat/lib/src/bubble/blocks/dm_chat_text_block_view.dart`
- Create: `packages/duskmoon_chat/test/bubble/blocks/dm_chat_text_block_view_test.dart`

- [ ] **Step 1: Write failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_chat/src/models/dm_chat_message.dart';
import 'package:duskmoon_chat/src/bubble/blocks/dm_chat_text_block_view.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart';

void main() {
  testWidgets('Renders static markdown', (tester) async {
    final block = const DmChatTextBlock(text: '**Hello**');
    
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: DmChatTextBlockView(block: block),
      ),
    ));

    expect(find.byType(DmMarkdown), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd packages/duskmoon_chat && flutter test test/bubble/blocks/dm_chat_text_block_view_test.dart`
Expected: FAIL (file not found)

- [ ] **Step 3: Write minimal implementation**

```dart
import 'package:flutter/material.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import '../../models/dm_chat_message.dart';

class DmChatTextBlockView extends StatelessWidget {
  const DmChatTextBlockView({
    super.key,
    required this.block,
    this.config = const DmMarkdownConfig(),
  });

  final DmChatTextBlock block;
  final DmMarkdownConfig config;

  @override
  Widget build(BuildContext context) {
    if (block.text != null) {
      return DmMarkdown(
        data: block.text,
        config: config,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      );
    }
    return DmMarkdown(
      stream: block.stream,
      config: config,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd packages/duskmoon_chat && flutter test test/bubble/blocks/dm_chat_text_block_view_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add packages/duskmoon_chat/lib packages/duskmoon_chat/test
git commit -m "feat(chat): implement DmChatTextBlockView using DmMarkdown"
```

---

### Task 4: Thinking Block Renderer

**Files:**
- Create: `packages/duskmoon_chat/lib/src/bubble/blocks/dm_chat_thinking_block_view.dart`
- Create: `packages/duskmoon_chat/test/bubble/blocks/dm_chat_thinking_block_view_test.dart`

- [ ] **Step 1: Write failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_chat/src/models/dm_chat_message.dart';
import 'package:duskmoon_chat/src/bubble/blocks/dm_chat_thinking_block_view.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart';

void main() {
  testWidgets('Thinking block toggles expansion', (tester) async {
    final block = const DmChatThinkingBlock(
      text: 'Reasoning...',
      duration: Duration(seconds: 2),
      initiallyExpanded: false,
    );
    
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: DmChatThinkingBlockView(block: block),
      ),
    ));

    // Initially collapsed, shows summary
    expect(find.text('Thought for 2s'), findsOneWidget);
    expect(find.byType(DmMarkdown), findsNothing);

    // Tap to expand
    await tester.tap(find.text('Thought for 2s'));
    await tester.pumpAndSettle();

    expect(find.byType(DmMarkdown), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd packages/duskmoon_chat && flutter test test/bubble/blocks/dm_chat_thinking_block_view_test.dart`
Expected: FAIL

- [ ] **Step 3: Write minimal implementation**

```dart
import 'package:flutter/material.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart';
import '../../models/dm_chat_message.dart';

class DmChatThinkingBlockView extends StatefulWidget {
  const DmChatThinkingBlockView({
    super.key,
    required this.block,
    this.config = const DmMarkdownConfig(),
  });

  final DmChatThinkingBlock block;
  final DmMarkdownConfig config;

  @override
  State<DmChatThinkingBlockView> createState() => _DmChatThinkingBlockViewState();
}

class _DmChatThinkingBlockViewState extends State<DmChatThinkingBlockView> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.block.initiallyExpanded;
  }

  @override
  void didUpdateWidget(DmChatThinkingBlockView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.block.initiallyExpanded != widget.block.initiallyExpanded) {
      _expanded = widget.block.initiallyExpanded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return DmCard(
      backgroundColor: colorScheme.surfaceContainerHighest,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                      widget.block.duration != null && !_expanded
                          ? 'Thought for ${widget.block.duration!.inSeconds}s'
                          : 'Thinking...',
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
          if (_expanded)
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: widget.block.text != null
                  ? DmMarkdown(
                      data: widget.block.text,
                      config: widget.config,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    )
                  : DmMarkdown(
                      stream: widget.block.stream,
                      config: widget.config,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
            ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd packages/duskmoon_chat && flutter test test/bubble/blocks/dm_chat_thinking_block_view_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add packages/duskmoon_chat/lib packages/duskmoon_chat/test
git commit -m "feat(chat): implement DmChatThinkingBlockView with collapsible card"
```

---

### Task 5: Tool Call Block Renderer

**Files:**
- Create: `packages/duskmoon_chat/lib/src/bubble/blocks/dm_chat_tool_call_block_view.dart`
- Create: `packages/duskmoon_chat/test/bubble/blocks/dm_chat_tool_call_block_view_test.dart`

- [ ] **Step 1: Write failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_chat/src/models/dm_chat_message.dart';
import 'package:duskmoon_chat/src/bubble/blocks/dm_chat_tool_call_block_view.dart';

void main() {
  testWidgets('Tool call block expands to show input/output', (tester) async {
    final block = const DmChatToolCallBlock(
      toolName: 'search_web',
      input: {'query': 'flutter'},
      output: 'Result: pub.dev',
      status: DmChatToolCallStatus.done,
    );
    
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: DmChatToolCallBlockView(block: block),
      ),
    ));

    expect(find.text('search_web'), findsOneWidget);
    // Not expanded initially
    expect(find.text('Input'), findsNothing);

    await tester.tap(find.text('search_web'));
    await tester.pumpAndSettle();

    expect(find.text('Input'), findsOneWidget);
    expect(find.text('Output'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd packages/duskmoon_chat && flutter test test/bubble/blocks/dm_chat_tool_call_block_view_test.dart`
Expected: FAIL

- [ ] **Step 3: Write minimal implementation**

```dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import '../../models/dm_chat_message.dart';

class DmChatToolCallBlockView extends StatefulWidget {
  const DmChatToolCallBlockView({
    super.key,
    required this.block,
    this.config = const DmMarkdownConfig(),
  });

  final DmChatToolCallBlock block;
  final DmMarkdownConfig config;

  @override
  State<DmChatToolCallBlockView> createState() => _DmChatToolCallBlockViewState();
}

class _DmChatToolCallBlockViewState extends State<DmChatToolCallBlockView> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DmChip(
          label: Text(widget.block.toolName),
          avatar: Icon(
            widget.block.status == DmChatToolCallStatus.done
                ? Icons.check
                : widget.block.status == DmChatToolCallStatus.error
                    ? Icons.error_outline
                    : Icons.build_circle_outlined,
            size: 16,
          ),
          onTap: () => setState(() => _expanded = !_expanded),
        ),
        if (_expanded)
          DmCard(
            margin: const EdgeInsets.only(top: 8),
            backgroundColor: colorScheme.surfaceContainerLow,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Input', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                DmMarkdown(
                  data: '```json\n${const JsonEncoder.withIndent('  ').convert(widget.block.input)}\n```',
                  config: widget.config,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
                if (widget.block.output != null) ...[
                  const SizedBox(height: 16),
                  Text('Output', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  DmMarkdown(
                    data: widget.block.output,
                    config: widget.config,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                ],
                if (widget.block.error != null) ...[
                  const SizedBox(height: 16),
                  Text('Error', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: colorScheme.error)),
                  const SizedBox(height: 8),
                  Text(widget.block.error.toString(), style: TextStyle(color: colorScheme.error)),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd packages/duskmoon_chat && flutter test test/bubble/blocks/dm_chat_tool_call_block_view_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add packages/duskmoon_chat/lib packages/duskmoon_chat/test
git commit -m "feat(chat): implement DmChatToolCallBlockView"
```

---

### Task 6: Bubble Layout & Dispatcher

**Files:**
- Create: `packages/duskmoon_chat/lib/src/bubble/dm_chat_bubble.dart`
- Create: `packages/duskmoon_chat/test/bubble/dm_chat_bubble_test.dart`

- [ ] **Step 1: Write failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_chat/src/models/dm_chat_message.dart';
import 'package:duskmoon_chat/src/bubble/dm_chat_bubble.dart';
import 'package:duskmoon_chat/src/bubble/blocks/dm_chat_text_block_view.dart';

void main() {
  testWidgets('DmChatBubble routes blocks correctly', (tester) async {
    final msg = const DmChatMessage(
      id: '1',
      role: DmChatRole.user,
      blocks: [DmChatTextBlock(text: 'Hello')],
    );
    
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: DmChatBubble(message: msg),
      ),
    ));

    expect(find.byType(DmChatTextBlockView), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd packages/duskmoon_chat && flutter test test/bubble/dm_chat_bubble_test.dart`
Expected: FAIL

- [ ] **Step 3: Write minimal implementation**

```dart
import 'package:flutter/material.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import '../models/dm_chat_message.dart';
import 'blocks/dm_chat_text_block_view.dart';
import 'blocks/dm_chat_thinking_block_view.dart';
import 'blocks/dm_chat_tool_call_block_view.dart';

class DmChatBubble extends StatelessWidget {
  const DmChatBubble({
    super.key,
    required this.message,
    this.markdownConfig = const DmMarkdownConfig(),
    this.avatar,
  });

  final DmChatMessage message;
  final DmMarkdownConfig markdownConfig;
  final Widget? avatar;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == DmChatRole.user;
    final colorScheme = Theme.of(context).colorScheme;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: message.blocks.map((block) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: _buildBlock(block),
        );
      }).toList(),
    );

    if (isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: FractionallySizedBox(
          widthFactor: 0.8,
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16).copyWith(
                bottomRight: const Radius.circular(4),
              ),
            ),
            child: DefaultTextStyle.merge(
              style: TextStyle(color: colorScheme.onPrimaryContainer),
              child: content,
            ),
          ),
        ),
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (avatar != null) ...[
            avatar!,
            const SizedBox(width: 12),
          ],
          Expanded(child: content),
        ],
      );
    }
  }

  Widget _buildBlock(DmChatBlock block) {
    return switch (block) {
      DmChatTextBlock b => DmChatTextBlockView(block: b, config: markdownConfig),
      DmChatThinkingBlock b => DmChatThinkingBlockView(block: b, config: markdownConfig),
      DmChatToolCallBlock b => DmChatToolCallBlockView(block: b, config: markdownConfig),
      DmChatAttachmentBlock _ => const SizedBox.shrink(), // Add later
      DmChatCustomBlock _ => const SizedBox.shrink(),     // Add later
    };
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd packages/duskmoon_chat && flutter test test/bubble/dm_chat_bubble_test.dart`
Expected: PASS

- [ ] **Step 5: Export in barrel**

Modify: `packages/duskmoon_chat/lib/duskmoon_chat.dart`
```dart
export 'src/bubble/dm_chat_bubble.dart';
```

- [ ] **Step 6: Commit**

```bash
git add packages/duskmoon_chat/lib packages/duskmoon_chat/test
git commit -m "feat(chat): implement DmChatBubble layout and block dispatcher"
```

---

### Task 7: Composed DmChatView

**Files:**
- Create: `packages/duskmoon_chat/lib/src/view/dm_chat_view.dart`
- Create: `packages/duskmoon_chat/test/view/dm_chat_view_test.dart`

- [ ] **Step 1: Write failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_chat/duskmoon_chat.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart';

void main() {
  testWidgets('DmChatView renders messages and input', (tester) async {
    final msgs = [
      const DmChatMessage(
        id: '1',
        role: DmChatRole.user,
        blocks: [DmChatTextBlock(text: 'Hello')],
      ),
    ];
    
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: DmChatView(
          messages: msgs,
          onSend: (_) {},
        ),
      ),
    ));

    expect(find.byType(DmChatBubble), findsOneWidget);
    expect(find.byType(DmMarkdownInput), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd packages/duskmoon_chat && flutter test test/view/dm_chat_view_test.dart`
Expected: FAIL

- [ ] **Step 3: Write minimal implementation**

```dart
import 'package:flutter/material.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import '../models/dm_chat_message.dart';
import '../bubble/dm_chat_bubble.dart';

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
  late final DmMarkdownInputController _inputController;

  @override
  void initState() {
    super.initState();
    _inputController = DmMarkdownInputController();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _inputController.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _inputController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final reversedMessages = widget.messages.reversed.toList();
    final isStreaming = widget.messages.isNotEmpty && 
                        widget.messages.last.status == DmChatMessageStatus.streaming;

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            reverse: true,
            padding: const EdgeInsets.all(16),
            itemCount: reversedMessages.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return DmChatBubble(
                message: reversedMessages[index],
                markdownConfig: widget.markdownConfig,
                avatar: widget.assistantAvatar,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DmMarkdownInput(
            controller: _inputController,
            config: widget.markdownConfig,
            minLines: 1,
            maxLines: 5,
            bottomRight: [
              if (isStreaming && widget.onStop != null)
                DmIconButton(
                  icon: const Icon(Icons.stop_circle_outlined),
                  onPressed: widget.onStop,
                )
              else
                DmIconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _handleSend,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd packages/duskmoon_chat && flutter test test/view/dm_chat_view_test.dart`
Expected: PASS

- [ ] **Step 5: Export in barrel**

Modify: `packages/duskmoon_chat/lib/duskmoon_chat.dart`
```dart
export 'src/view/dm_chat_view.dart';
```

- [ ] **Step 6: Commit**

```bash
git add packages/duskmoon_chat/lib packages/duskmoon_chat/test
git commit -m "feat(chat): implement DmChatView with reverse list and input"
```

---

## Execution Handoff

Plan complete and saved to `docs/superpowers/plans/2026-04-25-chat-widget-implementation.md`.

Two execution options:
1. **Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration
2. **Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

Which approach?