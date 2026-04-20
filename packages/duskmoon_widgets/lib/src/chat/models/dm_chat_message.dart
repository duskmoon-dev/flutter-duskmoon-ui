import 'package:flutter/foundation.dart';

import 'dm_chat_block.dart';

/// Role of a chat message participant.
enum DmChatRole { user, assistant, system }

/// Lifecycle status of a chat message.
enum DmChatMessageStatus { pending, streaming, complete, error }

/// A single chat message composed of ordered content blocks.
@immutable
class DmChatMessage {
  const DmChatMessage({
    required this.id,
    required this.role,
    required this.blocks,
    this.status = DmChatMessageStatus.complete,
    this.error,
    this.createdAt,
  });

  /// Stable identifier used for list diffing and stream re-subscription keys.
  final String id;
  final DmChatRole role;
  final List<DmChatBlock> blocks;
  final DmChatMessageStatus status;

  /// Populated when [status] == [DmChatMessageStatus.error].
  final Object? error;

  /// Optional creation timestamp — not rendered by default.
  final DateTime? createdAt;

  DmChatMessage copyWith({
    String? id,
    DmChatRole? role,
    List<DmChatBlock>? blocks,
    DmChatMessageStatus? status,
    Object? error,
    DateTime? createdAt,
  }) =>
      DmChatMessage(
        id: id ?? this.id,
        role: role ?? this.role,
        blocks: blocks ?? this.blocks,
        status: status ?? this.status,
        error: error ?? this.error,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DmChatMessage &&
          id == other.id &&
          role == other.role &&
          listEquals(blocks, other.blocks) &&
          status == other.status &&
          error == other.error &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      Object.hash(id, role, Object.hashAll(blocks), status, error, createdAt);
}
