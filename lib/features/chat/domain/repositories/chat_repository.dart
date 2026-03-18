// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Chat Repository (Abstract)
// Domain contract for chat data operations
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:fpdart/fpdart.dart';

import 'package:nexus_ai/core/error/failure.dart';
import 'package:nexus_ai/features/chat/domain/entities/message_entity.dart';
import 'package:nexus_ai/features/chat/domain/entities/conversation_entity.dart';

/// Abstract repository defining the contract for chat data operations.
///
/// All methods return `Either<Failure, T>` for typed error handling.
/// Implementations live in the data layer.
abstract class ChatRepository {
  // ── Conversations ─────────────────────────────────────────

  /// Get all conversations, ordered newest first.
  Future<Either<Failure, List<ConversationEntity>>> getConversations();

  /// Get or create a conversation by ID.
  Future<Either<Failure, ConversationEntity>> getOrCreateConversation(
    String conversationId,
  );

  /// Delete a conversation and all its messages.
  Future<Either<Failure, void>> deleteConversation(String conversationId);

  // ── Messages ──────────────────────────────────────────────

  /// Get all messages for a conversation.
  Future<Either<Failure, List<MessageEntity>>> getMessages(
    String conversationId,
  );

  /// Send a text message and receive streaming response.
  ///
  /// The [onToken] callback is invoked for each streamed token.
  /// Returns the complete AI response message when streaming finishes.
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String conversationId,
    required String content,
    List<String> imagePaths,
    required List<MessageEntity> history,
    required void Function(String token) onToken,
  });

  /// Persist a message to local storage.
  Future<Either<Failure, void>> saveMessage(MessageEntity message);

  /// Update an existing message (e.g., streaming content append).
  Future<Either<Failure, void>> updateMessage(MessageEntity message);
}
