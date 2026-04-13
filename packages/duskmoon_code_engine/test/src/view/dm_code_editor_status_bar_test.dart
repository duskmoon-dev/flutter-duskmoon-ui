import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('DmCodeEditorStatusBar', () {
    late EditorViewController controller;

    setUp(() {
      controller = EditorViewController(text: 'hello\nworld\nfoo');
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('renders cursor position', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorStatusBar(controller: controller),
        ),
      ));
      expect(find.textContaining('Ln 1'), findsOneWidget);
      expect(find.textContaining('Col 1'), findsOneWidget);
    });

    testWidgets('renders line count', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorStatusBar(controller: controller),
        ),
      ));
      expect(find.textContaining('3 lines'), findsOneWidget);
    });

    testWidgets('renders language name when provided', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorStatusBar(
            controller: controller,
            languageName: 'Dart',
          ),
        ),
      ));
      expect(find.text('Dart'), findsOneWidget);
    });

    testWidgets('omits language name when null', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorStatusBar(controller: controller),
        ),
      ));
      expect(find.text('Dart'), findsNothing);
    });

    testWidgets('updates cursor position reactively', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorStatusBar(controller: controller),
        ),
      ));
      expect(find.textContaining('Ln 1'), findsOneWidget);

      // Move cursor to line 2, col 3 (offset = 6 + 2 = 8)
      controller.setSelection(EditorSelection.cursor(8));
      await tester.pumpAndSettle();

      expect(find.textContaining('Ln 2'), findsOneWidget);
      expect(find.textContaining('Col 3'), findsOneWidget);
    });

    testWidgets('shows selection count when selection is non-empty', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorStatusBar(controller: controller),
        ),
      ));
      expect(find.textContaining('selected'), findsNothing);

      controller.setSelection(EditorSelection.range(anchor: 0, head: 5));
      await tester.pumpAndSettle();

      expect(find.textContaining('5 selected'), findsOneWidget);
    });

    testWidgets('hides selection count when selection is empty', (tester) async {
      controller.setSelection(EditorSelection.range(anchor: 0, head: 5));

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorStatusBar(controller: controller),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.textContaining('5 selected'), findsOneWidget);

      controller.setSelection(EditorSelection.cursor(0));
      await tester.pumpAndSettle();
      expect(find.textContaining('selected'), findsNothing);
    });

    testWidgets('applies custom decoration', (tester) async {
      const decoration = BoxDecoration(color: Colors.green);
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorStatusBar(
            controller: controller,
            decoration: decoration,
          ),
        ),
      ));
      final container = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(DmCodeEditorStatusBar),
          matching: find.byType(DecoratedBox),
        ),
      );
      expect(container.decoration, decoration);
    });
  });
}
