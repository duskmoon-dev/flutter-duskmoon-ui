import '../language/language.dart';
import '../language/language_data.dart';
import '_registry.dart';

/// Tree-sitter go syntax and comment metadata.
LanguageSupport goLanguageSupport() {
  const support = LanguageSupport(
    language: Language(
        name: 'go',
        data: LanguageData(
          commentTokens:
              CommentTokens(line: '//', block: (open: '/*', close: '*/')),
        )),
  );
  LanguageRegistry.register(support,
      extensions: ['go'], mimeTypes: ['text/x-go', 'application/x-go']);
  return support;
}
