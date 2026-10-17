import 'package:duskmoon_highlight/duskmoon_highlight.dart';
import 'package:duskmoon_highlight/languages/all.dart';
import 'package:flutter_test/flutter_test.dart';

class _Tokens implements HighlightRenderer {
  final runs = <({String text, List<String> scopes})>[];
  final _scopes = <String?>[];

  String get source => runs.map((run) => run.text).join();

  bool containsToken(String token, String scope) {
    return runs.any((run) =>
        run.text.contains(token) &&
        run.scopes
            .any((value) => value == scope || value.startsWith('$scope.')));
  }

  @override
  void addText(String text) {
    runs.add((text: text, scopes: _scopes.whereType<String>().toList()));
  }

  @override
  void openNode(DataNode node) => _scopes.add(node.scope);

  @override
  void closeNode(DataNode node) => _scopes.removeLast();
}

_Tokens _render(HighlightResult result) {
  final tokens = _Tokens();
  result.render(tokens);
  expect(tokens._scopes, isEmpty, reason: 'Renderer scopes must stay balanced');
  return tokens;
}

void main() {
  late Highlight highlight;

  setUp(() {
    highlight = Highlight()..registerLanguages(builtinAllLanguages);
  });

  test('ships and registers all 194 maintained languages', () {
    expect(builtinAllLanguages, hasLength(194));
    expect(
        highlight.listLanguages(), unorderedEquals(builtinAllLanguages.keys));
    for (final name in builtinAllLanguages.keys) {
      expect(highlight.getLanguage(name), isNotNull, reason: name);
    }
  });

  test('compiles every maintained language in debug mode', () {
    highlight.debugMode();
    for (final name in builtinAllLanguages.keys) {
      final result = highlight.highlight(code: '', language: name);
      expect(result.errorRaised, isNull, reason: name);
      expect(result.illegal, isFalse, reason: name);
      expect(_render(result).source, isEmpty, reason: name);
    }
  });

  test('retains common aliases with case-insensitive lookup', () {
    const aliases = {
      'JS': 'javascript',
      'PY': 'python',
      'HTML': 'xml',
      'SH': 'bash',
      'C#': 'csharp',
      'GNI': 'gn',
    };
    for (final alias in aliases.entries) {
      expect(
        highlight.getLanguage(alias.key),
        same(highlight.getLanguage(alias.value)),
        reason: alias.key,
      );
    }
    expect(highlight.getLanguage('not-a-language'), isNull);
  });

  const samples = {
    'dart': (
      code: '\tfinal message = "<tag>&amp; 中文 😀";\r\n// café\n',
      token: 'final',
      scope: 'keyword',
    ),
    'sql': (
      code: 'SELECT name FROM users WHERE name = \'中文 😀\';\r\n',
      token: 'SELECT',
      scope: 'keyword',
    ),
    'nix': (
      code: 'let name = "中文 😀"; in name\r\n',
      token: 'let',
      scope: 'keyword',
    ),
    'bash': (
      code: 'if true; then echo "中文 😀"; fi\r\n',
      token: 'if',
      scope: 'keyword',
    ),
    'html': (
      code: '<div class="greeting">中文 😀 &amp; &lt;</div>\r\n',
      token: 'div',
      scope: 'name',
    ),
    'vue': (
      code: '<template><div>中文 😀 &amp;</div></template>\r\n'
          '<script>\nconst greeting = "hello";\n</script>\n',
      token: 'div',
      scope: 'name',
    ),
    'gn': (
      code: 'executable("中文") {\r\n  sources = [ "main.cc" ]\r\n}\n',
      token: 'executable',
      scope: 'type',
    ),
  };
  for (final sample in samples.entries) {
    test('${sample.key} emits tokens without altering the source', () {
      final result = highlight.highlight(
        code: sample.value.code,
        language: sample.key,
      );

      expect(result.errorRaised, isNull);
      expect(result.illegal, isFalse);
      final tokens = _render(result);
      expect(tokens.source, sample.value.code);
      expect(
        tokens.containsToken(sample.value.token, sample.value.scope),
        isTrue,
      );
    });
  }

  test('preserves nested string interpolation scopes and text', () {
    const code = 'final message = "hello \${user.name}";\r\n';
    final tokens = _render(highlight.highlight(code: code, language: 'dart'));

    expect(tokens.source, code);
    expect(
      tokens.runs.any((run) =>
          run.text.contains('user') &&
          run.scopes.contains('string') &&
          run.scopes.contains('subst')),
      isTrue,
    );
  });

  test('reports grammar errors so callers can render a complete plain fallback',
      () {
    highlight.registerLanguage(
      'broken-grammar',
      Mode(contains: [
        Mode(
          begin: 'BOOM',
          onBegin: (match, response) => throw StateError('grammar failed'),
        ),
      ]),
    );
    const code = 'prefix BOOM suffix <tag>&amp; 中文 😀\r\n';
    final result = highlight.highlight(code: code, language: 'broken-grammar');

    expect(result.errorRaised, isA<StateError>());
    expect(result.code, code);
    final fallback = highlight.justTextHighlightResult(result.code);
    expect(_render(fallback).source, code);
    expect(fallback.errorRaised, isNull);
    expect(fallback.illegal, isFalse);
  });
}
