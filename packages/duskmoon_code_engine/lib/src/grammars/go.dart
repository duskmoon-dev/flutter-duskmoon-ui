import '../language/language.dart';
import '../language/language_data.dart';
import '../language/stream_language.dart';
import '_registry.dart';

LanguageSupport? _cached;

void _ensureRegistered() {
  if (LanguageRegistry.byName('go') != null) return;
  _cached = _goStream.languageSupport(
    extensions: ['go'],
    mimeTypes: ['text/x-go', 'application/x-go'],
  );
}

LanguageSupport goLanguageSupport() {
  _ensureRegistered();
  return _cached!;
}

final _goStream = StreamLanguage(
  name: 'go',
  rules: [
    // Line comments
    TokenRule(RegExp(r'//.*'), 'Comment'),
    // Block comments
    TokenRule(RegExp(r'/\*[\s\S]*?\*/'), 'Comment'),
    // Raw string literals (backtick)
    TokenRule(RegExp(r'`[^`]*`'), 'String'),
    // String literals
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    // Rune literals
    TokenRule(RegExp(r"'(?:[^'\\]|\\.)'"), 'String'),
    // Numbers (hex, float, int)
    TokenRule(RegExp(r'0x[0-9a-fA-F_]+'), 'Number'),
    TokenRule(RegExp(r'\b\d[\d_]*\.?\d*([eE][+-]?\d+)?\b'), 'Number'),
    // Keywords
    TokenRule(
      RegExp(
          r'\b(break|case|chan|const|continue|default|defer|else|fallthrough|'
          r'for|func|go|goto|if|import|interface|map|package|range|return|'
          r'select|struct|switch|type|var)\b'),
      'Keyword',
    ),
    // Built-in types and functions
    TokenRule(
      RegExp(
          r'\b(bool|byte|complex64|complex128|error|float32|float64|int|int8|'
          r'int16|int32|int64|rune|string|uint|uint8|uint16|uint32|uint64|'
          r'uintptr|append|cap|close|complex|copy|delete|imag|len|make|new|'
          r'panic|print|println|real|recover)\b'),
      'TypeName',
    ),
    // Type names (uppercase start)
    TokenRule(RegExp(r'\b[A-Z][a-zA-Z0-9_]*\b'), 'TypeName'),
    // Identifiers
    TokenRule(RegExp(r'[a-zA-Z_]\w*'), 'Identifier'),
    // Operators
    TokenRule(RegExp(r'[+\-*/%&|^~<>=!:]+'), 'Operator'),
    // Punctuation
    TokenRule(RegExp(r'[{}()\[\];,.]'), 'Punctuation'),
  ],
  data: const LanguageData(
    commentTokens: CommentTokens(line: '//', block: (open: '/*', close: '*/')),
  ),
);
