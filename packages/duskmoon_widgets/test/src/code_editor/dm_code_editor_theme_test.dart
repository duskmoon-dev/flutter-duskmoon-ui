import 'package:duskmoon_code_engine/duskmoon_code_engine.dart'
    show defaultDarkHighlight, defaultLightHighlight;
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

    testWidgets('light theme: highlightStyle = defaultLightHighlight', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: DmThemeData.sunshine(),
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      expect(result.highlightStyle, defaultLightHighlight);
    });

    testWidgets('light theme: gutterForeground = ext.baseContent with 0.5 alpha', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: DmThemeData.sunshine(),
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final ext = DmColorExtension.sunshine();
      expect(result.gutterForeground, ext.baseContent.withValues(alpha: 0.5));
    });

    testWidgets('light theme: gutterActiveForeground = ext.baseContent', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: DmThemeData.sunshine(),
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final ext = DmColorExtension.sunshine();
      expect(result.gutterActiveForeground, ext.baseContent);
    });

    testWidgets('light theme: selectionBackground = colorScheme.primary with 0.2 alpha', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: DmThemeData.sunshine(),
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final cs = DmThemeData.sunshine().colorScheme;
      expect(result.selectionBackground, cs.primary.withValues(alpha: 0.2));
    });

    testWidgets('light theme: lineHighlight = ext.base200 with 0.5 alpha', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: DmThemeData.sunshine(),
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final ext = DmColorExtension.sunshine();
      expect(result.lineHighlight, ext.base200.withValues(alpha: 0.5));
    });

    testWidgets('light theme: searchMatchBackground = ext.warning with 0.3 alpha', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: DmThemeData.sunshine(),
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final ext = DmColorExtension.sunshine();
      expect(result.searchMatchBackground, ext.warning.withValues(alpha: 0.3));
    });

    testWidgets('light theme: searchActiveMatchBackground = ext.warning with 0.6 alpha', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: DmThemeData.sunshine(),
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final ext = DmColorExtension.sunshine();
      expect(result.searchActiveMatchBackground, ext.warning.withValues(alpha: 0.6));
    });

    testWidgets('light theme: matchingBracketBackground = ext.accent with 0.2 alpha', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: DmThemeData.sunshine(),
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final ext = DmColorExtension.sunshine();
      expect(result.matchingBracketBackground, ext.accent.withValues(alpha: 0.2));
    });

    testWidgets('light theme: matchingBracketOutline = ext.accent', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: DmThemeData.sunshine(),
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final ext = DmColorExtension.sunshine();
      expect(result.matchingBracketOutline, ext.accent);
    });

    testWidgets('light theme: scrollbarThumb = colorScheme.onSurface with 0.3 alpha', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: DmThemeData.sunshine(),
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      final cs = DmThemeData.sunshine().colorScheme;
      expect(result.scrollbarThumb, cs.onSurface.withValues(alpha: 0.3));
    });

    testWidgets('light theme: scrollbarTrack = Colors.transparent', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: DmThemeData.sunshine(),
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      expect(result.scrollbarTrack, Colors.transparent);
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

    testWidgets('dark theme: highlightStyle = defaultDarkHighlight', (tester) async {
      late EditorTheme result;
      await tester.pumpWidget(MaterialApp(
        theme: DmThemeData.moonlight(),
        home: Builder(builder: (context) {
          result = DmCodeEditorTheme.fromContext(context);
          return const SizedBox.shrink();
        }),
      ));
      expect(result.highlightStyle, defaultDarkHighlight);
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
