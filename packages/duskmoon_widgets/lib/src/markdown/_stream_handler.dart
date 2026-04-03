import 'dart:async';

import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

import '../_shared/incremental_parser.dart';

/// Handles streaming markdown input and produces incremental AST updates.
///
/// Buffers incoming chunks, drives an [IncrementalParser] with append
/// optimization, and exposes a [ValueNotifier] for reactive rebuilds.
class StreamHandler {
  /// Creates a stream handler.
  StreamHandler({
    required Stream<String> stream,
    required this.parser,
    required this.onNodesChanged,
  }) {
    _subscription = stream.listen(
      _onChunk,
      onDone: _onDone,
      onError: _onError,
    );
  }

  /// The incremental parser instance.
  final IncrementalParser parser;

  /// Callback fired when the AST nodes are updated.
  final void Function(List<md.Node> nodes) onNodesChanged;

  final StringBuffer _buffer = StringBuffer();
  StreamSubscription<String>? _subscription;
  bool _isDone = false;

  /// Whether the stream is still active (not done/cancelled).
  bool get isActive => !_isDone;

  /// The full accumulated text.
  String get fullText => _buffer.toString();

  void _onChunk(String chunk) {
    _buffer.write(chunk);
    final result = parser.appendParse(_buffer.toString());
    onNodesChanged(result.nodes);
  }

  void _onDone() {
    _isDone = true;
    // Do a final full parse to ensure consistency.
    final result = parser.fullParse(_buffer.toString());
    onNodesChanged(result.nodes);
  }

  void _onError(Object error, StackTrace stackTrace) {
    // On stream error, keep what we have.
    _isDone = true;
    debugPrint('DmMarkdown stream error: $error');
  }

  /// Cancels the stream subscription and cleans up.
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}
