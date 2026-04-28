import 'package:flutter/foundation.dart';

/// Lifecycle status of an attachment.
enum DmChatAttachmentStatus { idle, uploading, done, error }

/// A file/image attachment tied to a chat message or pending input composition.
@immutable
class DmChatAttachment {
  const DmChatAttachment({
    required this.id,
    required this.name,
    this.sizeBytes,
    this.mimeType,
    this.url,
    this.bytes,
    this.status = DmChatAttachmentStatus.idle,
    this.uploadProgress,
    this.errorMessage,
  });

  /// Stable attachment id (used as widget key and cancel handle).
  final String id;
  final String name;
  final int? sizeBytes;
  final String? mimeType;

  /// Remote URL after upload.
  final Uri? url;

  /// Local bytes prior to (or alongside) upload.
  final Uint8List? bytes;

  final DmChatAttachmentStatus status;

  /// Upload progress in [0.0, 1.0] inclusive.
  final double? uploadProgress;

  final String? errorMessage;

  DmChatAttachment copyWith({
    String? id,
    String? name,
    int? sizeBytes,
    String? mimeType,
    Uri? url,
    Uint8List? bytes,
    DmChatAttachmentStatus? status,
    double? uploadProgress,
    String? errorMessage,
  }) =>
      DmChatAttachment(
        id: id ?? this.id,
        name: name ?? this.name,
        sizeBytes: sizeBytes ?? this.sizeBytes,
        mimeType: mimeType ?? this.mimeType,
        url: url ?? this.url,
        bytes: bytes ?? this.bytes,
        status: status ?? this.status,
        uploadProgress: uploadProgress ?? this.uploadProgress,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DmChatAttachment &&
          id == other.id &&
          name == other.name &&
          sizeBytes == other.sizeBytes &&
          mimeType == other.mimeType &&
          url == other.url &&
          _bytesEqual(bytes, other.bytes) &&
          status == other.status &&
          uploadProgress == other.uploadProgress &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        sizeBytes,
        mimeType,
        url,
        bytes == null ? null : Object.hashAll(bytes!),
        status,
        uploadProgress,
        errorMessage,
      );

  static bool _bytesEqual(Uint8List? a, Uint8List? b) {
    if (identical(a, b)) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Adapter implemented by consumers to upload local attachments.
///
/// [upload] emits updated [DmChatAttachment] snapshots as progress advances.
/// Implementations should:
/// - Always emit at least one terminal value with `status: done` or `error`.
/// - Emit progress updates with `status: uploading` and `uploadProgress` in [0,1].
/// - Preserve the original [DmChatAttachment.id] in every emission.
///
/// [cancel] aborts an in-flight upload by id; no-op if the upload is not active.
abstract class DmChatUploadAdapter {
  Stream<DmChatAttachment> upload(DmChatAttachment local);
  Future<void> cancel(String attachmentId);
}
