import '../language/language.dart';
import '../language/language_data.dart';
import '../language/stream_language.dart';
import '_registry.dart';

LanguageSupport? _cached;

void _ensureRegistered() {
  if (LanguageRegistry.byName('markdown') != null) return;
  _cached = _markdownStream.languageSupport(
    extensions: ['md', 'markdown'],
    mimeTypes: ['text/markdown', 'text/x-markdown'],
  );
}

LanguageSupport markdownLanguageSupport() {
  _ensureRegistered();
  return _cached!;
}

final _markdownStream = StreamLanguage(
  name: 'markdown',
  rules: [
    // Headings
    TokenRule(RegExp(r'^#{1,6}\s.*', multiLine: true), 'Heading'),
    // Bold
    TokenRule(RegExp(r'\*\*(?:[^*]|\*(?!\*))+\*\*'), 'Strong'),
    TokenRule(RegExp(r'__(?:[^_]|_(?!_))+__'), 'Strong'),
    // Italic
    TokenRule(RegExp(r'\*(?:[^*])+\*'), 'Emphasis'),
    TokenRule(RegExp(r'_(?:[^_])+_'), 'Emphasis'),
    // Inline code
    TokenRule(RegExp(r'`[^`]+`'), 'Code'),
    // Fenced code blocks
    TokenRule(RegExp(r'```[\s\S]*?```'), 'Code'),
    // Links and images
    TokenRule(RegExp(r'!?\[[^\]]*\]\([^)]*\)'), 'Link'),
    // List markers
    TokenRule(RegExp(r'^\s*[-*+]\s', multiLine: true), 'Punctuation'),
    TokenRule(RegExp(r'^\s*\d+\.\s', multiLine: true), 'Punctuation'),
    // Horizontal rule
    TokenRule(RegExp(r'^[-*_]{3,}\s*$', multiLine: true), 'Punctuation'),
    // Block quote
    TokenRule(RegExp(r'^>\s', multiLine: true), 'Operator'),
  ],
  data: const LanguageData(),
);
