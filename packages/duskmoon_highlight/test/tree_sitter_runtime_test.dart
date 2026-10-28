import 'package:duskmoon_highlight/tree_sitter.dart';
import 'package:duskmoon_highlight/src/tree_sitter/edit.dart';
import 'package:duskmoon_highlight/src/tree_sitter/predicates.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, Object?> describe(SyntaxNode node) => {
      'type': node.type,
      'from': node.from,
      'to': node.to,
      'named': node.isNamed,
      'error': node.hasError,
      'children': node.children.map(describe).toList(),
    };

Iterable<SyntaxNode> descendants(SyntaxNode node) sync* {
  yield node;
  for (final child in node.children) {
    yield* descendants(child);
  }
}

void main() {
  setUpAll(() => TreeSitterRuntime.ensureInitialized(languages: {'json'}));

  test('minimal edits preserve UTF16 surrogate boundaries', () {
    expect(sourceEdit('a😀b', 'a😁b'), (start: 1, oldEnd: 3, newEnd: 3));
    expect(sourceEdit('a😀b', 'a🨀b'), (start: 1, oldEnd: 3, newEnd: 3));
    expect(sourceEdit('abc', 'abc'), (start: 3, oldEnd: 3, newEnd: 3));
    expect(sourceEdit('abc', ''), (start: 0, oldEnd: 3, newEnd: 0));
  });

  test('text predicates filter whole quantified matches and retain priorities',
      () {
    QueryPredicates query(String operator, {String value = 'foo'}) =>
        QueryPredicates([
          [
            [
              {'capture': false, 'value': operator},
              {'capture': true, 'value': 'name'},
              {'capture': false, 'value': value},
            ],
            [
              {'capture': false, 'value': 'set!'},
              {'capture': false, 'value': 'priority'},
              {'capture': false, 'value': '20'},
            ],
          ],
        ]);
    const captures = [
      SyntaxCapture(name: 'name', from: 0, to: 3),
      SyntaxCapture(name: 'name', from: 4, to: 7),
    ];
    expect(query('eq?').accepts(0, captures, 'foo bar'), isFalse);
    expect(query('any-eq?').accepts(0, captures, 'foo bar'), isTrue);
    expect(query('not-eq?').accepts(0, captures, 'foo bar'), isFalse);
    expect(query('any-not-eq?').accepts(0, captures, 'foo bar'), isTrue);
    expect(
        query('match?', value: '^f').accepts(0, captures, 'foo bar'), isFalse);
    expect(query('any-match?', value: '^f').accepts(0, captures, 'foo bar'),
        isTrue);
    expect(query('any-of?').accepts(0, captures, 'foo bar'), isFalse);
    expect(query('not-any-of?').accepts(0, captures, 'foo bar'), isTrue);
    expect(query('eq?').priority(0), 20);
    expect(() => query('is?'), throwsUnsupportedError);
  });

  test('every advertised grammar initializes and produces a real syntax tree',
      () async {
    for (final language in TreeSitterRuntime.languages) {
      await TreeSitterRuntime.ensureInitialized(languages: {language});
      final session = TreeSitterSession(language: language);
      final snapshot = session.parse('');
      expect(snapshot.language, language);
      expect(snapshot.rootNode.from, 0, reason: language);
      expect(snapshot.rootNode.to, 0, reason: language);
      session.dispose();
    }
  });

  test('real syntax trees retain unnamed nodes and UTF16 capture ranges', () {
    final parser = TreeSitterSession(language: 'JSON');
    const source = '{"emoji":"😀","value":42}';
    final snapshot = parser.parse(source);
    expect(snapshot.rootNode.type, 'document');
    expect(snapshot.rootNode.to, source.length);
    expect(snapshot.rootNode.hasError, isFalse);
    final object = snapshot.rootNode.children.single;
    expect(object.children.first.type, '{');
    expect(object.children.first.isNamed, isFalse);
    expect(
        snapshot.captures.any(
            (capture) => source.substring(capture.from, capture.to) == '42'),
        isTrue);
    expect(
        snapshot.captures.any((capture) =>
            source.substring(capture.from, capture.to).contains('😀')),
        isTrue);
    expect(snapshot.incremental, isFalse);
    expect(() => snapshot.captures.clear(), throwsUnsupportedError);
    parser.dispose();
    expect(snapshot.rootNode.type, 'document');
    expect(() => parser.parse(source), throwsStateError);
    parser.dispose();
  });

  test(
    'AppleScript Unicode operators retain node names and query captures',
    () async {
      await TreeSitterRuntime.ensureInitialized(languages: {'applescript'});
      final parser = TreeSitterSession(language: 'applescript');
      try {
        for (final operator in ['≠', '≥', '≤', '÷']) {
          final source = 'return 1 $operator 2\n';
          final snapshot = parser.parse(source);
          expect(snapshot.rootNode.hasError, isFalse, reason: operator);
          expect(
            descendants(snapshot.rootNode).any((node) => node.type == operator),
            isTrue,
            reason: operator,
          );
          expect(
            snapshot.captures.any(
              (capture) =>
                  capture.name == 'operator' &&
                  source.substring(capture.from, capture.to) == operator,
            ),
            isTrue,
            reason: operator,
          );
        }
      } finally {
        parser.dispose();
      }
    },
  );

  test('incremental edits equal fresh parses across multiple lines and Unicode',
      () async {
    await TreeSitterRuntime.ensureInitialized(languages: {'javascript'});
    final parser = TreeSitterSession(language: 'javascript');
    final sources = [
      'const emoji = "😀";\nconst number = 42;\n',
      'const emoji = "😁";\nconst number = 420;\n',
      '/* inserted\ncomment */\nconst emoji = "😁";\nconst number = 420;\n',
      '/* inserted\ncomment */\nconst emoji = "😁";\nconst number = 0;\n',
      '',
      'const emoji = "😀";\n',
    ];
    SyntaxSnapshot? first;
    for (final source in sources) {
      final actual = parser.parse(source);
      final freshParser = TreeSitterSession(language: 'javascript');
      final fresh = freshParser.parse(source);
      expect(describe(actual.rootNode), describe(fresh.rootNode));
      expect(
          actual.captures
              .map((c) => (c.name, c.from, c.to, c.priority, c.patternIndex)),
          fresh.captures
              .map((c) => (c.name, c.from, c.to, c.priority, c.patternIndex)));
      expect(actual.incremental, first != null);
      first ??= actual;
      freshParser.dispose();
    }
    parser.dispose();
    expect(first!.source, sources.first);
    expect(first.rootNode.to, sources.first.length);
  });

  test('grammars produce distinct language-specific ASTs and error nodes',
      () async {
    await TreeSitterRuntime.ensureInitialized(languages: {'javascript'});
    final json = TreeSitterSession(language: 'json');
    final javascript = TreeSitterSession(language: 'javascript');
    expect(json.parse('{"value":42}').rootNode.type, 'document');
    expect(javascript.parse('const value = 42;').rootNode.type, 'program');
    expect(json.parse('{"value":').rootNode.hasError, isTrue);
    json.dispose();
    javascript.dispose();
    expect(() => TreeSitterSession(language: 'not-a-bundled-language'),
        throwsArgumentError);
  });

  final heredocs = <({String name, String marker, bool quoted, bool valid})>[
    (name: 'plain identifier', marker: 'EOF', quoted: false, valid: true),
    (
      name: 'quoted Unicode identifier',
      marker: 'α 𐐀',
      quoted: true,
      valid: true,
    ),
    (
      name: '255-byte ASCII identifier',
      marker: List.filled(255, 'A').join(),
      quoted: false,
      valid: true,
    ),
    (
      name: '255-byte Unicode identifier',
      marker: 'A${List.filled(84, '界').join()}ab',
      quoted: false,
      valid: true,
    ),
    (
      name: 'oversized ASCII identifier',
      marker: List.filled(256, 'A').join(),
      quoted: false,
      valid: false,
    ),
    (
      name: 'oversized Unicode identifier',
      marker: 'A${List.filled(85, '界').join()}',
      quoted: false,
      valid: false,
    ),
    (
      name: 'four-byte codepoint crossing the identifier limit',
      marker: '${List.filled(254, 'A').join()}𐐀',
      quoted: false,
      valid: false,
    ),
  ];
  for (final heredoc in heredocs) {
    test('Crystal heredoc preserves ${heredoc.name}', () async {
      await TreeSitterRuntime.ensureInitialized(languages: {'crystal'});
      final parser = TreeSitterSession(language: 'crystal');
      addTearDown(parser.dispose);
      final delimiter = heredoc.quoted ? "'${heredoc.marker}'" : heredoc.marker;
      final source = 'value = <<-$delimiter\nhello\n${heredoc.marker}\n';
      final snapshot = parser.parse(source);
      expect(snapshot.rootNode.hasError, !heredoc.valid);
      expect(snapshot.rootNode.to, source.length);
      expect(
        descendants(snapshot.rootNode)
            .any((node) => node.type == 'heredoc_end'),
        heredoc.valid,
      );
    });
  }

  test('Crystal heredoc identifier edits equal a fresh Unicode parse',
      () async {
    await TreeSitterRuntime.ensureInitialized(languages: {'crystal'});
    final parser = TreeSitterSession(language: 'crystal');
    final fresh = TreeSitterSession(language: 'crystal');
    addTearDown(parser.dispose);
    addTearDown(fresh.dispose);
    expect(parser.parse('value = <<-EOF\nhello\nEOF\n').rootNode.hasError,
        isFalse);
    const edited = "value = <<-'α 𐐀'\nhello 😀\nα 𐐀\n";
    final actual = parser.parse(edited);
    expect(actual.incremental, isTrue);
    expect(actual.rootNode.hasError, isFalse);
    expect(describe(actual.rootNode), describe(fresh.parse(edited).rootNode));
  });

  test('SML scanner preserves nested comments and Unicode', () async {
    await TreeSitterRuntime.ensureInitialized(languages: {'sml'});
    final parser = TreeSitterSession(language: 'sml');
    addTearDown(parser.dispose);
    const comment = '(* outer (* nested 😀 *) still outer *)';
    const source = '$comment\nval answer = 42;\n';
    final snapshot = parser.parse(source);
    expect(snapshot.rootNode.hasError, isFalse);
    final comments = descendants(snapshot.rootNode)
        .where((node) => node.type == 'block_comment')
        .toList();
    expect(comments, hasLength(1));
    expect(source.substring(comments.single.from, comments.single.to), comment);
  });

  test('SML scanner rejects unterminated nested comments', () async {
    await TreeSitterRuntime.ensureInitialized(languages: {'sml'});
    final parser = TreeSitterSession(language: 'sml');
    addTearDown(parser.dispose);
    const source = '(* outer (* nested *)\nval answer = 42;\n';
    expect(parser.parse(source).rootNode.hasError, isTrue);
  });

  test('SML nested comment edits equal a fresh Unicode parse', () async {
    await TreeSitterRuntime.ensureInitialized(languages: {'sml'});
    final parser = TreeSitterSession(language: 'sml');
    final fresh = TreeSitterSession(language: 'sml');
    addTearDown(parser.dispose);
    addTearDown(fresh.dispose);
    expect(parser.parse('(* before *)\nval answer = 42;\n').rootNode.hasError,
        isFalse);
    const edited = '(* outer (* inserted 😀 *) after *)\nval answer = 420;\n';
    final actual = parser.parse(edited);
    expect(actual.incremental, isTrue);
    expect(actual.rootNode.hasError, isFalse);
    expect(describe(actual.rootNode), describe(fresh.parse(edited).rootNode));
  });
}
