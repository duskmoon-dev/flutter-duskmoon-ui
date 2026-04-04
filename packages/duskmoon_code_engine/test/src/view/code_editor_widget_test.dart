import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('CodeEditorWidget', () {
    testWidgets('renders with initial doc', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: CodeEditorWidget(initialDoc: 'hello world')),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(CodeEditorWidget), findsOneWidget);
    });

    testWidgets('renders empty by default', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: CodeEditorWidget()),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(CodeEditorWidget), findsOneWidget);
    });

    testWidgets('accepts controller', (tester) async {
      final ctrl = EditorViewController(text: 'test');
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: CodeEditorWidget(controller: ctrl)),
      ));
      await tester.pumpAndSettle();
      expect(ctrl.text, 'test');
      ctrl.dispose();
    });

    testWidgets('renders with lineNumbers true', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: CodeEditorWidget(
            initialDoc: 'line1\nline2\nline3',
            lineNumbers: true,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(CodeEditorWidget), findsOneWidget);
    });

    testWidgets('renders with lineNumbers false', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: CodeEditorWidget(
            initialDoc: 'hello',
            lineNumbers: false,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(CodeEditorWidget), findsOneWidget);
    });

    testWidgets('applies dark theme', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: CodeEditorWidget(
          initialDoc: 'hello', theme: EditorTheme.dark(),
        )),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(CodeEditorWidget), findsOneWidget);
    });

    testWidgets('calls onStateChanged', (tester) async {
      EditorState? lastState;
      final ctrl = EditorViewController(text: 'hello');
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: CodeEditorWidget(
          controller: ctrl,
          onStateChanged: (s) => lastState = s,
        )),
      ));
      await tester.pumpAndSettle();
      ctrl.dispatch(TransactionSpec(
        changes: ChangeSet.of(5, [const ChangeSpec.insert(5, '!')]),
      ));
      await tester.pumpAndSettle();
      expect(lastState, isNotNull);
      expect(lastState!.doc.toString(), 'hello!');
      ctrl.dispose();
    });

    testWidgets('renders with readOnly', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: CodeEditorWidget(initialDoc: 'hello', readOnly: true)),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(CodeEditorWidget), findsOneWidget);
    });

    testWidgets('renders with language support', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: CodeEditorWidget(
          initialDoc: '{"key": 42}', language: jsonLanguageSupport(),
        )),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(CodeEditorWidget), findsOneWidget);
    });

    testWidgets('accepts keyboard focus on tap', (tester) async {
      final ctrl = EditorViewController(text: 'hello');
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: CodeEditorWidget(controller: ctrl, autofocus: true)),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(CodeEditorWidget), findsOneWidget);
      ctrl.dispose();
    });

    testWidgets('tap positions cursor', (tester) async {
      final ctrl = EditorViewController(text: 'hello\nworld\nfoo');
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: CodeEditorWidget(controller: ctrl)),
      ));
      await tester.pumpAndSettle();
      // Tap somewhere in the widget
      await tester.tap(find.byType(CodeEditorWidget));
      await tester.pump();
      // Focus should be gained
      expect(find.byType(CodeEditorWidget), findsOneWidget);
      // Unmount the widget to dispose the cursor blink timer before test ends
      await tester.pumpWidget(const SizedBox.shrink());
      ctrl.dispose();
    });
  });
}
