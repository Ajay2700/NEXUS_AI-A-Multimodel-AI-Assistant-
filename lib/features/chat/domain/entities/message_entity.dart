// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Message Entity
// Domain entity for chat messages (pure Dart, Freezed)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_entity.freezed.dart';
part 'message_entity.g.dart';

/// Roles a message can have.
enum MessageRole {
  user,
  assistant,
  system,
}

/// Content type of a message.
enum MessageType {
  text,
  image,
  voice,
}

/// Status of a message in the pipeline.
enum MessageStatus {
  sending,
  sent,
  streaming,
  error,
}

/// Domain entity representing a single chat message.
///
/// This is a pure domain object — no Flutter imports, no UI logic.
@freezed
class MessageEntity with _$MessageEntity {
  const factory MessageEntity({
    required String id,
    required String conversationId,
    required MessageRole role,
    @Default(MessageType.text) MessageType type,
    @Default('') String content,
    @Default(MessageStatus.sent) MessageStatus status,
    @Default([]) List<String> imagePaths,
    required DateTime createdAt,
  }) = _MessageEntity;

  factory MessageEntity.fromJson(Map<String, dynamic> json) =>
      _$MessageEntityFromJson(json);
}
