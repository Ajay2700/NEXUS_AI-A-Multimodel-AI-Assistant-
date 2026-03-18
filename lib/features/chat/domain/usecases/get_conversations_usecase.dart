// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Get Conversations UseCase
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:fpdart/fpdart.dart';

import 'package:nexus_ai/core/error/failure.dart';
import 'package:nexus_ai/features/chat/domain/entities/conversation_entity.dart';
import 'package:nexus_ai/features/chat/domain/repositories/chat_repository.dart';

/// Retrieves all conversations, ordered newest first.
class GetConversationsUseCase {
  const GetConversationsUseCase({required this.repository});

  final ChatRepository repository;

  Future<Either<Failure, List<ConversationEntity>>> call() async {
    return repository.getConversations();
  }
}
