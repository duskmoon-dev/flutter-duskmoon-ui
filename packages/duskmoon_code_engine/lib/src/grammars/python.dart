import '../language/language.dart';
import '../language/language_data.dart';
import '../language/stream_language.dart';
import '_registry.dart';

LanguageSupport? _cached;

void _ensureRegistered() {
  if (LanguageRegistry.byName('python') != null) return;
  _cached = _pythonStream.languageSupport(
    extensions: ['py'],
    mimeTypes: ['text/x-python', 'application/x-python'],
  );
}

LanguageSupport pythonLanguageSupport() {
  _ensureRegistered();
  return _cached!;
}

final _pythonStream = StreamLanguage(
  name: 'python',
  rules: [
    // Line comments
    TokenRule(RegExp(r'#.*'), 'Comment'),
    // Triple-quoted strings (must come before single-quoted)
    TokenRule(RegExp(r'"""[\s\S]*?"""'), 'String'),
    TokenRule(RegExp(r"'''[\s\S]*?'''"), 'String'),
    // String literals
    TokenRule(RegExp(r"'(?:[^'\\]|\\.)*'"), 'String'),
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    // Decorators
    TokenRule(RegExp(r'@[a-zA-Z_]\w*'), 'Annotation'),
    // Numbers (hex, float, int)
    TokenRule(RegExp(r'0x[0-9a-fA-F]+'), 'Number'),
    TokenRule(RegExp(r'\b\d+\.?\d*([eE][+-]?\d+)?\b'), 'Number'),
    // Keywords
    TokenRule(
      RegExp(r'\b(and|as|assert|async|await|break|class|continue|def|del|elif|'
          r'else|except|False|finally|for|from|global|if|import|in|is|lambda|'
          r'None|nonlocal|not|or|pass|raise|return|True|try|while|with|yield)\b'),
      'Keyword',
    ),
    // Type names (uppercase start)
    TokenRule(RegExp(r'\b[A-Z][a-zA-Z0-9_]*\b'), 'TypeName'),
    // Identifiers
    TokenRule(RegExp(r'[a-zA-Z_]\w*'), 'Identifier'),
    // Operators
    TokenRule(RegExp(r'[+\-*/%&|^~<>=!]+'), 'Operator'),
    // Punctuation
    TokenRule(RegExp(r'[{}()\[\];,.:@#]'), 'Punctuation'),
  ],
  data: const LanguageData(
    commentTokens: CommentTokens(line: '#'),
  ),
);
