// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Send Message UseCase
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:fpdart/fpdart.dart';

import 'package:nexus_ai/core/error/failure.dart';
import 'package:nexus_ai/features/chat/domain/entities/message_entity.dart';
import 'package:nexus_ai/features/chat/domain/repositories/chat_repository.dart';

/// Orchestrates sending a message and receiving a streaming response.
class SendMessageUseCase {
  const SendMessageUseCase({required this.repository});

  final ChatRepository repository;

  /// Execute: send user message, stream AI response tokens.
  ///
  /// 1. Saves user message to local storage
  /// 2. Sends to backend via WebSocket
  /// 3. Streams response tokens via [onToken]
  /// 4. Returns final complete AI message
  Future<Either<Failure, MessageEntity>> call({
    required String conversationId,
    required String content,
    List<String> imagePaths = const [],
    required List<MessageEntity> history,
    required void Function(String token) onToken,
  }) async {
    return repository.sendMessage(
      conversationId: conversationId,
      content: content,
      imagePaths: imagePaths,
      history: history,
      onToken: onToken,
    );
  }
}
