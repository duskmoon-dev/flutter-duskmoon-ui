import '../language/language.dart';
import '../language/language_data.dart';
import '_registry.dart';

/// Tree-sitter elixir syntax and comment metadata.
LanguageSupport elixirLanguageSupport() {
  const support = LanguageSupport(
    language: Language(
        name: 'elixir',
        data: LanguageData(
          commentTokens: CommentTokens(line: '#'),
        )),
  );
  LanguageRegistry.register(support,
      extensions: ['ex', 'exs'],
      mimeTypes: ['text/x-elixir', 'application/x-elixir']);
  return support;
}
