// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Chat State
// Freezed sealed state for the chat feature
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:nexus_ai/features/chat/domain/entities/conversation_entity.dart';
import 'package:nexus_ai/features/chat/domain/entities/message_entity.dart';

part 'chat_state.freezed.dart';

/// Sealed state union for the chat feature.
@freezed
sealed class ChatState with _$ChatState {
  /// Initial state before any data is loaded.
  const factory ChatState.initial() = ChatInitial;

  /// Loading state while data is being fetched.
  const factory ChatState.loading() = ChatLoading;

  /// Loaded state with conversation data.
  const factory ChatState.loaded({
    required ConversationEntity conversation,
    required List<MessageEntity> messages,
    @Default(false) bool isStreaming,
    @Default('') String streamingContent,
    @Default(false) bool isWaitingForResponse,
    String? errorMessage,
  }) = ChatLoaded;

  /// Error state.
  const factory ChatState.error({
    required String message,
  }) = ChatError;
}
