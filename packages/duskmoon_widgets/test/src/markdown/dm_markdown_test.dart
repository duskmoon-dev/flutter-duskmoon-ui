import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';

void main() {
  group('DmMarkdown', () {
    Widget buildApp({
      String? data,
      Stream<String>? stream,
      DmMarkdownConfig config = const DmMarkdownConfig(),
      bool selectable = true,
      bool shrinkWrap = false,
      ThemeData? themeData,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 600,
            child: DmMarkdown(
              data: data,
              stream: stream,
              config: config,
              selectable: selectable,
              shrinkWrap: shrinkWrap,
              themeData: themeData,
            ),
          ),
        ),
      );
    }

    testWidgets('renders simple paragraph from string data', (tester) async {
      await tester.pumpWidget(buildApp(data: 'Hello world'));
      await tester.pumpAndSettle();
      expect(find.text('Hello world'), findsOneWidget);
    });

    testWidgets('renders heading correctly', (tester) async {
      await tester.pumpWidget(buildApp(data: '# Title'));
      await tester.pumpAndSettle();
      expect(find.text('Title'), findsOneWidget);
    });

    testWidgets('renders multiple blocks', (tester) async {
      await tester.pumpWidget(buildApp(data: '# Title\n\nParagraph'));
      await tester.pumpAndSettle();
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Paragraph'), findsOneWidget);
    });

    testWidgets('renders code block with language label', (tester) async {
      await tester.pumpWidget(buildApp(data: '```dart\nvoid main() {}\n```'));
      await tester.pumpAndSettle();
      expect(find.text('dart'), findsOneWidget);
    });

    testWidgets('renders horizontal rule', (tester) async {
      await tester.pumpWidget(buildApp(data: 'Above\n\n---\n\nBelow'));
      await tester.pumpAndSettle();
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('blockquote renders with border decoration', (tester) async {
      await tester.pumpWidget(buildApp(data: '> Quote text'));
      await tester.pumpAndSettle();
      expect(find.text('Quote text'), findsOneWidget);
    });

    testWidgets('selectable=false disables SelectionArea', (tester) async {
      await tester.pumpWidget(buildApp(
        data: 'Some text',
        selectable: false,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(SelectionArea), findsNothing);
    });

    testWidgets('selectable=true enables SelectionArea', (tester) async {
      await tester.pumpWidget(buildApp(
        data: 'Some text',
        selectable: true,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(SelectionArea), findsOneWidget);
    });

    testWidgets('shrinkWrap mode works', (tester) async {
      await tester.pumpWidget(buildApp(
        data: 'Paragraph text',
        shrinkWrap: true,
      ));
      await tester.pumpAndSettle();
      expect(find.text('Paragraph text'), findsOneWidget);
    });

    testWidgets('theme override applies', (tester) async {
      final customTheme = ThemeData.dark();
      await tester.pumpWidget(buildApp(
        data: 'Themed text',
        themeData: customTheme,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(Theme), findsWidgets);
    });

    group('streaming', () {
      testWidgets('renders content from stream', (tester) async {
        final controller = StreamController<String>();

        await tester.pumpWidget(buildApp(stream: controller.stream));
        await tester.pump();

        controller.add('Hello ');
        await tester.pump(const Duration(milliseconds: 100));

        controller.add('world');
        await tester.pump(const Duration(milliseconds: 100));

        await controller.close();
        await tester.pumpAndSettle();

        expect(find.text('Hello world'), findsOneWidget);
      });
    });
  });
}
