import '../language/language.dart';
import '../language/language_data.dart';
import '_registry.dart';

/// Tree-sitter kotlin syntax and comment metadata.
LanguageSupport kotlinLanguageSupport() {
  const support = LanguageSupport(
    language: Language(
        name: 'kotlin',
        data: LanguageData(
          commentTokens:
              CommentTokens(line: '//', block: (open: '/*', close: '*/')),
        )),
  );
  LanguageRegistry.register(support,
      extensions: ['kt', 'kts'], mimeTypes: ['text/x-kotlin']);
  return support;
}
