import 'package:duskmoon_chat/duskmoon_chat.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart' show DmMarkdown;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Renders static markdown', (tester) async {
    final block = DmChatTextBlock(text: '**Hello**');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatTextBlockView(block: block),
        ),
      ),
    );

    final markdown = tester.widget<DmMarkdown>(find.byType(DmMarkdown));
    expect(markdown.data, '**Hello**');
    expect(markdown.shrinkWrap, isTrue);
    expect(markdown.physics, isA<NeverScrollableScrollPhysics>());
    expect(find.text('Hello'), findsOneWidget);
  });

  testWidgets('Renders streaming markdown', (tester) async {
    final stream = Stream<String>.value('**Hello**');
    final block = DmChatTextBlock(stream: stream);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DmChatTextBlockView(block: block),
        ),
      ),
    );

    final markdown = tester.widget<DmMarkdown>(find.byType(DmMarkdown));
    expect(markdown.stream, same(stream));
    expect(markdown.shrinkWrap, isTrue);
    expect(markdown.physics, isA<NeverScrollableScrollPhysics>());

    await tester.pump();

    expect(find.text('Hello'), findsOneWidget);
  });
}
