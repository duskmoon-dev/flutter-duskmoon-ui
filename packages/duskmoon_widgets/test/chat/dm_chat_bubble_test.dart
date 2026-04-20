import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/chat_test_harness.dart';

void main() {
  group('DmChatBubble', () {
    testWidgets('user message aligns right and is wrapped in a filled bubble',
        (tester) async {
      await pumpThemed(
        tester,
        const DmChatBubble(
          message: DmChatMessage(
            id: 'u1',
            role: DmChatRole.user,
            blocks: [DmChatTextBlock(text: 'hi there')],
          ),
        ),
      );
      expect(find.text('hi there'), findsOneWidget);
      final aligns = tester.widgetList<Align>(find.byType(Align)).toList();
      expect(aligns.any((a) => a.alignment == Alignment.centerRight), isTrue);
    });

    testWidgets('assistant message renders full-width with no bubble fill',
        (tester) async {
      await pumpThemed(
        tester,
        const DmChatBubble(
          message: DmChatMessage(
            id: 'a1',
            role: DmChatRole.assistant,
            blocks: [DmChatTextBlock(text: 'long response')],
          ),
        ),
      );
      expect(find.text('long response'), findsOneWidget);
      final aligns = tester.widgetList<Align>(find.byType(Align)).toList();
      expect(aligns.any((a) => a.alignment == Alignment.centerRight), isFalse);
    });

    testWidgets('system message centers and uses italic style', (tester) async {
      await pumpThemed(
        tester,
        const DmChatBubble(
          message: DmChatMessage(
            id: 's1',
            role: DmChatRole.system,
            blocks: [DmChatTextBlock(text: 'context injected')],
          ),
        ),
      );
      expect(find.text('context injected'), findsOneWidget);
      final aligns = tester.widgetList<Align>(find.byType(Align)).toList();
      expect(aligns.any((a) => a.alignment == Alignment.center), isTrue);
    });

    testWidgets('renders avatar and header slots when provided', (tester) async {
      await pumpThemed(
        tester,
        const DmChatBubble(
          message: DmChatMessage(
            id: 'a1',
            role: DmChatRole.assistant,
            blocks: [DmChatTextBlock(text: 'body')],
          ),
          avatar: Icon(Icons.smart_toy, key: ValueKey('avatar')),
          header: Text('Assistant', key: ValueKey('header')),
        ),
      );
      expect(find.byKey(const ValueKey('avatar')), findsOneWidget);
      expect(find.byKey(const ValueKey('header')), findsOneWidget);
    });
  });
}
