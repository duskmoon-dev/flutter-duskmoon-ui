import '../language/language.dart';
import '../language/language_data.dart';
import '_registry.dart';

/// Tree-sitter html syntax and comment metadata.
LanguageSupport htmlLanguageSupport() {
  const support = LanguageSupport(
    language: Language(
        name: 'html',
        data: LanguageData(
          commentTokens: CommentTokens(block: (open: '<!--', close: '-->')),
        )),
  );
  LanguageRegistry.register(support,
      extensions: ['html', 'htm'], mimeTypes: ['text/html']);
  return support;
}
