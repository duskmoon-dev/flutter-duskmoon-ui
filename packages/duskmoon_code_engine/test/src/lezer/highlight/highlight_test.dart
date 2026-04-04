import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Tag', () {
    test('predefined tags exist', () {
      expect(Tag.keyword, isNotNull);
      expect(Tag.string, isNotNull);
      expect(Tag.comment, isNotNull);
      expect(Tag.number, isNotNull);
      expect(Tag.variableName, isNotNull);
      expect(Tag.typeName, isNotNull);
      expect(Tag.operator_, isNotNull);
      expect(Tag.punctuation, isNotNull);
      expect(Tag.literal, isNotNull);
      expect(Tag.bool_, isNotNull);
      expect(Tag.null_, isNotNull);
      expect(Tag.function_, isNotNull);
      expect(Tag.invalid, isNotNull);
    });

    test('base tags have no parent', () {
      expect(Tag.keyword.parent, isNull);
      expect(Tag.literal.parent, isNull);
      expect(Tag.comment.parent, isNull);
      expect(Tag.punctuation.parent, isNull);
    });

    test('modified tags have correct parent', () {
      expect(Tag.string.parent, Tag.literal);
      expect(Tag.number.parent, Tag.literal);
      expect(Tag.integer.parent, Tag.number);
      expect(Tag.float.parent, Tag.number);
      expect(Tag.lineComment.parent, Tag.comment);
      expect(Tag.blockComment.parent, Tag.comment);
      expect(Tag.controlKeyword.parent, Tag.keyword);
      expect(Tag.paren.parent, Tag.punctuation);
    });

    test('tag name reflects hierarchy', () {
      expect(Tag.keyword.name, 'keyword');
      expect(Tag.string.name, 'literal.string');
      expect(Tag.integer.name, 'literal.number.integer');
      expect(Tag.lineComment.name, 'comment.lineComment');
    });

    test('toString returns Tag(name)', () {
      expect(Tag.keyword.toString(), 'Tag(keyword)');
      expect(Tag.string.toString(), 'Tag(literal.string)');
    });

    test('modified() creates child tag with parent', () {
      // Use existing tags to test modified() — controlKeyword is
      // keyword.modified(Tag._('controlKeyword'))
      expect(Tag.controlKeyword.parent, Tag.keyword);
      expect(Tag.controlKeyword.name, 'keyword.controlKeyword');
    });
  });

  group('HighlightStyle', () {
    const keywordStyle = TextStyle(color: Color(0xFF0000FF));
    const literalStyle = TextStyle(color: Color(0xFF00AA00));
    const stringStyle = TextStyle(color: Color(0xFF008800));

    test('creates with tag mappings', () {
      final hs = HighlightStyle([
        TagStyle(Tag.keyword, keywordStyle),
        TagStyle(Tag.literal, literalStyle),
      ]);
      expect(hs.specs.length, 2);
    });

    test('resolves exact tag match', () {
      final hs = HighlightStyle([
        TagStyle(Tag.keyword, keywordStyle),
        TagStyle(Tag.literal, literalStyle),
      ]);
      expect(hs.style(Tag.keyword), keywordStyle);
      expect(hs.style(Tag.literal), literalStyle);
    });

    test('returns null for unmatched tag with no parent', () {
      final hs = HighlightStyle([
        TagStyle(Tag.keyword, keywordStyle),
      ]);
      expect(hs.style(Tag.comment), isNull);
      expect(hs.style(Tag.punctuation), isNull);
    });

    test('resolves modified tag via parent fallback', () {
      final hs = HighlightStyle([
        TagStyle(Tag.literal, literalStyle),
      ]);
      // string is literal.modified(...), so falls back to literal
      expect(hs.style(Tag.string), literalStyle);
      // number also falls back to literal
      expect(hs.style(Tag.number), literalStyle);
      // integer falls back through number -> literal
      expect(hs.style(Tag.integer), literalStyle);
    });

    test('specific modified tag overrides parent', () {
      final hs = HighlightStyle([
        TagStyle(Tag.literal, literalStyle),
        TagStyle(Tag.string, stringStyle),
      ]);
      // string has its own style
      expect(hs.style(Tag.string), stringStyle);
      // number still falls back to literal
      expect(hs.style(Tag.number), literalStyle);
    });

    test('deep hierarchy fallback walks all ancestors', () {
      final hs = HighlightStyle([
        TagStyle(Tag.literal, literalStyle),
      ]);
      // integer -> number -> literal
      expect(hs.style(Tag.integer), literalStyle);
      expect(hs.style(Tag.float), literalStyle);
    });

    test('returns null when no ancestor matches', () {
      final hs = HighlightStyle([
        TagStyle(Tag.keyword, keywordStyle),
      ]);
      // literal has no parent, so string -> literal -> null
      expect(hs.style(Tag.string), isNull);
    });
  });
}
