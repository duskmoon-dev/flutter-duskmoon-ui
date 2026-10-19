import '../language/language.dart';
import '../language/language_data.dart';
import '_registry.dart';

/// Tree-sitter python syntax and comment metadata.
LanguageSupport pythonLanguageSupport() {
  const support = LanguageSupport(
    language: Language(
        name: 'python',
        data: LanguageData(
          commentTokens: CommentTokens(line: '#'),
        )),
  );
  LanguageRegistry.register(support,
      extensions: ['py'], mimeTypes: ['text/x-python', 'application/x-python']);
  return support;
}
