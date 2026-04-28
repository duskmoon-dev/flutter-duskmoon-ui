import 'package:flutter/foundation.dart';

import 'dm_chat_attachment.dart';

/// Status of a tool-call block.
enum DmChatToolCallStatus { pending, running, done, error }

/// Base class for message content blocks. Use pattern matching on subclasses.
@immutable
sealed class DmChatBlock {
  const DmChatBlock();
}

/// Markdown text block. Provide exactly one of [text] or [stream].
@immutable
class DmChatTextBlock extends DmChatBlock {
  const DmChatTextBlock({this.text, this.stream})
      : assert(
          (text == null) != (stream == null),
          'Exactly one of text or stream must be non-null',
        );

  final String? text;
  final Stream<String>? stream;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DmChatTextBlock && text == other.text && stream == other.stream;

  @override
  int get hashCode => Object.hash(text, stream);
}

/// Reasoning / thinking block. Provide exactly one of [text] or [stream].
@immutable
class DmChatThinkingBlock extends DmChatBlock {
  const DmChatThinkingBlock({this.text, this.stream, this.elapsed})
      : assert(
          (text == null) != (stream == null),
          'Exactly one of text or stream must be non-null',
        );

  final String? text;
  final Stream<String>? stream;

  /// Elapsed reasoning duration; drives the "Thought for Ns" summary.
  final Duration? elapsed;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DmChatThinkingBlock &&
          text == other.text &&
          stream == other.stream &&
          elapsed == other.elapsed;

  @override
  int get hashCode => Object.hash(text, stream, elapsed);
}

/// Tool-call block — chip-style renderer with expand-on-tap input/output.
@immutable
class DmChatToolCallBlock extends DmChatBlock {
  const DmChatToolCallBlock({
    required this.id,
    required this.name,
    this.input,
    this.output,
    this.status = DmChatToolCallStatus.pending,
    this.errorMessage,
  });

  /// Tool-call id supplied by the LLM (used as stable widget key).
  final String id;
  final String name;

  /// JSON-encodable input payload.
  final Object? input;

  /// JSON-encodable output or markdown string.
  final Object? output;

  final DmChatToolCallStatus status;
  final String? errorMessage;

  DmChatToolCallBlock copyWith({
    String? id,
    String? name,
    Object? input,
    Object? output,
    DmChatToolCallStatus? status,
    String? errorMessage,
  }) =>
      DmChatToolCallBlock(
        id: id ?? this.id,
        name: name ?? this.name,
        input: input ?? this.input,
        output: output ?? this.output,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DmChatToolCallBlock &&
          id == other.id &&
          name == other.name &&
          input == other.input &&
          output == other.output &&
          status == other.status &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode =>
      Object.hash(id, name, input, output, status, errorMessage);
}

/// Attachment block — one or more files/images.
@immutable
class DmChatAttachmentBlock extends DmChatBlock {
  const DmChatAttachmentBlock({required this.attachments});

  final List<DmChatAttachment> attachments;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DmChatAttachmentBlock &&
          listEquals(attachments, other.attachments);

  @override
  int get hashCode => Object.hashAll(attachments);
}

/// Extensible custom block. Renderer is resolved via
/// `DmChatTheme.customBuilders[kind]`.
@immutable
class DmChatCustomBlock extends DmChatBlock {
  const DmChatCustomBlock({required this.kind, this.data});

  final String kind;
  final Object? data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DmChatCustomBlock && kind == other.kind && data == other.data;

  @override
  int get hashCode => Object.hash(kind, data);
}
