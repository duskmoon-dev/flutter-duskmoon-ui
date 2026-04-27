import 'package:duskmoon_chat/duskmoon_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DmChatBubble routes blocks correctly', (tester) async {
    final msg = DmChatMessage(
      id: '1',
      role: DmChatRole.user,
      blocks: [DmChatTextBlock(text: 'Hello')],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatBubble(message: msg),
        ),
      ),
    );

    expect(find.byType(DmChatTextBlockView), findsOneWidget);
  });

  testWidgets('DmChatBubble dispatches supported block renderers',
      (tester) async {
    final msg = DmChatMessage(
      id: '1',
      role: DmChatRole.assistant,
      blocks: [
        DmChatTextBlock(text: 'Hello'),
        DmChatThinkingBlock(text: 'Reasoning'),
        DmChatToolCallBlock(toolName: 'search', input: {'query': 'Hello'}),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatBubble(message: msg),
        ),
      ),
    );

    expect(find.byType(DmChatTextBlockView), findsOneWidget);
    expect(find.byType(DmChatThinkingBlockView), findsOneWidget);
    expect(find.byType(DmChatToolCallBlockView), findsOneWidget);
  });

  testWidgets('DmChatBubble caps user message width without forcing 80%',
      (tester) async {
    final msg = DmChatMessage(
      id: '1',
      role: DmChatRole.user,
      blocks: [DmChatTextBlock(text: 'Hello')],
    );

    await tester.pumpWidget(
      Center(
        child: SizedBox(
          width: 1000,
          child: MaterialApp(
            home: Scaffold(
              body: DmChatBubble(message: msg),
            ),
          ),
        ),
      ),
    );

    final align = tester.widget<Align>(find.byType(Align));
    final constrainedBox = tester.widget<ConstrainedBox>(
      find.byWidgetPredicate(
        (widget) =>
            widget is ConstrainedBox && widget.constraints.maxWidth == 640,
      ),
    );

    expect(align.alignment, Alignment.centerRight);
    expect(find.byType(FractionallySizedBox), findsNothing);
    expect(constrainedBox.constraints.maxWidth, 640);
    expect(_userBubbleSize(tester).width, lessThan(640));
  });

  testWidgets('DmChatBubble does not throw in very narrow parents',
      (tester) async {
    final msg = DmChatMessage(
      id: '1',
      role: DmChatRole.user,
      blocks: [DmChatTextBlock(text: 'Hello')],
    );

    await tester.pumpWidget(
      Center(
        child: SizedBox(
          width: 40,
          child: MaterialApp(
            home: Scaffold(
              body: DmChatBubble(message: msg),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(_userBubbleSize(tester).width, lessThanOrEqualTo(32));
  });

  testWidgets('DmChatBubble passes user foreground color to markdown blocks',
      (tester) async {
    final msg = DmChatMessage(
      id: '1',
      role: DmChatRole.user,
      blocks: [DmChatTextBlock(text: 'Hello')],
    );
    const colorScheme = ColorScheme.light(
      primaryContainer: Color(0xff112233),
      onPrimaryContainer: Color(0xffddeeff),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(colorScheme: colorScheme),
        home: Scaffold(
          body: DmChatBubble(message: msg),
        ),
      ),
    );

    final textBlockView =
        tester.widget<DmChatTextBlockView>(find.byType(DmChatTextBlockView));

    expect(
      textBlockView.themeData?.colorScheme.onSurface,
      colorScheme.onPrimaryContainer,
    );
    expect(
      textBlockView.themeData?.textTheme.bodyMedium?.color,
      colorScheme.onPrimaryContainer,
    );
    expect(textBlockView.markdownPadding, EdgeInsets.zero);
  });

  testWidgets(
      'DmChatBubble estimates short user width without markdown padding',
      (tester) async {
    final msg = DmChatMessage(
      id: '1',
      role: DmChatRole.user,
      blocks: [DmChatTextBlock(text: 'Hello')],
    );
    final textStyle = ThemeData().textTheme.bodyMedium!;
    final painter = TextPainter(
      text: TextSpan(text: 'Hello', style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(textTheme: TextTheme(bodyMedium: textStyle)),
        home: Scaffold(
          body: DmChatBubble(message: msg),
        ),
      ),
    );

    expect(
      _userBubbleSize(tester).width,
      moreOrLessEquals(painter.width + 32, epsilon: 2),
    );
  });

  testWidgets(
      'DmChatBubble renders observable placeholders for deferred blocks',
      (tester) async {
    final msg = DmChatMessage(
      id: '1',
      role: DmChatRole.assistant,
      blocks: [
        DmChatAttachmentBlock(
          attachments: [
            DmChatAttachment(id: 'a', name: 'report.pdf'),
          ],
        ),
        DmChatCustomBlock(kind: 'chart'),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatBubble(message: msg),
        ),
      ),
    );

    expect(
      find.text('Attachments are not supported yet: 1 attachment(s)'),
      findsOneWidget,
    );
    expect(
      find.text('Custom block is not supported yet: chart'),
      findsOneWidget,
    );
  });

  testWidgets('DmChatBubble shows assistant avatar before content',
      (tester) async {
    final msg = DmChatMessage(
      id: '1',
      role: DmChatRole.assistant,
      blocks: [DmChatTextBlock(text: 'Hello')],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatBubble(
            message: msg,
            avatar: const CircleAvatar(key: ValueKey<String>('avatar')),
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey<String>('avatar')), findsOneWidget);
    expect(find.byType(Row), findsOneWidget);
    expect(find.byType(DmChatTextBlockView), findsOneWidget);
  });
}

Size _userBubbleSize(WidgetTester tester) {
  return tester.getSize(find.byKey(DmChatBubble.userBubbleKey));
}
