import '../language/language.dart';
import '../language/language_data.dart';
import '../language/stream_language.dart';
import '_registry.dart';

LanguageSupport? _cached;

void _ensureRegistered() {
  if (LanguageRegistry.byName('ruby') != null) return;
  _cached = _rubyStream.languageSupport(
    extensions: ['rb', 'rake', 'gemspec'],
    mimeTypes: ['text/x-ruby'],
  );
}

LanguageSupport rubyLanguageSupport() {
  _ensureRegistered();
  return _cached!;
}

final _rubyStream = StreamLanguage(
  name: 'ruby',
  rules: [
    // Block comments: =begin...=end
    TokenRule(RegExp(r'^=begin[\s\S]*?^=end', multiLine: true), 'Comment'),
    // Line comments
    TokenRule(RegExp(r'#.*'), 'Comment'),
    // Symbols: :name
    TokenRule(RegExp(r':[a-zA-Z_]\w*'), 'Atom'),
    // Class variables: @@name
    TokenRule(RegExp(r'@@[a-zA-Z_]\w*'), 'VariableName'),
    // Instance variables: @name
    TokenRule(RegExp(r'@[a-zA-Z_]\w*'), 'VariableName'),
    // String literals
    TokenRule(RegExp(r"'(?:[^'\\]|\\.)*'"), 'String'),
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    // Numbers
    TokenRule(RegExp(r'0[xX][0-9a-fA-F]+'), 'Number'),
    TokenRule(RegExp(r'\b\d+\.?\d*([eE][+-]?\d+)?\b'), 'Number'),
    // Keywords
    TokenRule(
      RegExp(r'\b(alias|and|begin|break|case|class|def|do|else|elsif|end|'
          r'ensure|false|for|if|in|module|next|nil|not|or|redo|rescue|retry|'
          r'return|self|super|then|true|undef|unless|until|when|while|yield|'
          r'require|include|private|protected|public|raise)\b'),
      'Keyword',
    ),
    // Constants (uppercase start)
    TokenRule(RegExp(r'\b[A-Z][a-zA-Z0-9_]*\b'), 'TypeName'),
    // Identifiers
    TokenRule(RegExp(r'[a-zA-Z_]\w*[!?]?'), 'Identifier'),
    // Operators
    TokenRule(RegExp(r'[+\-*/%&|^~<>=!?]+'), 'Operator'),
    // Punctuation
    TokenRule(RegExp(r'[{}()\[\];,.:@#]'), 'Punctuation'),
  ],
  data: const LanguageData(
    commentTokens: CommentTokens(line: '#'),
  ),
);
