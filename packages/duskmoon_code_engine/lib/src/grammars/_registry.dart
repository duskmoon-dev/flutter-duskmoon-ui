import 'package:duskmoon_highlight/tree_sitter.dart';
import '../language/language.dart';
import 'c.dart';
import 'cpp.dart';
import 'css.dart';
import 'dart.dart';
import 'elixir.dart';
import 'erlang.dart';
import 'go.dart';
import 'html.dart';
import 'java.dart';
import 'javascript.dart';
import 'json.dart';
import 'jsx.dart';
import 'kotlin.dart';
import 'markdown.dart';
import 'php.dart';
import 'python.dart';
import 'ruby.dart';
import 'rust.dart';
import 'swift.dart';
import 'tsx.dart';
import 'typescript.dart';
import 'yaml.dart';
import 'zig.dart';

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

  static LanguageSupport? byName(String name) =>
      _byName[name] ??
      _builtin(TreeSitterRuntime.resolveLanguage(name) ?? name);
  static LanguageSupport? byExtension(String ext) =>
      _byExtension[ext] ?? byName(ext);
  static LanguageSupport? byMimeType(String mime) => _byMimeType[mime];
  static List<String> get names => List.unmodifiable({
        ...TreeSitterRuntime.languages,
        ..._byName.keys,
      });
  static LanguageSupport? _builtin(String name) => switch (name) {
        'jsx' => jsxLanguageSupport(),
        'php' => phpLanguageSupport(),
        'swift' => swiftLanguageSupport(),
        'yaml' => yamlLanguageSupport(),
        'dart' => dartLanguageSupport(),
        'kotlin' => kotlinLanguageSupport(),
        'c' => cLanguageSupport(),
        'erlang' => erlangLanguageSupport(),
        'java' => javaLanguageSupport(),
        'go' => goLanguageSupport(),
        'cpp' => cppLanguageSupport(),
        'css' => cssLanguageSupport(),
        'html' => htmlLanguageSupport(),
        'json' => jsonLanguageSupport(),
        'markdown' => markdownLanguageSupport(),
        'javascript' => javascriptLanguageSupport(),
        'tsx' => tsxLanguageSupport(),
        'elixir' => elixirLanguageSupport(),
        'python' => pythonLanguageSupport(),
        'ruby' => rubyLanguageSupport(),
        'zig' => zigLanguageSupport(),
        'rust' => rustLanguageSupport(),
        'typescript' => typescriptLanguageSupport(),
        _ => treeSitterLanguageSupport(name),
      };
  static void clear() {
    _byName.clear();
    _byExtension.clear();
    _byMimeType.clear();
  }
}
