import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/chat_test_harness.dart';

void main() {
  group('DmChatToolCallBlockView', () {
    testWidgets('renders collapsed chip with tool name and status icon',
        (tester) async {
      await pumpThemed(
        tester,
        const DmChatToolCallBlockView(
          block: DmChatToolCallBlock(
            id: 't1',
            name: 'search_web',
            status: DmChatToolCallStatus.done,
          ),
        ),
      );
      expect(find.text('search_web'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('tap expands to show input JSON and output', (tester) async {
      await pumpThemed(
        tester,
        const DmChatToolCallBlockView(
          block: DmChatToolCallBlock(
            id: 't1',
            name: 'search_web',
            status: DmChatToolCallStatus.done,
            input: {'query': 'flutter'},
            output: 'result text',
          ),
        ),
      );
      await tester.tap(find.text('search_web'));
      await tester.pumpAndSettle();
      // JsonEncoder.withIndent produces multi-line output that breaks
      // textContaining on the raw jsonEncode result; match the key instead.
      expect(find.textContaining('query'), findsWidgets);
      expect(find.textContaining('result text'), findsOneWidget);
    });

    testWidgets('error status shows errorMessage', (tester) async {
      await pumpThemed(
        tester,
        const DmChatToolCallBlockView(
          block: DmChatToolCallBlock(
            id: 't1',
            name: 'search_web',
            status: DmChatToolCallStatus.error,
            errorMessage: 'network timeout',
          ),
        ),
      );
      await tester.tap(find.text('search_web'));
      await tester.pumpAndSettle();
      expect(find.textContaining('network timeout'), findsOneWidget);
    });
  });
}
