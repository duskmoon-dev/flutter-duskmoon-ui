import 'package:duskmoon_code_engine/duskmoon_code_engine.dart'
    show CodeEditorWidget, syntaxTree;
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
    testWidgets('focused readOnly transition blocks IME and resumes editing',
        (tester) async {
      final controller = EditorViewController(text: 'original');
      final focus = FocusNode();
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox.shrink());
        focus.dispose();
        controller.dispose();
      });
      Future<void> show(bool readOnly) async {
        await tester.pumpWidget(_wrap(DmCodeEditor(
          controller: controller,
          focusNode: focus,
          readOnly: readOnly,
        )));
        await tester.pump();
      }

      await show(false);
      focus.requestFocus();
      await tester.pump();
      expect(tester.testTextInput.hasAnyClients, isTrue);
      await show(true);
      tester.testTextInput.updateEditingValue(const TextEditingValue(
        text: 'injected',
        selection: TextSelection.collapsed(offset: 8),
        composing: TextRange(start: 0, end: 8),
      ));
      await tester.pump();
      expect(controller.text, 'original');
      expect(focus.hasFocus, isTrue);
      expect(tester.testTextInput.hasAnyClients, isFalse);
      controller.text = 'save snapshot';
      await show(false);
      expect(tester.testTextInput.editingState!['text'], 'save snapshot');
      tester.testTextInput.enterText('save snapshot\nmobile edit');
      await tester.pump();
      expect(controller.text, 'save snapshot\nmobile edit');
    });

    testWidgets('editable touch and focused retap show the soft keyboard',
        (tester) async {
      final controller = EditorViewController(text: 'hello\n');
      final focus = FocusNode();
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox.shrink());
        focus.dispose();
        controller.dispose();
      });
      await tester.pumpWidget(_wrap(DmCodeEditor(
        controller: controller,
        focusNode: focus,
      )));
      final point = tester.getTopLeft(find.byType(CodeEditorWidget)) +
          const Offset(120, 10);
      await tester.tapAt(point);
      await tester.pump();
      expect(tester.testTextInput.isVisible, isTrue);
      tester.testTextInput.hide();
      expect(focus.hasFocus, isTrue);
      await tester.tapAt(point);
      await tester.pump();
      expect(tester.testTextInput.isVisible, isTrue);
      tester.testTextInput.enterText('hello\nmobile');
      await tester.pump();
      expect(controller.text, 'hello\nmobile');
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

    testWidgets('readOnly touch never opens a software keyboard',
        (tester) async {
      final controller = EditorViewController(text: 'original');
      final focus = FocusNode();
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox.shrink());
        focus.dispose();
        controller.dispose();
      });
      await tester.pumpWidget(_wrap(DmCodeEditor(
        controller: controller,
        focusNode: focus,
        readOnly: true,
      )));
      await tester.tapAt(tester.getTopLeft(find.byType(CodeEditorWidget)) +
          const Offset(120, 10));
      await tester.pump();
      expect(focus.hasFocus, isTrue);
      expect(tester.testTextInput.hasAnyClients, isFalse);
      expect(tester.testTextInput.isVisible, isFalse);
      expect(controller.text, 'original');
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

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

    testWidgets('switches TypeScript, TSX and C++ without losing editor state',
        (tester) async {
      final controller = EditorViewController(text: 'const value = 1;');
      addTearDown(controller.dispose);
      final view = controller.view;
      Future<void> showLanguage(String name) async {
        await tester.pumpWidget(_wrap(DmCodeEditor(
            key: const ValueKey('editor'),
            controller: controller,
            language: name)));
        await tester.pump();
        await controller.ready;
        await tester.pump();
      }

      await showLanguage('ts');
      expect(syntaxTree(controller.state)!.language, 'typescript');
      controller.text = 'const element = <div />;';
      await showLanguage('tsx');
      expect(syntaxTree(controller.state)!.language, 'tsx');
      expect(syntaxTree(controller.state)!.rootNode.hasError, isFalse);
      await showLanguage('c++');
      expect(syntaxTree(controller.state)!.language, 'cpp');
      expect(controller.view, same(view));
      expect(controller.text, 'const element = <div />;');
    });

    testWidgets('unknown language resolves to null without error',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const DmCodeEditor(
          language: 'not-a-language',
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
