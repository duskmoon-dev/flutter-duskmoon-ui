import 'package:duskmoon_widgets/src/markdown/_code_block_widget.dart';
import 'package:duskmoon_widgets/src/markdown/dm_markdown.dart';
import 'package:duskmoon_widgets/src/markdown/dm_markdown_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app({
  required String code,
  String? language,
  Brightness brightness = Brightness.light,
}) {
  return MaterialApp(
    theme: ThemeData(brightness: brightness),
    home: Scaffold(
      body: CodeBlockWidget(code: code, language: language),
    ),
  );
}

RichText _codeText(WidgetTester tester, String code) {
  return tester
      .widgetList<RichText>(find.descendant(
        of: find.byType(CodeBlockWidget),
        matching: find.byType(RichText),
      ))
      .singleWhere((widget) => widget.text.toPlainText() == code);
}

Iterable<({String text, TextStyle style})> _runs(
  InlineSpan span, [
  TextStyle inherited = const TextStyle(),
]) sync* {
  final style = inherited.merge(span.style);
  if (span is TextSpan) {
    if (span.text case final text?) {
      yield (text: text, style: style);
    }
    for (final child in span.children ?? <InlineSpan>[]) {
      yield* _runs(child, style);
    }
  }
}

Color? _tokenColor(RichText codeText, String token) {
  final source = codeText.text.toPlainText();
  final target = source.indexOf(token);
  expect(target, greaterThanOrEqualTo(0));
  var offset = 0;
  for (final run in _runs(codeText.text)) {
    offset += run.text.length;
    if (offset > target) return run.style.color;
  }
  fail('No text span contains $token');
}

void _expectHighlighted(WidgetTester tester, String code, String token) {
  final baseColor = Theme.of(
    tester.element(find.byType(CodeBlockWidget)),
  ).colorScheme.onSurface;
  expect(_tokenColor(_codeText(tester, code), token), isNotNull);
  expect(
    _tokenColor(_codeText(tester, code), token),
    isNot(baseColor),
    reason: '$token should have a syntax color',
  );
}

void main() {
  testWidgets('colors Dart keywords, strings, and comments', (tester) async {
    const code = 'final greeting = "hello"; // comment';
    await tester.pumpWidget(_app(code: code, language: 'dart'));

    for (final token in ['final', '"hello"', '// comment']) {
      _expectHighlighted(tester, code, token);
    }
  });

  const languages = {
    'bash': (code: 'if true; then echo "hello"; fi', token: 'if'),
    'sql': (code: 'SELECT name FROM users WHERE id = 1;', token: 'SELECT'),
    'nix': (code: 'let name = "world"; in name', token: 'let'),
    'js': (code: 'const greeting = "hello";', token: 'const'),
    'py': (code: 'def greet():\n    return "hello"', token: 'def'),
    'html': (code: '<div class="greeting">hello</div>', token: 'div'),
    'sh': (code: 'if true; then echo "hello"; fi', token: 'if'),
  };
  for (final entry in languages.entries) {
    testWidgets('highlights ${entry.key} code', (tester) async {
      await tester.pumpWidget(
        _app(code: entry.value.code, language: entry.key),
      );

      _expectHighlighted(tester, entry.value.code, entry.value.token);
    });
  }

  testWidgets('colors JavaScript class and function names', (tester) async {
    const code = 'class Greeter {}\nfunction greet() { return "hello"; }';
    await tester.pumpWidget(_app(code: code, language: 'javascript'));

    _expectHighlighted(tester, code, 'Greeter');
    _expectHighlighted(tester, code, 'greet');
  });

  testWidgets('retains tag color around nested HTML spans', (tester) async {
    const code = '<div class="greeting">hello</div>';
    await tester.pumpWidget(_app(code: code, language: 'html'));

    final text = _codeText(tester, code);
    _expectHighlighted(tester, code, '<');
    expect(_tokenColor(text, '<'), _tokenColor(text, 'div'));
  });

  testWidgets('preserves whitespace, entities, and Unicode verbatim',
      (tester) async {
    const code = '\tfinal message = "<tag>&amp; 中文 😀";\r\n// café & < >\n  ';
    await tester.pumpWidget(_app(code: code, language: 'dart'));

    expect(_codeText(tester, code).text.toPlainText(), code);
    _expectHighlighted(tester, code, 'final');
  });

  for (final language in <String?>[null, '', 'unknown-language']) {
    testWidgets('uses plain text for language $language', (tester) async {
      const code = 'final message = "<hello> & 😀";';
      await tester.pumpWidget(_app(code: code, language: language));

      final baseColor = Theme.of(
        tester.element(find.byType(CodeBlockWidget)),
      ).colorScheme.onSurface;
      expect(_codeText(tester, code).text.toPlainText(), code);
      expect(
        _runs(_codeText(tester, code).text).map((run) => run.style.color),
        everyElement(baseColor),
      );
    });
  }

  testWidgets('updates syntax colors when ambient brightness changes',
      (tester) async {
    const code = 'final greeting = "hello";';
    await tester.pumpWidget(_app(code: code, language: 'dart'));
    final lightColor = _tokenColor(_codeText(tester, code), 'final');

    await tester.pumpWidget(_app(
      code: code,
      language: 'dart',
      brightness: Brightness.dark,
    ));
    await tester.pumpAndSettle();

    _expectHighlighted(tester, code, 'final');
    expect(_tokenColor(_codeText(tester, code), 'final'), isNot(lightColor));
  });

  testWidgets('updates highlighting when code or language changes',
      (tester) async {
    const initialCode = 'final count = 1;';
    await tester.pumpWidget(_app(code: initialCode, language: 'dart'));
    _expectHighlighted(tester, initialCode, 'final');

    const updatedCode = 'SELECT name FROM users;';
    await tester.pumpWidget(_app(code: updatedCode, language: 'dart'));
    expect(_codeText(tester, updatedCode).text.toPlainText(), updatedCode);

    await tester.pumpWidget(_app(code: updatedCode, language: 'sql'));
    _expectHighlighted(tester, updatedCode, 'SELECT');

    await tester.pumpWidget(_app(code: updatedCode));
    final text = _codeText(tester, updatedCode);
    expect(_tokenColor(text, 'SELECT'), text.text.style!.color);
  });

  testWidgets('copies the raw source to the clipboard', (tester) async {
    const code = '\tfinal text = "<tag>&amp; 中文 😀";\n';
    String? copiedText;
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') {
        copiedText = (call.arguments as Map)['text'] as String;
      }
      return null;
    });
    addTearDown(() {
      messenger.setMockMethodCallHandler(SystemChannels.platform, null);
    });

    await tester.pumpWidget(_app(code: code, language: 'dart'));
    await tester.tap(find.byTooltip('Copy code'));
    await tester.pump();

    expect(copiedText, code);
    expect(find.byTooltip('Copied!'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    expect(find.byTooltip('Copy code'), findsOneWidget);
  });

  testWidgets('Markdown can disable fenced-code highlighting', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: DmMarkdown(
          data: '```dart\nfinal count = 1;\n```',
          config: DmMarkdownConfig(enableCodeHighlight: false),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('final count = 1;\n'), findsOneWidget);
    expect(find.byType(CodeBlockWidget), findsNothing);
  });
}
