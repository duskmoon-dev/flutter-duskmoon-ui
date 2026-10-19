import '../language/language.dart';
import '../language/language_data.dart';
import '_registry.dart';

/// Tree-sitter dart syntax and comment metadata.
LanguageSupport dartLanguageSupport() {
  const support = LanguageSupport(
    language: Language(
        name: 'dart',
        data: LanguageData(
          commentTokens:
              CommentTokens(line: '//', block: (open: '/*', close: '*/')),
        )),
  );
  LanguageRegistry.register(support,
      extensions: ['dart'], mimeTypes: ['application/dart', 'text/x-dart']);
  return support;
}
