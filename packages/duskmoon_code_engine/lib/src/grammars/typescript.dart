import '../language/language.dart';
import '../language/language_data.dart';
import '_registry.dart';

LanguageSupport typescriptLanguageSupport() {
  const support = LanguageSupport(
    language: Language(
        name: 'typescript',
        data: LanguageData(
          commentTokens:
              CommentTokens(line: '//', block: (open: '/*', close: '*/')),
        )),
  );
  LanguageRegistry.register(support,
      extensions: ['typescript'], mimeTypes: const <String>[]);
  return support;
}
