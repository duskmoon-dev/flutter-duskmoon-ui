import '../language/language.dart';
import '../language/language_data.dart';
import '_registry.dart';

/// Tree-sitter javascript syntax and comment metadata.
LanguageSupport javascriptLanguageSupport() {
  const support = LanguageSupport(
    language: Language(
        name: 'javascript',
        data: LanguageData(
          commentTokens:
              CommentTokens(line: '//', block: (open: '/*', close: '*/')),
        )),
  );
  LanguageRegistry.register(support, extensions: [
    'js',
    'jsx',
    'ts',
    'tsx',
    'mjs'
  ], mimeTypes: [
    'text/javascript',
    'application/javascript',
    'text/typescript'
  ]);
  return support;
}
