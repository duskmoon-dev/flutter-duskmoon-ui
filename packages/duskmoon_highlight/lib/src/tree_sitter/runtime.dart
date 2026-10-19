import 'generated/grammars.dart';
import 'model.dart';
import 'native.dart' if (dart.library.js_interop) 'web.dart' as backend;

/// Initializes bundled official parsers. Web consumers await initialization
/// before creating synchronous parsing/highlighting sessions.
abstract final class TreeSitterRuntime {
  static String? resolveLanguage(String language) {
    final name = language.toLowerCase();
    return treeSitterGrammarData.containsKey(name)
        ? name
        : treeSitterAliases[name];
  }

  static List<String> get languages =>
      List.unmodifiable(treeSitterGrammarData.keys);

  static bool isInitialized(String language) {
    final canonical = resolveLanguage(language);
    return canonical != null && backend.isInitialized(canonical);
  }

  /// An empty set initializes only the runtime, without loading grammars on web.
  static Future<void> ensureInitialized({Set<String> languages = const {}}) {
    final canonical = <String>{};
    for (final language in languages) {
      final id = resolveLanguage(language);
      if (id == null) throw ArgumentError.value(language, 'languages');
      canonical.add(id);
    }
    return backend.ensureInitialized(canonical);
  }
}

/// An owned incremental parser. Dispose sessions when their editor is closed.
final class TreeSitterSession {
  final backend.Session _session;

  TreeSitterSession({required String language})
      : _session = backend.Session(
          TreeSitterRuntime.resolveLanguage(language) ??
              (throw ArgumentError.value(language, 'language')),
        );

  SyntaxSnapshot parse(String source) => _session.parse(source);

  void dispose() => _session.dispose();
}
