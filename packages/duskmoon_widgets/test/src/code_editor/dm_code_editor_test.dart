import 'package:duskmoon_code_engine/duskmoon_code_engine.dart'
    show CodeEditorWidget;
import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {ThemeData? theme}) {
  return MaterialApp(
    theme: theme ?? DmThemeData.sunshine(),
    // Zero-duration theme animation so pumpWidget + pump() settles immediately
    // in tests without needing pumpAndSettle().
    themeAnimationDuration: Duration.zero,
    home: Scaffold(body: child),
  );
}

void main() {
  group('DmCodeEditor', () {
    testWidgets('renders without controller', (tester) async {
      await tester.pumpWidget(_wrap(
        const DmCodeEditor(initialDoc: 'hello'),
      ));
      await tester.pump();
      expect(find.byType(DmCodeEditor), findsOneWidget);
      expect(find.byType(CodeEditorWidget), findsOneWidget);
    });

    testWidgets('renders with external controller', (tester) async {
      final controller = EditorViewController(text: 'world');
      addTearDown(controller.dispose);
      await tester.pumpWidget(_wrap(
        DmCodeEditor(controller: controller),
      ));
      await tester.pump();
      expect(find.byType(DmCodeEditor), findsOneWidget);
    });

    testWidgets('external controller is NOT disposed on widget removal',
        (tester) async {
      final controller = EditorViewController(text: 'world');
      await tester.pumpWidget(_wrap(DmCodeEditor(controller: controller)));
      await tester.pump();
      await tester.pumpWidget(const SizedBox.shrink());
      // If controller was improperly disposed, accessing .text would throw
      expect(() => controller.text, returnsNormally);
      controller.dispose();
    });

    testWidgets(
        'onChanged fires with current text when content changes via controller',
        (tester) async {
      final controller = EditorViewController(text: '');
      addTearDown(controller.dispose);
      String? lastChanged;
      await tester.pumpWidget(_wrap(
        DmCodeEditor(
          controller: controller,
          onChanged: (t) => lastChanged = t,
        ),
      ));
      await tester.pump();
      controller.insertText('hello');
      await tester.pump();
      expect(lastChanged, 'hello');
    });

    testWidgets('onStateChanged fires when content changes via controller',
        (tester) async {
      final controller = EditorViewController(text: '');
      addTearDown(controller.dispose);
      EditorState? lastState;
      await tester.pumpWidget(_wrap(
        DmCodeEditor(
          controller: controller,
          onStateChanged: (s) => lastState = s,
        ),
      ));
      await tester.pump();
      controller.insertText('dart');
      await tester.pump();
      expect(lastState, isNotNull);
      expect(lastState!.doc.toString(), 'dart');
    });

    testWidgets('known language "dart" resolves without error', (tester) async {
      await tester.pumpWidget(_wrap(
        const DmCodeEditor(
          language: 'dart',
          initialDoc: 'void main() {}',
        ),
      ));
      await tester.pump();
      expect(find.byType(DmCodeEditor), findsOneWidget);
    });

    testWidgets('unknown language resolves to null without error',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const DmCodeEditor(
          language: 'brainfuck',
          initialDoc: '+++.',
        ),
      ));
      await tester.pump();
      expect(find.byType(DmCodeEditor), findsOneWidget);
    });

    testWidgets('explicit theme override bypasses DmCodeEditorTheme',
        (tester) async {
      final customTheme = EditorTheme.dark();
      final controller = EditorViewController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(_wrap(
        DmCodeEditor(
          controller: controller,
          theme: customTheme,
        ),
        theme: DmThemeData.sunshine(), // light app theme
      ));
      await tester.pump();
      // Controller should have the custom dark theme applied
      expect(controller.theme, customTheme);
    });

    testWidgets('theme updates when ThemeData changes in widget tree',
        (tester) async {
      final controller = EditorViewController();
      addTearDown(controller.dispose);

      // Start with light theme
      await tester.pumpWidget(_wrap(
        DmCodeEditor(controller: controller),
        theme: DmThemeData.sunshine(),
      ));
      await tester.pump();
      final lightBackground = controller.theme?.background;

      // Switch to dark theme
      await tester.pumpWidget(_wrap(
        DmCodeEditor(controller: controller),
        theme: DmThemeData.moonlight(),
      ));
      await tester.pump();
      final darkBackground = controller.theme?.background;

      expect(lightBackground, isNotNull);
      expect(darkBackground, isNotNull);
      expect(lightBackground, isNot(equals(darkBackground)));
    });

    testWidgets(
        'swapping external controllerA → controllerB: A not disposed, B receives theme',
        (tester) async {
      final controllerA = EditorViewController(text: 'A');
      final controllerB = EditorViewController(text: 'B');

      await tester.pumpWidget(_wrap(
        DmCodeEditor(controller: controllerA),
        theme: DmThemeData.sunshine(),
      ));
      await tester.pump();

      // Swap to controllerB
      await tester.pumpWidget(_wrap(
        DmCodeEditor(controller: controllerB),
        theme: DmThemeData.sunshine(),
      ));
      await tester.pump();

      // controllerA must not have been disposed (text still accessible)
      expect(() => controllerA.text, returnsNormally);
      // controllerB should have received the theme
      expect(controllerB.theme, isNotNull);

      controllerA.dispose();
      controllerB.dispose();
    });
  });
}
