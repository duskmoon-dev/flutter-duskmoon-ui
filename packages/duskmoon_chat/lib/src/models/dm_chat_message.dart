import 'dart:typed_data';

enum DmChatRole { user, assistant, system }

enum DmChatMessageStatus { pending, streaming, done, error, stopped }

final class DmChatMessage {
  DmChatMessage({
    required this.id,
    required this.role,
    required List<DmChatBlock> blocks,
    this.createdAt,
    this.status = DmChatMessageStatus.done,
    Object? error,
  })  : _blocks = List.unmodifiable(blocks),
        error = _deepFreeze(error);

  final String id;
  final DmChatRole role;
  final List<DmChatBlock> _blocks;
  final DateTime? createdAt;
  final DmChatMessageStatus status;

  /// Recursively frozen for supported collection, map, set, and Uint8List data.
  /// Arbitrary object instances are retained by reference.
  final Object? error;

  List<DmChatBlock> get blocks => _blocks;
}

sealed class DmChatBlock {
  const DmChatBlock();
}

final class DmChatTextBlock extends DmChatBlock {
  DmChatTextBlock({this.text, this.stream}) {
    _validateSingleContentSource(text: text, stream: stream);
  }

  final String? text;
  final Stream<String>? stream;
}

final class DmChatThinkingBlock extends DmChatBlock {
  DmChatThinkingBlock({
    this.text,
    this.stream,
    this.duration,
    this.initiallyExpanded = true,
  }) {
    _validateSingleContentSource(text: text, stream: stream);
  }

  final String? text;
  final Stream<String>? stream;
  final Duration? duration;
  final bool initiallyExpanded;
}

enum DmChatToolCallStatus { running, done, error }

final class DmChatToolCallBlock extends DmChatBlock {
  DmChatToolCallBlock({
    required this.toolName,
    required Map<String, Object?> input,
    this.output,
    this.status = DmChatToolCallStatus.running,
    Object? error,
  })  : _input = _freezeStringMap(input),
        error = _deepFreeze(error);

  final String toolName;
  final Map<String, Object?> _input;
  final String? output;
  final DmChatToolCallStatus status;

  /// Recursively frozen for supported collection, map, set, and Uint8List data.
  /// Arbitrary object instances are retained by reference.
  final Object? error;

  /// Recursively frozen for supported collection, map, set, and Uint8List data.
  /// Arbitrary object instances are retained by reference.
  Map<String, Object?> get input => _input;
}

enum DmChatUploadStatus { idle, uploading, done, error }

final class DmChatAttachment {
  DmChatAttachment({
    required this.id,
    required this.name,
    this.sizeBytes,
    this.mimeType,
    this.url,
    Uint8List? bytes,
    this.uploadStatus = DmChatUploadStatus.idle,
    this.uploadProgress,
    Object? uploadError,
  })  : _bytes = bytes == null
            ? null
            : Uint8List.fromList(bytes).asUnmodifiableView(),
        uploadError = _deepFreeze(uploadError);

  final String id;
  final String name;
  final int? sizeBytes;
  final String? mimeType;
  final Uri? url;
  final Uint8List? _bytes;
  final DmChatUploadStatus uploadStatus;
  final double? uploadProgress;

  /// Recursively frozen for supported collection, map, set, and Uint8List data.
  /// Arbitrary object instances are retained by reference.
  final Object? uploadError;

  Uint8List? get bytes => _bytes;
}

final class DmChatAttachmentBlock extends DmChatBlock {
  DmChatAttachmentBlock({required List<DmChatAttachment> attachments})
      : _attachments = List.unmodifiable(attachments);

  final List<DmChatAttachment> _attachments;

  List<DmChatAttachment> get attachments => _attachments;
}

final class DmChatCustomBlock extends DmChatBlock {
  DmChatCustomBlock({required this.kind, Object? data})
      : data = _deepFreeze(data);

  final String kind;

  /// Recursively frozen for supported collection, map, set, and Uint8List data.
  /// Arbitrary object instances are retained by reference.
  final Object? data;
}

abstract class DmChatUploadAdapter {
  Stream<DmChatAttachment> upload(DmChatAttachment attachment);

  Future<void> cancel(String attachmentId);
}

void _validateSingleContentSource({
  required String? text,
  required Stream<String>? stream,
}) {
  if (text == null && stream == null) {
    throw ArgumentError('Either text or stream must be provided.');
  }

  if (text != null && stream != null) {
    throw ArgumentError('Only one of text or stream may be provided.');
  }
}

Map<String, Object?> _freezeStringMap(Map<String, Object?> value) {
  return Map.unmodifiable(
    value.map((key, value) => MapEntry(key, _deepFreeze(value))),
  );
}

Object? _deepFreeze(Object? value) {
  return switch (value) {
    null ||
    String() ||
    num() ||
    bool() ||
    Uri() ||
    DateTime() ||
    Duration() ||
    Enum() =>
      value,
    Uint8List() => Uint8List.fromList(value).asUnmodifiableView(),
    Map() => Map.unmodifiable(
        value.map(
            (key, value) => MapEntry(_deepFreeze(key), _deepFreeze(value))),
      ),
    Set() => Set.unmodifiable(value.map(_deepFreeze)),
    Iterable() => List.unmodifiable(value.map(_deepFreeze)),
    _ => value,
  };
}
