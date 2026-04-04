import '../language/language.dart';
import '../language/language_data.dart';
import '../language/stream_language.dart';
import '_registry.dart';

LanguageSupport? _cached;

void _ensureRegistered() {
  if (LanguageRegistry.byName('kotlin') != null) return;
  _cached = _kotlinStream.languageSupport(
    extensions: ['kt', 'kts'],
    mimeTypes: ['text/x-kotlin'],
  );
}

LanguageSupport kotlinLanguageSupport() {
  _ensureRegistered();
  return _cached!;
}

final _kotlinStream = StreamLanguage(
  name: 'kotlin',
  rules: [
    // Line comments (before operators to catch //)
    TokenRule(RegExp(r'//.*'), 'Comment'),
    // Block comments
    TokenRule(RegExp(r'/\*[\s\S]*?\*/'), 'Comment'),
    // Annotations
    TokenRule(RegExp(r'@[a-zA-Z_]\w*'), 'Annotation'),
    // Triple-quoted strings
    TokenRule(RegExp(r'"""[\s\S]*?"""'), 'String'),
    // Double-quoted strings
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    // Char literals
    TokenRule(RegExp(r"'(?:[^'\\]|\\.)*'"), 'String'),
    // Numbers
    TokenRule(RegExp(r'0[xX][0-9a-fA-F]+[lL]?'), 'Number'),
    TokenRule(RegExp(r'\b\d+\.?\d*([eE][+-]?\d+)?[fFdDlL]?\b'), 'Number'),
    // Keywords
    TokenRule(
      RegExp(r'\b(abstract|actual|annotation|as|break|by|catch|class|'
          r'companion|const|constructor|continue|data|do|else|enum|expect|'
          r'false|final|finally|for|fun|get|if|import|in|init|interface|'
          r'internal|is|lateinit|null|object|open|operator|override|package|'
          r'private|protected|public|return|sealed|set|super|suspend|this|'
          r'throw|true|try|typealias|val|var|when|where|while)\b'),
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
