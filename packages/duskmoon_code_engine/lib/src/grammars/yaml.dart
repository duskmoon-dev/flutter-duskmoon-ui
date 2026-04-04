import '../language/language.dart';
import '../language/language_data.dart';
import '../language/stream_language.dart';
import '_registry.dart';

LanguageSupport? _cached;

void _ensureRegistered() {
  if (LanguageRegistry.byName('yaml') != null) return;
  _cached = _yamlStream.languageSupport(
    extensions: ['yaml', 'yml'],
    mimeTypes: ['text/yaml', 'application/yaml', 'application/x-yaml'],
  );
}

LanguageSupport yamlLanguageSupport() {
  _ensureRegistered();
  return _cached!;
}

final _yamlStream = StreamLanguage(
  name: 'yaml',
  rules: [
    // Line comments
    TokenRule(RegExp(r'#.*'), 'Comment'),
    // Document markers
    TokenRule(RegExp(r'^---$', multiLine: true), 'Punctuation'),
    TokenRule(RegExp(r'^\.\.\.$', multiLine: true), 'Punctuation'),
    // String literals (quoted)
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    TokenRule(RegExp(r"'(?:[^'\\]|\\.)*'"), 'String'),
    // Booleans and null
    TokenRule(
      RegExp(r'\b(true|false|yes|no|on|off|null|~)\b'),
      'Keyword',
    ),
    // Numbers (hex, float, int)
    TokenRule(RegExp(r'0x[0-9a-fA-F]+'), 'Number'),
    TokenRule(RegExp(r'\b\d+\.?\d*([eE][+-]?\d+)?\b'), 'Number'),
    // List markers
    TokenRule(RegExp(r'^\s*-\s', multiLine: true), 'Punctuation'),
    // Keys (word followed by colon)
    TokenRule(RegExp(r'[a-zA-Z_][a-zA-Z0-9_\-\.]*(?=\s*:)'), 'Key'),
    // Anchors and aliases
    TokenRule(RegExp(r'&[a-zA-Z_][a-zA-Z0-9_\-]*'), 'Annotation'),
    TokenRule(RegExp(r'\*[a-zA-Z_][a-zA-Z0-9_\-]*'), 'Annotation'),
    // Tags
    TokenRule(RegExp(r'![^\s,\[\]{]+'), 'TypeName'),
    // Identifiers
    TokenRule(RegExp(r'[a-zA-Z_][a-zA-Z0-9_\-\.]*'), 'Identifier'),
    // Operators
    TokenRule(RegExp(r'[:>|]+'), 'Operator'),
    // Punctuation
    TokenRule(RegExp(r'[{}\[\],]'), 'Punctuation'),
  ],
  data: const LanguageData(
    commentTokens: CommentTokens(line: '#'),
  ),
);
