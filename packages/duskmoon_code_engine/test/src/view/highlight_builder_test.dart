import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
// Hide Flutter's InlineSpan to avoid conflict with our InlineSpan.
import 'package:flutter/painting.dart' hide InlineSpan;
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

LRParser _createJsonParser() {
  return LRParser.deserialize(
    nodeNames: [
      '',
      'JsonText',
      'Number',
      'String',
      'Boolean',
      'Null',
      '{',
      '}',
      '[',
      ']',
      ',',
      ':',
      '⚠',
    ],
    states: [0],
    stateData: [0],
    gotoTable: [0],
    tokenData: [0],
    topRuleIndex: 1,
    nodeProps: {
      1: {NodeProp.top: true},
      12: {NodeProp.error: true},
    },
  );
}

Tree _parseJson(String text) => _createJsonParser().parse(text);

HighlightStyle _makeStyle() => HighlightStyle([
      TagStyle(Tag.number, const TextStyle(color: Color(0xFF098658))),
      TagStyle(Tag.string, const TextStyle(color: Color(0xFFA31515))),
      TagStyle(Tag.bool_, const TextStyle(color: Color(0xFF0000FF))),
      TagStyle(Tag.null_, const TextStyle(color: Color(0xFF0000FF))),
      TagStyle(Tag.brace, const TextStyle(color: Color(0xFF000000))),
      TagStyle(Tag.squareBracket, const TextStyle(color: Color(0xFF000000))),
      TagStyle(Tag.separator, const TextStyle(color: Color(0xFF000000))),
    ]);

List<InlineSpan> _build(String text, {TextStyle? defaultStyle}) {
  final tree = _parseJson(text);
  return HighlightBuilder.buildSpans(
    tree: tree,
    source: text,
    highlightStyle: _makeStyle(),
    lineFrom: 0,
    lineTo: text.length,
    defaultStyle: defaultStyle,
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('HighlightBuilder', () {
    group('empty document', () {
      test('returns empty spans', () {
        final spans = _build('');
        expect(spans, isEmpty);
      });

      test('lineFrom == lineTo returns empty spans', () {
        final tree = _parseJson('42');
        final spans = HighlightBuilder.buildSpans(
          tree: tree,
          source: '42',
          highlightStyle: _makeStyle(),
          lineFrom: 0,
          lineTo: 0,
        );
        expect(spans, isEmpty);
      });
    });

    group('single number token', () {
      test('produces one span with number color', () {
        const text = '42';
        final spans = _build(text);
        expect(spans.length, 1);
        expect(spans[0].text, '42');
        expect(spans[0].from, 0);
        expect(spans[0].to, 2);
        expect(spans[0].style?.color, const Color(0xFF098658));
      });

      test('span length matches token length', () {
        const text = '12345';
        final spans = _build(text);
        expect(spans[0].length, 5);
      });
    });

    group('single string token', () {
      test('produces one span with string color', () {
        const text = '"hello"';
        final spans = _build(text);
        expect(spans.length, 1);
        expect(spans[0].text, '"hello"');
        expect(spans[0].style?.color, const Color(0xFFA31515));
      });
    });

    group('boolean and null tokens', () {
      test('true gets bool color', () {
        final spans = _build('true');
        expect(spans.length, 1);
        expect(spans[0].style?.color, const Color(0xFF0000FF));
      });

      test('null gets null color', () {
        final spans = _build('null');
        expect(spans.length, 1);
        expect(spans[0].style?.color, const Color(0xFF0000FF));
      });
    });

    group('mixed tokens', () {
      test('object produces multiple typed spans', () {
        // {"a":1}  →  { "a" : 1 }  (5 tokens, whitespace is skipped by parser)
        const text = '{"a":1}';
        final spans = _build(text);
        // Expect tokens: { "a" : 1 }
        final names = spans.map((s) => s.text).toList();
        expect(names, containsAll(['{', '"a"', ':', '1', '}']));
      });

      test('array with two numbers produces spans for both numbers', () {
        const text = '[1,2]';
        final spans = _build(text);
        final texts = spans.map((s) => s.text).toList();
        expect(texts, containsAll(['[', '1', ',', '2', ']']));
      });
    });

    group('spans cover full range without gaps', () {
      test('total length equals text length for number', () {
        const text = '42';
        final spans = _build(text);
        final total = spans.fold(0, (sum, s) => sum + s.length);
        expect(total, text.length);
      });

      test('total length equals text length for object with whitespace', () {
        // Parser skips whitespace → gaps are filled by HighlightBuilder.
        const text = '{ "key" : 99 }';
        final spans = _build(text);
        final total = spans.fold(0, (sum, s) => sum + s.length);
        expect(total, text.length);
      });

      test('spans are contiguous (no gaps or overlaps)', () {
        const text = '{"x":true}';
        final spans = _build(text);
        int cursor = 0;
        for (final span in spans) {
          expect(span.from, cursor,
              reason: 'gap or overlap before span "${span.text}"');
          cursor = span.to;
        }
        expect(cursor, text.length);
      });

      test('spans cover full range for string', () {
        const text = '"hello world"';
        final spans = _build(text);
        final total = spans.fold(0, (sum, s) => sum + s.length);
        expect(total, text.length);
      });
    });

    group('unstyled text gets default style', () {
      const defaultStyle = TextStyle(color: Color(0xFF333333));

      test('whitespace gap gets default style', () {
        // Parser skips whitespace so "42 99" produces gap " " between tokens.
        const text = '42 99';
        final tree = _parseJson(text);
        final spans = HighlightBuilder.buildSpans(
          tree: tree,
          source: text,
          highlightStyle: _makeStyle(),
          lineFrom: 0,
          lineTo: text.length,
          defaultStyle: defaultStyle,
        );
        // Find the gap span (the space).
        final gap = spans.firstWhere((s) => s.text == ' ');
        expect(gap.style, defaultStyle);
      });

      test('unknown node name gets default style', () {
        // The error node '⚠' has no tag mapping → default style.
        const text = '@'; // unknown char → error node
        final tree = _parseJson(text);
        final spans = HighlightBuilder.buildSpans(
          tree: tree,
          source: text,
          highlightStyle: _makeStyle(),
          lineFrom: 0,
          lineTo: text.length,
          defaultStyle: defaultStyle,
        );
        expect(spans.length, 1);
        expect(spans[0].style, defaultStyle);
      });

      test('null defaultStyle produces null style for gaps', () {
        const text = '42 99';
        final tree = _parseJson(text);
        final spans = HighlightBuilder.buildSpans(
          tree: tree,
          source: text,
          highlightStyle: _makeStyle(),
          lineFrom: 0,
          lineTo: text.length,
        );
        final gap = spans.firstWhere((s) => s.text == ' ');
        expect(gap.style, isNull);
      });
    });

    group('partial range (lineFrom / lineTo)', () {
      test('only spans within range are returned', () {
        // "42 99": request only the "42" portion [0..2]
        const text = '42 99';
        final tree = _parseJson(text);
        final spans = HighlightBuilder.buildSpans(
          tree: tree,
          source: text,
          highlightStyle: _makeStyle(),
          lineFrom: 0,
          lineTo: 2,
        );
        final total = spans.fold(0, (sum, s) => sum + s.length);
        expect(total, 2);
        for (final s in spans) {
          expect(s.from, greaterThanOrEqualTo(0));
          expect(s.to, lessThanOrEqualTo(2));
        }
      });

      test('spans outside range are excluded', () {
        const text = '{"a":1}';
        final tree = _parseJson(text);
        // Only request the first character.
        final spans = HighlightBuilder.buildSpans(
          tree: tree,
          source: text,
          highlightStyle: _makeStyle(),
          lineFrom: 0,
          lineTo: 1,
        );
        expect(spans.length, 1);
        expect(spans[0].text, '{');
      });
    });

    group('InlineSpan', () {
      test('length equals to - from', () {
        const span = InlineSpan(from: 2, to: 7, text: 'hello');
        expect(span.length, 5);
      });

      test('text field is accessible', () {
        const span = InlineSpan(from: 0, to: 3, text: 'foo');
        expect(span.text, 'foo');
      });

      test('style can be null', () {
        const span = InlineSpan(from: 0, to: 1, text: 'x');
        expect(span.style, isNull);
      });
    });
  });
}
