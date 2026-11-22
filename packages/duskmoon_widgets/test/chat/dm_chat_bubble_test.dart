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

    testWidgets('renders avatar and header slots when provided',
        (tester) async {
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

    testWidgets('renders user avatar and header slots when provided',
        (tester) async {
      await pumpThemed(
        tester,
        const DmChatBubble(
          message: DmChatMessage(
            id: 'u1',
            role: DmChatRole.user,
            blocks: [DmChatTextBlock(text: 'body')],
          ),
          avatar: Icon(Icons.person, key: ValueKey('user-avatar')),
          header: Text('User', key: ValueKey('user-header')),
        ),
      );
      expect(find.byKey(const ValueKey('user-avatar')), findsOneWidget);
      expect(find.byKey(const ValueKey('user-header')), findsOneWidget);
    });

    testWidgets('renders user footer outside and below the filled bubble',
        (tester) async {
      await pumpThemed(
        tester,
        const DmChatBubble(
          message: DmChatMessage(
            id: 'u1',
            role: DmChatRole.user,
            blocks: [DmChatTextBlock(text: 'short prompt')],
          ),
          footer: Row(
            key: ValueKey('user-footer'),
            mainAxisSize: MainAxisSize.min,
            children: [Icon(Icons.copy, size: 16)],
          ),
        ),
      );

      final footerFinder = find.byKey(const ValueKey('user-footer'));
      expect(footerFinder, findsOneWidget);

      final bubbleContainerFinder = find.ancestor(
        of: find.text('short prompt'),
        matching: find.byWidgetPredicate(
          (w) => w is Container && w.decoration is BoxDecoration,
        ),
      );
      expect(bubbleContainerFinder, findsOneWidget);

      // Footer must NOT be a descendant of the bubble Container.
      expect(
        find.descendant(of: bubbleContainerFinder, matching: footerFinder),
        findsNothing,
      );

      // Footer must sit vertically below the bubble.
      final bubbleRect = tester.getRect(bubbleContainerFinder);
      final footerRect = tester.getRect(footerFinder);
      expect(footerRect.top, greaterThanOrEqualTo(bubbleRect.bottom));
    });

    testWidgets('does not notify stream scope during a parent rebuild',
        (tester) async {
      DmChatMessage message(String text) => DmChatMessage(
            id: 'a1',
            role: DmChatRole.assistant,
            blocks: [
              const DmChatThinkingBlock(text: 'reasoning'),
              DmChatTextBlock(text: text),
            ],
          );

      await pumpThemed(
        tester,
        DmChatBubble(message: message('partial streamed text')),
      );
      await pumpThemed(
        tester,
        DmChatBubble(message: message('partial streamed text updated')),
      );

      expect(tester.takeException(), isNull);
    });
  });
}
