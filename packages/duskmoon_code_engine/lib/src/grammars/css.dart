import '../language/language.dart';
import '../language/language_data.dart';
import '_registry.dart';

/// Tree-sitter css syntax and comment metadata.
LanguageSupport cssLanguageSupport() {
  const support = LanguageSupport(
    language: Language(
        name: 'css',
        data: LanguageData(
          commentTokens: CommentTokens(block: (open: '/*', close: '*/')),
        )),
  );
  LanguageRegistry.register(support,
      extensions: ['css', 'scss', 'less'],
      mimeTypes: ['text/css', 'text/x-scss', 'text/x-less']);
  return support;
}
