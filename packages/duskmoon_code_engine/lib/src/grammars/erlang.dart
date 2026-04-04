import '../language/language.dart';
import '../language/language_data.dart';
import '../language/stream_language.dart';
import '_registry.dart';

LanguageSupport? _cached;

void _ensureRegistered() {
  if (LanguageRegistry.byName('erlang') != null) return;
  _cached = _erlangStream.languageSupport(
    extensions: ['erl', 'hrl'],
    mimeTypes: ['text/x-erlang'],
  );
}

LanguageSupport erlangLanguageSupport() {
  _ensureRegistered();
  return _cached!;
}

final _erlangStream = StreamLanguage(
  name: 'erlang',
  rules: [
    // Line comments
    TokenRule(RegExp(r'%.*'), 'Comment'),
    // Module attributes: -module, -export, etc.
    TokenRule(RegExp(r'-[a-z]\w*'), 'Meta'),
    // String literals
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    // Single-quoted atoms
    TokenRule(RegExp(r"'(?:[^'\\]|\\.)*'"), 'Atom'),
    // Numbers
    TokenRule(RegExp(r'0[xX][0-9a-fA-F]+'), 'Number'),
    TokenRule(RegExp(r'\b\d+#[0-9a-zA-Z]+\b'), 'Number'),
    TokenRule(RegExp(r'\b\d+\.?\d*([eE][+-]?\d+)?\b'), 'Number'),
    // Keywords
    TokenRule(
      RegExp(r'\b(after|and|andalso|band|begin|bnot|bor|bsl|bsr|bxor|case|'
          r'catch|cond|div|end|fun|if|let|not|of|or|orelse|receive|rem|try|'
          r'when|xor)\b'),
      'Keyword',
    ),
    // Variables: uppercase start
    TokenRule(RegExp(r'\b[A-Z_][a-zA-Z0-9_]*\b'), 'VariableName'),
    // Atoms: lowercase start
    TokenRule(RegExp(r'\b[a-z][a-zA-Z0-9_@]*\b'), 'Atom'),
    // Operators
    TokenRule(RegExp(r'[+\-*/%&|^~<>=!?:]+'), 'Operator'),
    // Punctuation
    TokenRule(RegExp(r'[{}()\[\];,.|#]'), 'Punctuation'),
  ],
  data: const LanguageData(
    commentTokens: CommentTokens(line: '%'),
  ),
);
