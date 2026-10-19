import '../language/language.dart';
import '../language/language_data.dart';
import '_registry.dart';

/// Tree-sitter php syntax and comment metadata.
LanguageSupport phpLanguageSupport() {
  const support = LanguageSupport(
    language: Language(
        name: 'php',
        data: LanguageData(
          commentTokens:
              CommentTokens(line: '//', block: (open: '/*', close: '*/')),
        )),
  );
  LanguageRegistry.register(support,
      extensions: ['php', 'phtml'],
      mimeTypes: ['text/x-php', 'application/x-httpd-php']);
  return support;
}
