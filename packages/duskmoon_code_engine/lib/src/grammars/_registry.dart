import '../language/language.dart';

class LanguageRegistry {
  LanguageRegistry._();

  static final _byName = <String, LanguageSupport>{};
  static final _byExtension = <String, LanguageSupport>{};
  static final _byMimeType = <String, LanguageSupport>{};

  static void register(
    LanguageSupport support, {
    List<String> extensions = const [],
    List<String> mimeTypes = const [],
  }) {
    _byName[support.language.name] = support;
    for (final ext in extensions) {
      _byExtension[ext] = support;
    }
    for (final mime in mimeTypes) {
      _byMimeType[mime] = support;
    }
  }

  static LanguageSupport? byName(String name) => _byName[name];
  static LanguageSupport? byExtension(String ext) => _byExtension[ext];
  static LanguageSupport? byMimeType(String mime) => _byMimeType[mime];
  static List<String> get names => List.unmodifiable(_byName.keys);

  static void clear() {
    _byName.clear();
    _byExtension.clear();
    _byMimeType.clear();
  }
}
