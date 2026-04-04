import '../language/language.dart';
import '../language/language_data.dart';
import '../language/stream_language.dart';
import '_registry.dart';

LanguageSupport? _cached;

void _ensureRegistered() {
  if (LanguageRegistry.byName('rust') != null) return;
  _cached = _rustStream.languageSupport(
    extensions: ['rs'],
    mimeTypes: ['text/x-rustsrc', 'application/x-rust'],
  );
}

LanguageSupport rustLanguageSupport() {
  _ensureRegistered();
  return _cached!;
}

final _rustStream = StreamLanguage(
  name: 'rust',
  rules: [
    // Doc comments
    TokenRule(RegExp(r'///.*'), 'Comment'),
    TokenRule(RegExp(r'//.*'), 'Comment'),
    // Block comments
    TokenRule(RegExp(r'/\*[\s\S]*?\*/'), 'Comment'),
    // Attribute macros #[...] and #![...]
    TokenRule(RegExp(r'#!?\[[^\]]*\]'), 'Annotation'),
    // Raw strings r"..." r#"..."#
    TokenRule(RegExp(r'r#+?"[\s\S]*?"#+?'), 'String'),
    // String literals
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    // Character literals
    TokenRule(RegExp(r"'(?:[^'\\]|\\.)'"), 'String'),
    // Lifetimes 'a (before regular strings to avoid conflict)
    TokenRule(RegExp(r"'[a-zA-Z_]\w*\b"), 'TypeName'),
    // Numbers (hex, binary, octal, float, int with suffixes)
    TokenRule(RegExp(r'0x[0-9a-fA-F_]+'), 'Number'),
    TokenRule(RegExp(r'0b[01_]+'), 'Number'),
    TokenRule(RegExp(r'0o[0-7_]+'), 'Number'),
    TokenRule(RegExp(r'\b\d[\d_]*\.?\d*(([eE][+-]?\d+)?[a-z]*)?\b'), 'Number'),
    // Keywords
    TokenRule(
      RegExp(
          r'\b(as|async|await|break|const|continue|crate|dyn|else|enum|extern|'
          r'false|fn|for|if|impl|in|let|loop|match|mod|move|mut|pub|ref|return|'
          r'self|Self|static|struct|super|trait|true|type|unsafe|use|where|while)\b'),
      'Keyword',
    ),
    // Built-in types
    TokenRule(
      RegExp(
          r'\b(bool|char|f32|f64|i8|i16|i32|i64|i128|isize|str|u8|u16|u32|u64|'
          r'u128|usize)\b'),
      'TypeName',
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
