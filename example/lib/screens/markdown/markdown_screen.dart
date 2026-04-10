import 'dart:async';

import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';

import '../../destination.dart';

class MarkdownScreen extends StatelessWidget {
  static const name = 'Markdown';
  static const path = '/markdown';

  const MarkdownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DmAppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Markdown'),
        actions: const [PlatformSwitchAction()],
      ),
      body: const _MarkdownBody(),
    );
  }
}

class _MarkdownBody extends StatefulWidget {
  const _MarkdownBody();

  @override
  State<_MarkdownBody> createState() => _MarkdownBodyState();
}

class _MarkdownBodyState extends State<_MarkdownBody>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _inputController = DmMarkdownInputController();
  bool _showPreview = true;
  StreamController<String>? _streamController;
  Timer? _streamTimer;
  Key _streamKey = UniqueKey();

  static const _sampleMarkdown = '''
# DmMarkdown Showcase

This is a **demonstration** of the `DmMarkdown` renderer with *all* supported features.

## Text Formatting

You can use **bold**, *italic*, ~~strikethrough~~, and `inline code` in your markdown.

## Lists

### Unordered
- First item
- Second item with **bold**
- Third item with `code`

### Ordered
1. Step one
2. Step two
3. Step three

## Blockquote

> "The best way to predict the future is to create it."
>
> — Peter Drucker

## Code Block

```dart
void main() {
  final greeting = 'Hello, DuskMoon!';
  print(greeting);
}
```

```python
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)
```

## Table

| Feature | Status | Priority |
|---------|--------|----------|
| GFM | Done | High |
| KaTeX | Done | High |
| Mermaid | Planned | Medium |
| Streaming | Done | High |

## Math (KaTeX)

Inline math: \$E = mc^2\$

Display math:

\$\$
x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}
\$\$

## Horizontal Rule

---

*End of showcase content.*
''';

  static const _streamingText = [
    '# Streaming Demo\n\n',
    'This content is being ',
    '**streamed** in real-time, ',
    'simulating an *LLM response*.\n\n',
    '## Features\n\n',
    '- Incremental parsing\n',
    '- Blinking cursor\n',
    '- Smooth rendering\n\n',
    'The `DmMarkdown` widget handles ',
    'streaming input gracefully with ',
    'its **incremental parser**.\n\n',
    '```dart\n',
    'DmMarkdown(\n',
    '  stream: myStream,\n',
    ')\n',
    '```\n',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _inputController.text =
        '# Write your markdown here\n\nTry using **bold** or *italic* text!';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _inputController.dispose();
    _streamTimer?.cancel();
    _streamController?.close();
    super.dispose();
  }

  void _startStreaming() {
    _streamTimer?.cancel();
    _streamController?.close();
    _streamController = StreamController<String>.broadcast();
    _streamKey = UniqueKey();
    var index = 0;
    setState(() {});
    _streamTimer =
        Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (index < _streamingText.length) {
        _streamController!.add(_streamingText[index]);
        index++;
      } else {
        _streamController!.close();
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          color: colorScheme.surfaceContainer,
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.article), text: 'Renderer'),
              Tab(icon: Icon(Icons.stream), text: 'Streaming'),
              Tab(icon: Icon(Icons.edit_note), text: 'Editor'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildRendererDemo(),
              _buildStreamingDemo(),
              _buildEditorDemo(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRendererDemo() {
    return const DmMarkdown(
      data: _sampleMarkdown,
      config: DmMarkdownConfig(enableKatex: true),
      padding: EdgeInsets.all(16),
    );
  }

  Widget _buildStreamingDemo() {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              FilledButton.icon(
                onPressed: _startStreaming,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Stream'),
              ),
              const SizedBox(width: 12),
              Text(
                'Simulates LLM-style streaming output',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _streamController != null
              ? DmMarkdown(
                  key: _streamKey,
                  stream: _streamController!.stream,
                  config: const DmMarkdownConfig(enableKatex: true),
                  padding: const EdgeInsets.all(16),
                )
              : Center(
                  child: Text(
                    'Press "Start Stream" to begin',
                    style:
                        TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildEditorDemo() {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: colorScheme.surfaceContainer,
          child: Row(
            children: [
              Text(
                'Show Preview Tab',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              const Spacer(),
              Switch(
                value: _showPreview,
                onChanged: (v) => setState(() => _showPreview = v),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: DmMarkdownInput(
            controller: _inputController,
            showLineNumbers: true,
            showPreview: _showPreview,
            config: const DmMarkdownConfig(enableKatex: true),
          ),
        ),
      ],
    );
  }
}
