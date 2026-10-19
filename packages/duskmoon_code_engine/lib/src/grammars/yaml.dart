import '../language/language.dart';
import '../language/language_data.dart';
import '_registry.dart';

/// Tree-sitter yaml syntax and comment metadata.
LanguageSupport yamlLanguageSupport() {
  const support = LanguageSupport(
    language: Language(
        name: 'yaml',
        data: LanguageData(
          commentTokens: CommentTokens(line: '#'),
        )),
  );
  LanguageRegistry.register(support,
      extensions: ['yaml', 'yml'],
      mimeTypes: ['text/yaml', 'application/yaml', 'application/x-yaml']);
  return support;
}
