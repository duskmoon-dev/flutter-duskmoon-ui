import '../language/language.dart';
import '../language/language_data.dart';
import '../language/stream_language.dart';
import '_registry.dart';

LanguageSupport? _cached;

void _ensureRegistered() {
  if (LanguageRegistry.byName('dart') != null) return;
  _cached = _dartStream.languageSupport(
    extensions: ['dart'],
    mimeTypes: ['application/dart', 'text/x-dart'],
  );
}

LanguageSupport dartLanguageSupport() {
  _ensureRegistered();
  return _cached!;
}

final _dartStream = StreamLanguage(
  name: 'dart',
  rules: [
    // Line comments (before operators to catch //)
    TokenRule(RegExp(r'///.*'), 'Comment'),
    TokenRule(RegExp(r'//.*'), 'Comment'),
    // Annotations
    TokenRule(RegExp(r'@[a-zA-Z_]\w*'), 'Annotation'),
    // String literals
    TokenRule(RegExp(r"'(?:[^'\\]|\\.)*'"), 'String'),
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    // Numbers
    TokenRule(RegExp(r'0x[0-9a-fA-F]+'), 'Number'),
    TokenRule(RegExp(r'\b\d+\.?\d*([eE][+-]?\d+)?\b'), 'Number'),
    // Keywords
    TokenRule(
      RegExp(r'\b(abstract|as|assert|async|await|base|break|case|catch|class|'
          r'const|continue|covariant|default|deferred|do|dynamic|else|enum|'
          r'export|extends|extension|external|factory|false|final|finally|'
          r'for|Function|get|hide|if|implements|import|in|interface|is|late|'
          r'library|mixin|new|null|on|operator|part|required|rethrow|return|'
          r'sealed|set|show|static|super|switch|sync|this|throw|true|try|'
          r'typedef|var|void|when|while|with|yield)\b'),
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
