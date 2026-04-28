import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/chat_test_harness.dart';

void main() {
  group('DmChatInput', () {
    testWidgets('uses markdown input with an upward send control', (
      tester,
    ) async {
      await pumpThemed(
        tester,
        DmChatInput(onSend: (_, __) {}),
      );

      expect(find.byType(DmMarkdownInput), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
      expect(find.byIcon(Icons.send), findsNothing);
    });

    testWidgets('send is disabled until text or ready attachments exist', (
      tester,
    ) async {
      await pumpThemed(
        tester,
        DmChatInput(onSend: (_, __) {}),
      );

      var sendButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.arrow_upward),
      );
      expect(sendButton.onPressed, isNull);

      await tester.enterText(find.byType(EditableText), 'hello');
      await tester.pump();

      sendButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.arrow_upward),
      );
      expect(sendButton.onPressed, isNotNull);
    });

    testWidgets('renders send button; tap submits current text',
        (tester) async {
      String? sent;
      await pumpThemed(
        tester,
        DmChatInput(
          onSend: (text, atts) => sent = text,
        ),
      );
      await tester.enterText(find.byType(EditableText), 'hello');
      await tester.pump();
      await tester.tap(find.byTooltip('Send'));
      await tester.pump();
      expect(sent, 'hello');
    });

    testWidgets(
        'submitShortcut=enter submits on Enter, Shift+Enter inserts newline',
        (tester) async {
      final submissions = <String>[];
      await pumpThemed(
        tester,
        DmChatInput(
          submitShortcut: DmChatSubmitShortcut.enter,
          onSend: (text, atts) => submissions.add(text),
        ),
      );
      await tester.enterText(find.byType(EditableText), 'a');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(submissions, ['a']);
    });

    testWidgets('submitShortcut=cmdEnter does NOT submit on Enter alone',
        (tester) async {
      final submissions = <String>[];
      await pumpThemed(
        tester,
        DmChatInput(
          onSend: (text, atts) => submissions.add(text),
        ),
      );
      await tester.enterText(find.byType(EditableText), 'b');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(submissions, isEmpty);
    });

    testWidgets('send button becomes stop when isStreaming', (tester) async {
      var stopped = false;
      await pumpThemed(
        tester,
        DmChatInput(
          onSend: (_, __) {},
          onStop: () => stopped = true,
          isStreaming: true,
        ),
      );
      expect(find.byTooltip('Stop'), findsOneWidget);
      expect(find.byTooltip('Send'), findsNothing);
      await tester.tap(find.byTooltip('Stop'));
      expect(stopped, isTrue);
    });

    testWidgets('attach button hidden when onAttach is null', (tester) async {
      await pumpThemed(
        tester,
        DmChatInput(onSend: (_, __) {}),
      );
      expect(find.byTooltip('Attach'), findsNothing);
    });

    testWidgets('send disabled while any pending attachment is uploading',
        (tester) async {
      var sent = false;
      await pumpThemed(
        tester,
        DmChatInput(
          onSend: (_, __) => sent = true,
          pendingAttachments: const [
            DmChatAttachment(
              id: 'a1',
              name: 'x',
              status: DmChatAttachmentStatus.uploading,
            ),
          ],
        ),
      );
      await tester.enterText(find.byType(EditableText), 'text');
      await tester.pump();
      await tester.tap(find.byTooltip('Send'));
      await tester.pump();
      expect(sent, isFalse);
    });
  });
}
