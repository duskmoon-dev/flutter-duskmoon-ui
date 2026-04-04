import '../language/language.dart';
import '../language/language_data.dart';
import '../language/stream_language.dart';
import '_registry.dart';

LanguageSupport? _cached;

void _ensureRegistered() {
  if (LanguageRegistry.byName('swift') != null) return;
  _cached = _swiftStream.languageSupport(
    extensions: ['swift'],
    mimeTypes: ['text/x-swift'],
  );
}

LanguageSupport swiftLanguageSupport() {
  _ensureRegistered();
  return _cached!;
}

final _swiftStream = StreamLanguage(
  name: 'swift',
  rules: [
    // Line comments (before operators to catch //)
    TokenRule(RegExp(r'//.*'), 'Comment'),
    // Block comments
    TokenRule(RegExp(r'/\*[\s\S]*?\*/'), 'Comment'),
    // Annotations
    TokenRule(RegExp(r'@[a-zA-Z_]\w*'), 'Annotation'),
    // Compiler directives
    TokenRule(RegExp(r'#[a-zA-Z_]\w*'), 'Meta'),
    // Triple-quoted strings
    TokenRule(RegExp(r'"""[\s\S]*?"""'), 'String'),
    // Double-quoted strings
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    // Numbers
    TokenRule(RegExp(r'0[xX][0-9a-fA-F]+'), 'Number'),
    TokenRule(RegExp(r'\b\d+\.?\d*([eE][+-]?\d+)?\b'), 'Number'),
    // Keywords
    TokenRule(
      RegExp(r'\b(actor|any|as|async|await|break|case|catch|class|continue|'
          r'default|defer|do|else|enum|extension|fallthrough|false|final|for|'
          r'func|guard|if|import|in|init|internal|is|let|nil|open|operator|'
          r'override|private|protocol|public|repeat|return|self|Self|set|some|'
          r'static|struct|subscript|super|switch|throw|throws|true|try|'
          r'typealias|var|weak|where|while)\b'),
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
