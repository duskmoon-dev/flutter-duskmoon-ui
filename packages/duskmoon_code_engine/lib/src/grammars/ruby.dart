import '../language/language.dart';
import '../language/language_data.dart';
import '_registry.dart';

/// Tree-sitter ruby syntax and comment metadata.
LanguageSupport rubyLanguageSupport() {
  const support = LanguageSupport(
    language: Language(
        name: 'ruby',
        data: LanguageData(
          commentTokens: CommentTokens(line: '#'),
        )),
  );
  LanguageRegistry.register(support,
      extensions: ['rb', 'rake', 'gemspec'], mimeTypes: ['text/x-ruby']);
  return support;
}
