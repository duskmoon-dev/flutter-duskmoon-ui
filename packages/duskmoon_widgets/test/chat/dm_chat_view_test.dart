import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/chat_test_harness.dart';

void main() {
  group('DmChatView', () {
    testWidgets('renders messages oldest→newest visually (reverse list)',
        (tester) async {
      await pumpThemed(
        tester,
        SizedBox(
          height: 400,
          child: DmChatView(
            messages: const [
              DmChatMessage(
                id: 'u1',
                role: DmChatRole.user,
                blocks: [DmChatTextBlock(text: 'first')],
              ),
              DmChatMessage(
                id: 'a1',
                role: DmChatRole.assistant,
                blocks: [DmChatTextBlock(text: 'second')],
              ),
            ],
            onSend: (_, _) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('first'), findsOneWidget);
      expect(find.text('second'), findsOneWidget);
      final first = tester.getTopLeft(find.text('first')).dy;
      final second = tester.getTopLeft(find.text('second')).dy;
      expect(second, greaterThan(first));
    });

    testWidgets('shows emptyBuilder when messages is empty', (tester) async {
      await pumpThemed(
        tester,
        SizedBox(
          height: 400,
          child: DmChatView(
            messages: const [],
            onSend: (_, _) {},
            emptyBuilder: (_) => const Text('no messages yet'),
          ),
        ),
      );
      expect(find.text('no messages yet'), findsOneWidget);
    });

    testWidgets('input placeholder propagates to DmChatInput', (tester) async {
      await pumpThemed(
        tester,
        SizedBox(
          height: 400,
          child: DmChatView(
            messages: const [],
            onSend: (_, _) {},
            inputPlaceholder: 'Say hi',
          ),
        ),
      );
      expect(find.byType(DmChatInput), findsOneWidget);
      expect(find.text('Say hi'), findsOneWidget);
    });

    testWidgets('hiding input gives messages the full available height', (
      tester,
    ) async {
      await pumpThemed(
        tester,
        const SizedBox(
          height: 400,
          child: DmChatView(messages: [], showInput: false),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DmChatInput), findsNothing);
      expect(find.byType(DmMarkdownInput), findsNothing);
      expect(tester.getSize(find.byType(ListView)).height, 400);
      expect(tester.takeException(), isNull);
    });

    testWidgets('input can be toggled without replacing the conversation', (
      tester,
    ) async {
      Future<void> pumpChat(bool showInput) => pumpThemed(
            tester,
            SizedBox(
              height: 400,
              child: DmChatView(
                messages: const [],
                showInput: showInput,
              ),
            ),
          );

      await pumpChat(true);
      await tester.pumpAndSettle();
      final state = tester.state(find.byType(DmChatView));
      final scrollController =
          tester.widget<ListView>(find.byType(ListView)).controller;
      expect(find.byType(DmChatInput), findsOneWidget);
      expect(tester.getSize(find.byType(ListView)).height, lessThan(400));

      await pumpChat(false);
      await tester.pumpAndSettle();
      expect(find.byType(DmChatInput), findsNothing);
      expect(tester.getSize(find.byType(ListView)).height, 400);
      expect(tester.state(find.byType(DmChatView)), same(state));
      expect(tester.widget<ListView>(find.byType(ListView)).controller,
          same(scrollController));

      await pumpChat(true);
      await tester.pumpAndSettle();
      expect(find.byType(DmChatInput), findsOneWidget);
      expect(tester.getSize(find.byType(ListView)).height, lessThan(400));
      expect(tester.state(find.byType(DmChatView)), same(state));
      expect(tester.takeException(), isNull);
    });

    testWidgets('input line limits propagate to DmMarkdownInput', (
      tester,
    ) async {
      await pumpThemed(
        tester,
        SizedBox(
          height: 500,
          child: DmChatView(
            messages: const [],
            onSend: (_, _) {},
            inputMinLines: 6,
            inputMaxLines: 6,
          ),
        ),
      );

      final input = tester.widget<DmMarkdownInput>(
        find.byType(DmMarkdownInput),
      );
      expect(input.minLines, 6);
      expect(input.maxLines, 6);
    });
  });
}
