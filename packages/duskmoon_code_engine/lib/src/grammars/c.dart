import '../language/language.dart';
import '../language/language_data.dart';
import '../language/stream_language.dart';
import '_registry.dart';

LanguageSupport? _cached;

void _ensureRegistered() {
  if (LanguageRegistry.byName('c') != null) return;
  _cached = _cStream.languageSupport(
    extensions: ['c', 'h', 'cpp', 'hpp', 'cc', 'cxx'],
    mimeTypes: ['text/x-csrc', 'text/x-c++src', 'text/x-chdr'],
  );
}

LanguageSupport cLanguageSupport() {
  _ensureRegistered();
  return _cached!;
}

final _cStream = StreamLanguage(
  name: 'c',
  rules: [
    // Line comments
    TokenRule(RegExp(r'//.*'), 'Comment'),
    // Block comments
    TokenRule(RegExp(r'/\*[\s\S]*?\*/'), 'Comment'),
    // Preprocessor directives
    TokenRule(
      RegExp(
          r'#\s*(include|define|undef|ifdef|ifndef|if|elif|else|endif|pragma|'
          r'error|warning|line)\b'),
      'Meta',
    ),
    // String literals
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    // Character literals
    TokenRule(RegExp(r"'(?:[^'\\]|\\.)'"), 'String'),
    // Numbers (hex, float, int with suffixes)
    TokenRule(RegExp(r'0x[0-9a-fA-F]+[uUlL]*'), 'Number'),
    TokenRule(RegExp(r'\b\d+\.?\d*([eE][+-]?\d+)?[fFlL]?\b'), 'Number'),
    // C++ keywords (after C keywords to avoid conflicts)
    TokenRule(
      RegExp(
          r'\b(auto|break|case|char|const|continue|default|do|double|else|enum|'
          r'extern|float|for|goto|if|inline|int|long|register|return|short|'
          r'signed|sizeof|static|struct|switch|typedef|union|unsigned|void|'
          r'volatile|while|class|namespace|template|virtual|public|private|'
          r'protected|new|delete|try|catch|throw|using|bool|true|false|nullptr|'
          r'override|final|constexpr|decltype|auto|noexcept)\b'),
      'Keyword',
    ),
    // Type names (uppercase start)
    TokenRule(RegExp(r'\b[A-Z][a-zA-Z0-9_]*\b'), 'TypeName'),
    // Identifiers
    TokenRule(RegExp(r'[a-zA-Z_]\w*'), 'Identifier'),
    // Operators
    TokenRule(RegExp(r'[+\-*/%&|^~<>=!?:]+'), 'Operator'),
    // Punctuation
    TokenRule(RegExp(r'[{}()\[\];,.]'), 'Punctuation'),
  ],
  data: const LanguageData(
    commentTokens: CommentTokens(line: '//', block: (open: '/*', close: '*/')),
  ),
);
