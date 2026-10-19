import '../language/language.dart';
import '../language/language_data.dart';
import '_registry.dart';

/// Tree-sitter java syntax and comment metadata.
LanguageSupport javaLanguageSupport() {
  const support = LanguageSupport(
    language: Language(
        name: 'java',
        data: LanguageData(
          commentTokens:
              CommentTokens(line: '//', block: (open: '/*', close: '*/')),
        )),
  );
  LanguageRegistry.register(support,
      extensions: ['java'], mimeTypes: ['text/x-java']);
  return support;
}
