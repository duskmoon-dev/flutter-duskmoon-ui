import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {required bool bounded}) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(
        height: 400,
        child: bounded ? child : SingleChildScrollView(child: child),
      ),
    ),
  );
}

void main() {
  for (final bounded in [true, false]) {
    for (final showPreview in [true, false]) {
      for (final showLineNumbers in [false, true]) {
        for (final bottom in ['none', 'custom', 'slots']) {
          testWidgets(
            '${bounded ? 'bounded' : 'unbounded'} markdown input '
            'preview=$showPreview gutter=$showLineNumbers bottom=$bottom',
            (tester) async {
              final controller = DmMarkdownInputController(text: '# Original');
              addTearDown(controller.dispose);
              await tester.pumpWidget(_wrap(
                DmMarkdownInput(
                  controller: controller,
                  minLines: 3,
                  maxLines: 5,
                  showPreview: showPreview,
                  showLineNumbers: showLineNumbers,
                  bottom: bottom == 'custom' ? const Text('Custom bar') : null,
                  bottomLeft: bottom == 'slots' ? const Text('Left bar') : null,
                  bottomRight:
                      bottom == 'slots' ? const Text('Right bar') : null,
                ),
                bounded: bounded,
              ));
              await tester.pumpAndSettle();
              expect(tester.takeException(), isNull);

              final inputHeight =
                  tester.getSize(find.byType(DmMarkdownInput)).height;
              expect(inputHeight.isFinite, isTrue);
              expect(inputHeight, bounded ? 400 : lessThan(400));
              final editable =
                  tester.widget<EditableText>(find.byType(EditableText));
              expect(editable.expands, bounded);
              if (!bounded) {
                expect(editable.minLines, 3);
                expect(editable.maxLines, 5);
              }

              await tester.enterText(
                find.byType(EditableText),
                '# Updated heading\n\nUpdated body',
              );
              await tester.pumpAndSettle();
              if (showPreview) {
                await tester.tap(find.text('Preview'));
                await tester.pumpAndSettle();
                expect(tester.takeException(), isNull);
                expect(find.text('Updated heading', findRichText: true),
                    findsOneWidget);
                await tester.tap(find.text('Write'));
                await tester.pumpAndSettle();
                expect(find.byType(EditableText), findsOneWidget);
              }
              expect(controller.text, '# Updated heading\n\nUpdated body');
              if (bottom == 'custom') {
                expect(find.text('Custom bar'), findsOneWidget);
              } else if (bottom == 'slots') {
                expect(find.text('Left bar'), findsOneWidget);
                expect(find.text('Right bar'), findsOneWidget);
              }
              expect(tester.takeException(), isNull);
            },
          );
        }
      }
    }
  }

  testWidgets('unbounded editor grows from minLines up to maxLines',
      (tester) async {
    await tester.pumpWidget(_wrap(
      const DmMarkdownInput(minLines: 2, maxLines: 4, showLineNumbers: true),
      bounded: false,
    ));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final surface = find.byKey(const ValueKey('dm-markdown-editor-surface'));
    final initialHeight = tester.getSize(surface).height;

    await tester.enterText(find.byType(EditableText), 'one\ntwo\nthree\nfour');
    await tester.pumpAndSettle();
    final maximumHeight = tester.getSize(surface).height;
    expect(maximumHeight, greaterThan(initialHeight));

    await tester.enterText(
        find.byType(EditableText), List.filled(12, 'line').join('\n'));
    await tester.pumpAndSettle();
    expect(tester.getSize(surface).height, maximumHeight);
    expect(tester.takeException(), isNull);
  });

  for (final bounded in [true, false]) {
    testWidgets('RTL gutter follows directionality with bounded=$bounded',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const Directionality(
          textDirection: TextDirection.rtl,
          child: DmMarkdownInput(
            initialValue: 'RTL gutter',
            showPreview: false,
            showLineNumbers: true,
            minLines: 3,
          ),
        ),
        bounded: bounded,
      ));
      await tester.pumpAndSettle();
      final input = tester.getRect(find.byType(DmMarkdownInput));
      final editor = tester.getRect(
        find.byKey(const ValueKey('dm-markdown-editor-surface')),
      );
      expect(editor.left, closeTo(input.left + 1, 0.01));
      expect(input.right - editor.right, greaterThanOrEqualTo(40));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('bounded tabs retain swipe navigation', (tester) async {
    DmMarkdownTab? selectedTab;
    await tester.pumpWidget(_wrap(
      DmMarkdownInput(
        initialValue: '# Swipe preview',
        onTabChanged: (tab) => selectedTab = tab,
      ),
      bounded: true,
    ));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(TabBarView), const Offset(-700, 0));
    await tester.pumpAndSettle();
    expect(selectedTab, DmMarkdownTab.preview);
    expect(find.text('Swipe preview', findRichText: true), findsOneWidget);
    await tester.drag(find.byType(TabBarView), const Offset(700, 0));
    await tester.pumpAndSettle();
    expect(selectedTab, DmMarkdownTab.write);
    expect(
        tester.widget<EditableText>(find.byType(EditableText)).expands, isTrue);
    expect(tester.takeException(), isNull);
  });

  for (final readOnly in [false, true]) {
    testWidgets('unbounded initial preview supports readOnly=$readOnly',
        (tester) async {
      await tester.pumpWidget(_wrap(
        DmMarkdownInput(
          initialValue: '# Initial preview',
          initialTab: DmMarkdownTab.preview,
          readOnly: readOnly,
          bottom: const Text('Preview bar'),
        ),
        bounded: false,
      ));
      await tester.pumpAndSettle();
      expect(find.text('Initial preview', findRichText: true), findsOneWidget);
      expect(find.text('Preview bar'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
