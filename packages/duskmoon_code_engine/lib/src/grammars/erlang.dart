import '../language/language.dart';
import '../language/language_data.dart';
import '_registry.dart';

/// Tree-sitter erlang syntax and comment metadata.
LanguageSupport erlangLanguageSupport() {
  const support = LanguageSupport(
    language: Language(
        name: 'erlang',
        data: LanguageData(
          commentTokens: CommentTokens(line: '%'),
        )),
  );
  LanguageRegistry.register(support,
      extensions: ['erl', 'hrl'], mimeTypes: ['text/x-erlang']);
  return support;
}
