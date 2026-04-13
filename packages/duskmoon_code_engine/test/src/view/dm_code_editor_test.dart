import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('DmCodeEditor', () {
    testWidgets('renders with default bars', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: DmCodeEditor(initialDoc: 'hello'),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(DmCodeEditor), findsOneWidget);
      expect(find.byType(CodeEditorWidget), findsOneWidget);
      expect(find.byType(DmCodeEditorToolbar), findsOneWidget);
      expect(find.byType(DmCodeEditorStatusBar), findsOneWidget);
    });

    testWidgets('renders title in default toolbar', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: DmCodeEditor(
            initialDoc: 'hello',
            title: 'main.dart',
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('main.dart'), findsOneWidget);
    });

    testWidgets('renders custom actions in default toolbar', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditor(
            initialDoc: 'hello',
            actions: [
              DmEditorAction(
                icon: Icons.play_arrow,
                tooltip: 'Run',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('custom topBar replaces default toolbar', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: DmCodeEditor(
            initialDoc: 'hello',
            topBar: Text('Custom Top'),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Custom Top'), findsOneWidget);
      expect(find.byType(DmCodeEditorToolbar), findsNothing);
    });

    testWidgets('custom bottomBar replaces default status bar', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: DmCodeEditor(
            initialDoc: 'hello',
            bottomBar: Text('Custom Bottom'),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Custom Bottom'), findsOneWidget);
      expect(find.byType(DmCodeEditorStatusBar), findsNothing);
    });

    testWidgets('SizedBox.shrink hides top bar', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: DmCodeEditor(
            initialDoc: 'hello',
            topBar: SizedBox.shrink(),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(DmCodeEditorToolbar), findsNothing);
    });

    testWidgets('SizedBox.shrink hides bottom bar', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: DmCodeEditor(
            initialDoc: 'hello',
            bottomBar: SizedBox.shrink(),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(DmCodeEditorStatusBar), findsNothing);
    });

    testWidgets('title is ignored when custom topBar is provided', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: DmCodeEditor(
            initialDoc: 'hello',
            title: 'should-not-appear',
            topBar: Text('Custom'),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('should-not-appear'), findsNothing);
      expect(find.text('Custom'), findsOneWidget);
    });

    testWidgets('accepts external controller', (tester) async {
      final ctrl = EditorViewController(text: 'test');
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditor(controller: ctrl),
        ),
      ));
      await tester.pumpAndSettle();
      expect(ctrl.text, 'test');
      ctrl.dispose();
    });

    testWidgets('passes through readOnly to CodeEditorWidget', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: DmCodeEditor(
            initialDoc: 'hello',
            readOnly: true,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      final inner = tester.widget<CodeEditorWidget>(
        find.byType(CodeEditorWidget),
      );
      expect(inner.readOnly, isTrue);
    });

    testWidgets('passes through language name to default status bar', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DmCodeEditor(
            initialDoc: '{"a":1}',
            language: jsonLanguageSupport(),
            languageName: 'JSON',
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('JSON'), findsOneWidget);
    });
  });
}
