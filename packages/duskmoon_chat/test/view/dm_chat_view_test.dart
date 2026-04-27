import 'package:duskmoon_chat/duskmoon_chat.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DmChatView renders messages and input', (tester) async {
    final msgs = [
      DmChatMessage(
        id: '1',
        role: DmChatRole.user,
        blocks: [DmChatTextBlock(text: 'Hello')],
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatView(
            messages: msgs,
            onSend: (_) {},
          ),
        ),
      ),
    );

    expect(find.byType(DmChatBubble), findsOneWidget);
    expect(find.byType(DmMarkdownInput), findsOneWidget);
  });

  testWidgets('DmChatView trims sent text and clears input', (tester) async {
    final sent = <String>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatView(
            messages: const [],
            onSend: sent.add,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(EditableText), '  Hello chat  ');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();

    expect(sent, ['Hello chat']);
    expect(find.text('Hello chat'), findsNothing);
  });

  testWidgets('DmChatView ignores empty or whitespace-only sends',
      (tester) async {
    final sent = <String>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatView(
            messages: const [],
            onSend: sent.add,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(EditableText), '   \n  ');
    await tester.tap(find.byTooltip('Send message'));
    await tester.pump();

    expect(sent, isEmpty);
  });

  testWidgets('DmChatView configures input controller from markdown config',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatView(
            messages: const [],
            onSend: (_) {},
            markdownConfig: const DmMarkdownConfig(
              enableGfm: false,
              enableKatex: false,
            ),
          ),
        ),
      ),
    );

    final input = tester.widget<DmMarkdownInput>(find.byType(DmMarkdownInput));

    expect(input.controller?.enableGfm, isFalse);
    expect(input.controller?.enableKatex, isFalse);
  });

  testWidgets(
      'DmChatView updates input controller when markdown config changes',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatView(
            messages: const [],
            onSend: (_) {},
            markdownConfig: const DmMarkdownConfig(enableGfm: false),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(EditableText), 'draft');
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatView(
            messages: const [],
            onSend: (_) {},
            markdownConfig: const DmMarkdownConfig(enableGfm: true),
          ),
        ),
      ),
    );

    final input = tester.widget<DmMarkdownInput>(find.byType(DmMarkdownInput));

    expect(input.controller?.enableGfm, isTrue);
    expect(find.text('draft'), findsOneWidget);
  });

  testWidgets('DmChatView recreates input widget when parsing config changes',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatView(
            messages: const [],
            onSend: (_) {},
            markdownConfig: const DmMarkdownConfig(enableGfm: false),
          ),
        ),
      ),
    );

    final firstInput =
        tester.widget<DmMarkdownInput>(find.byType(DmMarkdownInput));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatView(
            messages: const [],
            onSend: (_) {},
            markdownConfig: const DmMarkdownConfig(enableGfm: true),
          ),
        ),
      ),
    );

    final secondInput =
        tester.widget<DmMarkdownInput>(find.byType(DmMarkdownInput));

    expect(secondInput.key, isNot(firstInput.key));
  });

  testWidgets('DmChatView shows stop action while latest message streams',
      (tester) async {
    var stopped = false;
    final msgs = [
      DmChatMessage(
        id: '1',
        role: DmChatRole.assistant,
        status: DmChatMessageStatus.streaming,
        blocks: [DmChatTextBlock(text: 'Working')],
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatView(
            messages: msgs,
            onSend: (_) {},
            onStop: () => stopped = true,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.stop_circle_outlined), findsOneWidget);
    expect(find.byIcon(Icons.send), findsNothing);

    await tester.tap(find.byIcon(Icons.stop_circle_outlined));

    expect(stopped, isTrue);
  });

  testWidgets('DmChatView exposes tooltips for icon-only actions',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatView(
            messages: const [],
            onSend: (_) {},
          ),
        ),
      ),
    );

    expect(find.byTooltip('Send message'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatView(
            messages: [
              DmChatMessage(
                id: '1',
                role: DmChatRole.assistant,
                status: DmChatMessageStatus.streaming,
                blocks: [DmChatTextBlock(text: 'Working')],
              ),
            ],
            onSend: (_) {},
            onStop: () {},
          ),
        ),
      ),
    );

    expect(find.byTooltip('Stop response'), findsOneWidget);
  });

  testWidgets('DmChatView keys bubbles by message id', (tester) async {
    final msgs = [
      DmChatMessage(
        id: 'older',
        role: DmChatRole.assistant,
        blocks: [DmChatTextBlock(text: 'Older')],
      ),
      DmChatMessage(
        id: 'newer',
        role: DmChatRole.user,
        blocks: [DmChatTextBlock(text: 'Newer')],
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatView(
            messages: msgs,
            onSend: (_) {},
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey<String>('older')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('newer')), findsOneWidget);
  });

  testWidgets('DmChatView places newest chronological message by composer',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatView(
            messages: [
              DmChatMessage(
                id: 'older',
                role: DmChatRole.assistant,
                blocks: [DmChatTextBlock(text: 'Older')],
              ),
              DmChatMessage(
                id: 'newer',
                role: DmChatRole.user,
                blocks: [DmChatTextBlock(text: 'Newer')],
              ),
            ],
            onSend: (_) {},
          ),
        ),
      ),
    );

    final olderBottom =
        tester.getBottomLeft(find.byKey(const ValueKey<String>('older'))).dy;
    final newerBottom =
        tester.getBottomLeft(find.byKey(const ValueKey<String>('newer'))).dy;
    final composerTop = tester.getTopLeft(find.byType(DmMarkdownInput)).dy;

    expect(newerBottom, greaterThan(olderBottom));
    expect(composerTop - newerBottom, lessThan(composerTop - olderBottom));
  });

  testWidgets('DmChatView composer does not overflow in short bounded layouts',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 160,
            child: DmChatView(
              messages: [
                DmChatMessage(
                  id: '1',
                  role: DmChatRole.user,
                  blocks: [DmChatTextBlock(text: 'Hello')],
                ),
              ],
              onSend: (_) {},
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('DmChatView forwards assistant avatar to bubbles',
      (tester) async {
    final msgs = [
      DmChatMessage(
        id: '1',
        role: DmChatRole.assistant,
        blocks: [DmChatTextBlock(text: 'Hello')],
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatView(
            messages: msgs,
            onSend: (_) {},
            assistantAvatar: const CircleAvatar(
              key: ValueKey<String>('assistant-avatar'),
            ),
          ),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey<String>('assistant-avatar')),
      findsOneWidget,
    );
  });
}
