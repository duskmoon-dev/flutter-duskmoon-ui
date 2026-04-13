import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('DmCodeEditorToolbar', () {
    late EditorViewController controller;

    setUp(() {
      controller = EditorViewController(text: 'hello');
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('renders title text', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorToolbar(
            title: 'main.dart',
            controller: controller,
          ),
        ),
      ));
      expect(find.text('main.dart'), findsOneWidget);
    });

    testWidgets('renders without title', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorToolbar(controller: controller),
        ),
      ));
      expect(find.byType(DmCodeEditorToolbar), findsOneWidget);
    });

    testWidgets('renders action buttons', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorToolbar(
            controller: controller,
            actions: [
              DmEditorAction(
                icon: Icons.undo,
                tooltip: 'Undo',
                onPressed: () {},
              ),
              DmEditorAction(
                icon: Icons.redo,
                tooltip: 'Redo',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ));
      expect(find.byIcon(Icons.undo), findsOneWidget);
      expect(find.byIcon(Icons.redo), findsOneWidget);
    });

    testWidgets('action button fires onPressed callback', (tester) async {
      var pressed = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorToolbar(
            controller: controller,
            actions: [
              DmEditorAction(
                icon: Icons.play_arrow,
                tooltip: 'Run',
                onPressed: () => pressed = true,
              ),
            ],
          ),
        ),
      ));
      await tester.tap(find.byIcon(Icons.play_arrow));
      expect(pressed, isTrue);
    });

    testWidgets('disabled action button does not respond to tap',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorToolbar(
            controller: controller,
            actions: const [
              DmEditorAction(
                icon: Icons.undo,
                tooltip: 'Undo',
              ),
            ],
          ),
        ),
      ));
      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconButton.onPressed, isNull);
    });

    testWidgets('applies custom decoration', (tester) async {
      final decoration = BoxDecoration(
        color: Colors.red,
        border: Border.all(color: Colors.blue),
      );
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditorToolbar(
            controller: controller,
            decoration: decoration,
          ),
        ),
      ));
      final container = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(DmCodeEditorToolbar),
          matching: find.byType(DecoratedBox),
        ),
      );
      expect(container.decoration, decoration);
    });
  });
}
