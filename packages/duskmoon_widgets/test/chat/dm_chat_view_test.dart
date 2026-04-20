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
            onSend: (_, __) {},
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
            onSend: (_, __) {},
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
            onSend: (_, __) {},
            inputPlaceholder: 'Say hi',
          ),
        ),
      );
      expect(find.text('Say hi'), findsOneWidget);
    });
  });
}
