import '../language/language.dart';
import '../language/language_data.dart';
import '_registry.dart';

/// Tree-sitter json syntax and comment metadata.
LanguageSupport jsonLanguageSupport() {
  const support = LanguageSupport(
    language: Language(name: 'json', data: LanguageData()),
  );
  LanguageRegistry.register(support,
      extensions: ['json'], mimeTypes: ['application/json']);
  return support;
}
