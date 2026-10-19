import '../language/language.dart';
import '../language/language_data.dart';
import '_registry.dart';

/// Tree-sitter swift syntax and comment metadata.
LanguageSupport swiftLanguageSupport() {
  const support = LanguageSupport(
    language: Language(
        name: 'swift',
        data: LanguageData(
          commentTokens:
              CommentTokens(line: '//', block: (open: '/*', close: '*/')),
        )),
  );
  LanguageRegistry.register(support,
      extensions: ['swift'], mimeTypes: ['text/x-swift']);
  return support;
}
