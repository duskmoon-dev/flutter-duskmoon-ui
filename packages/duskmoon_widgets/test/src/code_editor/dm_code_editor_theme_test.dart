import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DmCodeEditorTheme.fromContext', () {
    testWidgets('light theme: background = colorScheme.surface', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: DmThemeData.sunshine(),
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final cs = DmThemeData.sunshine().colorScheme;
      expect(result.background, cs.surface);
    });

    testWidgets('light theme: foreground = colorScheme.onSurface', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: DmThemeData.sunshine(),
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final cs = DmThemeData.sunshine().colorScheme;
      expect(result.foreground, cs.onSurface);
    });

    testWidgets('light theme: cursorColor = colorScheme.primary', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: DmThemeData.sunshine(),
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final cs = DmThemeData.sunshine().colorScheme;
      expect(result.cursorColor, cs.primary);
    });

    testWidgets('light theme: gutterBackground = DmColorExtension.base200', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: DmThemeData.sunshine(),
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final ext = DmColorExtension.sunshine();
      expect(result.gutterBackground, ext.base200);
    });

    testWidgets('dark theme: background = colorScheme.surface', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: DmThemeData.moonlight(),
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final cs = DmThemeData.moonlight().colorScheme;
      expect(result.background, cs.surface);
    });

    testWidgets('dark theme: cursorColor = colorScheme.primary', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: DmThemeData.moonlight(),
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final cs = DmThemeData.moonlight().colorScheme;
      expect(result.cursorColor, cs.primary);
    });

    testWidgets('falls back to EditorTheme.light() when DmColorExtension absent', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData.light(), // No DmColorExtension
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final fallback = EditorTheme.light();
      expect(result.background, fallback.background);
      expect(result.foreground, fallback.foreground);
    });

    testWidgets('falls back to EditorTheme.dark() when DmColorExtension absent and dark brightness', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData.dark(), // No DmColorExtension, dark brightness
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final fallback = EditorTheme.dark();
      expect(result.background, fallback.background);
      expect(result.foreground, fallback.foreground);
    });
  });
}
