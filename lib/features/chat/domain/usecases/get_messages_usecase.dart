// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Get Messages UseCase
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:fpdart/fpdart.dart';

import 'package:nexus_ai/core/error/failure.dart';
import 'package:nexus_ai/features/chat/domain/entities/message_entity.dart';
import 'package:nexus_ai/features/chat/domain/repositories/chat_repository.dart';

/// Retrieves all messages for a given conversation.
class GetMessagesUseCase {
  const GetMessagesUseCase({required this.repository});

  final ChatRepository repository;

  Future<Either<Failure, List<MessageEntity>>> call(
    String conversationId,
  ) async {
    return repository.getMessages(conversationId);
  }
}
