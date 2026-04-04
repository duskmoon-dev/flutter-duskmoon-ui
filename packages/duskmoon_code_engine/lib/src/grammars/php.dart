import '../language/language.dart';
import '../language/language_data.dart';
import '../language/stream_language.dart';
import '_registry.dart';

LanguageSupport? _cached;

void _ensureRegistered() {
  if (LanguageRegistry.byName('php') != null) return;
  _cached = _phpStream.languageSupport(
    extensions: ['php', 'phtml'],
    mimeTypes: ['text/x-php', 'application/x-httpd-php'],
  );
}

LanguageSupport phpLanguageSupport() {
  _ensureRegistered();
  return _cached!;
}

final _phpStream = StreamLanguage(
  name: 'php',
  rules: [
    // Line comments (before operators to catch //)
    TokenRule(RegExp(r'//.*'), 'Comment'),
    // Hash comments
    TokenRule(RegExp(r'#.*'), 'Comment'),
    // Block comments
    TokenRule(RegExp(r'/\*[\s\S]*?\*/'), 'Comment'),
    // Variables
    TokenRule(RegExp(r'\$[a-zA-Z_]\w*'), 'VariableName'),
    // String literals
    TokenRule(RegExp(r"'(?:[^'\\]|\\.)*'"), 'String'),
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    // Numbers
    TokenRule(RegExp(r'0[xX][0-9a-fA-F]+'), 'Number'),
    TokenRule(RegExp(r'\b\d+\.?\d*([eE][+-]?\d+)?\b'), 'Number'),
    // Keywords
    TokenRule(
      RegExp(r'\b(abstract|and|array|as|break|callable|case|catch|class|'
          r'clone|const|continue|default|do|echo|else|elseif|empty|extends|'
          r'false|final|finally|fn|for|foreach|function|global|if|implements|'
          r'import|instanceof|interface|isset|list|match|namespace|new|null|'
          r'or|print|private|protected|public|readonly|require|return|static|'
          r'switch|throw|trait|true|try|unset|use|var|void|while|xor|yield)\b'),
      'Keyword',
    ),
    // Type names (uppercase start)
    TokenRule(RegExp(r'\b[A-Z][a-zA-Z0-9_]*\b'), 'TypeName'),
    // Identifiers
    TokenRule(RegExp(r'[a-zA-Z_]\w*'), 'Identifier'),
    // Operators
    TokenRule(RegExp(r'[+\-*/%&|^~<>=!?]+'), 'Operator'),
    // Punctuation
    TokenRule(RegExp(r'[{}()\[\];,.:@#$]'), 'Punctuation'),
  ],
  data: const LanguageData(
    commentTokens: CommentTokens(line: '//', block: (open: '/*', close: '*/')),
  ),
);
