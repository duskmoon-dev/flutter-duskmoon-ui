import '../language/language.dart';
import '../language/language_data.dart';
import '../language/stream_language.dart';
import '_registry.dart';

LanguageSupport? _cached;

void _ensureRegistered() {
  if (LanguageRegistry.byName('zig') != null) return;
  _cached = _zigStream.languageSupport(
    extensions: ['zig'],
    mimeTypes: ['text/x-zig'],
  );
}

LanguageSupport zigLanguageSupport() {
  _ensureRegistered();
  return _cached!;
}

final _zigStream = StreamLanguage(
  name: 'zig',
  rules: [
    // Line comments (before operators to catch //)
    TokenRule(RegExp(r'//.*'), 'Comment'),
    // Builtins: @name
    TokenRule(RegExp(r'@[a-zA-Z_]\w*'), 'Annotation'),
    // String literals
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    // Char literals
    TokenRule(RegExp(r"'(?:[^'\\]|\\.)*'"), 'String'),
    // Numbers
    TokenRule(RegExp(r'0[xX][0-9a-fA-F]+'), 'Number'),
    TokenRule(RegExp(r'0[oO][0-7]+'), 'Number'),
    TokenRule(RegExp(r'0[bB][01]+'), 'Number'),
    TokenRule(RegExp(r'\b\d+\.?\d*([eE][+-]?\d+)?\b'), 'Number'),
    // Built-in types
    TokenRule(
      RegExp(r'\b(bool|f16|f32|f64|i8|i16|i32|i64|u8|u16|u32|u64|'
          r'usize|isize|void|type)\b'),
      'TypeName',
    ),
    // Keywords
    TokenRule(
      RegExp(r'\b(addrspace|align|allowzero|and|anyframe|anytype|asm|async|'
          r'await|break|catch|comptime|const|continue|defer|else|enum|'
          r'errdefer|error|export|extern|false|fn|for|if|inline|noalias|null|'
          r'opaque|or|orelse|packed|pub|resume|return|struct|suspend|switch|'
          r'test|true|try|undefined|union|unreachable|var|volatile|while)\b'),
      'Keyword',
    ),
    // Identifiers
    TokenRule(RegExp(r'[a-zA-Z_]\w*'), 'Identifier'),
    // Operators
    TokenRule(RegExp(r'[+\-*/%&|^~<>=!?]+'), 'Operator'),
    // Punctuation
    TokenRule(RegExp(r'[{}()\[\];,.:@#]'), 'Punctuation'),
  ],
  data: const LanguageData(
    commentTokens: CommentTokens(line: '//'),
  ),
);
