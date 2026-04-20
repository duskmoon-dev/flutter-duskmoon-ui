import 'dart:async';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/chat_test_harness.dart';

void main() {
  group('DmChatThinkingBlockView', () {
    testWidgets('renders static text collapsed with duration summary',
        (tester) async {
      await pumpThemed(
        tester,
        const DmChatThinkingBlockView(
          block: DmChatThinkingBlock(
            text: 'Step 1\nStep 2',
            elapsed: Duration(seconds: 3),
          ),
        ),
      );
      expect(find.textContaining('Thought for'), findsOneWidget);
      expect(find.textContaining('3'), findsOneWidget);
      expect(find.text('Step 1\nStep 2'), findsNothing);
    });

    testWidgets('tap expands revealing content', (tester) async {
      await pumpThemed(
        tester,
        const DmChatThinkingBlockView(
          block: DmChatThinkingBlock(
            text: 'reasoning body',
            elapsed: Duration(seconds: 2),
          ),
        ),
      );
      await tester.tap(find.byType(DmChatThinkingBlockView));
      await tester.pumpAndSettle();
      expect(find.textContaining('reasoning body'), findsOneWidget);
    });

    testWidgets('auto-expands while streaming', (tester) async {
      final controller = StreamController<String>();
      addTearDown(controller.close);
      await pumpThemed(
        tester,
        DmChatThinkingBlockView(
          block: DmChatThinkingBlock(stream: controller.stream),
        ),
      );
      controller.add('partial reasoning');
      await tester.pump();
      expect(find.textContaining('partial reasoning'), findsOneWidget);
    });
  });
}
