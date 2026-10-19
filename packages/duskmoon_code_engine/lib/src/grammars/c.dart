import '../language/language.dart';
import '../language/language_data.dart';
import '_registry.dart';

/// Tree-sitter c syntax and comment metadata.
LanguageSupport cLanguageSupport() {
  const support = LanguageSupport(
    language: Language(
        name: 'c',
        data: LanguageData(
          commentTokens:
              CommentTokens(line: '//', block: (open: '/*', close: '*/')),
        )),
  );
  LanguageRegistry.register(support,
      extensions: ['c', 'h', 'cpp', 'hpp', 'cc', 'cxx'],
      mimeTypes: ['text/x-csrc', 'text/x-c++src', 'text/x-chdr']);
  return support;
}
