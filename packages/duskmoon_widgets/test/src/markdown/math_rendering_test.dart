import 'dart:convert';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:duskmoon_widgets/src/markdown/_math_widget.dart';
import 'package:duskmoon_widgets/src/vendor/flutter_math/flutter_math.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late List<Map<String, dynamic>> fonts;

  setUpAll(() async {
    final manifest =
        jsonDecode(await rootBundle.loadString('FontManifest.json'))
            as List<dynamic>;
    fonts = manifest.cast<Map<String, dynamic>>().where((entry) {
      return (entry['family'] as String).contains('KaTeX_');
    }).toList();
    for (final entry in fonts) {
      final family = entry['family'] as String;
      final loader = FontLoader(family.startsWith('packages/')
          ? family
          : 'packages/duskmoon_widgets/$family');
      for (final font in entry['fonts'] as List<dynamic>) {
        loader.addFont(rootBundle.load(font['asset'] as String));
      }
      await loader.load();
    }
  });

  test('all KaTeX font families and files are present in the asset bundle',
      () async {
    expect(fonts, hasLength(12));
    final assets = fonts.expand((entry) => entry['fonts'] as List<dynamic>);
    expect(assets, hasLength(20));
    for (final font in assets) {
      final asset = font['asset'] as String;
      final data = await rootBundle.load(asset);
      expect(data.lengthInBytes, greaterThan(1000), reason: asset);
      expect(data.getUint32(0), 0x00010000, reason: asset);
    }
  });

  testWidgets('Markdown renders inline and display math with the owned engine',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: DmMarkdown(
          data: r'''Before $x^2$ after.

$$
\frac{a}{b}
$$
''',
          selectable: false,
          shrinkWrap: true,
        ),
      ),
    ));
    await tester.pumpAndSettle();

    final math = tester.widgetList<Math>(find.byType(Math)).toList();
    expect(math, hasLength(2));
    expect(math.map((widget) => widget.mathStyle),
        [MathStyle.text, MathStyle.display]);
    expect(math.every((widget) => widget.parseError == null), isTrue);
    expect(find.byType(Tooltip), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('invalid TeX keeps the raw expression and themed error fallback',
      (tester) async {
    const invalid = r'\notARealCommand{';
    final colors = ColorScheme.fromSeed(seedColor: Colors.purple);
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(colorScheme: colors),
      home: const Scaffold(body: MathWidget(tex: invalid)),
    ));
    await tester.pumpAndSettle();

    final fallback = tester.widget<Text>(find.text(invalid));
    expect(fallback.style?.color, colors.onErrorContainer);
    expect(fallback.style?.fontFamily, 'monospace');
    expect(tester.widget<Tooltip>(find.byType(Tooltip)).message, isNotEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('math uses the theme, bundled font family and text scaler',
      (tester) async {
    final colors = ColorScheme.fromSeed(seedColor: Colors.teal);
    Future<void> render(double scale) async {
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(colorScheme: colors),
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(scale)),
          child: const Scaffold(body: MathWidget(tex: 'x')),
        ),
      ));
      await tester.pumpAndSettle();
    }

    TextStyle symbolStyle() {
      return tester
          .widgetList<RichText>(find.byType(RichText))
          .map((widget) => widget.text.style)
          .whereType<TextStyle>()
          .firstWhere((style) =>
              style.fontFamily == 'packages/duskmoon_widgets/KaTeX_Math');
    }

    await render(1);
    final normal = symbolStyle();
    expect(normal.color, colors.onSurface);
    await render(2);
    expect(symbolStyle().fontSize, normal.fontSize! * 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('wide display expressions scroll within their available width',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 120,
          child: MathWidget(
            tex: List.filled(40, 'x').join('+'),
            displayMode: true,
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    final scroll = tester
        .widget<SingleChildScrollView>(find.byType(SingleChildScrollView));
    expect(scroll.scrollDirection, Axis.horizontal);
    expect(
        tester
            .state<ScrollableState>(find.byType(Scrollable))
            .position
            .maxScrollExtent,
        greaterThan(0));
    expect(tester.takeException(), isNull);
  });
}
