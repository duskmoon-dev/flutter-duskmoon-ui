import '../language/language.dart';
import '../language/language_data.dart';
import '_registry.dart';

LanguageSupport jsxLanguageSupport() {
  const support = LanguageSupport(
    language: Language(
        name: 'jsx',
        data: LanguageData(
          commentTokens:
              CommentTokens(line: '//', block: (open: '/*', close: '*/')),
        )),
  );
  LanguageRegistry.register(support,
      extensions: ['jsx'], mimeTypes: const <String>[]);
  return support;
}
