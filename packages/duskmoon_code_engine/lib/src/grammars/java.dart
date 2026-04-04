import '../language/language.dart';
import '../language/language_data.dart';
import '../language/stream_language.dart';
import '_registry.dart';

LanguageSupport? _cached;

void _ensureRegistered() {
  if (LanguageRegistry.byName('java') != null) return;
  _cached = _javaStream.languageSupport(
    extensions: ['java'],
    mimeTypes: ['text/x-java'],
  );
}

LanguageSupport javaLanguageSupport() {
  _ensureRegistered();
  return _cached!;
}

final _javaStream = StreamLanguage(
  name: 'java',
  rules: [
    // Line comments (before operators to catch //)
    TokenRule(RegExp(r'//.*'), 'Comment'),
    // Block comments
    TokenRule(RegExp(r'/\*[\s\S]*?\*/'), 'Comment'),
    // Annotations
    TokenRule(RegExp(r'@[a-zA-Z_]\w*'), 'Annotation'),
    // String literals
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    // Char literals
    TokenRule(RegExp(r"'(?:[^'\\]|\\.)*'"), 'String'),
    // Numbers: hex, float with suffixes, long
    TokenRule(RegExp(r'0[xX][0-9a-fA-F]+[lL]?'), 'Number'),
    TokenRule(RegExp(r'\b\d+\.?\d*([eE][+-]?\d+)?[fFdDlL]?\b'), 'Number'),
    // Keywords
    TokenRule(
      RegExp(r'\b(abstract|assert|boolean|break|byte|case|catch|char|class|'
          r'const|continue|default|do|double|else|enum|extends|false|final|'
          r'finally|float|for|if|implements|import|instanceof|int|interface|'
          r'long|native|new|null|package|private|protected|public|return|'
          r'short|static|super|switch|synchronized|this|throw|throws|true|'
          r'try|var|void|volatile|while|yield|record|sealed)\b'),
      'Keyword',
    ),
    // Type names (uppercase start)
    TokenRule(RegExp(r'\b[A-Z][a-zA-Z0-9_]*\b'), 'TypeName'),
    // Identifiers
    TokenRule(RegExp(r'[a-zA-Z_$]\w*'), 'Identifier'),
    // Operators
    TokenRule(RegExp(r'[+\-*/%&|^~<>=!?]+'), 'Operator'),
    // Punctuation
    TokenRule(RegExp(r'[{}()\[\];,.:@#]'), 'Punctuation'),
  ],
  data: const LanguageData(
    commentTokens: CommentTokens(line: '//', block: (open: '/*', close: '*/')),
  ),
);
