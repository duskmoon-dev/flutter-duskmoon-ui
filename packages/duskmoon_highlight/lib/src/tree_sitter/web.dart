import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'edit.dart';
import 'generated/grammars.dart';
import 'model.dart';

@JS('document')
external _Document get _document;
@JS('duskmoonTreeSitter.Parser')
external JSFunction get _parserConstructor;
@JS('duskmoonTreeSitter.Language')
external JSObject get _languageClass;
@JS('duskmoonTreeSitter.Query')
external JSFunction get _queryConstructor;
@JS('Object.keys')
external JSArray<JSString> _keys(JSObject value);
@JS('fetch')
external JSPromise<_Response> _fetch(String url);

extension type _Response(JSObject _) implements JSObject {
  external bool get ok;
  external int get status;
  external JSPromise<JSArrayBuffer> arrayBuffer();
}

extension type _Document(JSObject _) implements JSObject {
  external _Script createElement(String tag);
  external JSObject get head;
  external String get baseURI;
}

extension type _Script(JSObject _) implements JSObject {
  external set type(String value);
  external set src(String value);
  external set onload(JSFunction value);
  external set onerror(JSFunction value);
}

extension type _Parser(JSObject _) implements JSObject {
  external void setLanguage(JSObject language);
  external _Tree? parse(String source, [_Tree? oldTree]);
  external void delete();
}

extension type _Tree(JSObject _) implements JSObject {
  external _Node get rootNode;
  external void edit(JSObject edit);
  external void delete();
}

extension type _Node(JSObject _) implements JSObject {
  external String get type;
  external int get startIndex;
  external int get endIndex;
  external bool get isNamed;
  external bool get hasError;
  external JSArray<_Node> get children;
}

extension type _Query(JSObject _) implements JSObject {
  external JSArray<_Match> matches(_Node root);
  external JSArray<JSArray<JSObject>> get predicates;
  external JSArray<JSObject?> get assertedProperties;
  external JSArray<JSObject?> get refutedProperties;
  external bool didExceedMatchLimit();
  external void delete();
}

extension type _Match(JSObject _) implements JSObject {
  external int get patternIndex;
  external JSArray<_Capture> get captures;
  external JSObject? get setProperties;
}

extension type _Capture(JSObject _) implements JSObject {
  external String get name;
  external _Node get node;
}

final _languages = <String, JSObject>{};
final _loading = <String, Future<void>>{};
Future<void>? _initializing;

bool isInitialized(String language) => _languages.containsKey(language);

String _asset(String path) => Uri.parse(_document.baseURI)
    .resolve('assets/packages/duskmoon_highlight/$path')
    .toString();

Future<void> _initialize() async {
  final loaded = Completer<void>();
  final script = _document.createElement('script');
  script.type = 'module';
  script.src = _asset('assets/tree-sitter/duskmoon-tree-sitter.js');
  script.onload = ((JSAny? event) => loaded.complete()).toJS;
  script.onerror = ((JSAny? event) {
    loaded
        .completeError(StateError('Could not load bundled Tree-sitter module'));
  }).toJS;
  _document.head.callMethod<JSAny?>('appendChild'.toJS, script);
  await loaded.future;
  final options = JSObject();
  options.setProperty(
      'locateFile'.toJS,
      ((JSAny? file, JSAny? prefix) =>
          _asset('assets/tree-sitter/web-tree-sitter.wasm').toJS).toJS);
  await _parserConstructor
      .callMethod<JSPromise<JSAny?>>(
        'init'.toJS,
        options,
      )
      .toDart;
}

Future<void> ensureInitialized(Set<String> languages) async {
  try {
    await (_initializing ??= _initialize());
  } catch (_) {
    _initializing = null;
    rethrow;
  }
  await Future.wait([
    for (final language in languages)
      _loading.putIfAbsent(language, () async {
        try {
          final url = _asset(treeSitterGrammarData[language]!.wasmAsset);
          final response = await _fetch(url).toDart;
          if (!response.ok) {
            throw StateError('Could not load Tree-sitter grammar $language '
                '(HTTP ${response.status}): $url');
          }
          // Passing bytes uses the official asynchronous instantiation path.
          // Its URL/streaming path instantiates a compiled module synchronously,
          // which Chrome disallows above 8 MB on the browser's main thread.
          final bytes = JSUint8Array(await response.arrayBuffer().toDart);
          _languages[language] = await _languageClass
              .callMethod<JSPromise<JSObject>>(
                'load'.toJS,
                bytes,
              )
              .toDart;
        } catch (_) {
          _loading.remove(language);
          rethrow;
        }
      }),
  ]);
}

final class Session {
  final String language;
  late final _Parser _parser;
  late final _Query _query;
  _Tree? _tree;
  String? _source;
  bool _disposed = false;

  Session(this.language) {
    final grammar = _languages[language];
    if (grammar == null) {
      throw StateError(
        'Tree-sitter language "$language" is not initialized. Await '
        'TreeSitterRuntime.ensureInitialized(languages: {"$language"}) first.',
      );
    }
    _parser = _parserConstructor.callAsConstructor<_Parser>();
    _parser.setLanguage(grammar);
    var queryCreated = false;
    try {
      _query = _queryConstructor.callAsConstructor<_Query>(
        grammar,
        treeSitterGrammarData[language]!.highlights.toJS,
      );
      queryCreated = true;
      for (final pattern in _query.predicates.toDart) {
        if (pattern.toDart.isNotEmpty) {
          final operator = pattern.toDart.first
              .getProperty<JSString>('operator'.toJS)
              .toDart;
          throw UnsupportedError(
              'Unsupported Tree-sitter predicate #$operator for $language');
        }
      }
      for (final properties in [
        ..._query.assertedProperties.toDart,
        ..._query.refutedProperties.toDart,
      ]) {
        if (properties != null && _keys(properties).toDart.isNotEmpty) {
          throw UnsupportedError(
              'Tree-sitter local predicates are not supported for $language');
        }
      }
    } catch (error, stack) {
      if (queryCreated) _query.delete();
      _parser.delete();
      if (error is UnsupportedError) rethrow;
      Error.throwWithStackTrace(
        StateError(
            'Could not initialize Tree-sitter grammar/query $language: $error'),
        stack,
      );
    }
  }

  SyntaxSnapshot parse(String source) {
    if (_disposed) throw StateError('Tree-sitter session is disposed');
    final previous = _source;
    final old = _tree;
    if (old != null) {
      final edit = sourceEdit(previous!, source);
      JSObject point(({int row, int column}) point) {
        final value = JSObject();
        value.setProperty('row'.toJS, point.row.toJS);
        value.setProperty('column'.toJS, point.column.toJS);
        return value;
      }

      final value = JSObject();
      value.setProperty('startIndex'.toJS, edit.start.toJS);
      value.setProperty('oldEndIndex'.toJS, edit.oldEnd.toJS);
      value.setProperty('newEndIndex'.toJS, edit.newEnd.toJS);
      value.setProperty(
          'startPosition'.toJS, point(sourcePoint(previous, edit.start)));
      value.setProperty(
          'oldEndPosition'.toJS, point(sourcePoint(previous, edit.oldEnd)));
      value.setProperty(
          'newEndPosition'.toJS, point(sourcePoint(source, edit.newEnd)));
      old.edit(value);
    }
    final next = _parser.parse(source, old);
    if (next == null) throw StateError('Tree-sitter parsing failed');
    old?.delete();
    _tree = next;
    _source = source;
    final captures = <SyntaxCapture>[];
    for (final match in _query.matches(next.rootNode).toDart) {
      final properties = match.setProperties;
      final priority = properties == null
          ? 0
          : int.tryParse(
                  properties.getProperty<JSString?>('priority'.toJS)?.toDart ??
                      '') ??
              0;
      for (final capture in match.captures.toDart) {
        captures.add(SyntaxCapture(
          name: capture.name,
          from: capture.node.startIndex,
          to: capture.node.endIndex,
          priority: priority,
          patternIndex: match.patternIndex,
        ));
      }
    }
    if (_query.didExceedMatchLimit()) {
      throw StateError('Tree-sitter query match limit exceeded for $language');
    }
    captures.sort((a, b) {
      final from = a.from.compareTo(b.from);
      return from != 0 ? from : a.patternIndex.compareTo(b.patternIndex);
    });
    return SyntaxSnapshot(
      language: language,
      source: source,
      rootNode: _copyNode(next.rootNode),
      captures: captures,
      incremental: previous != null,
    );
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _tree?.delete();
    _query.delete();
    _parser.delete();
  }
}

SyntaxNode _copyNode(_Node node) => SyntaxNode(
      type: node.type,
      from: node.startIndex,
      to: node.endIndex,
      isNamed: node.isNamed,
      hasError: node.hasError,
      children: [for (final child in node.children.toDart) _copyNode(child)],
    );
