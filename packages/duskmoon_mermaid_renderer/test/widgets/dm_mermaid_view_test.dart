import 'package:duskmoon_mermaid_renderer/duskmoon_mermaid_renderer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DmMermaidView paints a flowchart', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DmMermaidView(
            source: 'flowchart TD\nA[Start] --> B{Decision}',
          ),
        ),
      ),
    );

    expect(find.byType(DmMermaidView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
