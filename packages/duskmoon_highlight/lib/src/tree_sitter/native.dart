import 'dart:convert';
import 'dart:ffi';

import 'edit.dart';
import 'generated/grammars.dart';
import 'model.dart';
import 'predicates.dart';

@Native<Pointer<Void> Function(IntPtr)>(symbol: 'dmh_allocate')
external Pointer<Void> _allocate(int size);
@Native<Void Function(Pointer<Void>)>(symbol: 'dmh_free')
external void _free(Pointer<Void> pointer);
@Native<
    Pointer<Void> Function(
        Pointer<Uint8>, Pointer<Uint8>, Pointer<Uint32>)>(symbol: 'dmh_create')
external Pointer<Void> _create(
  Pointer<Uint8> language,
  Pointer<Uint8> query,
  Pointer<Uint32> error,
);
@Native<Void Function(Pointer<Void>)>(symbol: 'dmh_dispose')
external void _dispose(Pointer<Void> session);
@Native<Pointer<Uint8> Function(Pointer<Void>)>(symbol: 'dmh_predicates')
external Pointer<Uint8> _predicates(Pointer<Void> session);
@Native<
    Pointer<Uint8> Function(
      Pointer<Void>,
      Pointer<Uint8>,
      Uint32,
      Uint32,
      Uint32,
      Uint32,
      Uint32,
      Uint32,
      Uint32,
      Uint32,
      Uint32,
      Uint32,
    )>(symbol: 'dmh_parse')
external Pointer<Uint8> _parse(
  Pointer<Void> session,
  Pointer<Uint8> source,
  int length,
  int start,
  int oldEnd,
  int newEnd,
  int startRow,
  int startColumn,
  int oldRow,
  int oldColumn,
  int newRow,
  int newColumn,
);

bool isInitialized(String language) =>
    treeSitterGrammarData.containsKey(language);
Future<void> ensureInitialized(Set<String> languages) async {
  // Resolve the bundled native asset even when no grammar was requested.
  final probe = _allocate(1);
  _free(probe);
  for (final language in languages) {
    Session(language).dispose();
  }
}

Pointer<Uint8> _string(String value) {
  final bytes = utf8.encode(value);
  final pointer = _allocate(bytes.length + 1).cast<Uint8>();
  pointer.asTypedList(bytes.length + 1).setAll(0, [...bytes, 0]);
  return pointer;
}

dynamic _json(Pointer<Uint8> pointer) {
  if (pointer == nullptr) throw StateError('Tree-sitter parsing failed');
  try {
    var length = 0;
    while (pointer[length] != 0) {
      length++;
    }
    return jsonDecode(utf8.decode(pointer.asTypedList(length)));
  } finally {
    _free(pointer.cast());
  }
}

final _finalizer = NativeFinalizer(Native.addressOf(_dispose));

final class Session implements Finalizable {
  final String language;
  late final Pointer<Void> _handle;
  late final QueryPredicates _queryPredicates;
  String? _source;
  bool _disposed = false;

  Session(this.language) {
    final id = _string(language);
    final query = _string(treeSitterGrammarData[language]!.highlights);
    final error = _allocate(8).cast<Uint32>();
    try {
      _handle = _create(id, query, error);
      if (_handle == nullptr) {
        throw StateError('Could not initialize Tree-sitter grammar/query '
            '$language (query error ${error[1]} at UTF8 byte ${error[0]})');
      }
    } finally {
      _free(id.cast());
      _free(query.cast());
      _free(error.cast());
    }
    try {
      _queryPredicates = QueryPredicates(_json(_predicates(_handle)) as List);
    } catch (_) {
      _dispose(_handle);
      rethrow;
    }
    _finalizer.attach(this, _handle, detach: this);
  }

  SyntaxSnapshot parse(String source) {
    if (_disposed) throw StateError('Tree-sitter session is disposed');
    final previous = _source;
    final edit = sourceEdit(previous ?? '', source);
    final start = sourcePoint(previous ?? '', edit.start);
    final oldEnd = sourcePoint(previous ?? '', edit.oldEnd);
    final newEnd = sourcePoint(source, edit.newEnd);
    final bytes = _allocate((source.length + 1) * 2).cast<Uint8>();
    // Tree-sitter expects UTF16LE regardless of the host byte order.
    final data = bytes.asTypedList((source.length + 1) * 2);
    for (var i = 0; i < source.length; i++) {
      final unit = source.codeUnitAt(i);
      data[i * 2] = unit & 255;
      data[i * 2 + 1] = unit >> 8;
    }
    late final Map result;
    try {
      result = _json(_parse(
        _handle,
        bytes,
        source.length,
        edit.start,
        edit.oldEnd,
        edit.newEnd,
        start.row,
        start.column,
        oldEnd.row,
        oldEnd.column,
        newEnd.row,
        newEnd.column,
      )) as Map;
    } finally {
      _free(bytes.cast());
    }
    _source = source;
    if (result['exceeded'] == true) {
      throw StateError('Tree-sitter query match limit exceeded for $language');
    }
    final captures = <SyntaxCapture>[];
    for (final match in result['matches'] as List) {
      final pattern = (match as Map)['pattern'] as int;
      final current = [
        for (final item in match['captures'] as List)
          SyntaxCapture(
            name: (item as Map)['name'] as String,
            from: item['from'] as int,
            to: item['to'] as int,
            patternIndex: pattern,
            priority: _queryPredicates.priority(pattern),
          ),
      ];
      if (_queryPredicates.accepts(pattern, current, source)) {
        captures.addAll(current);
      }
    }
    captures.sort(_compareCaptures);
    return SyntaxSnapshot(
      language: language,
      source: source,
      rootNode: _node(result['root'] as Map),
      captures: captures,
      incremental: previous != null,
    );
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _finalizer.detach(this);
    _dispose(_handle);
  }
}

SyntaxNode _node(Map value) => SyntaxNode(
      type: value['type'] as String,
      from: value['from'] as int,
      to: value['to'] as int,
      isNamed: value['isNamed'] as bool,
      hasError: value['hasError'] as bool,
      children: [
        for (final child in value['children'] as List) _node(child as Map)
      ],
    );

int _compareCaptures(SyntaxCapture a, SyntaxCapture b) {
  final from = a.from.compareTo(b.from);
  return from != 0 ? from : a.patternIndex.compareTo(b.patternIndex);
}
