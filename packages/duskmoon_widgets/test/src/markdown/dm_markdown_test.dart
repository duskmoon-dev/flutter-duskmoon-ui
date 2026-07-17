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

    testWidgets('renders mermaid as code when disabled', (tester) async {
      await tester.pumpWidget(buildApp(
        data: '```mermaid\nflowchart LR\nA --> B\n```',
      ));
      await tester.pumpAndSettle();

      expect(find.text('mermaid'), findsOneWidget);
      expect(find.byType(DmMermaidView), findsNothing);
    });

    testWidgets('renders mermaid view when enabled', (tester) async {
      await tester.pumpWidget(buildApp(
        data: '```mermaid\nflowchart LR\nA --> B\n```',
        config: const DmMarkdownConfig(enableMermaid: true),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(DmMermaidView), findsOneWidget);
    });

    testWidgets('renders horizontal rule', (tester) async {
      await tester.pumpWidget(buildApp(data: 'Above\n\n---\n\nBelow'));
      await tester.pumpAndSettle();
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('renders color chips for complete CSS colors', (tester) async {
      await tester.pumpWidget(buildApp(
        data:
            'Colors `#4C86FC`, `rgba(255, 0, 0, 0.5)`, and `hsl(120, 50%, 50%)`.',
      ));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('dm-markdown-color-chip')),
        findsNWidgets(3),
      );
    });

    testWidgets('can disable color chips', (tester) async {
      await tester.pumpWidget(buildApp(
        data: '`#fff`',
        config: const DmMarkdownConfig(enableColorChips: false),
      ));
      await tester.pumpAndSettle();

      expect(
          find.byKey(const ValueKey('dm-markdown-color-chip')), findsNothing);
      expect(find.text('#fff'), findsOneWidget);
    });

    testWidgets('renders initial front matter as yaml by default',
        (tester) async {
      await tester.pumpWidget(buildApp(
        data: '---\ntitle: Example\n---\n# Document',
      ));
      await tester.pumpAndSettle();

      expect(find.text('yaml'), findsOneWidget);
      expect(find.text('Document'), findsOneWidget);
      expect(find.textContaining('title: Example'), findsOneWidget);
    });

    testWidgets('can hide initial front matter', (tester) async {
      await tester.pumpWidget(buildApp(
        data: '---\ntitle: Example\n---\n# Document',
        config: const DmMarkdownConfig(
          frontMatter: DmFrontMatterMode.hidden,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Document'), findsOneWidget);
      expect(find.textContaining('title: Example'), findsNothing);
    });

    testWidgets('renders soft line breaks by default', (tester) async {
      await tester.pumpWidget(buildApp(data: 'First line\nSecond line'));
      await tester.pumpAndSettle();

      final richText = tester.widget<RichText>(
        find
            .descendant(
                of: find.byType(DmMarkdown), matching: find.byType(RichText))
            .first,
      );
      expect(richText.text.toPlainText(), contains('First line\nSecond line'));
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
