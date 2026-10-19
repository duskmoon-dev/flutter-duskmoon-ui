import '../language/language.dart';
import '../language/language_data.dart';
import '_registry.dart';

LanguageSupport cppLanguageSupport() {
  const support = LanguageSupport(
    language: Language(
        name: 'cpp',
        data: LanguageData(
          commentTokens:
              CommentTokens(line: '//', block: (open: '/*', close: '*/')),
        )),
  );
  LanguageRegistry.register(support,
      extensions: ['cpp'], mimeTypes: const <String>[]);
  return support;
}
