import 'package:duskmoon_mermaid_renderer/duskmoon_mermaid_renderer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('buildMermaidScene creates nodes, edges, and labels', () {
    final output = parseMermaid('''
flowchart TD
  A[Start] -->|go| B[End]
''');
    final layout = computeMermaidLayout(
      output.graph,
      const MermaidLayoutConfig(),
      const HeuristicTextMeasurer(),
    );

    final scene = buildMermaidScene(layout, MermaidTheme.modern);

    expect(scene.nodes, hasLength(2));
    expect(scene.edges, hasLength(1));
    expect(scene.labels.map((label) => label.text), contains('go'));
  });
}
