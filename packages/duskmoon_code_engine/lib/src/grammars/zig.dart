import '../language/language.dart';
import '../language/language_data.dart';
import '_registry.dart';

/// Tree-sitter zig syntax and comment metadata.
LanguageSupport zigLanguageSupport() {
  const support = LanguageSupport(
    language: Language(
        name: 'zig',
        data: LanguageData(
          commentTokens: CommentTokens(line: '//'),
        )),
  );
  LanguageRegistry.register(support,
      extensions: ['zig'], mimeTypes: ['text/x-zig']);
  return support;
}
