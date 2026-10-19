import 'package:duskmoon_highlight/tree_sitter.dart';

import '../state/extension.dart';
import 'language_data.dart';
import 'syntax.dart';

/// A Tree-sitter language identifier with editor metadata.
class Language {
  const Language({required this.name, this.data = const LanguageData()});
  final String name;
  final LanguageData data;
}

class LanguageSupport {
  const LanguageSupport({required this.language, this.support = const []});
  final Language language;
  final List<Extension> support;

  /// Load the WebAssembly parser before creating raw editor states on web.
  /// Controllers and widgets initialize automatically.
  Future<void> ensureInitialized() =>
      TreeSitterRuntime.ensureInitialized(languages: {language.name});

  Extension get extension => ExtensionGroup([
        syntaxLanguage.of(language),
        syntaxStateField,
        ...support,
      ]);
}

/// Resolve any grammar shipped by the shared Tree-sitter runtime.
LanguageSupport? treeSitterLanguageSupport(String identifier) {
  final canonical = TreeSitterRuntime.resolveLanguage(identifier);
  return canonical == null
      ? null
      : LanguageSupport(language: Language(name: canonical));
}
