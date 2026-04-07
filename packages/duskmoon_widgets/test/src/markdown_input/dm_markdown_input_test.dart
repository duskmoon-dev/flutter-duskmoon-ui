import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';

void main() {
  group('DmMarkdownInput', () {
    Widget buildApp({
      DmMarkdownInputController? controller,
      String? initialValue,
      DmMarkdownTab initialTab = DmMarkdownTab.write,
      bool readOnly = false,
      bool enabled = true,
      bool showLineNumbers = false,
      ValueChanged<String>? onChanged,
      ValueChanged<DmMarkdownTab>? onTabChanged,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 600,
            child: DmMarkdownInput(
              controller: controller,
              initialValue: initialValue,
              initialTab: initialTab,
              readOnly: readOnly,
              enabled: enabled,
              showLineNumbers: showLineNumbers,
              onChanged: onChanged,
              onTabChanged: onTabChanged,
            ),
          ),
        ),
      );
    }

    testWidgets('renders with write and preview tabs', (tester) async {
      await tester.pumpWidget(buildApp(initialValue: 'Hello'));
      await tester.pumpAndSettle();

      expect(find.text('Write'), findsOneWidget);
      expect(find.text('Preview'), findsOneWidget);
    });

    testWidgets('shows initial value in editor', (tester) async {
      await tester.pumpWidget(buildApp(initialValue: 'Test content'));
      await tester.pumpAndSettle();

      expect(find.text('Test content'), findsOneWidget);
    });

    testWidgets('tab switching fires onTabChanged', (tester) async {
      DmMarkdownTab? lastTab;
      await tester.pumpWidget(buildApp(
        initialValue: 'Hello',
        onTabChanged: (tab) => lastTab = tab,
      ));
      await tester.pumpAndSettle();

      // Tap preview tab.
      await tester.tap(find.text('Preview'));
      await tester.pumpAndSettle();

      expect(lastTab, DmMarkdownTab.preview);
    });

    testWidgets('onChanged fires on text change', (tester) async {
      String? lastText;
      await tester.pumpWidget(buildApp(
        initialValue: '',
        onChanged: (text) => lastText = text,
      ));
      await tester.pumpAndSettle();

      // Type into editor.
      await tester.enterText(find.byType(EditableText), 'New content');
      await tester.pumpAndSettle();

      expect(lastText, 'New content');
    });

    testWidgets('readOnly mode starts on preview tab', (tester) async {
      await tester.pumpWidget(buildApp(
        initialValue: 'Read only',
        readOnly: true,
      ));
      await tester.pumpAndSettle();

      // Should show preview content.
      expect(find.text('Read only'), findsWidgets);
    });

    testWidgets('external controller works', (tester) async {
      final controller = DmMarkdownInputController(text: 'External');
      await tester.pumpWidget(buildApp(controller: controller));
      await tester.pumpAndSettle();

      expect(find.text('External'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('editor fills available height when line numbers are shown', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          initialValue: 'Line 1',
          showLineNumbers: true,
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester.widget<EditableText>(find.byType(EditableText)).expands,
        isTrue,
      );
      expect(
        tester
            .getSize(find.byKey(const ValueKey('dm-markdown-editor-surface')))
            .height,
        greaterThan(400),
      );
    });
  });
}
