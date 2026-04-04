import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BracketMatching.findMatch', () {
    test('finds matching closing parenthesis', () {
      final doc = Document.fromString('(hello)');
      expect(BracketMatching.findMatch(doc, 0), 6);
    });

    test('finds matching opening parenthesis', () {
      final doc = Document.fromString('(hello)');
      expect(BracketMatching.findMatch(doc, 6), 0);
    });

    test('handles nested brackets — outer parens', () {
      final doc = Document.fromString('(a(b)c)');
      expect(BracketMatching.findMatch(doc, 0), 6);
    });

    test('handles nested brackets — inner parens', () {
      final doc = Document.fromString('(a(b)c)');
      expect(BracketMatching.findMatch(doc, 2), 4);
    });

    test('handles curly braces', () {
      final doc = Document.fromString('{x}');
      expect(BracketMatching.findMatch(doc, 0), 2);
      expect(BracketMatching.findMatch(doc, 2), 0);
    });

    test('handles square brackets', () {
      final doc = Document.fromString('[1,2]');
      expect(BracketMatching.findMatch(doc, 0), 4);
      expect(BracketMatching.findMatch(doc, 4), 0);
    });

    test('returns null for non-bracket character', () {
      final doc = Document.fromString('hello');
      expect(BracketMatching.findMatch(doc, 1), isNull);
    });

    test('returns null for unmatched opening bracket', () {
      final doc = Document.fromString('(hello');
      expect(BracketMatching.findMatch(doc, 0), isNull);
    });

    test('returns null for unmatched closing bracket', () {
      final doc = Document.fromString('hello)');
      expect(BracketMatching.findMatch(doc, 5), isNull);
    });

    test('works across multiple lines', () {
      final doc = Document.fromString('(\nfoo\n)');
      expect(BracketMatching.findMatch(doc, 0), 6);
      expect(BracketMatching.findMatch(doc, 6), 0);
    });
  });

  group('BracketMatching.matchForState', () {
    test('returns pair when cursor is on opening bracket', () {
      final state = EditorState.create(
        docString: '(hello)',
        selection: EditorSelection.cursor(0),
      );
      final pair = BracketMatching.matchForState(state);
      expect(pair, isNotNull);
      expect(pair!.open, 0);
      expect(pair.close, 6);
    });

    test('returns pair when cursor is on closing bracket', () {
      final state = EditorState.create(
        docString: '(hello)',
        selection: EditorSelection.cursor(6),
      );
      final pair = BracketMatching.matchForState(state);
      expect(pair, isNotNull);
      expect(pair!.open, 0);
      expect(pair.close, 6);
    });

    test('returns pair when cursor is just after closing bracket', () {
      // head=7 → char before cursor at 6 is ')'
      final state = EditorState.create(
        docString: '(hello)',
        selection: EditorSelection.cursor(7),
      );
      final pair = BracketMatching.matchForState(state);
      expect(pair, isNotNull);
      expect(pair!.open, 0);
      expect(pair.close, 6);
    });

    test('returns null when not at or adjacent to a bracket', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(2),
      );
      expect(BracketMatching.matchForState(state), isNull);
    });
  });
}
