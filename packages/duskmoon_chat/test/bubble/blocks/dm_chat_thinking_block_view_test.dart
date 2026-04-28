import 'dart:async';

import 'package:duskmoon_chat/duskmoon_chat.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart' show DmMarkdown;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Thinking block toggles expansion', (tester) async {
    final block = DmChatThinkingBlock(
      text: 'Reasoning...',
      duration: const Duration(seconds: 2),
      initiallyExpanded: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatThinkingBlockView(block: block),
        ),
      ),
    );

    expect(find.text('Thought for 2s'), findsOneWidget);
    expect(find.byType(DmMarkdown), findsNothing);

    await tester.tap(find.text('Thought for 2s'));
    await tester.pumpAndSettle();

    expect(find.byType(DmMarkdown), findsOneWidget);
  });

  testWidgets('Thinking block renders markdown content when initially expanded',
      (tester) async {
    final block = DmChatThinkingBlock(
      text: 'Reasoning...',
      initiallyExpanded: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatThinkingBlockView(block: block),
        ),
      ),
    );

    final markdown = tester.widget<DmMarkdown>(find.byType(DmMarkdown));

    expect(find.text('Thinking...'), findsOneWidget);
    expect(markdown.data, 'Reasoning...');
    expect(markdown.shrinkWrap, isTrue);
    expect(markdown.physics, isA<NeverScrollableScrollPhysics>());
  });

  testWidgets('Thinking block keeps one stream subscription while collapsed',
      (tester) async {
    var listenCount = 0;
    var cancelCount = 0;
    final controller = StreamController<String>(
      onListen: () => listenCount += 1,
      onCancel: () => cancelCount += 1,
    );
    final block = DmChatThinkingBlock(
      stream: controller.stream,
      initiallyExpanded: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatThinkingBlockView(block: block),
        ),
      ),
    );

    expect(listenCount, 1);
    expect(find.byType(DmMarkdown), findsNothing);

    controller.add('First ');
    await tester.pump();

    await tester.tap(find.text('Thinking...'));
    await tester.pump();

    var markdown = tester.widget<DmMarkdown>(find.byType(DmMarkdown));
    expect(markdown.data, 'First ');

    await tester.tap(find.text('Thinking...'));
    await tester.pump();

    controller.add('second');
    await tester.pump();

    expect(listenCount, 1);
    expect(cancelCount, 0);

    await tester.tap(find.text('Thinking...'));
    await tester.pump();

    markdown = tester.widget<DmMarkdown>(find.byType(DmMarkdown));
    expect(markdown.data, 'First second');
    expect(listenCount, 1);
    expect(cancelCount, 0);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();

    expect(cancelCount, 1);
  });

  testWidgets('Thinking block preserves streamed text when stream errors',
      (tester) async {
    final controller = StreamController<String>();
    final block = DmChatThinkingBlock(
      stream: controller.stream,
      initiallyExpanded: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatThinkingBlockView(block: block),
        ),
      ),
    );

    controller.add('Partial reasoning');
    await tester.pump();

    controller.addError(Exception('stream failed'));
    await tester.pump();

    final markdown = tester.widget<DmMarkdown>(find.byType(DmMarkdown));

    expect(markdown.data, 'Partial reasoning');
    expect(find.text('Thinking stopped'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Thinking block replaces stream subscription and clears old text',
      (tester) async {
    var firstListenCount = 0;
    var firstCancelCount = 0;
    var secondListenCount = 0;
    final firstController = StreamController<String>(
      onListen: () => firstListenCount += 1,
      onCancel: () => firstCancelCount += 1,
    );
    final secondController = StreamController<String>(
      onListen: () => secondListenCount += 1,
    );
    final firstBlock = DmChatThinkingBlock(
      stream: firstController.stream,
      initiallyExpanded: true,
    );
    final secondBlock = DmChatThinkingBlock(
      stream: secondController.stream,
      initiallyExpanded: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatThinkingBlockView(block: firstBlock),
        ),
      ),
    );

    firstController.add('Old text');
    await tester.pump();

    expect(firstListenCount, 1);
    expect(tester.widget<DmMarkdown>(find.byType(DmMarkdown)).data, 'Old text');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatThinkingBlockView(block: secondBlock),
        ),
      ),
    );

    expect(firstCancelCount, 1);
    expect(secondListenCount, 1);
    expect(tester.widget<DmMarkdown>(find.byType(DmMarkdown)).data, '');

    secondController.add('New text');
    await tester.pump();

    expect(tester.widget<DmMarkdown>(find.byType(DmMarkdown)).data, 'New text');
  });

  testWidgets('Thinking block resets expansion when initiallyExpanded changes',
      (tester) async {
    final expandedBlock = DmChatThinkingBlock(
      text: 'Reasoning...',
      initiallyExpanded: true,
    );
    final collapsedBlock = DmChatThinkingBlock(
      text: 'Reasoning...',
      initiallyExpanded: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatThinkingBlockView(block: expandedBlock),
        ),
      ),
    );

    expect(find.byType(DmMarkdown), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatThinkingBlockView(block: collapsedBlock),
        ),
      ),
    );

    expect(find.byType(DmMarkdown), findsNothing);
  });

  testWidgets('Thinking block header exposes button and expanded semantics',
      (tester) async {
    final semantics = tester.ensureSemantics();

    final block = DmChatThinkingBlock(
      text: 'Reasoning...',
      duration: const Duration(seconds: 2),
      initiallyExpanded: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatThinkingBlockView(block: block),
        ),
      ),
    );

    expect(
      tester.getSemantics(find.byKey(DmChatThinkingBlockView.headerKey)),
      matchesSemantics(
        label: 'Thought for 2s',
        isButton: true,
        hasExpandedState: true,
        isExpanded: false,
        hasTapAction: true,
      ),
    );

    await tester.tap(find.text('Thought for 2s'));
    await tester.pumpAndSettle();

    expect(
      tester.getSemantics(find.byKey(DmChatThinkingBlockView.headerKey)),
      matchesSemantics(
        label: 'Thinking...',
        isButton: true,
        hasExpandedState: true,
        isExpanded: true,
        hasTapAction: true,
      ),
    );

    semantics.dispose();
  });
}
