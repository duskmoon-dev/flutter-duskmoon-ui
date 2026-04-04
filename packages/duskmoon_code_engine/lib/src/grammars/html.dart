import '../language/language.dart';
import '../language/language_data.dart';
import '../language/stream_language.dart';
import '_registry.dart';

LanguageSupport? _cached;

void _ensureRegistered() {
  if (LanguageRegistry.byName('html') != null) return;
  _cached = _htmlStream.languageSupport(
    extensions: ['html', 'htm'],
    mimeTypes: ['text/html'],
  );
}

LanguageSupport htmlLanguageSupport() {
  _ensureRegistered();
  return _cached!;
}

final _htmlStream = StreamLanguage(
  name: 'html',
  rules: [
    // HTML comments
    TokenRule(RegExp(r'<!--[\s\S]*?-->'), 'Comment'),
    // Doctype
    TokenRule(RegExp(r'<!DOCTYPE[^>]*>', caseSensitive: false), 'Meta'),
    // Closing tags
    TokenRule(RegExp(r'</[a-zA-Z][a-zA-Z0-9\-]*\s*>'), 'TagName'),
    // Opening tags (just the tag name portion)
    TokenRule(RegExp(r'<[a-zA-Z][a-zA-Z0-9\-]*'), 'TagName'),
    // Self-closing and closing angle brackets
    TokenRule(RegExp(r'/?>'), 'Punctuation'),
    // Attribute values (quoted)
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    TokenRule(RegExp(r"'(?:[^'\\]|\\.)*'"), 'String'),
    // HTML entities
    TokenRule(RegExp(r'&[a-zA-Z]+;|&#\d+;|&#x[0-9a-fA-F]+;'), 'Atom'),
    // Attribute names
    TokenRule(RegExp(r'[a-zA-Z_:][a-zA-Z0-9_:\-\.]*'), 'Identifier'),
    // Operators (=)
    TokenRule(RegExp(r'='), 'Operator'),
    // Punctuation
    TokenRule(RegExp(r'[<>{}]'), 'Punctuation'),
  ],
  data: const LanguageData(
    commentTokens: CommentTokens(block: (open: '<!--', close: '-->')),
  ),
);
