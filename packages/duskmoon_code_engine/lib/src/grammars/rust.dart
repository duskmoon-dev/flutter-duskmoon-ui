import '../language/language.dart';
import '../language/language_data.dart';
import '_registry.dart';

/// Tree-sitter rust syntax and comment metadata.
LanguageSupport rustLanguageSupport() {
  const support = LanguageSupport(
    language: Language(
        name: 'rust',
        data: LanguageData(
          commentTokens:
              CommentTokens(line: '//', block: (open: '/*', close: '*/')),
        )),
  );
  LanguageRegistry.register(support,
      extensions: ['rs'], mimeTypes: ['text/x-rustsrc', 'application/x-rust']);
  return support;
}
