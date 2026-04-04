import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

EditorState _apply(EditorState state, TransactionSpec spec) =>
    state.applyTransaction(state.update(spec));

void main() {
  // ---------------------------------------------------------------------------
  // SearchState.findMatches
  // ---------------------------------------------------------------------------
  group('SearchState.findMatches', () {
    test('finds all occurrences of a literal query', () {
      final doc = Document.fromString('foo bar foo baz foo');
      final matches = SearchState.findMatches(doc, 'foo');
      expect(matches.length, 3);
      expect(matches[0], const SearchMatch(0, 3));
      expect(matches[1], const SearchMatch(8, 11));
      expect(matches[2], const SearchMatch(16, 19));
    });

    test('returns empty list when no match found', () {
      final doc = Document.fromString('hello world');
      expect(SearchState.findMatches(doc, 'xyz'), isEmpty);
    });

    test('returns empty list for empty query', () {
      final doc = Document.fromString('hello');
      expect(SearchState.findMatches(doc, ''), isEmpty);
    });

    test('is case-insensitive by default', () {
      final doc = Document.fromString('Hello HELLO hello');
      final matches = SearchState.findMatches(doc, 'hello');
      expect(matches.length, 3);
    });

    test('case-sensitive mode skips mismatched case', () {
      final doc = Document.fromString('Hello HELLO hello');
      final matches =
          SearchState.findMatches(doc, 'hello', caseSensitive: true);
      expect(matches.length, 1);
      expect(matches[0], const SearchMatch(12, 17));
    });

    test('regex search finds matches', () {
      final doc = Document.fromString('foo123bar456');
      final matches = SearchState.findMatches(doc, r'\d+', useRegex: true);
      expect(matches.length, 2);
      expect(matches[0], const SearchMatch(3, 6));
      expect(matches[1], const SearchMatch(9, 12));
    });

    test('regex search is case-insensitive by default', () {
      final doc = Document.fromString('ABC abc');
      final matches = SearchState.findMatches(doc, 'abc', useRegex: true);
      expect(matches.length, 2);
    });

    test('regex search respects caseSensitive flag', () {
      final doc = Document.fromString('ABC abc');
      final matches = SearchState.findMatches(doc, 'abc',
          useRegex: true, caseSensitive: true);
      expect(matches.length, 1);
      expect(matches[0], const SearchMatch(4, 7));
    });

    test('invalid regex returns empty list without throwing', () {
      final doc = Document.fromString('hello');
      expect(
        () => SearchState.findMatches(doc, r'[invalid', useRegex: true),
        returnsNormally,
      );
      expect(
          SearchState.findMatches(doc, r'[invalid', useRegex: true), isEmpty);
    });

    test('overlapping literal matches via sliding window', () {
      final doc = Document.fromString('aaaa');
      final matches = SearchState.findMatches(doc, 'aa');
      // pos advances by 1 each step: indices 0,1,2
      expect(matches.length, 3);
    });
  });

  // ---------------------------------------------------------------------------
  // SearchCommands.findNext
  // ---------------------------------------------------------------------------
  group('SearchCommands.findNext', () {
    late EditorState state;
    late List<SearchMatch> matches;

    setUp(() {
      state = EditorState.create(docString: 'foo bar foo baz foo');
      matches = SearchState.findMatches(state.doc, 'foo');
    });

    test('moves to next match', () {
      final spec = SearchCommands.findNext(state, matches, 0);
      final next = _apply(state, spec);
      expect(next.selection.main.from, matches[1].from);
      expect(next.selection.main.to, matches[1].to);
    });

    test('wraps around from last match to first', () {
      final spec = SearchCommands.findNext(state, matches, 2);
      final next = _apply(state, spec);
      expect(next.selection.main.from, matches[0].from);
      expect(next.selection.main.to, matches[0].to);
    });

    test('returns empty spec when matches list is empty', () {
      final spec = SearchCommands.findNext(state, const [], 0);
      // No selection change — spec has no changes and no selection.
      expect(spec.selection, isNull);
      expect(spec.changes, isNull);
    });

    test('sets scrollIntoView', () {
      final spec = SearchCommands.findNext(state, matches, 0);
      expect(spec.scrollIntoView, isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // SearchCommands.findPrevious
  // ---------------------------------------------------------------------------
  group('SearchCommands.findPrevious', () {
    late EditorState state;
    late List<SearchMatch> matches;

    setUp(() {
      state = EditorState.create(docString: 'foo bar foo baz foo');
      matches = SearchState.findMatches(state.doc, 'foo');
    });

    test('moves to previous match', () {
      final spec = SearchCommands.findPrevious(state, matches, 2);
      final next = _apply(state, spec);
      expect(next.selection.main.from, matches[1].from);
    });

    test('wraps around from first match to last', () {
      final spec = SearchCommands.findPrevious(state, matches, 0);
      final next = _apply(state, spec);
      expect(next.selection.main.from, matches[2].from);
    });

    test('returns empty spec when matches list is empty', () {
      final spec = SearchCommands.findPrevious(state, const [], 0);
      expect(spec.selection, isNull);
      expect(spec.changes, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // SearchCommands.replaceOne
  // ---------------------------------------------------------------------------
  group('SearchCommands.replaceOne', () {
    test('replaces exact range with replacement text', () {
      final state = EditorState.create(docString: 'foo bar foo');
      final spec = SearchCommands.replaceOne(state, 0, 3, 'baz');
      final next = _apply(state, spec);
      expect(next.doc.toString(), 'baz bar foo');
    });

    test('places cursor after inserted replacement', () {
      final state = EditorState.create(docString: 'foo bar');
      final spec = SearchCommands.replaceOne(state, 0, 3, 'hello');
      final next = _apply(state, spec);
      expect(next.selection.main.head, 5); // 'hello'.length
      expect(next.selection.main.isEmpty, isTrue);
    });

    test('replacement can be empty (i.e. deletion)', () {
      final state = EditorState.create(docString: 'foo bar');
      final spec = SearchCommands.replaceOne(state, 3, 7, '');
      final next = _apply(state, spec);
      expect(next.doc.toString(), 'foo');
    });
  });

  // ---------------------------------------------------------------------------
  // SearchCommands.replaceAll
  // ---------------------------------------------------------------------------
  group('SearchCommands.replaceAll', () {
    test('replaces all matches atomically', () {
      final state = EditorState.create(docString: 'foo bar foo baz foo');
      final matches = SearchState.findMatches(state.doc, 'foo');
      final spec = SearchCommands.replaceAll(state, matches, 'qux');
      final next = _apply(state, spec);
      expect(next.doc.toString(), 'qux bar qux baz qux');
    });

    test('returns empty spec when matches list is empty', () {
      final state = EditorState.create(docString: 'hello');
      final spec = SearchCommands.replaceAll(state, const [], 'x');
      expect(spec.changes, isNull);
      expect(spec.selection, isNull);
    });

    test('replaces with empty string (deletion of all matches)', () {
      final state = EditorState.create(docString: 'foo bar foo');
      final matches = SearchState.findMatches(state.doc, 'foo');
      final spec = SearchCommands.replaceAll(state, matches, '');
      final next = _apply(state, spec);
      expect(next.doc.toString(), ' bar ');
    });
  });
}
