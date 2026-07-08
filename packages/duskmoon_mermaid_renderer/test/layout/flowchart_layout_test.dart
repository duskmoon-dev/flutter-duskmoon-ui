import 'package:duskmoon_mermaid_renderer/duskmoon_mermaid_renderer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('computeMermaidLayout places basic flowchart nodes', () {
    final output = parseMermaid('''
flowchart LR
  A[Start] --> B[End]
''');

    final layout = computeMermaidLayout(
      output.graph,
      const MermaidLayoutConfig(),
      const HeuristicTextMeasurer(),
    );

    expect(layout.width, greaterThan(0));
    expect(layout.height, greaterThan(0));
    expect(
        layout.nodes['A']!.rect.left, lessThan(layout.nodes['B']!.rect.left));
    expect(layout.edges.single.points.length, greaterThanOrEqualTo(2));
  });
}
