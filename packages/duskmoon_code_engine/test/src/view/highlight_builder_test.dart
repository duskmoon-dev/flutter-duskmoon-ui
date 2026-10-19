import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter/painting.dart' hide InlineSpan;
import 'package:flutter_test/flutter_test.dart';

void main() {
  final style = HighlightStyle([
    TagStyle(Tag.keyword, const TextStyle(color: Color(0xFF0000FF))),
    TagStyle(Tag.function_, const TextStyle(color: Color(0xFFFF0000))),
    TagStyle(Tag.typeName, const TextStyle(color: Color(0xFF00FF00))),
  ]);
  SyntaxSnapshot snapshot(String source, List<SyntaxCapture> captures) =>
      SyntaxSnapshot(
          language: 'test',
          source: source,
          rootNode: SyntaxNode(
              type: 'document',
              from: 0,
              to: source.length,
              children: [],
              isNamed: true,
              hasError: false),
          captures: captures,
          incremental: false);

  test(
      'nested capture overlaps resolve deterministically and cover exact slice',
      () {
    const source = 'abcdefghij';
    final tree = snapshot(source, [
      const SyntaxCapture(name: 'keyword', from: 0, to: 9),
      const SyntaxCapture(name: 'function.method', from: 2, to: 7),
      const SyntaxCapture(name: 'type.builtin', from: 4, to: 6, priority: 10),
    ]);
    final spans = HighlightBuilder.buildSpans(
        tree: tree,
        source: source,
        highlightStyle: style,
        lineFrom: 1,
        lineTo: 10);
    expect(spans.map((s) => s.text).join(), source.substring(1));
    expect(spans.map((s) => s.from), [1, 2, 4, 6, 7, 9]);
    expect(spans.map((s) => s.to), [2, 4, 6, 7, 9, 10]);
    expect(spans[0].style?.color, const Color(0xFF0000FF));
    expect(spans[1].style?.color, const Color(0xFFFF0000));
    expect(spans[2].style?.color, const Color(0xFF00FF00));
    expect(spans.last.style, isNull);
  });

  test('exact dotted capture theme overrides hierarchical fallback', () {
    const source = 'foo';
    final exact = HighlightStyle([
      TagStyle(Tag.function_, const TextStyle(color: Color(0xFFFF0000))),
      TagStyle(Tag.capture('function.method'),
          const TextStyle(color: Color(0xFF123456))),
    ]);
    final spans = HighlightBuilder.buildSpans(
        tree: snapshot(source,
            [const SyntaxCapture(name: 'function.method', from: 0, to: 3)]),
        source: source,
        highlightStyle: exact,
        lineFrom: 0,
        lineTo: 3);
    expect(spans.single.style?.color, const Color(0xFF123456));
  });

  test('auxiliary query captures preserve styled captures; none clears them',
      () {
    const source = 'abc';
    final tree = snapshot(source, [
      const SyntaxCapture(name: 'keyword', from: 0, to: 3),
      const SyntaxCapture(name: 'spell', from: 0, to: 3, priority: 100),
      const SyntaxCapture(name: 'none', from: 1, to: 2, priority: 200),
    ]);
    final spans = HighlightBuilder.buildSpans(
        tree: tree,
        source: source,
        highlightStyle: style,
        lineFrom: 0,
        lineTo: 3);
    expect(spans.map((s) => s.text).join(), source);
    expect(spans.map((s) => s.style?.color), [
      const Color(0xFF0000FF),
      null,
      const Color(0xFF0000FF),
    ]);
  });

  test('plain text and Unicode retain every source code unit', () {
    const source = '😀\n雪 plain';
    final spans = HighlightBuilder.buildSpans(
        tree: null,
        source: source,
        highlightStyle: style,
        lineFrom: 0,
        lineTo: source.length);
    expect(spans.single.text, source);
    expect(spans.single.length, source.length);
  });

  test('empty slices produce no spans', () {
    expect(
        HighlightBuilder.buildSpans(
            tree: null,
            source: '',
            highlightStyle: style,
            lineFrom: 0,
            lineTo: 0),
        isEmpty);
  });
}
