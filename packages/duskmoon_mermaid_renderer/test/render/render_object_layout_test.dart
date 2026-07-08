import 'package:duskmoon_mermaid_renderer/duskmoon_mermaid_renderer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DmMermaidView creates a RenderDmMermaid with size',
      (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: DmMermaidView(
            source: 'flowchart LR\nA[Start] --> B[End]',
          ),
        ),
      ),
    );

    final renderObject =
        tester.renderObject<RenderDmMermaid>(find.byType(DmMermaidView));
    expect(renderObject.size.width, greaterThan(0));
    expect(renderObject.size.height, greaterThan(0));
  });

  testWidgets('DmMermaidView reports errors without throwing', (tester) async {
    MermaidError? error;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: DmMermaidView(
          source: 'sequenceDiagram\nA->>B: hello',
          onError: (value) => error = value,
        ),
      ),
    );

    expect(error, isA<UnsupportedDiagramError>());
    expect(tester.takeException(), isNull);
  });
}
