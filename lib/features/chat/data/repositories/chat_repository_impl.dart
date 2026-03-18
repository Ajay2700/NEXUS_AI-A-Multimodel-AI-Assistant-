// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Chat Repository Implementation
// Bridges domain contract with local/remote data sources
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:convert';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import 'package:nexus_ai/core/error/failure.dart';
import 'package:nexus_ai/core/utils/logger.dart';
import 'package:nexus_ai/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:nexus_ai/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:nexus_ai/features/chat/domain/entities/conversation_entity.dart';
import 'package:nexus_ai/features/chat/domain/entities/message_entity.dart';
import 'package:nexus_ai/features/chat/domain/repositories/chat_repository.dart';

/// Implementation of [ChatRepository] using local Drift DB + WebSocket remote.
class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  final ChatLocalDataSource localDataSource;
  final ChatRemoteDataSource remoteDataSource;
  final Uuid _uuid = const Uuid();

  // ── Conversations ─────────────────────────────────────────

  @override
  Future<Either<Failure, List<ConversationEntity>>> getConversations() async {
    try {
      final conversations = await localDataSource.getAllConversations();
      return Right(conversations);
    } catch (e, st) {
      logger.error('Failed to get conversations', e, st);
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ConversationEntity>> getOrCreateConversation(
    String conversationId,
  ) async {
    try {
      final conversation = await localDataSource.getOrCreateConversation(
        conversationId,
      );
      return Right(conversation);
    } catch (e, st) {
      logger.error('Failed to get/create conversation', e, st);
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteConversation(
    String conversationId,
  ) async {
    try {
      await localDataSource.deleteConversation(conversationId);
      return const Right(null);
    } catch (e, st) {
      logger.error('Failed to delete conversation', e, st);
      return Left(Failure.storage(message: e.toString()));
    }
  }

  // ── Messages ──────────────────────────────────────────────

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(
    String conversationId,
  ) async {
    try {
      final messages = await localDataSource.getMessages(conversationId);
      return Right(messages);
    } catch (e, st) {
      logger.error('Failed to get messages', e, st);
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String conversationId,
    required String content,
    List<String>? imagePaths,
    required List<MessageEntity> history,
    required void Function(String token) onToken,
  }) async {
    try {
      // Ensure WebSocket is connected
      if (!remoteDataSource.isConnected) {
        await remoteDataSource.connect(conversationId);
      }

      // Encode images to base64 if provided
      List<String>? base64Images;
      if (imagePaths != null && imagePaths.isNotEmpty) {
        base64Images = [];
        for (final path in imagePaths) {
          final file = File(path);
          if (await file.exists()) {
            final bytes = await file.readAsBytes();
            base64Images.add(base64Encode(bytes));
          }
        }
      }

      // Format history for backend
      final formattedHistory = remoteDataSource.formatHistory(history);

      // Send and stream response
      final fullResponse = await remoteDataSource.sendAndStream(
        content: content,
        history: formattedHistory,
        base64Images: base64Images,
        onToken: onToken,
      );

      // Create the completed AI message entity
      final aiMessage = MessageEntity(
        id: _uuid.v4(),
        conversationId: conversationId,
        role: MessageRole.assistant,
        type: MessageType.text,
        content: fullResponse,
        status: MessageStatus.sent,
        createdAt: DateTime.now(),
      );

      // Persist AI message
      await localDataSource.insertMessage(aiMessage);
      await localDataSource.updateConversationTimestamp(conversationId);

      return Right(aiMessage);
    } on SocketException catch (e) {
      logger.error('Network error sending message', e);
      return Left(Failure.network(message: e.message));
    } catch (e, st) {
      logger.error('Failed to send message', e, st);
      return Left(Failure.llm(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveMessage(MessageEntity message) async {
    try {
      await localDataSource.insertMessage(message);
      return const Right(null);
    } catch (e, st) {
      logger.error('Failed to save message', e, st);
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateMessage(MessageEntity message) async {
    try {
      await localDataSource.updateMessage(message);
      return const Right(null);
    } catch (e, st) {
      logger.error('Failed to update message', e, st);
      return Left(Failure.storage(message: e.toString()));
    }
  }
}
