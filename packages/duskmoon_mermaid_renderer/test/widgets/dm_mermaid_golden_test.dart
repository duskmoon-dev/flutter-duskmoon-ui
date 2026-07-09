import 'package:duskmoon_mermaid_renderer/duskmoon_mermaid_renderer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DmMermaidView goldens', () {
    testWidgets('basic flowchart', (tester) async {
      await _pumpGolden(
        tester,
        source: 'flowchart LR\nA[Start] --> B[End]',
      );

      await expectLater(
        find.byKey(_goldenKey),
        matchesGoldenFile('../goldens/basic_flowchart.png'),
      );
    });

    testWidgets('labeled edge', (tester) async {
      await _pumpGolden(
        tester,
        source: 'flowchart TD\nA[Start] -->|continue| B[End]',
      );

      await expectLater(
        find.byKey(_goldenKey),
        matchesGoldenFile('../goldens/labeled_edge.png'),
      );
    });

    testWidgets('common node shapes', (tester) async {
      await _pumpGolden(
        tester,
        source: r'''
flowchart LR
  A[Rect] --> B(Round)
  B --> C((Circle))
  C --> D{Diamond}
  D --> E[[Sub]]
  E --> F[(Data)]
  F --> G{{Hex}}
  G --> H([Stadium])
''',
      );

      await expectLater(
        find.byKey(_goldenKey),
        matchesGoldenFile('../goldens/common_node_shapes.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await _pumpGolden(
        tester,
        source: 'flowchart LR\nA[Start] --> B{Decision}',
        options: const MermaidRenderOptions(theme: MermaidTheme.dark),
        background: const Color(0xFF0F172A),
      );

      await expectLater(
        find.byKey(_goldenKey),
        matchesGoldenFile('../goldens/dark_theme.png'),
      );
    });

    testWidgets('error scene', (tester) async {
      await _pumpGolden(
        tester,
        source: 'unsupportedDiagram\nclass User',
      );

      await expectLater(
        find.byKey(_goldenKey),
        matchesGoldenFile('../goldens/error_scene.png'),
      );
    });
  });
}

const _goldenKey = ValueKey('dm-mermaid-golden');

Future<void> _pumpGolden(
  WidgetTester tester, {
  required String source,
  MermaidRenderOptions options = const MermaidRenderOptions(),
  Color background = Colors.white,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        backgroundColor: background,
        body: Center(
          child: RepaintBoundary(
            key: _goldenKey,
            child: SizedBox(
              width: 420,
              height: 220,
              child: Center(
                child: DmMermaidView(
                  source: source,
                  options: options,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
