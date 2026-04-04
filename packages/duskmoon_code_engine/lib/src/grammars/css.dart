import '../language/language.dart';
import '../language/language_data.dart';
import '../language/stream_language.dart';
import '_registry.dart';

LanguageSupport? _cached;

void _ensureRegistered() {
  if (LanguageRegistry.byName('css') != null) return;
  _cached = _cssStream.languageSupport(
    extensions: ['css', 'scss', 'less'],
    mimeTypes: ['text/css', 'text/x-scss', 'text/x-less'],
  );
}

LanguageSupport cssLanguageSupport() {
  _ensureRegistered();
  return _cached!;
}

final _cssStream = StreamLanguage(
  name: 'css',
  rules: [
    // Block comments
    TokenRule(RegExp(r'/\*[\s\S]*?\*/'), 'Comment'),
    // At-rules
    TokenRule(
      RegExp(r'@(media|import|keyframes|font-face|charset|namespace|supports|'
          r'page|layer|container|property|color-profile|counter-style)\b'),
      'Keyword',
    ),
    // Color hex values
    TokenRule(RegExp(r'#[0-9a-fA-F]{3,8}\b'), 'Atom'),
    // String literals
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    TokenRule(RegExp(r"'(?:[^'\\]|\\.)*'"), 'String'),
    // Numbers with units
    TokenRule(RegExp(r'\b\d+\.?\d*(px|em|rem|vh|vw|%|pt|cm|mm|s|ms|deg|fr)?\b'),
        'Number'),
    // Class selectors
    TokenRule(RegExp(r'\.[a-zA-Z_-][a-zA-Z0-9_-]*'), 'TypeName'),
    // ID selectors
    TokenRule(RegExp(r'#[a-zA-Z_-][a-zA-Z0-9_-]*'), 'Atom'),
    // Property names (word followed by colon)
    TokenRule(RegExp(r'[a-zA-Z_-][a-zA-Z0-9_-]*(?=\s*:)'), 'Identifier'),
    // Identifiers
    TokenRule(RegExp(r'[a-zA-Z_-][a-zA-Z0-9_-]*'), 'Identifier'),
    // Operators
    TokenRule(RegExp(r'[+>~*=|^$!]+'), 'Operator'),
    // Punctuation
    TokenRule(RegExp(r'[{}()\[\];:,.]'), 'Punctuation'),
  ],
  data: const LanguageData(
    commentTokens: CommentTokens(block: (open: '/*', close: '*/')),
  ),
);
