import 'package:duskmoon_mermaid_renderer/duskmoon_mermaid_renderer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('HeuristicTextMeasurer treats CJK text as wider than ASCII', () {
    const measurer = HeuristicTextMeasurer();
    const style = MermaidTextStyle(fontSize: 16, lineHeight: 1.25);

    final ascii = measurer.measure('abc', style);
    final cjk = measurer.measure('你好你', style);

    expect(cjk.width, greaterThan(ascii.width));
  });
}
