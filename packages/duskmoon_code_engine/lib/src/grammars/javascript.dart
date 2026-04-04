import '../language/language.dart';
import '../language/language_data.dart';
import '../language/stream_language.dart';
import '_registry.dart';

LanguageSupport? _cached;

void _ensureRegistered() {
  if (LanguageRegistry.byName('javascript') != null) return;
  _cached = _jsStream.languageSupport(
    extensions: ['js', 'jsx', 'ts', 'tsx', 'mjs'],
    mimeTypes: ['text/javascript', 'application/javascript', 'text/typescript'],
  );
}

LanguageSupport javascriptLanguageSupport() {
  _ensureRegistered();
  return _cached!;
}

final _jsStream = StreamLanguage(
  name: 'javascript',
  rules: [
    // Line comments
    TokenRule(RegExp(r'//.*'), 'Comment'),
    // Block comments
    TokenRule(RegExp(r'/\*[\s\S]*?\*/'), 'Comment'),
    // Template literals (backticks)
    TokenRule(RegExp(r'`(?:[^`\\]|\\.)*`'), 'String'),
    // String literals
    TokenRule(RegExp(r"'(?:[^'\\]|\\.)*'"), 'String'),
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    // Numbers (hex, float, int)
    TokenRule(RegExp(r'0x[0-9a-fA-F]+'), 'Number'),
    TokenRule(RegExp(r'\b\d+\.?\d*([eE][+-]?\d+)?\b'), 'Number'),
    // Keywords
    TokenRule(
      RegExp(
          r'\b(async|await|break|case|catch|class|const|continue|default|delete|'
          r'do|else|export|extends|false|finally|for|from|function|get|if|import|'
          r'in|instanceof|let|new|null|of|return|set|static|super|switch|this|'
          r'throw|true|try|typeof|undefined|var|void|while|with|yield)\b'),
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
