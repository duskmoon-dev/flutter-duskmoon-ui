import '../language/language.dart';
import '../language/language_data.dart';
import '_registry.dart';

/// Tree-sitter markdown syntax and comment metadata.
LanguageSupport markdownLanguageSupport() {
  const support = LanguageSupport(
    language: Language(name: 'markdown', data: LanguageData()),
  );
  LanguageRegistry.register(support,
      extensions: ['md', 'markdown'],
      mimeTypes: ['text/markdown', 'text/x-markdown']);
  return support;
}
