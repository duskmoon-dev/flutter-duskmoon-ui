import '../language/language.dart';
import '../language/language_data.dart';
import '_registry.dart';

LanguageSupport tsxLanguageSupport() {
  const support = LanguageSupport(
    language: Language(
        name: 'tsx',
        data: LanguageData(
          commentTokens:
              CommentTokens(line: '//', block: (open: '/*', close: '*/')),
        )),
  );
  LanguageRegistry.register(support,
      extensions: ['tsx'], mimeTypes: const <String>[]);
  return support;
}
